Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212B77D742
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbfHAIUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33325 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfHAIUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so31784329plo.0
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MgdKvQC/PG/qzasZyBmDzAkccfxFwFqJHdwmPruVads=;
        b=M/W0Na2Zy7+HBEvHxxb6P/FPKdVkMATRN4C9Zb77vqKqQhL6z7bpMb1EeSx6PCKSXP
         WIpm09ydesGuVwKMj+W1yik9OCyQfN6plQEwk4acdSnuulENxPHSU0NaxsqQRRX0OI7Q
         CJ0tqIjPLDjnBIOWX5BruNZGIu9Qcme1K2e3M+sHqvXxw5u8OHzx11C0FhOuZ3LDh7OG
         Chz2+U3DN9zgQWBVGzmzxpJA5H8T8XIB//yeb10FYl9FV1Dimc13X4LokQdTvFyqY6vp
         ivz+ZoapG/08jHgX0zsH7JhOVAEay8pOIsb6pQiJUTzbVriQoqreFrBxWT58hO5m/UO3
         cJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MgdKvQC/PG/qzasZyBmDzAkccfxFwFqJHdwmPruVads=;
        b=ULFfBSxfgapmkqgiwaYLZVbsoApkSUJP+gTCHy8xkJObOcrNdbW0JMgHTYd8pbLwJD
         icz8Z01bwmLyTTBpFRiP/u4nG2xnbcwY3YnzEtRcuXmhC23cBGCvnz40PyYAEiaJ638Z
         jH5GWVRr/2zOBIZA3vVdV9uCSI/cUfIIm2HZB4XlQ4jBzXXbtHeuyCCDaQVBMkfa0yMr
         19nSYW2LnYB/CCuNiPlV2Uw0TTtoJPtaLugXjIl8VxykLs1fymXRgaAOEpKJ5GIw1soS
         KIfebfm3YJ1lFHNjjhOak4NQr8V1uUyhQIg+g1/mMHStdz15zgw2rjq4XHo8BXAyNvNw
         n2Ug==
X-Gm-Message-State: APjAAAU5HPi8UADzDfQSJXsZdwI/Bogus3jkjUJLLGU/RUzcrx41ynRk
        0nGGL6iCbvXJtr9bP2oIXV2j+fRcxRc=
X-Google-Smtp-Source: APXvYqwtnX5haa3mjsJZEuPJitXn8/aU61HgK/ZxG2IVG2xywq2bD6FMIeoJyjny8aFcR2dHWhALVw==
X-Received: by 2002:a17:902:f095:: with SMTP id go21mr126863136plb.58.1564647648095;
        Thu, 01 Aug 2019 01:20:48 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id z12sm52519280pfn.29.2019.08.01.01.20.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:47 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 28/47] ARM: 8789/1: signal: copy registers using __copy_to_user()
Date:   Thu,  1 Aug 2019 13:46:12 +0530
Message-Id: <cbbdded762d4e1547f3574a56e3ae78a35c82ba6.1564646727.git.viresh.kumar@linaro.org>
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

Commit 5ca451cf6ed04443774bbb7ee45332dafa42e99f upstream.

When saving the ARM integer registers, use __copy_to_user() to
copy them into user signal frame, rather than __put_user_error().
This has the benefit of disabling/enabling PAN once for the whole copy
intead of once per write.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kernel/signal.c | 49 ++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 76f85c38f2b8..98685e2523bf 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -255,30 +255,35 @@ static int
 setup_sigframe(struct sigframe __user *sf, struct pt_regs *regs, sigset_t *set)
 {
 	struct aux_sigframe __user *aux;
+	struct sigcontext context;
 	int err = 0;
 
-	__put_user_error(regs->ARM_r0, &sf->uc.uc_mcontext.arm_r0, err);
-	__put_user_error(regs->ARM_r1, &sf->uc.uc_mcontext.arm_r1, err);
-	__put_user_error(regs->ARM_r2, &sf->uc.uc_mcontext.arm_r2, err);
-	__put_user_error(regs->ARM_r3, &sf->uc.uc_mcontext.arm_r3, err);
-	__put_user_error(regs->ARM_r4, &sf->uc.uc_mcontext.arm_r4, err);
-	__put_user_error(regs->ARM_r5, &sf->uc.uc_mcontext.arm_r5, err);
-	__put_user_error(regs->ARM_r6, &sf->uc.uc_mcontext.arm_r6, err);
-	__put_user_error(regs->ARM_r7, &sf->uc.uc_mcontext.arm_r7, err);
-	__put_user_error(regs->ARM_r8, &sf->uc.uc_mcontext.arm_r8, err);
-	__put_user_error(regs->ARM_r9, &sf->uc.uc_mcontext.arm_r9, err);
-	__put_user_error(regs->ARM_r10, &sf->uc.uc_mcontext.arm_r10, err);
-	__put_user_error(regs->ARM_fp, &sf->uc.uc_mcontext.arm_fp, err);
-	__put_user_error(regs->ARM_ip, &sf->uc.uc_mcontext.arm_ip, err);
-	__put_user_error(regs->ARM_sp, &sf->uc.uc_mcontext.arm_sp, err);
-	__put_user_error(regs->ARM_lr, &sf->uc.uc_mcontext.arm_lr, err);
-	__put_user_error(regs->ARM_pc, &sf->uc.uc_mcontext.arm_pc, err);
-	__put_user_error(regs->ARM_cpsr, &sf->uc.uc_mcontext.arm_cpsr, err);
-
-	__put_user_error(current->thread.trap_no, &sf->uc.uc_mcontext.trap_no, err);
-	__put_user_error(current->thread.error_code, &sf->uc.uc_mcontext.error_code, err);
-	__put_user_error(current->thread.address, &sf->uc.uc_mcontext.fault_address, err);
-	__put_user_error(set->sig[0], &sf->uc.uc_mcontext.oldmask, err);
+	context = (struct sigcontext) {
+		.arm_r0        = regs->ARM_r0,
+		.arm_r1        = regs->ARM_r1,
+		.arm_r2        = regs->ARM_r2,
+		.arm_r3        = regs->ARM_r3,
+		.arm_r4        = regs->ARM_r4,
+		.arm_r5        = regs->ARM_r5,
+		.arm_r6        = regs->ARM_r6,
+		.arm_r7        = regs->ARM_r7,
+		.arm_r8        = regs->ARM_r8,
+		.arm_r9        = regs->ARM_r9,
+		.arm_r10       = regs->ARM_r10,
+		.arm_fp        = regs->ARM_fp,
+		.arm_ip        = regs->ARM_ip,
+		.arm_sp        = regs->ARM_sp,
+		.arm_lr        = regs->ARM_lr,
+		.arm_pc        = regs->ARM_pc,
+		.arm_cpsr      = regs->ARM_cpsr,
+
+		.trap_no       = current->thread.trap_no,
+		.error_code    = current->thread.error_code,
+		.fault_address = current->thread.address,
+		.oldmask       = set->sig[0],
+	};
+
+	err |= __copy_to_user(&sf->uc.uc_mcontext, &context, sizeof(context));
 
 	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(*set));
 
-- 
2.21.0.rc0.269.g1a574e7a288b

