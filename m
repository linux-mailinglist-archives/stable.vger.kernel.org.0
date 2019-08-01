Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A44A7D71A
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbfHAITw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:19:52 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43593 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbfHAITw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:19:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so24862373pld.10
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8FgYZ0lVoh76yEFRGdkiTuXxRHgDjc15a9Db0UAG0RM=;
        b=U2pFy8zplP29YpsCH8W5CImqW9kDRTXequpz5TZjdTd/cKjWqInrw3Uwd1AL2uD6lU
         qbZ/TwswNmotIc7tfzAT06bNLn3+R8t/4ayZ3lv6smnADiIqJ77U8FH5+ntKrSwXrMCf
         XkgfLzlAC8TJa9x6Elq24iJrBFMA2SC0pp/liR93dQ4TUU8E2GuBBHp6WlVS6LSJhNao
         ImLUvMYM8Id3R/lKhgjC7TaPnfvasBP4OyyrDRFHP8oH957QYy7TLvliiwmwD+dQAitC
         aEVWiulUEAtHO7t4spHHwYrNSMz+RgEFMpvh3JV3t4gQZMGjxPO20KwIbAnbo9bsihGo
         c+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8FgYZ0lVoh76yEFRGdkiTuXxRHgDjc15a9Db0UAG0RM=;
        b=ls+cNyXc5mZ1F/jaf/rljfwENA0487i1p2lc7Uy4YtuROp2YzZ0YczVSHS88Orp9DO
         XOYRYzVQ9i8pg976xIDg7aE1q7WgMDXsHz/J9kHrk6J1YjNqR91mCJ9M260N9buh0awG
         Ct2qDBr5JOWcVMhCGm7rzQscoFaz6/f1pI6RolRT3Tf3vxbnQO6MSi7zRQFxZUzcObni
         pB7DmOWIezTp4zrLLR0Ch8HWNHUjJsKiCr3esNF21WasuibnKBSb166SpQgP+vO2+GYd
         QMgfyFDYtlwA3boy9HxjP9C2HfHObcZzL+Fsqt8QiUnEyop1W4gXMUVvVQ86WMghuIxQ
         GdZg==
X-Gm-Message-State: APjAAAWY4YM/ti67oJqsHTGe91n+Bv+jQFg8Fz/H3AWe0n6cPgeEnlaU
        MvdEBXdOf1OQWuBxKP/k5uIC1haFbFo=
X-Google-Smtp-Source: APXvYqzSgtxQ3JDCBf442PLtZn52NA1MhiDih6RwxeLZMFxUsFnDqNuIiXEcBuC3C4LEZKGa4aagUQ==
X-Received: by 2002:a17:902:ff05:: with SMTP id f5mr120452352plj.116.1564647591056;
        Thu, 01 Aug 2019 01:19:51 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id l6sm71842795pga.72.2019.08.01.01.19.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:19:50 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 06/47] firmware/psci: Expose SMCCC version through psci_ops
Date:   Thu,  1 Aug 2019 13:45:50 +0530
Message-Id: <df931c6a40eda93c9021c01ceddcb5115ebeb2c8.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
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

