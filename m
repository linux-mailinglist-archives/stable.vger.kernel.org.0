Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EBE4D3308
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiCIQMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiCIQJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81D55FBE;
        Wed,  9 Mar 2022 08:08:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84651B8221D;
        Wed,  9 Mar 2022 16:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA37FC340E8;
        Wed,  9 Mar 2022 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842123;
        bh=O7bwEJKYJXRVJIDfJwdzLbTR7ZgsTiITRhcn192SuLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1qGIrppo9tdHyr90/1na62FfWTOpAFPvCcWRby6b14g2xmbuhAohDXCpVCdj6ywu
         Bu2v0zcRLyzOhe4Fc1KofpYLiM/jxwqgxt8N5jRM+Jj4gadJSxsg85MQRlQd8pYSOV
         M325deqQk/t3OOM7G5P39Y4/RKGfEU0zxG8nW1lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 36/43] arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of Spectre-v2
Date:   Wed,  9 Mar 2022 17:00:20 +0100
Message-Id: <20220309155900.778511912@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
References: <20220309155859.734715884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/spectre.h |    2 ++
 arch/arm64/kernel/proton-pack.c  |   36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -93,5 +93,7 @@ void spectre_v4_enable_task_mitigation(s
 
 enum mitigation_state arm64_get_meltdown_state(void);
 
+enum mitigation_state arm64_get_spectre_bhb_state(void);
+
 #endif	/* __ASSEMBLY__ */
 #endif	/* __ASM_SPECTRE_H */
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -96,14 +96,39 @@ static bool spectre_v2_mitigations_off(v
 	return ret;
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
+	enum mitigation_state bhb_state = arm64_get_spectre_bhb_state();
+	const char *bhb_str = get_bhb_affected_string(bhb_state);
+	const char *v2_str = "Branch predictor hardening";
+
 	switch (spectre_v2_state) {
 	case SPECTRE_UNAFFECTED:
-		return sprintf(buf, "Not affected\n");
+		if (bhb_state == SPECTRE_UNAFFECTED)
+			return sprintf(buf, "Not affected\n");
+
+		/*
+		 * Platforms affected by Spectre-BHB can't report
+		 * "Not affected" for Spectre-v2.
+		 */
+		v2_str = "CSV2";
+		fallthrough;
 	case SPECTRE_MITIGATED:
-		return sprintf(buf, "Mitigation: Branch predictor hardening\n");
+		return sprintf(buf, "Mitigation: %s%s\n", v2_str, bhb_str);
 	case SPECTRE_VULNERABLE:
 		fallthrough;
 	default:
@@ -771,6 +796,13 @@ int arch_prctl_spec_ctrl_get(struct task
 	}
 }
 
+static enum mitigation_state spectre_bhb_state;
+
+enum mitigation_state arm64_get_spectre_bhb_state(void)
+{
+	return spectre_bhb_state;
+}
+
 /* Patched to NOP when enabled */
 void noinstr spectre_bhb_patch_loop_mitigation_enable(struct alt_instr *alt,
 						     __le32 *origptr,


