Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A95D4D493D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbiCJOO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243037AbiCJOOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:14:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7799B1587B8;
        Thu, 10 Mar 2022 06:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB17E61B7A;
        Thu, 10 Mar 2022 14:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BC1C340E8;
        Thu, 10 Mar 2022 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921495;
        bh=O7bwEJKYJXRVJIDfJwdzLbTR7ZgsTiITRhcn192SuLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=um3kwZCSE54ejEjsQSQb22hryMmiGO/MWb7ekPR0aTid43zqNwZidaGMVo4E3OajT
         vrUu5HAhfHz4nwrS4szu1nNZ4geeJ2VRw9Zg4GEQvKI2pF30SsCmICpdDns2bnsAwy
         30AVoELWqDDyWGGs6Bh7sl3r9VplBifkAqbD8nQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.16 32/53] arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of Spectre-v2
Date:   Thu, 10 Mar 2022 15:09:37 +0100
Message-Id: <20220310140812.757862740@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
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


