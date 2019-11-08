Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED348F4BDA
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKHMhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHMhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:01 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8E93224EE;
        Fri,  8 Nov 2019 12:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216619;
        bh=9zEzgaF/i100FaTDlnTkpTkWH3xkB6p+qvk0HYo0cBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQRByXrtM+NLdJqr9HprsGLjogWdepBXZ7Ds+wZOrxJ29WFPSL4OSt5fQpjQ33dQl
         c1sp6pb2a6nm4nxSynC4ZJLbruhSx/xVBmokNYxMK5coWazvZrnNV668QC+f+FdpMc
         1IBN969ohJ/yjqGFmJFF53zvWoS/pOUkfULnmxPk=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 30/50] ARM: signal: copy registers using __copy_from_user()
Date:   Fri,  8 Nov 2019 13:35:34 +0100
Message-Id: <20191108123554.29004-31-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit c32cd419d6650e42b9cdebb83c672ec945e6bd7e upstream.

__get_user_error() is used as a fast accessor to make copying structure
members in the signal handling path as efficient as possible.  However,
with software PAN and the recent Spectre variant 1, the efficiency is
reduced as these are no longer fast accessors.

In the case of software PAN, it has to switch the domain register around
each access, and with Spectre variant 1, it would have to repeat the
access_ok() check for each access.

It becomes much more efficient to use __copy_from_user() instead, so
let's use this for the ARM integer registers.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/kernel/signal.c | 38 +++++++++++---------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 7b8f2141427b..a592bc0287f8 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -141,6 +141,7 @@ struct rt_sigframe {
 
 static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
 {
+	struct sigcontext context;
 	struct aux_sigframe __user *aux;
 	sigset_t set;
 	int err;
@@ -149,23 +150,26 @@ static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
 	if (err == 0)
 		set_current_blocked(&set);
 
-	__get_user_error(regs->ARM_r0, &sf->uc.uc_mcontext.arm_r0, err);
-	__get_user_error(regs->ARM_r1, &sf->uc.uc_mcontext.arm_r1, err);
-	__get_user_error(regs->ARM_r2, &sf->uc.uc_mcontext.arm_r2, err);
-	__get_user_error(regs->ARM_r3, &sf->uc.uc_mcontext.arm_r3, err);
-	__get_user_error(regs->ARM_r4, &sf->uc.uc_mcontext.arm_r4, err);
-	__get_user_error(regs->ARM_r5, &sf->uc.uc_mcontext.arm_r5, err);
-	__get_user_error(regs->ARM_r6, &sf->uc.uc_mcontext.arm_r6, err);
-	__get_user_error(regs->ARM_r7, &sf->uc.uc_mcontext.arm_r7, err);
-	__get_user_error(regs->ARM_r8, &sf->uc.uc_mcontext.arm_r8, err);
-	__get_user_error(regs->ARM_r9, &sf->uc.uc_mcontext.arm_r9, err);
-	__get_user_error(regs->ARM_r10, &sf->uc.uc_mcontext.arm_r10, err);
-	__get_user_error(regs->ARM_fp, &sf->uc.uc_mcontext.arm_fp, err);
-	__get_user_error(regs->ARM_ip, &sf->uc.uc_mcontext.arm_ip, err);
-	__get_user_error(regs->ARM_sp, &sf->uc.uc_mcontext.arm_sp, err);
-	__get_user_error(regs->ARM_lr, &sf->uc.uc_mcontext.arm_lr, err);
-	__get_user_error(regs->ARM_pc, &sf->uc.uc_mcontext.arm_pc, err);
-	__get_user_error(regs->ARM_cpsr, &sf->uc.uc_mcontext.arm_cpsr, err);
+	err |= __copy_from_user(&context, &sf->uc.uc_mcontext, sizeof(context));
+	if (err == 0) {
+		regs->ARM_r0 = context.arm_r0;
+		regs->ARM_r1 = context.arm_r1;
+		regs->ARM_r2 = context.arm_r2;
+		regs->ARM_r3 = context.arm_r3;
+		regs->ARM_r4 = context.arm_r4;
+		regs->ARM_r5 = context.arm_r5;
+		regs->ARM_r6 = context.arm_r6;
+		regs->ARM_r7 = context.arm_r7;
+		regs->ARM_r8 = context.arm_r8;
+		regs->ARM_r9 = context.arm_r9;
+		regs->ARM_r10 = context.arm_r10;
+		regs->ARM_fp = context.arm_fp;
+		regs->ARM_ip = context.arm_ip;
+		regs->ARM_sp = context.arm_sp;
+		regs->ARM_lr = context.arm_lr;
+		regs->ARM_pc = context.arm_pc;
+		regs->ARM_cpsr = context.arm_cpsr;
+	}
 
 	err |= !valid_user_regs(regs);
 
-- 
2.20.1

