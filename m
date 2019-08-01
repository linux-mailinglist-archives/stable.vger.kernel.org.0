Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD397D744
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbfHAIUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36366 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfHAIUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:51 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so31880461plt.3
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z+TjXjo63OoUiebA/nVcgaugef8flgCeXLGArxWolNY=;
        b=oDNzbpMHyWtAAuk+AA4TcYZ78EFl6JZ8Iti4SxiMfcc1O4tW8ZWErsVrUli0VkjSyU
         gbbCeDO8IUVJM3KzRMXnLfyV7K2WXU1VefHyR3ecG0nA8y1nsg5+Xlfc887ahn4H1Byc
         +BYB9inFuFPtPDhosjBWG/yyDYD7VORs/yyAR1dxfLR5dSqdQV+dVYdJ0RBCK5mu2SfH
         C42c5TNvpduhj/hH8fJJ+xzNepluUbsqr9+i8yJnK9GprLx/a+6C7HfY8bw+f3JOZCIF
         TKwAxaImzi2zOZxFBvoubmrXlKftUrKsjOu8Av2BGbQj8UjqcAB4Cp9gLyWlUgzaFssA
         5V1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z+TjXjo63OoUiebA/nVcgaugef8flgCeXLGArxWolNY=;
        b=CUezRzJGiKsmwEjzlXNnSUix8vgCYlsiKptoDZa+ntdBKFKvLfHrgPtuy4XvvKrreQ
         4zYiERxCjrhp7J3BQMLTJUFBom2dezYNwiRqtuxec660/lAzzSA8E5pE5w/KNwZnnsLd
         zNcgoRUycOJenrdcaz34O1DASVc5LuZW5K0trsKw0SH2gp37Tw0euDc0H8IDO5kPcSpH
         wRW2KARNUNRmVRhmV56bqlIhg9rRWyQ7TS4pXe3Ug4onvutXANv9dw3Rj1n5ivkLYQdF
         LbuYfxeLO8dEJSKQHZvxjL5z6cKa6exUZVMDDVvyvlXjPFTlTxBOfuD9gLTBovVg9SBS
         Jl1Q==
X-Gm-Message-State: APjAAAXQXLpRNByFF9j1oBjIH3ekXT3b/8t1hs0h1g16I3Gz/7IGbMtn
        Rs1w9/QGWDjPBN5FfXASuxjLH5n5tpY=
X-Google-Smtp-Source: APXvYqwq0rBdTlx8rRlkb567BcZlJ5ZxpRAejULO4h/mIBdO4VwR7jouOb86/HafLUYLWLXS4CJF8A==
X-Received: by 2002:a17:902:d917:: with SMTP id c23mr124580913plz.248.1564647650566;
        Thu, 01 Aug 2019 01:20:50 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id g8sm77853763pgk.1.2019.08.01.01.20.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:50 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 29/47] ARM: 8791/1: vfp: use __copy_to_user() when saving VFP state
Date:   Thu,  1 Aug 2019 13:46:13 +0530
Message-Id: <34c32a770df4c8d2630390fdfe3e4ec6047f721c.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
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
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/thread_info.h |  4 ++--
 arch/arm/kernel/signal.c           | 13 +++++++------
 arch/arm/vfp/vfpmodule.c           | 20 ++++++++------------
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 57d2ad9c75ca..df8420672c7e 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -124,8 +124,8 @@ extern void vfp_flush_hwstate(struct thread_info *);
 struct user_vfp;
 struct user_vfp_exc;
 
-extern int vfp_preserve_user_clear_hwstate(struct user_vfp __user *,
-					   struct user_vfp_exc __user *);
+extern int vfp_preserve_user_clear_hwstate(struct user_vfp *,
+					   struct user_vfp_exc *);
 extern int vfp_restore_user_hwstate(struct user_vfp *,
 				    struct user_vfp_exc *);
 #endif
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 98685e2523bf..6f0bd90f6d93 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -94,17 +94,18 @@ static int restore_iwmmxt_context(struct iwmmxt_sigframe *frame)
 
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
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 7aa6366b2a8d..f07567eedd82 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -558,12 +558,11 @@ void vfp_flush_hwstate(struct thread_info *thread)
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
@@ -572,22 +571,19 @@ int vfp_preserve_user_clear_hwstate(struct user_vfp __user *ufp,
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
-- 
2.21.0.rc0.269.g1a574e7a288b

