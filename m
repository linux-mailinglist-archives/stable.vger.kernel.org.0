Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352E1E32FB
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502144AbfJXMuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:50:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40155 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502139AbfJXMt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id o28so25925251wro.7
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Og0am2Pv0CEi9ZDZ1uRy5VNKdKOduiqMfYuS+Xne1XM=;
        b=rDwgWIxpukgpkhKfUqu/gEQU5bMGbjBaAMOiRSN/l5gLouFqDbPCfSBlIdldfIr1GT
         kAVqeRUyR999PoW6wo+QLUO6kq7iIUewe4zsmnrHQng3nyhj4g/Ko4z1gSB3E1hKHzps
         KEmeiYzMk9JGCJw6bG4CQIAa3K81gsnTcZB4cXYogSQ31axvkcMBa4FLEbkw0fEY+zfs
         t5gURqgX6erS6hPTSdeK1lqAM1X8RdwaSxgC52adhm80aLbP73lAAM/oM6+HUioT5Kgq
         IsDgKUujuSfnDQQnUjhR32+bBwPjPjuMJpmpkDZPGosFsAWPrsNlc+uErvhknL3Z5GW/
         4rdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Og0am2Pv0CEi9ZDZ1uRy5VNKdKOduiqMfYuS+Xne1XM=;
        b=aC/rZ5HmdzGU0U5KYKkY7QxJn9U83fImqGNMheD5u/p977P2BPoHU8CFeWlonNstYW
         m6JRncIoFMNP4/4ww6YCySu86g4eckwT7FRjXRfJX5IUjiomb+UspA50Ms+j2th2LmC3
         t17IKZ2ThvJKpiE6DGzkGFkgVspyWR2q3TdTLOsfzVqBFjfFV+pTGPfXDQSrnyjgkrrc
         HCrUHswIG0gpJmSEzmzHmorPjOX8IkpyPfbbqsp9VlSAnndJcRurcSjJY6ou09A07Uc4
         6cFdhQgzA/hLajG2APbskioB9mGU8/GNJwYK1urg7Cc+Yq5mvIk14cELZPkoIEu2mara
         qBbw==
X-Gm-Message-State: APjAAAXztMGTwF0+a5kSIRg9lqGnM9x6/rdcSkfQ4Ahdr9BnezPUlW/w
        WLqGvQ1To5CgRpzSLF2W+KV5ZGEzlIvBCyVe
X-Google-Smtp-Source: APXvYqye96ZlMY0y9JYFQ+hZCVQwpjXv4f2WhZ+aw92H4tD5XUfpSfzkQ/kjMERN0FDORnDwBsqmuQ==
X-Received: by 2002:a5d:640d:: with SMTP id z13mr3673006wru.75.1571921397325;
        Thu, 24 Oct 2019 05:49:57 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 44/48] arm64: add sysfs vulnerability show for speculative store bypass
Date:   Thu, 24 Oct 2019 14:48:29 +0200
Message-Id: <20191024124833.4158-45-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit 526e065dbca6df0b5a130b84b836b8b3c9f54e21 ]

Return status based on ssbd_state and __ssb_safe. If the
mitigation is disabled, or the firmware isn't responding then
return the expected machine state based on a whitelist of known
good cores.

Given a heterogeneous machine, the overall machine vulnerability
defaults to safe but is reset to unsafe when we miss the whitelist
and the firmware doesn't explicitly tell us the core is safe.
In order to make that work we delay transitioning to vulnerable
until we know the firmware isn't responding to avoid a case
where we miss the whitelist, but the firmware goes ahead and
reports the core is not vulnerable. If all the cores in the
machine have SSBS, then __ssb_safe will remain true.

Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 42 ++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 809a736f38a9..2898130c3156 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -225,6 +225,7 @@ static int detect_harden_bp_fw(void)
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
 int ssbd_state __read_mostly = ARM64_SSBD_KERNEL;
+static bool __ssb_safe = true;
 
 static const struct ssbd_options {
 	const char	*str;
@@ -328,6 +329,7 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	struct arm_smccc_res res;
 	bool required = true;
 	s32 val;
+	bool this_cpu_safe = false;
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
@@ -336,8 +338,14 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 		goto out_printmsg;
 	}
 
+	/* delay setting __ssb_safe until we get a firmware response */
+	if (is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list))
+		this_cpu_safe = true;
+
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0) {
 		ssbd_state = ARM64_SSBD_UNKNOWN;
+		if (!this_cpu_safe)
+			__ssb_safe = false;
 		return false;
 	}
 
@@ -354,6 +362,8 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	default:
 		ssbd_state = ARM64_SSBD_UNKNOWN;
+		if (!this_cpu_safe)
+			__ssb_safe = false;
 		return false;
 	}
 
@@ -362,14 +372,18 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	switch (val) {
 	case SMCCC_RET_NOT_SUPPORTED:
 		ssbd_state = ARM64_SSBD_UNKNOWN;
+		if (!this_cpu_safe)
+			__ssb_safe = false;
 		return false;
 
+	/* machines with mixed mitigation requirements must not return this */
 	case SMCCC_RET_NOT_REQUIRED:
 		pr_info_once("%s mitigation not required\n", entry->desc);
 		ssbd_state = ARM64_SSBD_MITIGATED;
 		return false;
 
 	case SMCCC_RET_SUCCESS:
+		__ssb_safe = false;
 		required = true;
 		break;
 
@@ -379,6 +393,8 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	default:
 		WARN_ON(1);
+		if (!this_cpu_safe)
+			__ssb_safe = false;
 		return false;
 	}
 
@@ -419,6 +435,14 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	return required;
 }
 
+/* known invulnerable cores */
+static const struct midr_range arm64_ssb_cpus[] = {
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A53),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
+	{},
+};
+
 #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
 	.matches = is_affected_midr_range,			\
 	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
@@ -666,6 +690,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.capability = ARM64_SSBD,
 		.matches = has_ssbd_mitigation,
+		.midr_range_list = arm64_ssb_cpus,
 	},
 	{
 	}
@@ -688,3 +713,20 @@ ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
 
 	return sprintf(buf, "Vulnerable\n");
 }
+
+ssize_t cpu_show_spec_store_bypass(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	if (__ssb_safe)
+		return sprintf(buf, "Not affected\n");
+
+	switch (ssbd_state) {
+	case ARM64_SSBD_KERNEL:
+	case ARM64_SSBD_FORCE_ENABLE:
+		if (IS_ENABLED(CONFIG_ARM64_SSBD))
+			return sprintf(buf,
+			    "Mitigation: Speculative Store Bypass disabled via prctl\n");
+	}
+
+	return sprintf(buf, "Vulnerable\n");
+}
-- 
2.20.1

