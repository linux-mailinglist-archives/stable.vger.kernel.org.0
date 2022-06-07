Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6171A540B37
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350011AbiFGS1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352426AbiFGSRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7317D10D934;
        Tue,  7 Jun 2022 10:52:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C520761782;
        Tue,  7 Jun 2022 17:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632D6C385A5;
        Tue,  7 Jun 2022 17:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624325;
        bh=gXYvlZnPFUNaM7G9ja0Y0pLazVMlcUftyKWO1ibNkxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNzoz0NKuUwVkcr4002XwwyJNPQS1c9/ZsQlYU3bbxdOPsjbOpWuooGCMXU3wzVwa
         AWLSRLuKVpFjfbNHweI0GnluxE+sBF9nvSzUeHuaWnDn+oPQUxrHNmhpx7NikG5CVM
         Sdc2Fx1FopCaRKMAkunhA79DkXrbQ58YeVZGWcOVxNMGSs/lbinSX3/oBjpLY6Bu1G
         hfvM1DEvdq1YzjIW2gLO2V1X2k3zWFeeEw+S0PsdxQ2ck71DMxqWpHi4dR6PQ2x59l
         hHe/N/THGrPI45AO9DYPhQALmhe4Oly3OF8JYcKs8RykSN2JzCIpjX10FrY6ifayV4
         oSfc2Gq1HgycA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        lijo.lazar@amd.com, luben.tuikov@amd.com,
        andrey.grodzovsky@amd.com, sathishkumar.sundararaju@amd.com,
        danijel.slivka@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 50/68] drm/amd/pm: correct the metrics version for SMU 11.0.11/12/13
Date:   Tue,  7 Jun 2022 13:48:16 -0400
Message-Id: <20220607174846.477972-50-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 396beb91a9eb86cbfa404e4220cca8f3ada70777 ]

Correct the metrics version used for SMU 11.0.11/12/13.
Fixes misreported GPU metrics (e.g., fan speed, etc.) depending
on which version of SMU firmware is loaded.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1925
Signed-off-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 57 ++++++++++++++-----
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 38f04836c82f..7a1e225fb823 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -586,12 +586,28 @@ static int sienna_cichlid_get_smu_metrics_data(struct smu_context *smu,
 	uint16_t average_gfx_activity;
 	int ret = 0;
 
-	if ((smu->adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-		(smu->smc_fw_version >= 0x3A4900))
-		use_metrics_v3 = true;
-	else if ((smu->adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-		(smu->smc_fw_version >= 0x3A4300))
-		use_metrics_v2 =  true;
+	switch (smu->adev->ip_versions[MP1_HWIP][0]) {
+	case IP_VERSION(11, 0, 7):
+		if (smu->smc_fw_version >= 0x3A4900)
+			use_metrics_v3 = true;
+		else if (smu->smc_fw_version >= 0x3A4300)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 11):
+		if (smu->smc_fw_version >= 0x412D00)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 12):
+		if (smu->smc_fw_version >= 0x3B2300)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 13):
+		if (smu->smc_fw_version >= 0x491100)
+			use_metrics_v2 = true;
+		break;
+	default:
+		break;
+	}
 
 	ret = smu_cmn_get_metrics_table(smu,
 					NULL,
@@ -3701,13 +3717,28 @@ static ssize_t sienna_cichlid_get_gpu_metrics(struct smu_context *smu,
 	uint16_t average_gfx_activity;
 	int ret = 0;
 
-	if ((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-		(smu->smc_fw_version >= 0x3A4900))
-		use_metrics_v3 = true;
-	else if ((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-		(smu->smc_fw_version >= 0x3A4300))
-		use_metrics_v2 = true;
-
+	switch (smu->adev->ip_versions[MP1_HWIP][0]) {
+	case IP_VERSION(11, 0, 7):
+		if (smu->smc_fw_version >= 0x3A4900)
+			use_metrics_v3 = true;
+		else if (smu->smc_fw_version >= 0x3A4300)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 11):
+		if (smu->smc_fw_version >= 0x412D00)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 12):
+		if (smu->smc_fw_version >= 0x3B2300)
+			use_metrics_v2 = true;
+		break;
+	case IP_VERSION(11, 0, 13):
+		if (smu->smc_fw_version >= 0x491100)
+			use_metrics_v2 = true;
+		break;
+	default:
+		break;
+	}
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics_external,
-- 
2.35.1

