Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2ECE57DE95
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbiGVJ3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbiGVJ2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:28:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60948B8518;
        Fri, 22 Jul 2022 02:17:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 615D0B827BC;
        Fri, 22 Jul 2022 09:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68E8C341C6;
        Fri, 22 Jul 2022 09:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481474;
        bh=ht/zw+tJsdLI5zMA2BjnKf2FhyrjDAtiyH10+522ZUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmIsOq2UDgVoiYBTC9lDUegSCL4HNQtQTwOtizc5NozOxtlXxzMrEwrCSH/Adri1p
         WUJcyBQCuSdcCXiN2mHZm2bmfv6TXFtHEWTSYw/2yJkogAVDMQDS7Qlq0y2SxNe/HS
         Cf9m+vWtMdphvyo2yxvycxUUz91G5LSCMmvqWezc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 82/89] efi/x86: use naked RET on mixed mode call wrapper
Date:   Fri, 22 Jul 2022 11:11:56 +0200
Message-Id: <20220722091137.929354267@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 51a6fa0732d6be6a44e0032752ad2ac10d67c796 upstream.

When running with return thunks enabled under 32-bit EFI, the system
crashes with:

  kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
  BUG: unable to handle page fault for address: 000000005bc02900
  #PF: supervisor instruction fetch in kernel mode
  #PF: error_code(0x0011) - permissions violation
  PGD 18f7063 P4D 18f7063 PUD 18ff063 PMD 190e063 PTE 800000005bc02063
  Oops: 0011 [#1] PREEMPT SMP PTI
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc6+ #166
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:0x5bc02900
  Code: Unable to access opcode bytes at RIP 0x5bc028d6.
  RSP: 0018:ffffffffb3203e10 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000048
  RDX: 000000000190dfac RSI: 0000000000001710 RDI: 000000007eae823b
  RBP: ffffffffb3203e70 R08: 0000000001970000 R09: ffffffffb3203e28
  R10: 747563657865206c R11: 6c6977203a696665 R12: 0000000000001710
  R13: 0000000000000030 R14: 0000000001970000 R15: 0000000000000001
  FS:  0000000000000000(0000) GS:ffff8e013ca00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
  CR2: 000000005bc02900 CR3: 0000000001930000 CR4: 00000000000006f0
  Call Trace:
   ? efi_set_virtual_address_map+0x9c/0x175
   efi_enter_virtual_mode+0x4a6/0x53e
   start_kernel+0x67c/0x71e
   x86_64_start_reservations+0x24/0x2a
   x86_64_start_kernel+0xe9/0xf4
   secondary_startup_64_no_verify+0xe5/0xeb

That's because it cannot jump to the return thunk from the 32-bit code.

Using a naked RET and marking it as safe allows the system to proceed
booting.

Fixes: aa3d480315ba ("x86: Use return-thunk in asm code")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: <stable@vger.kernel.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/platform/efi/efi_thunk_64.S |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/efi/efi_thunk_64.S
+++ b/arch/x86/platform/efi/efi_thunk_64.S
@@ -22,6 +22,7 @@
 #include <linux/linkage.h>
 #include <asm/page_types.h>
 #include <asm/segment.h>
+#include <asm/nospec-branch.h>
 
 	.text
 	.code64
@@ -63,7 +64,9 @@ SYM_CODE_START(__efi64_thunk)
 1:	movq	24(%rsp), %rsp
 	pop	%rbx
 	pop	%rbp
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 
 	.code32
 2:	pushl	$__KERNEL_CS


