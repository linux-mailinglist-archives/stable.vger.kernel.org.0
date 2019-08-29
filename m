Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9103DA18E7
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfH2Lgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36392 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfH2Lgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id w2so1874231pfi.3
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8FgYZ0lVoh76yEFRGdkiTuXxRHgDjc15a9Db0UAG0RM=;
        b=UeOn1W6gwCyzjiugPXX9SymT/iYCvcguyV59792moJTQ0odoPIXAPUDBRV5S7/ZGnz
         5LmJ2aoVZ/BH5zX3UM7Ot5Lvj1GLHlfSQJ6y85yEiGvj8gY4+jMYcqFv3DdEcGOHmy14
         XlJiiVT+m8VhZHrXTyIxObNjygZVYGrCro+uaz9h1Nw4FZwmGpU8iQO2yRB4vS67itrA
         odn9Yw5LwC5AG45CtUY5g1U0UpM09fMOAWj5qZnweKbY1hvLI/B9FIRY/TO4GRichLyn
         ttyQVfv0rgHThUXWTw2ZKzW4Eesi+LQpVES7ypKaKBsu99fp3xAjjtmXwy27fSV2A7co
         wkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8FgYZ0lVoh76yEFRGdkiTuXxRHgDjc15a9Db0UAG0RM=;
        b=sZpowqV5ZT9aiPkt96GZyzqSBtry2e1SLSpZ2R7dgAsqsZ6JFAsJotax6NzLy3E5FO
         9tkZfHuaonwNsS0EeC+yiEbdxXmG3hUkZl+6CFa8I86sPC7bQ2tBNNtQGh0jNRl/gXBv
         xabU6RBua+uFdaB1Ln3Om2NIgnKACpXefRpKYrJELs3jaj60lIyE/1IJP9mFePx34ig3
         nXBb7xAU0+HunrF0CbMIyC4uNsu4UncWx708kxndmz+/ndt4EfTYoAi/JmVpY8/IYuNP
         raD8QzH+YuBwCZ1ffnRVX0uoa4VGbZZAxyD9KLkUGxfZ5E2PQL5avzebwa26J3VL9Pnk
         sufA==
X-Gm-Message-State: APjAAAV6H6QOJ9V8uy34Ex5WCJTT8WaD8/4kloQDFeGjYyYWifkaTFAv
        JA2Qc0PjDpgX6qboToPj91rzjE/6pxk=
X-Google-Smtp-Source: APXvYqzyfv+SDuNRi+YLnL07o5whOghOfzYx0kIYQQjE58yIpOlQiv4SDlwagANtMgS/gecP2JwvAg==
X-Received: by 2002:a65:5144:: with SMTP id g4mr7940524pgq.202.1567078596132;
        Thu, 29 Aug 2019 04:36:36 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id m145sm2667406pfd.68.2019.08.29.04.36.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:35 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 39/44] firmware/psci: Expose SMCCC version through psci_ops
Date:   Thu, 29 Aug 2019 17:04:24 +0530
Message-Id: <0e4f990741cd3607fbdf1fc46dc7f47c598b199a.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
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

