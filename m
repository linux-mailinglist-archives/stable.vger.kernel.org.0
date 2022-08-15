Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125A45948C0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245173AbiHOX3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244724AbiHOXYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:24:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512FB83F0A;
        Mon, 15 Aug 2022 13:05:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 112E0B80EA8;
        Mon, 15 Aug 2022 20:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7436DC433D7;
        Mon, 15 Aug 2022 20:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593940;
        bh=U8UoyS0+Bri2GFi3RY7EKgWLY6hzotOmbRvxg6553RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEB+8cfYZz3AsflU7MamORMyqjwMu4kwh1lJ5iDfYzakSj+fx43O/TFReSkRT4vMi
         31p4b7B/MAIuPBbD9jsGekrxgk0LXg/l5ZEh4Qu1rjRp/Utryre17pXRDS7Q7c7dPO
         dxpE4Wc6wYe+aC3ZCqDdezrbbgFDsh8J3SI0OcX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1032/1095] intel_idle: Add AlderLake support
Date:   Mon, 15 Aug 2022 20:07:11 +0200
Message-Id: <20220815180511.754732096@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit d1cf8bbfed1edc5108220342ab39e4544d55fbc3 ]

Similar to SPR, the C1 and C1E states on ADL are mutually exclusive.
Only one of them can be enabled at a time.

But contrast to SPR, which usually has a strong latency requirement
as a Xeon processor, C1E is preferred on ADL for better energy
efficiency.

Add custom C-state tables for ADL with both C1 and C1E, and

 1. Enable the "C1E promotion" bit in MSR_IA32_POWER_CTL and mark C1
    with the CPUIDLE_FLAG_UNUSABLE flag, so C1 is not available by
    default.

 2. Add support for the "preferred_cstates" module parameter, so that
    users can choose to use C1 instead of C1E by booting with
    "intel_idle.preferred_cstates=2".

Separate custom C-state tables are introduced for the ADL mobile and
desktop processors, because of the exit latency differences between
these two variants, especially with respect to PC10.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
[ rjw: Changelog edits, code rearrangement ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 133 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 47b68c6071be..907700d1e78e 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -811,6 +811,106 @@ static struct cpuidle_state icx_cstates[] __initdata = {
 		.enter = NULL }
 };
 
+/*
+ * On AlderLake C1 has to be disabled if C1E is enabled, and vice versa.
+ * C1E is enabled only if "C1E promotion" bit is set in MSR_IA32_POWER_CTL.
+ * But in this case there is effectively no C1, because C1 requests are
+ * promoted to C1E. If the "C1E promotion" bit is cleared, then both C1
+ * and C1E requests end up with C1, so there is effectively no C1E.
+ *
+ * By default we enable C1E and disable C1 by marking it with
+ * 'CPUIDLE_FLAG_UNUSABLE'.
+ */
+static struct cpuidle_state adl_cstates[] __initdata = {
+	{
+		.name = "C1",
+		.desc = "MWAIT 0x00",
+		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_UNUSABLE,
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C1E",
+		.desc = "MWAIT 0x01",
+		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_ALWAYS_ENABLE,
+		.exit_latency = 2,
+		.target_residency = 4,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C6",
+		.desc = "MWAIT 0x20",
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 220,
+		.target_residency = 600,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C8",
+		.desc = "MWAIT 0x40",
+		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 280,
+		.target_residency = 800,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C10",
+		.desc = "MWAIT 0x60",
+		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 680,
+		.target_residency = 2000,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.enter = NULL }
+};
+
+static struct cpuidle_state adl_l_cstates[] __initdata = {
+	{
+		.name = "C1",
+		.desc = "MWAIT 0x00",
+		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_UNUSABLE,
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C1E",
+		.desc = "MWAIT 0x01",
+		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_ALWAYS_ENABLE,
+		.exit_latency = 2,
+		.target_residency = 4,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C6",
+		.desc = "MWAIT 0x20",
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 170,
+		.target_residency = 500,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C8",
+		.desc = "MWAIT 0x40",
+		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 200,
+		.target_residency = 600,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C10",
+		.desc = "MWAIT 0x60",
+		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 230,
+		.target_residency = 700,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.enter = NULL }
+};
+
 /*
  * On Sapphire Rapids Xeon C1 has to be disabled if C1E is enabled, and vice
  * versa. On SPR C1E is enabled only if "C1E promotion" bit is set in
@@ -1194,6 +1294,14 @@ static const struct idle_cpu idle_cpu_icx __initconst = {
 	.use_acpi = true,
 };
 
+static const struct idle_cpu idle_cpu_adl __initconst = {
+	.state_table = adl_cstates,
+};
+
+static const struct idle_cpu idle_cpu_adl_l __initconst = {
+	.state_table = adl_l_cstates,
+};
+
 static const struct idle_cpu idle_cpu_spr __initconst = {
 	.state_table = spr_cstates,
 	.disable_promotion_to_c1e = true,
@@ -1262,6 +1370,8 @@ static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,		&idle_cpu_skx),
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&idle_cpu_icx),
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,		&idle_cpu_icx),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&idle_cpu_adl),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&idle_cpu_adl_l),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&idle_cpu_spr),
 	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,	&idle_cpu_knl),
 	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,	&idle_cpu_knl),
@@ -1620,6 +1730,25 @@ static void __init skx_idle_state_table_update(void)
 	}
 }
 
+/**
+ * adl_idle_state_table_update - Adjust AlderLake idle states table.
+ */
+static void __init adl_idle_state_table_update(void)
+{
+	/* Check if user prefers C1 over C1E. */
+	if (preferred_states_mask & BIT(1) && !(preferred_states_mask & BIT(2))) {
+		cpuidle_state_table[0].flags &= ~CPUIDLE_FLAG_UNUSABLE;
+		cpuidle_state_table[1].flags |= CPUIDLE_FLAG_UNUSABLE;
+
+		/* Disable C1E by clearing the "C1E promotion" bit. */
+		c1e_promotion = C1E_PROMOTION_DISABLE;
+		return;
+	}
+
+	/* Make sure C1E is enabled by default */
+	c1e_promotion = C1E_PROMOTION_ENABLE;
+}
+
 /**
  * spr_idle_state_table_update - Adjust Sapphire Rapids idle states table.
  */
@@ -1689,6 +1818,10 @@ static void __init intel_idle_init_cstates_icpu(struct cpuidle_driver *drv)
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 		spr_idle_state_table_update();
 		break;
+	case INTEL_FAM6_ALDERLAKE:
+	case INTEL_FAM6_ALDERLAKE_L:
+		adl_idle_state_table_update();
+		break;
 	}
 
 	for (cstate = 0; cstate < CPUIDLE_STATE_MAX; ++cstate) {
-- 
2.35.1



