Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E958F4BDB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKHMhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHMhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:02 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FAFA2245C;
        Fri,  8 Nov 2019 12:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216621;
        bh=ZLja43hAjKSrtt/cJYt/mLFmFltmV0O2fnNyq8I5ktg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzfVouqYFOy+6G4DQoNPXtx+X3jxhMsorXc6qgWJUGJm9E725oPRM056qGk6JNau1
         PixW3BU6nsNolFvRZ2h2m56eHa7ciBFCXxAqfKSJvkrYliGNjCvx22LBLiKXcYMkSO
         +2juNYjnMbwOsttp/NNKwUJoQYPjPKhxisuNsjjc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 31/50] ARM: vfp: use __copy_from_user() when restoring VFP state
Date:   Fri,  8 Nov 2019 13:35:35 +0100
Message-Id: <20191108123554.29004-32-ardb@kernel.org>
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

Commit 42019fc50dfadb219f9e6ddf4c354f3837057d80 upstream.

__get_user_error() is used as a fast accessor to make copying structure
members in the signal handling path as efficient as possible.  However,
with software PAN and the recent Spectre variant 1, the efficiency is
reduced as these are no longer fast accessors.

In the case of software PAN, it has to switch the domain register around
each access, and with Spectre variant 1, it would have to repeat the
access_ok() check for each access.

Use __copy_from_user() rather than __get_user_err() for individual
members when restoring VFP state.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/thread_info.h |  4 ++--
 arch/arm/kernel/signal.c           | 17 ++++++++---------
 arch/arm/vfp/vfpmodule.c           | 17 +++++++----------
 3 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 776757d1604a..57d2ad9c75ca 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -126,8 +126,8 @@ struct user_vfp_exc;
 
 extern int vfp_preserve_user_clear_hwstate(struct user_vfp __user *,
 					   struct user_vfp_exc __user *);
-extern int vfp_restore_user_hwstate(struct user_vfp __user *,
-				    struct user_vfp_exc __user *);
+extern int vfp_restore_user_hwstate(struct user_vfp *,
+				    struct user_vfp_exc *);
 #endif
 
 /*
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index a592bc0287f8..6bee5c9b1133 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -107,21 +107,20 @@ static int preserve_vfp_context(struct vfp_sigframe __user *frame)
 	return vfp_preserve_user_clear_hwstate(&frame->ufp, &frame->ufp_exc);
 }
 
-static int restore_vfp_context(struct vfp_sigframe __user *frame)
+static int restore_vfp_context(struct vfp_sigframe __user *auxp)
 {
-	unsigned long magic;
-	unsigned long size;
-	int err = 0;
+	struct vfp_sigframe frame;
+	int err;
 
-	__get_user_error(magic, &frame->magic, err);
-	__get_user_error(size, &frame->size, err);
+	err = __copy_from_user(&frame, (char __user *) auxp, sizeof(frame));
 
 	if (err)
-		return -EFAULT;
-	if (magic != VFP_MAGIC || size != VFP_STORAGE_SIZE)
+		return err;
+
+	if (frame.magic != VFP_MAGIC || frame.size != VFP_STORAGE_SIZE)
 		return -EINVAL;
 
-	return vfp_restore_user_hwstate(&frame->ufp, &frame->ufp_exc);
+	return vfp_restore_user_hwstate(&frame.ufp, &frame.ufp_exc);
 }
 
 #endif
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 2a61e4b04600..7aa6366b2a8d 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -601,13 +601,11 @@ int vfp_preserve_user_clear_hwstate(struct user_vfp __user *ufp,
 }
 
 /* Sanitise and restore the current VFP state from the provided structures. */
-int vfp_restore_user_hwstate(struct user_vfp __user *ufp,
-			     struct user_vfp_exc __user *ufp_exc)
+int vfp_restore_user_hwstate(struct user_vfp *ufp, struct user_vfp_exc *ufp_exc)
 {
 	struct thread_info *thread = current_thread_info();
 	struct vfp_hard_struct *hwstate = &thread->vfpstate.hard;
 	unsigned long fpexc;
-	int err = 0;
 
 	/* Disable VFP to avoid corrupting the new thread state. */
 	vfp_flush_hwstate(thread);
@@ -616,17 +614,16 @@ int vfp_restore_user_hwstate(struct user_vfp __user *ufp,
 	 * Copy the floating point registers. There can be unused
 	 * registers see asm/hwcap.h for details.
 	 */
-	err |= __copy_from_user(&hwstate->fpregs, &ufp->fpregs,
-				sizeof(hwstate->fpregs));
+	memcpy(&hwstate->fpregs, &ufp->fpregs, sizeof(hwstate->fpregs));
 	/*
 	 * Copy the status and control register.
 	 */
-	__get_user_error(hwstate->fpscr, &ufp->fpscr, err);
+	hwstate->fpscr = ufp->fpscr;
 
 	/*
 	 * Sanitise and restore the exception registers.
 	 */
-	__get_user_error(fpexc, &ufp_exc->fpexc, err);
+	fpexc = ufp_exc->fpexc;
 
 	/* Ensure the VFP is enabled. */
 	fpexc |= FPEXC_EN;
@@ -635,10 +632,10 @@ int vfp_restore_user_hwstate(struct user_vfp __user *ufp,
 	fpexc &= ~(FPEXC_EX | FPEXC_FP2V);
 	hwstate->fpexc = fpexc;
 
-	__get_user_error(hwstate->fpinst, &ufp_exc->fpinst, err);
-	__get_user_error(hwstate->fpinst2, &ufp_exc->fpinst2, err);
+	hwstate->fpinst = ufp_exc->fpinst;
+	hwstate->fpinst2 = ufp_exc->fpinst2;
 
-	return err ? -EFAULT : 0;
+	return 0;
 }
 
 /*
-- 
2.20.1

