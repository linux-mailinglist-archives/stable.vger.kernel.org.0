Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51AB6AE5B8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjCGQBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjCGQA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:00:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C77A92BDD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 07:58:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5E08B8191F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 15:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCF3C433D2;
        Tue,  7 Mar 2023 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678204716;
        bh=zVrTHSn5hhdqn5Cu8ARqza2HQK3odv/MSsd0nYlul1g=;
        h=Subject:To:Cc:From:Date:From;
        b=w742Jgin1m7sfcfglt8YP3ftRWmYQSVKQvmTe+yWqzyene0GneFFkxcUC8263ozT4
         qu4NApj2rpMibjfycho7VZgcN80HbmO4vWtB2P7U8Vs1Cf6x+gI59T4Bi2XtFcgVIB
         q4rL2P34My7ItQ4GECu7SitgBahcbIxBKRa28Smg=
Subject: FAILED: patch "[PATCH] riscv: ftrace: Fixup panic by disabling preemption" failed to apply to 6.1-stable tree
To:     andy.chiu@sifive.com, guoren@kernel.org, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 16:58:33 +0100
Message-ID: <1678204713100113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 8547649981e6631328cd64f583667501ae385531
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678204713100113@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

8547649981e6 ("riscv: ftrace: Fixup panic by disabling preemption")
f32b4b467ebd ("RISC-V: enable dynamic ftrace for RV32I")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8547649981e6631328cd64f583667501ae385531 Mon Sep 17 00:00:00 2001
From: Andy Chiu <andy.chiu@sifive.com>
Date: Thu, 12 Jan 2023 04:05:57 -0500
Subject: [PATCH] riscv: ftrace: Fixup panic by disabling preemption

In RISCV, we must use an AUIPC + JALR pair to encode an immediate,
forming a jump that jumps to an address over 4K. This may cause errors
if we want to enable kernel preemption and remove dependency from
patching code with stop_machine(). For example, if a task was switched
out on auipc. And, if we changed the ftrace function before it was
switched back, then it would jump to an address that has updated 11:0
bits mixing with previous XLEN:12 part.

p: patched area performed by dynamic ftrace
ftrace_prologue:
p|      REG_S   ra, -SZREG(sp)
p|      auipc   ra, 0x? ------------> preempted
					...
				change ftrace function
					...
p|      jalr    -?(ra) <------------- switched back
p|      REG_L   ra, -SZREG(sp)
func:
	xxx
	ret

Fixes: afc76b8b8011 ("riscv: Using PATCHABLE_FUNCTION_ENTRY instead of MCOUNT")
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230112090603.1295340-2-guoren@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index e2b656043abf..ee0d39b26794 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -138,7 +138,7 @@ config RISCV
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS if HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
 	select HAVE_FUNCTION_GRAPH_TRACER
-	select HAVE_FUNCTION_TRACER if !XIP_KERNEL
+	select HAVE_FUNCTION_TRACER if !XIP_KERNEL && !PREEMPTION
 
 config ARCH_MMAP_RND_BITS_MIN
 	default 18 if 64BIT

