Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A45AA18D0
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfH2Lfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:52 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42469 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfH2Lfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id p3so1436028pgb.9
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tUK8ETga6k61l9Q+/z8rY6SIV6XG+DcjRuCd/1NWAIQ=;
        b=EKkXXo+25/F2wHAvxwC+L41EuvRc64ZuVgzd/LPBxjuYWjUOugeBxX/JmSX8/pPuWi
         tcTrkn9aLyId59ixMbK5XFkaU3wK0vKNY3VK/rHHrRBg/dPSckEW+9rmjlNWuQM9Tisx
         0KJ3e7msSb2P0/kZmniWPexAfGtt/YjGycG7slVs+YzEMUXsFeD2Aewrk9WB7F+DPfeI
         TTd0iWFy2hXN8TbqyaK53fAVy0kmnGxF83t3lGsQU142ZiTORguncJKiCnZh3bb1pSpG
         YnyCr7j6D258ztcvLdFikS1wRddMjD+luCPjxUZUU/kiSvqvN5wsIEBuOgsJZ320VmEd
         wT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tUK8ETga6k61l9Q+/z8rY6SIV6XG+DcjRuCd/1NWAIQ=;
        b=n7wkJoQuCXaZ0LBu0eBMmXr2XSp1wGIQHsj77xjw4Wx4PoJg2UFAfmIbA0Xrr2K+8J
         si6KyxSPYMs3CkdDINrI4L0Fh6FTmV8BycXf/WekQ7kJqtRoq258iLVM5nWYRK4IIhHN
         //zhXsAoPVHQjF/I0a+7WjPsRS794u2Z6ebEMV5yfqey8fC/MXVW4+yOpMCraiYl/Yss
         d4jdZzyNVnHiK+YG3lKLVCkM4kT9r+Nq5ZXt7qnVqvuCWF9Q6UHUFmY9Wnf87KsnQl2b
         0uubg9m8/qe5eQXjphekx2dGO7IoCkecR/cCLrqncMgb58B3ZtzD1rWXz+izMxCsaoBK
         iohg==
X-Gm-Message-State: APjAAAVlZEjOt+gGiGUG2loQBJIfayBaabeNns86XhKfAVqHgnbP5wy2
        PVLr3h+VwT4h9j5ST2CdGFnMBeMFUaI=
X-Google-Smtp-Source: APXvYqwyRqyVrCjmXqfEVcoS++1F677bWD4W2x6l2td9wpndpwTN/jv+TLo91zKWOXfA3/0yBbtMTA==
X-Received: by 2002:a17:90b:8c1:: with SMTP id ds1mr9513477pjb.114.1567078551685;
        Thu, 29 Aug 2019 04:35:51 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id c199sm3767496pfb.28.2019.08.29.04.35.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:50 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 22/44] drivers/firmware: Expose psci_get_version through psci_ops structure
Date:   Thu, 29 Aug 2019 17:04:07 +0530
Message-Id: <116c1fadc5685b62ab36b1a368eede3f9b1bb9da.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit d68e3ba5303f7e1099f51fdcd155f5263da8569b upstream.

Entry into recent versions of ARM Trusted Firmware will invalidate the CPU
branch predictor state in order to protect against aliasing attacks.

This patch exposes the PSCI "VERSION" function via psci_ops, so that it
can be invoked outside of the PSCI driver where necessary.

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/firmware/psci.c | 2 ++
 include/linux/psci.h    | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
index ae70d2485ca1..290f8982e7b3 100644
--- a/drivers/firmware/psci.c
+++ b/drivers/firmware/psci.c
@@ -305,6 +305,8 @@ static void __init psci_init_migrate(void)
 static void __init psci_0_2_set_functions(void)
 {
 	pr_info("Using standard PSCI v0.2 function IDs\n");
+	psci_ops.get_version = psci_get_version;
+
 	psci_function_id[PSCI_FN_CPU_SUSPEND] =
 					PSCI_FN_NATIVE(0_2, CPU_SUSPEND);
 	psci_ops.cpu_suspend = psci_cpu_suspend;
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 12c4865457ad..04b4d92c7791 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -25,6 +25,7 @@ bool psci_power_state_loses_context(u32 state);
 bool psci_power_state_is_valid(u32 state);
 
 struct psci_operations {
+	u32 (*get_version)(void);
 	int (*cpu_suspend)(u32 state, unsigned long entry_point);
 	int (*cpu_off)(u32 state);
 	int (*cpu_on)(unsigned long cpuid, unsigned long entry_point);
-- 
2.21.0.rc0.269.g1a574e7a288b

