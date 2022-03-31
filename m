Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D144EE098
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 20:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiCaSgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 14:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbiCaSgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 14:36:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E858D21DF2E;
        Thu, 31 Mar 2022 11:34:48 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9641139F;
        Thu, 31 Mar 2022 11:34:48 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0BC193F718;
        Thu, 31 Mar 2022 11:34:47 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     james.morse@arm.com, catalin.marinas@arm.com
Subject: [stable:PATCH v4.14.274 22/27] arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of Spectre-v2
Date:   Thu, 31 Mar 2022 19:33:55 +0100
Message-Id: <20220331183400.73183-23-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220331183400.73183-1-james.morse@arm.com>
References: <20220331183400.73183-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit dee435be76f4117410bbd90573a881fd33488f37 upstream.

Speculation attacks against some high-performance processors can
make use of branch history to influence future speculation as part of
a spectre-v2 attack. This is not mitigated by CSV2, meaning CPUs that
previously reported 'Not affected' are now moderately mitigated by CSV2.

Update the value in /sys/devices/system/cpu/vulnerabilities/spectre_v2
to also show the state of the BHB mitigation.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[ code move to cpu_errata.c for backport ]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  8 ++++++
 arch/arm64/kernel/cpu_errata.c      | 38 ++++++++++++++++++++++++++---
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 166f81b7afee..5f9f40a02784 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -495,6 +495,14 @@ static inline int arm64_get_ssbd_state(void)
 
 void arm64_set_ssbd_mitigation(bool state);
 
+/* Watch out, ordering is important here. */
+enum mitigation_state {
+	SPECTRE_UNAFFECTED,
+	SPECTRE_MITIGATED,
+	SPECTRE_VULNERABLE,
+};
+
+enum mitigation_state arm64_get_spectre_bhb_state(void);
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index d75c4f4144f4..41caf2f01814 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -730,14 +730,39 @@ ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
 }
 
+static const char *get_bhb_affected_string(enum mitigation_state bhb_state)
+{
+	switch (bhb_state) {
+	case SPECTRE_UNAFFECTED:
+		return "";
+	default:
+	case SPECTRE_VULNERABLE:
+		return ", but not BHB";
+	case SPECTRE_MITIGATED:
+		return ", BHB";
+	}
+}
+
 ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	if (__spectrev2_safe)
-		return sprintf(buf, "Not affected\n");
+	enum mitigation_state bhb_state = arm64_get_spectre_bhb_state();
+	const char *bhb_str = get_bhb_affected_string(bhb_state);
+	const char *v2_str = "Branch predictor hardening";
+
+	if (__spectrev2_safe) {
+		if (bhb_state == SPECTRE_UNAFFECTED)
+			return sprintf(buf, "Not affected\n");
+
+		/*
+		 * Platforms affected by Spectre-BHB can't report
+		 * "Not affected" for Spectre-v2.
+		 */
+		v2_str = "CSV2";
+	}
 
 	if (__hardenbp_enab)
-		return sprintf(buf, "Mitigation: Branch predictor hardening\n");
+		return sprintf(buf, "Mitigation: %s%s\n", v2_str, bhb_str);
 
 	return sprintf(buf, "Vulnerable\n");
 }
@@ -758,3 +783,10 @@ ssize_t cpu_show_spec_store_bypass(struct device *dev,
 
 	return sprintf(buf, "Vulnerable\n");
 }
+
+static enum mitigation_state spectre_bhb_state;
+
+enum mitigation_state arm64_get_spectre_bhb_state(void)
+{
+	return spectre_bhb_state;
+}
-- 
2.30.2

