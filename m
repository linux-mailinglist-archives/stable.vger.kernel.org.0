Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA666AE5B7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjCGQAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjCGQAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:00:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E7B7B4BD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 07:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E77A61265
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 15:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F40EC433EF;
        Tue,  7 Mar 2023 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678204671;
        bh=t9EI5ShNxAoVfPPvch1ZSpAWR2nUETesIo5QYcTKJd4=;
        h=Subject:To:Cc:From:Date:From;
        b=lGXOma2MAMUmiADFoFTBY42c7KNteKv6NoDi0fsqqT2vmi3/CcEjo5YkDQuTPuBre
         bHMBTCLGEqD4FEcINSOUQKYTZbe9Jjve0QvoOBQ6nFxj+hJaGUI90SzhP8U8SQ4dmP
         FIE2WQvEbiU6AJ4e7DqQ9trZNMggdMEQppZ++pjE=
Subject: FAILED: patch "[PATCH] riscv: Avoid enabling interrupts in die()" failed to apply to 5.15-stable tree
To:     mnissler@rivosinc.com, bjorn@kernel.org, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 16:57:47 +0100
Message-ID: <1678204667104220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 130aee3fd9981297ff9354e5d5609cd59aafbbea
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678204667104220@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

130aee3fd998 ("riscv: Avoid enabling interrupts in die()")
f2913d006fcd ("RISC-V: Avoid dereferening NULL regs in die()")
3f1901110a89 ("RISC-V: Add fast call path of crash_kexec()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 130aee3fd9981297ff9354e5d5609cd59aafbbea Mon Sep 17 00:00:00 2001
From: Mattias Nissler <mnissler@rivosinc.com>
Date: Wed, 15 Feb 2023 14:48:28 +0000
Subject: [PATCH] riscv: Avoid enabling interrupts in die()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While working on something else, I noticed that the kernel would start
accepting interrupts again after crashing in an interrupt handler. Since
the kernel is already in inconsistent state, enabling interrupts is
dangerous and opens up risk of kernel state deteriorating further.
Interrupts do get enabled via what looks like an unintended side effect of
spin_unlock_irq, so switch to the more cautious
spin_lock_irqsave/spin_unlock_irqrestore instead.

Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Signed-off-by: Mattias Nissler <mnissler@rivosinc.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/r/20230215144828.3370316-1-mnissler@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 549bde5c970a..70c98ce23be2 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -34,10 +34,11 @@ void die(struct pt_regs *regs, const char *str)
 	static int die_counter;
 	int ret;
 	long cause;
+	unsigned long flags;
 
 	oops_enter();
 
-	spin_lock_irq(&die_lock);
+	spin_lock_irqsave(&die_lock, flags);
 	console_verbose();
 	bust_spinlocks(1);
 
@@ -54,7 +55,7 @@ void die(struct pt_regs *regs, const char *str)
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	spin_unlock_irq(&die_lock);
+	spin_unlock_irqrestore(&die_lock, flags);
 	oops_exit();
 
 	if (in_interrupt())

