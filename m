Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C107D719
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbfHAITt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:19:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46677 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbfHAITt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:19:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id c3so10466826pfa.13
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lhetsf/v1WHqsODDPiuS8lCaAlBwJqZTnWnIuf4OhuE=;
        b=IeSrybNXM1FIuaHjdY8UGbg00YzSWruFMn1J7qNAW3drOxKc0UR8dxZDM5PD/UwY9x
         crfCdf8Q/xTPuaVROFU/r8eIsG9JXSdJGbjUk2DQH+rIPUUK8C3VNg2wcYriMmtqGNJT
         7j4NI63W+dSuf3NJWh0T7mG2Cw8wSakGtzWws8D97SnvRP6mpWDaG62Q8ukYZh3xNWAS
         bHT+s5u0WQ5XjcbNpFziJfAkntmqjT2wtaDVQ0RzER6/blMnFCrZhvS1x/2b6IzqPe2o
         t8qPEVYRxsRguSB7/QUcvmTdeatQF8Of3ll29ZRRZ4t3FmlNSiDoNElGjxoS23J1Irhp
         k1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lhetsf/v1WHqsODDPiuS8lCaAlBwJqZTnWnIuf4OhuE=;
        b=nIcZqAAPlyPDPnAQrrtIEvtwXwaahJwdvohC56k2o1hW5qg1xCIVX6mONruT5HBFqj
         cZlExZWZc1IaOy68Eg/gRV7BciB5gnwwSTXp4oiF00z9NPCBSZ0/jRQaEoLNXYOcitsF
         6+LvKktu30HbO+2jRJ34v5g5r6ZrPjfg2bfBCoD7Lnl31oMASmO9HPs4Q9v4NnSitGv9
         MaufcW+jV+envvPWZG/kHh606tHjDwpoIUwrxxJIslj2+PaVYgsRAglLpFtbEP7DOMQU
         UBlNi8IxD4TfRxlOa4EFxiun5jT/Kbk9IZXKzd3EH0tcITjfSOAECXrw5VBK8kOcP1ha
         fCvw==
X-Gm-Message-State: APjAAAVg+1lEXbk6qwJU8nxDPoWV9agKOJBTwcxdqA8Zbt/11Cm/gsu9
        yyW78vQm34tZTioWHFLRwzR1X/hRxeA=
X-Google-Smtp-Source: APXvYqzwaezWIvdwv0H5ugpgJ6JrKb46pj+oO7T+aNheVkzhLn/9E35sO38a1NI/m7ezUfYyfu5Mhw==
X-Received: by 2002:a17:90a:1ac5:: with SMTP id p63mr7090797pjp.25.1564647588607;
        Thu, 01 Aug 2019 01:19:48 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id f64sm74385803pfa.115.2019.08.01.01.19.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:19:48 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 05/47] firmware/psci: Expose PSCI conduit
Date:   Thu,  1 Aug 2019 13:45:49 +0530
Message-Id: <9af0ed2a4a54549532931e98643daa5ed274ac8f.1564646727.git.viresh.kumar@linaro.org>
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

commit 09a8d6d48499f93e2abde691f5800081cd858726 upstream.

In order to call into the firmware to apply workarounds, it is
useful to find out whether we're using HVC or SMC. Let's expose
this through the psci_ops.

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/firmware/psci.c | 28 +++++++++++++++++++++++-----
 include/linux/psci.h    |  7 +++++++
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
index 290f8982e7b3..7b2665f6b38d 100644
--- a/drivers/firmware/psci.c
+++ b/drivers/firmware/psci.c
@@ -54,7 +54,9 @@ bool psci_tos_resident_on(int cpu)
 	return cpu == resident_cpu;
 }
 
-struct psci_operations psci_ops;
+struct psci_operations psci_ops = {
+	.conduit = PSCI_CONDUIT_NONE,
+};
 
 typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
@@ -187,6 +189,22 @@ static unsigned long psci_migrate_info_up_cpu(void)
 			      0, 0, 0);
 }
 
+static void set_conduit(enum psci_conduit conduit)
+{
+	switch (conduit) {
+	case PSCI_CONDUIT_HVC:
+		invoke_psci_fn = __invoke_psci_fn_hvc;
+		break;
+	case PSCI_CONDUIT_SMC:
+		invoke_psci_fn = __invoke_psci_fn_smc;
+		break;
+	default:
+		WARN(1, "Unexpected PSCI conduit %d\n", conduit);
+	}
+
+	psci_ops.conduit = conduit;
+}
+
 static int get_set_conduit_method(struct device_node *np)
 {
 	const char *method;
@@ -199,9 +217,9 @@ static int get_set_conduit_method(struct device_node *np)
 	}
 
 	if (!strcmp("hvc", method)) {
-		invoke_psci_fn = __invoke_psci_fn_hvc;
+		set_conduit(PSCI_CONDUIT_HVC);
 	} else if (!strcmp("smc", method)) {
-		invoke_psci_fn = __invoke_psci_fn_smc;
+		set_conduit(PSCI_CONDUIT_SMC);
 	} else {
 		pr_warn("invalid \"method\" property: %s\n", method);
 		return -EINVAL;
@@ -463,9 +481,9 @@ int __init psci_acpi_init(void)
 	pr_info("probing for conduit method from ACPI.\n");
 
 	if (acpi_psci_use_hvc())
-		invoke_psci_fn = __invoke_psci_fn_hvc;
+		set_conduit(PSCI_CONDUIT_HVC);
 	else
-		invoke_psci_fn = __invoke_psci_fn_smc;
+		set_conduit(PSCI_CONDUIT_SMC);
 
 	return psci_probe();
 }
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 04b4d92c7791..e071a1b8ddb5 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -24,6 +24,12 @@ bool psci_tos_resident_on(int cpu);
 bool psci_power_state_loses_context(u32 state);
 bool psci_power_state_is_valid(u32 state);
 
+enum psci_conduit {
+	PSCI_CONDUIT_NONE,
+	PSCI_CONDUIT_SMC,
+	PSCI_CONDUIT_HVC,
+};
+
 struct psci_operations {
 	u32 (*get_version)(void);
 	int (*cpu_suspend)(u32 state, unsigned long entry_point);
@@ -33,6 +39,7 @@ struct psci_operations {
 	int (*affinity_info)(unsigned long target_affinity,
 			unsigned long lowest_affinity_level);
 	int (*migrate_info_type)(void);
+	enum psci_conduit conduit;
 };
 
 extern struct psci_operations psci_ops;
-- 
2.21.0.rc0.269.g1a574e7a288b

