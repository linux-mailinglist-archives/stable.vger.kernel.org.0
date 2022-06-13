Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037CC54926A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381499AbiFMOIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381428AbiFMOEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:04:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756CC2408E;
        Mon, 13 Jun 2022 04:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43B4BB80EA7;
        Mon, 13 Jun 2022 11:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F84C34114;
        Mon, 13 Jun 2022 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120366;
        bh=2odPTdIemNCZvUqa/teihxfs4Xg+DkcxHMGcQKkw3Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+YQB5ugSuzztmVOqMIhPedaNo4a9aseMD/pFbiN/brd/RBoSq/5QCZI/2XeLRVwf
         liML2nHihcY7HLVM6DvwQPWqW56WwwtdM1aBFjKLFTHA3D79bG5+nzC4CHfRkdweoN
         mlg7xYSPknswwuKGB1AOVFBK66C4kGTzPWRUqN0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Miculas <ariel.miculas@belden.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.18 334/339] powerpc/32: Fix overread/overwrite of thread_struct via ptrace
Date:   Mon, 13 Jun 2022 12:12:39 +0200
Message-Id: <20220613094936.867299167@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 8e1278444446fc97778a5e5c99bca1ce0bbc5ec9 upstream.

The ptrace PEEKUSR/POKEUSR (aka PEEKUSER/POKEUSER) API allows a process
to read/write registers of another process.

To get/set a register, the API takes an index into an imaginary address
space called the "USER area", where the registers of the process are
laid out in some fashion.

The kernel then maps that index to a particular register in its own data
structures and gets/sets the value.

The API only allows a single machine-word to be read/written at a time.
So 4 bytes on 32-bit kernels and 8 bytes on 64-bit kernels.

The way floating point registers (FPRs) are addressed is somewhat
complicated, because double precision float values are 64-bit even on
32-bit CPUs. That means on 32-bit kernels each FPR occupies two
word-sized locations in the USER area. On 64-bit kernels each FPR
occupies one word-sized location in the USER area.

Internally the kernel stores the FPRs in an array of u64s, or if VSX is
enabled, an array of pairs of u64s where one half of each pair stores
the FPR. Which half of the pair stores the FPR depends on the kernel's
endianness.

To handle the different layouts of the FPRs depending on VSX/no-VSX and
big/little endian, the TS_FPR() macro was introduced.

Unfortunately the TS_FPR() macro does not take into account the fact
that the addressing of each FPR differs between 32-bit and 64-bit
kernels. It just takes the index into the "USER area" passed from
userspace and indexes into the fp_state.fpr array.

On 32-bit there are 64 indexes that address FPRs, but only 32 entries in
the fp_state.fpr array, meaning the user can read/write 256 bytes past
the end of the array. Because the fp_state sits in the middle of the
thread_struct there are various fields than can be overwritten,
including some pointers. As such it may be exploitable.

It has also been observed to cause systems to hang or otherwise
misbehave when using gdbserver, and is probably the root cause of this
report which could not be easily reproduced:
  https://lore.kernel.org/linuxppc-dev/dc38afe9-6b78-f3f5-666b-986939e40fc6@keymile.com/

Rather than trying to make the TS_FPR() macro even more complicated to
fix the bug, or add more macros, instead add a special-case for 32-bit
kernels. This is more obvious and hopefully avoids a similar bug
happening again in future.

Note that because 32-bit kernels never have VSX enabled the code doesn't
need to consider TS_FPRWIDTH/OFFSET at all. Add a BUILD_BUG_ON() to
ensure that 32-bit && VSX is never enabled.

Fixes: 87fec0514f61 ("powerpc: PTRACE_PEEKUSR/PTRACE_POKEUSER of FPR registers in little endian builds")
Cc: stable@vger.kernel.org # v3.13+
Reported-by: Ariel Miculas <ariel.miculas@belden.com>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220609133245.573565-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/ptrace/ptrace-fpu.c |   20 ++++++++++++++------
 arch/powerpc/kernel/ptrace/ptrace.c     |    3 +++
 2 files changed, 17 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kernel/ptrace/ptrace-fpu.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-fpu.c
@@ -17,9 +17,13 @@ int ptrace_get_fpr(struct task_struct *c
 
 #ifdef CONFIG_PPC_FPU_REGS
 	flush_fp_to_thread(child);
-	if (fpidx < (PT_FPSCR - PT_FPR0))
-		memcpy(data, &child->thread.TS_FPR(fpidx), sizeof(long));
-	else
+	if (fpidx < (PT_FPSCR - PT_FPR0)) {
+		if (IS_ENABLED(CONFIG_PPC32))
+			// On 32-bit the index we are passed refers to 32-bit words
+			*data = ((u32 *)child->thread.fp_state.fpr)[fpidx];
+		else
+			memcpy(data, &child->thread.TS_FPR(fpidx), sizeof(long));
+	} else
 		*data = child->thread.fp_state.fpscr;
 #else
 	*data = 0;
@@ -39,9 +43,13 @@ int ptrace_put_fpr(struct task_struct *c
 
 #ifdef CONFIG_PPC_FPU_REGS
 	flush_fp_to_thread(child);
-	if (fpidx < (PT_FPSCR - PT_FPR0))
-		memcpy(&child->thread.TS_FPR(fpidx), &data, sizeof(long));
-	else
+	if (fpidx < (PT_FPSCR - PT_FPR0)) {
+		if (IS_ENABLED(CONFIG_PPC32))
+			// On 32-bit the index we are passed refers to 32-bit words
+			((u32 *)child->thread.fp_state.fpr)[fpidx] = data;
+		else
+			memcpy(&child->thread.TS_FPR(fpidx), &data, sizeof(long));
+	} else
 		child->thread.fp_state.fpscr = data;
 #endif
 
--- a/arch/powerpc/kernel/ptrace/ptrace.c
+++ b/arch/powerpc/kernel/ptrace/ptrace.c
@@ -450,4 +450,7 @@ void __init pt_regs_check(void)
 #else
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_HAVE_FUNCTION_DESCRIPTORS));
 #endif
+
+	// ptrace_get/put_fpr() rely on PPC32 and VSX being incompatible
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_PPC32) && IS_ENABLED(CONFIG_VSX));
 }


