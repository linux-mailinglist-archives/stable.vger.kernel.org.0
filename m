Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8C27D739
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbfHAIUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44304 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731089AbfHAIUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so33734644pgl.11
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uRyk3zcBxn+kArv7clzkKBJGfRbp0pIX9juxiKGvE2U=;
        b=b2McCC/WCcGBPzkhtxUUkoJMeMcdJguyRODCBJ0WTu/VoS9DEEque4sOadkrF9Nbft
         lPCrVhWn8e8vlLv2WWnVQZJRuv3ttph1yCzYhXrPNBvES/oMHX2J1WpCdT1oG9MQMP+D
         Jt/0F9x460JOvtbf5koGqj6pES0Ec3SdobEldPLHFvYJvGZET5aHonfh2gMfP5ZT/VLg
         EJFEuXzxVGFfmlErLRbS0l/WPAPQuTGoCIH/i0Z5vanbDpw4ZjXJQREgsoYvtVVpVzbM
         eVc3rMqWzX0hfKrrk3QsXMlXzD6NdG5EZbR19l0oj43J9RBgyjDLk2+iB6/q7m5FMEvc
         9xtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uRyk3zcBxn+kArv7clzkKBJGfRbp0pIX9juxiKGvE2U=;
        b=kLqfenlKphL3DUeNjCNhHJpGoIWUWeHu7Y9AP55oX9DtMlBlu7o8APazRjQTUFnhqT
         M3mVA9w57Lz+ATvSnna+YvInIdB26/5V6pHjqr/6LHxjVUI1qL5vGTymh0qsve5wJlYC
         vDPUcgZGPj07Q3FFRdY4yuwA+71QDJe2vokhSBHq5zwYGnHE/eoI9MGk6fx1PW7MKfWX
         NHbbjk98MyQLcEVhjSd/QWtc3me2j2Ofy5VmkQnztAibwlM0nT96SQVJ9cxuiDr0ZUFi
         sCM8/AD1C2x5ONqNnxB88+R47eUOzKX15cNTWtTPRGLY9IBuff8Vti2VCSUOfdD8zwqL
         6O4g==
X-Gm-Message-State: APjAAAXLQE0BSYlAebtzTn0FmV66OLAehKGXuww5XdXw/fy3vmynXzNx
        ZTWg0C6Zb3Q5q7rgV2JDqoR7uFL9Y+8=
X-Google-Smtp-Source: APXvYqxL4re/D71PbEnnmwmOeprKRJUhUxiAc8Bj8thOBjsQS5N86j2M8Po5fkRwLg7hw8Lweus4EA==
X-Received: by 2002:aa7:9dcd:: with SMTP id g13mr53047380pfq.204.1564647635649;
        Thu, 01 Aug 2019 01:20:35 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id n17sm74761757pfq.182.2019.08.01.01.20.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:35 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 23/47] ARM: vfp: use __copy_from_user() when restoring VFP state
Date:   Thu,  1 Aug 2019 13:46:07 +0530
Message-Id: <8476fc23988444fda761ae9d99563cea0b21c191.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
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
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/thread_info.h |  4 ++--
 arch/arm/kernel/signal.c           | 18 ++++++++----------
 arch/arm/vfp/vfpmodule.c           | 17 +++++++----------
 3 files changed, 17 insertions(+), 22 deletions(-)

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
index a592bc0287f8..76f85c38f2b8 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -107,21 +107,19 @@ static int preserve_vfp_context(struct vfp_sigframe __user *frame)
 	return vfp_preserve_user_clear_hwstate(&frame->ufp, &frame->ufp_exc);
 }
 
-static int restore_vfp_context(struct vfp_sigframe __user *frame)
+static int restore_vfp_context(struct vfp_sigframe __user *auxp)
 {
-	unsigned long magic;
-	unsigned long size;
-	int err = 0;
-
-	__get_user_error(magic, &frame->magic, err);
-	__get_user_error(size, &frame->size, err);
+	struct vfp_sigframe frame;
+	int err;
 
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
2.21.0.rc0.269.g1a574e7a288b

