Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72490D2411
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389696AbfJJIsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387657AbfJJIsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:48:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85A192064A;
        Thu, 10 Oct 2019 08:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697324;
        bh=JTeskSJEsytwnsbhj0g3kb2jBcSdMn7bs2/OemONbdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRYg/2yNrBa1fcpxo1+U0m+F1ucdiKufH2wm27F+f8WV5h4iJ6637p2LrRNeTi3KE
         /7Mpfmj5u/KCDiw3uIklHH0akNiRIZN+5vnRkbRS1zUPTVnZTpV78GsYioTnNzS5uc
         OG/NZGGviUTYO1QpSQP/6LvG9Zdlda29GrG97c4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.19 101/114] arm64: add sysfs vulnerability show for speculative store bypass
Date:   Thu, 10 Oct 2019 10:36:48 +0200
Message-Id: <20191010083613.546505028@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |   42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -233,6 +233,7 @@ static int detect_harden_bp_fw(void)
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
 int ssbd_state __read_mostly = ARM64_SSBD_KERNEL;
+static bool __ssb_safe = true;
 
 static const struct ssbd_options {
 	const char	*str;
@@ -336,6 +337,7 @@ static bool has_ssbd_mitigation(const st
 	struct arm_smccc_res res;
 	bool required = true;
 	s32 val;
+	bool this_cpu_safe = false;
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
@@ -344,8 +346,14 @@ static bool has_ssbd_mitigation(const st
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
 
@@ -362,6 +370,8 @@ static bool has_ssbd_mitigation(const st
 
 	default:
 		ssbd_state = ARM64_SSBD_UNKNOWN;
+		if (!this_cpu_safe)
+			__ssb_safe = false;
 		return false;
 	}
 
@@ -370,14 +380,18 @@ static bool has_ssbd_mitigation(const st
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
 
@@ -387,6 +401,8 @@ static bool has_ssbd_mitigation(const st
 
 	default:
 		WARN_ON(1);
+		if (!this_cpu_safe)
+			__ssb_safe = false;
 		return false;
 	}
 
@@ -427,6 +443,14 @@ out_printmsg:
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
 #ifdef CONFIG_ARM64_ERRATUM_1463225
 DEFINE_PER_CPU(int, __in_cortex_a76_erratum_1463225_wa);
 
@@ -748,6 +772,7 @@ const struct arm64_cpu_capabilities arm6
 		.capability = ARM64_SSBD,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = has_ssbd_mitigation,
+		.midr_range_list = arm64_ssb_cpus,
 	},
 #ifdef CONFIG_ARM64_ERRATUM_1463225
 	{
@@ -778,3 +803,20 @@ ssize_t cpu_show_spectre_v2(struct devic
 
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


