Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CDF4EE87F
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiDAGkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245611AbiDAGjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:39:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3288264811;
        Thu, 31 Mar 2022 23:37:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4749AB823E8;
        Fri,  1 Apr 2022 06:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3527C340EE;
        Fri,  1 Apr 2022 06:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648795040;
        bh=ozyQ2xQiU42aoCVatxu5Lv/+CjIAA8xu/x5KnPLdbr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1d0ytcSX0Y1Zql2p2IXnCDYUi4lmH5ioWVzxfLLCXkO6YjdTCwQ/s9nlvyvMtRZNT
         V4ejl3FouwIp22rB6ppqCcVkIpC/C9iGb00yfzansnPoBNkhtL1mJ/oDRugLqyoPRJ
         jv5aY501nFeKaz4ZBrg5XCo4PGLIU/xleuRqOPpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 22/27] arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of Spectre-v2
Date:   Fri,  1 Apr 2022 08:36:32 +0200
Message-Id: <20220401063624.860794754@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401063624.232282121@linuxfoundation.org>
References: <20220401063624.232282121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    8 +++++++
 arch/arm64/kernel/cpu_errata.c      |   38 +++++++++++++++++++++++++++++++++---
 2 files changed, 43 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -495,6 +495,14 @@ static inline int arm64_get_ssbd_state(v
 
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
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -730,14 +730,39 @@ ssize_t cpu_show_spectre_v1(struct devic
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
@@ -758,3 +783,10 @@ ssize_t cpu_show_spec_store_bypass(struc
 
 	return sprintf(buf, "Vulnerable\n");
 }
+
+static enum mitigation_state spectre_bhb_state;
+
+enum mitigation_state arm64_get_spectre_bhb_state(void)
+{
+	return spectre_bhb_state;
+}


