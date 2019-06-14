Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED4D45288
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfFNDNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42971 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so487408pff.9
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lhetsf/v1WHqsODDPiuS8lCaAlBwJqZTnWnIuf4OhuE=;
        b=dzAIXfjMtBl0yLP99Ks992Mq6IPJZ1HUk7Cbh9sMLFPdCk0tjIbGqG2zuQ02QyxMll
         jM+kUdcPwm9JdTju9yvrbg8ThgOP88bOWYBqRNTKKJVn7ijo43+wsVsQbqUJItl1uuqC
         kl9DITbxr1DjaaV0vry/PlU/VBmSmjfWu86CuurkeLAk6rmmhbUx61UfBSdkvXJWnXHx
         w4RX182pDEgAvFqcb21IReDHbX6IVx3u7uvXz5GUI3/M3RcKN1eDoJ1I7TfEw5jqHGKc
         445EMtA6G9UfW0AnEtq03m5nA8StW9sR8G/tiN2bQeZCRzDw4CNP02qyubxU8Axkf4CU
         WLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lhetsf/v1WHqsODDPiuS8lCaAlBwJqZTnWnIuf4OhuE=;
        b=a/g0MvTqDO5O8CY6JbnXhaaVSyCY4mEnUWuQ4AtYSdMZfBzIE9jfaqk5cJhA7uHd3u
         q6fmrspFlNic2z++DTBDsqHan1/r2G3ie+bB2yb3vDRXG2Rgx5i4PdGWSsxOTyDdCLmR
         qzM6G7zUN8qCUh2oBg9qlqDWWJvg/ZJlDIwBl+houpTxnrr79WBEzg5uT+KJAF6QABYV
         LxIo1KAAhoT5IgU9o912zu/snvf4C7np1QC5XQph+I2VF9HPJ9QOrvsMzyC+dPFlAXRe
         aquxVjOirdc6jRqOLq1spzyDf3kmWf9jvOl6t+5sDOPl8uAao4jLwaijzdkeD6KAkiW1
         hFBQ==
X-Gm-Message-State: APjAAAU314s1CYPWV4Fu0Bvtqj0BQ+ekT1HSiEFCp0GY3c7zXf6uFO1g
        c1nf+wN359duPsxV4wNlA+LdDH5FEEY=
X-Google-Smtp-Source: APXvYqymprJXCY9sWZAo+ui3FwuWMtd42W1wCE4AxPI6bvvdcG3IBLtauENKMMN6WtacSFzztkW8Fg==
X-Received: by 2002:a63:1b56:: with SMTP id b22mr32193643pgm.87.1560482016730;
        Thu, 13 Jun 2019 20:13:36 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id e22sm1107255pgb.9.2019.06.13.20.13.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:36 -0700 (PDT)
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
Subject: [PATCH v4.4 39/45] firmware/psci: Expose PSCI conduit
Date:   Fri, 14 Jun 2019 08:38:22 +0530
Message-Id: <8b5c248d26b432206c3e019d8630da59e18dfb3d.1560480942.git.viresh.kumar@linaro.org>
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

