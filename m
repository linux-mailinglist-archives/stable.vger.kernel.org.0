Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A11045289
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfFNDNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45459 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id s21so656762pga.12
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8FgYZ0lVoh76yEFRGdkiTuXxRHgDjc15a9Db0UAG0RM=;
        b=lv7ALkokBtCxuF0Pb2QGAynH5EmP6+hWl8YTf/8htRpD/JOpxkK1Xua6Q32p3zAcJG
         MlKJcqsbz1BZt1tqo8tVvOPin1iNWGS1K6vb4+S5DL/w8JwY69CkxhmvsPgybtMSUt2y
         dX4adwqML14qOFeBbRhLQVBoxwaKNGrAXPQWW/CSQmHOJAznIPzo/P9umTzO4khHXPEd
         /ElLjLUlWaRKbTTbi6i8H6WoRILdTuSgwWQy5f5rY2018+96HoUsMaCWeV6KsfoEu/uG
         6NciLkwwDCxmVny3AZfHRF7pM7QkTQpPdnKJQW9w4ut5rsTLsv63X3Z0VD/EfTN1ypud
         hTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8FgYZ0lVoh76yEFRGdkiTuXxRHgDjc15a9Db0UAG0RM=;
        b=nHSM7GYLTQc7bmuv66xFCLCbSqprHOrljpu/NYUeeCchWBf3/FuBkIG6IG17oFQxpA
         O8Qiq37k9j1KZ/WM3z6qZm8hB3pBF1GMDMzC4S5EeOUf9aSYq3VDLPt7koi+kPuqsV/W
         0uYZCukBLzk4e8ij2bEE5vQORV4S3YSY+DeNwHVjf04IK/GIl8wJyHQZdsURJk2znC1+
         Q8VbByylUcz4aXIiOGfdf7Gj4OWr5ryu2i/sefj3KTfPGq+UtWXRLxzwJOFgxIf79kWq
         MYkkTKypnOjrLSHQAAbhe7FAXdrCCiPIDzcoQAFxKheplND3uCLzEMh5GgXCi/3tMsrF
         9i6g==
X-Gm-Message-State: APjAAAUDjf9SlNkuIPTYxHvXIIhuF86Qa6A2ceBXQtucE6+niI1JH8qS
        NLiZDaCZQWHDcmXaQwfOrxBwSA==
X-Google-Smtp-Source: APXvYqyDXM7aoINn+8QnduB+nrz7bywuRlRv2t73TBC3yrYzXbRk5w8bFtjmk/a4c24kE7Z/jM17rg==
X-Received: by 2002:a17:90a:5d0a:: with SMTP id s10mr8696027pji.94.1560482019108;
        Thu, 13 Jun 2019 20:13:39 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id s15sm1080007pfd.183.2019.06.13.20.13.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:38 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 40/45] firmware/psci: Expose SMCCC version through psci_ops
Date:   Fri, 14 Jun 2019 08:38:23 +0530
Message-Id: <c5cd47362213c8f61cbb1ef99b7c2e2ac7158d72.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit e78eef554a912ef6c1e0bbf97619dafbeae3339f upstream.

Since PSCI 1.0 allows the SMCCC version to be (indirectly) probed,
let's do that at boot time, and expose the version of the calling
convention as part of the psci_ops structure.

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Included arm-smccc.h ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/firmware/psci.c | 28 ++++++++++++++++++++++++++++
 include/linux/psci.h    |  6 ++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
index 7b2665f6b38d..0809a48e8089 100644
--- a/drivers/firmware/psci.c
+++ b/drivers/firmware/psci.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) "psci: " fmt
 
+#include <linux/arm-smccc.h>
 #include <linux/errno.h>
 #include <linux/linkage.h>
 #include <linux/of.h>
@@ -56,6 +57,7 @@ bool psci_tos_resident_on(int cpu)
 
 struct psci_operations psci_ops = {
 	.conduit = PSCI_CONDUIT_NONE,
+	.smccc_version = SMCCC_VERSION_1_0,
 };
 
 typedef unsigned long (psci_fn)(unsigned long, unsigned long,
@@ -320,6 +322,31 @@ static void __init psci_init_migrate(void)
 	pr_info("Trusted OS resident on physical CPU 0x%lx\n", cpuid);
 }
 
+static void __init psci_init_smccc(void)
+{
+	u32 ver = ARM_SMCCC_VERSION_1_0;
+	int feature;
+
+	feature = psci_features(ARM_SMCCC_VERSION_FUNC_ID);
+
+	if (feature != PSCI_RET_NOT_SUPPORTED) {
+		u32 ret;
+		ret = invoke_psci_fn(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0);
+		if (ret == ARM_SMCCC_VERSION_1_1) {
+			psci_ops.smccc_version = SMCCC_VERSION_1_1;
+			ver = ret;
+		}
+	}
+
+	/*
+	 * Conveniently, the SMCCC and PSCI versions are encoded the
+	 * same way. No, this isn't accidental.
+	 */
+	pr_info("SMC Calling Convention v%d.%d\n",
+		PSCI_VERSION_MAJOR(ver), PSCI_VERSION_MINOR(ver));
+
+}
+
 static void __init psci_0_2_set_functions(void)
 {
 	pr_info("Using standard PSCI v0.2 function IDs\n");
@@ -368,6 +395,7 @@ static int __init psci_probe(void)
 	psci_init_migrate();
 
 	if (PSCI_VERSION_MAJOR(ver) >= 1) {
+		psci_init_smccc();
 		psci_init_cpu_suspend();
 		psci_init_system_suspend();
 	}
diff --git a/include/linux/psci.h b/include/linux/psci.h
index e071a1b8ddb5..e5c3277bfd78 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -30,6 +30,11 @@ enum psci_conduit {
 	PSCI_CONDUIT_HVC,
 };
 
+enum smccc_version {
+	SMCCC_VERSION_1_0,
+	SMCCC_VERSION_1_1,
+};
+
 struct psci_operations {
 	u32 (*get_version)(void);
 	int (*cpu_suspend)(u32 state, unsigned long entry_point);
@@ -40,6 +45,7 @@ struct psci_operations {
 			unsigned long lowest_affinity_level);
 	int (*migrate_info_type)(void);
 	enum psci_conduit conduit;
+	enum smccc_version smccc_version;
 };
 
 extern struct psci_operations psci_ops;
-- 
2.21.0.rc0.269.g1a574e7a288b

