Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3C5549628
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380220AbiFMN6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381300AbiFMN4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:56:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF608A049;
        Mon, 13 Jun 2022 04:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84FA3B80EC7;
        Mon, 13 Jun 2022 11:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEB7C3411F;
        Mon, 13 Jun 2022 11:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120207;
        bh=gXYvlZnPFUNaM7G9ja0Y0pLazVMlcUftyKWO1ibNkxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=se6vbjxvqz6sPPJM7qpusnwiYJde+BL6HrvJBBOJMh5dXC8TiWtedd72E/RdKdKMY
         2mooWW7qsyf0x86qG/5uVheNXpup2vwvTCoVBCOXIvgRGQodXq3Xzki2ni9X0K/O9B
         adO5Fp2QthsBF6wqDEJgpcHnRNHlKzGZ359evh28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 269/339] drm/amd/pm: correct the metrics version for SMU 11.0.11/12/13
Date:   Mon, 13 Jun 2022 12:11:34 +0200
Message-Id: <20220613094934.804918162@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



