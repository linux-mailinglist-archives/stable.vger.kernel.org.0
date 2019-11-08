Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD0BF5425
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733035AbfKHSyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733026AbfKHSyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1C6D218AE;
        Fri,  8 Nov 2019 18:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239278;
        bh=G5koLnlXtw0DchERfXqkmtwlK3URehPO7qNSCWz7f2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Upe3FpEO2ObH55RLpJlqzkn1SBFiG1rxjAmQs7iWZkFI4WgNNtgR6CeuEnahLs8D5
         MVEQ889FDElVLBORv+/g9yMpgfCM958O+m4w9wtuSbH71pZ46YRvXfdIGgpa0qcOue
         UP8LTPfn1QAX5YzfuhCjrbFGPlkS/whwkDO/yc1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Thierry <julien.thierry@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David A. Long" <dave.long@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 60/75] ARM: 8791/1: vfp: use __copy_to_user() when saving VFP state
Date:   Fri,  8 Nov 2019 19:50:17 +0100
Message-Id: <20191108174801.038118689@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit 3aa2df6ec2ca6bc143a65351cca4266d03a8bc41 upstream.

Use __copy_to_user() rather than __put_user_error() for individual
members when saving VFP state.
This has the benefit of disabling/enabling PAN once per copied struct
intead of once per write.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/thread_info.h |    4 ++--
 arch/arm/kernel/signal.c           |   13 +++++++------
 arch/arm/vfp/vfpmodule.c           |   20 ++++++++------------
 3 files changed, 17 insertions(+), 20 deletions(-)

--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -124,8 +124,8 @@ extern void vfp_flush_hwstate(struct thr
 struct user_vfp;
 struct user_vfp_exc;
 
-extern int vfp_preserve_user_clear_hwstate(struct user_vfp __user *,
-					   struct user_vfp_exc __user *);
+extern int vfp_preserve_user_clear_hwstate(struct user_vfp *,
+					   struct user_vfp_exc *);
 extern int vfp_restore_user_hwstate(struct user_vfp *,
 				    struct user_vfp_exc *);
 #endif
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -94,17 +94,18 @@ static int restore_iwmmxt_context(struct
 
 static int preserve_vfp_context(struct vfp_sigframe __user *frame)
 {
-	const unsigned long magic = VFP_MAGIC;
-	const unsigned long size = VFP_STORAGE_SIZE;
+	struct vfp_sigframe kframe;
 	int err = 0;
 
-	__put_user_error(magic, &frame->magic, err);
-	__put_user_error(size, &frame->size, err);
+	memset(&kframe, 0, sizeof(kframe));
+	kframe.magic = VFP_MAGIC;
+	kframe.size = VFP_STORAGE_SIZE;
 
+	err = vfp_preserve_user_clear_hwstate(&kframe.ufp, &kframe.ufp_exc);
 	if (err)
-		return -EFAULT;
+		return err;
 
-	return vfp_preserve_user_clear_hwstate(&frame->ufp, &frame->ufp_exc);
+	return __copy_to_user(frame, &kframe, sizeof(kframe));
 }
 
 static int restore_vfp_context(struct vfp_sigframe __user *auxp)
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -558,12 +558,11 @@ void vfp_flush_hwstate(struct thread_inf
  * Save the current VFP state into the provided structures and prepare
  * for entry into a new function (signal handler).
  */
-int vfp_preserve_user_clear_hwstate(struct user_vfp __user *ufp,
-				    struct user_vfp_exc __user *ufp_exc)
+int vfp_preserve_user_clear_hwstate(struct user_vfp *ufp,
+				    struct user_vfp_exc *ufp_exc)
 {
 	struct thread_info *thread = current_thread_info();
 	struct vfp_hard_struct *hwstate = &thread->vfpstate.hard;
-	int err = 0;
 
 	/* Ensure that the saved hwstate is up-to-date. */
 	vfp_sync_hwstate(thread);
@@ -572,22 +571,19 @@ int vfp_preserve_user_clear_hwstate(stru
 	 * Copy the floating point registers. There can be unused
 	 * registers see asm/hwcap.h for details.
 	 */
-	err |= __copy_to_user(&ufp->fpregs, &hwstate->fpregs,
-			      sizeof(hwstate->fpregs));
+	memcpy(&ufp->fpregs, &hwstate->fpregs, sizeof(hwstate->fpregs));
+
 	/*
 	 * Copy the status and control register.
 	 */
-	__put_user_error(hwstate->fpscr, &ufp->fpscr, err);
+	ufp->fpscr = hwstate->fpscr;
 
 	/*
 	 * Copy the exception registers.
 	 */
-	__put_user_error(hwstate->fpexc, &ufp_exc->fpexc, err);
-	__put_user_error(hwstate->fpinst, &ufp_exc->fpinst, err);
-	__put_user_error(hwstate->fpinst2, &ufp_exc->fpinst2, err);
-
-	if (err)
-		return -EFAULT;
+	ufp_exc->fpexc = hwstate->fpexc;
+	ufp_exc->fpinst = hwstate->fpinst;
+	ufp_exc->fpinst2 = ufp_exc->fpinst2;
 
 	/* Ensure that VFP is disabled. */
 	vfp_flush_hwstate(thread);


