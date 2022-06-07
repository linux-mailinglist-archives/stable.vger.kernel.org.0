Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133D2541216
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356926AbiFGTn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357900AbiFGTmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:42:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268A6BCB7;
        Tue,  7 Jun 2022 11:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8B36B82367;
        Tue,  7 Jun 2022 18:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425F4C385A2;
        Tue,  7 Jun 2022 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625821;
        bh=1SgiK37DEyvhrj6XEktO4Xg9hiQ9neVLoDKVwZ0AdRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3R46UOiormXE1GQaTz1D7SIYtxQRvFKcTvkUMrPgQdwtFJbNBe6vS/ft3qe154hg
         LJzame3xgBPtQ1i2sHf4aSihT4R2HyXXisj9rgRMrxVWS45hTmdcfDj6ETqHqtP3S/
         GIIFhwQIt1O3Lv0DvK4+qzSOSaYmdv2ccw5liAXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sathishkumar S <sathishkumar.sundararaju@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 155/772] drm/amd/pm: update smartshift powerboost calc for smu13
Date:   Tue,  7 Jun 2022 18:55:47 +0200
Message-Id: <20220607164953.611198189@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

[ Upstream commit cdf4c8ec39872a61a58d62f19b4db80f0f7bc586 ]

smartshift apu and dgpu power boost are reported as percentage
with respect to their power limits. adjust the units of power before
calculating the percentage of boost.

Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c  | 62 ++++++++++++++-----
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
index 0bc84b709a93..d0715927b07f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -296,6 +296,42 @@ static int yellow_carp_mode2_reset(struct smu_context *smu)
 	return yellow_carp_mode_reset(smu, SMU_RESET_MODE_2);
 }
 
+
+static void yellow_carp_get_ss_power_percent(SmuMetrics_t *metrics,
+					uint32_t *apu_percent, uint32_t *dgpu_percent)
+{
+	uint32_t apu_boost = 0;
+	uint32_t dgpu_boost = 0;
+	uint16_t apu_limit = 0;
+	uint16_t dgpu_limit = 0;
+	uint16_t apu_power = 0;
+	uint16_t dgpu_power = 0;
+
+	/* APU and dGPU power values are reported in milli Watts
+	 * and STAPM power limits are in Watts */
+	apu_power = metrics->ApuPower/1000;
+	apu_limit = metrics->StapmOpnLimit;
+	if (apu_power > apu_limit && apu_limit != 0)
+		apu_boost =  ((apu_power - apu_limit) * 100) / apu_limit;
+	apu_boost = (apu_boost > 100) ? 100 : apu_boost;
+
+	dgpu_power = metrics->dGpuPower/1000;
+	if (metrics->StapmCurrentLimit > metrics->StapmOpnLimit)
+		dgpu_limit = metrics->StapmCurrentLimit - metrics->StapmOpnLimit;
+	if (dgpu_power > dgpu_limit && dgpu_limit != 0)
+		dgpu_boost = ((dgpu_power - dgpu_limit) * 100) / dgpu_limit;
+	dgpu_boost = (dgpu_boost > 100) ? 100 : dgpu_boost;
+
+	if (dgpu_boost >= apu_boost)
+		apu_boost = 0;
+	else
+		dgpu_boost = 0;
+
+	*apu_percent = apu_boost;
+	*dgpu_percent = dgpu_boost;
+
+}
+
 static int yellow_carp_get_smu_metrics_data(struct smu_context *smu,
 							MetricsMember_t member,
 							uint32_t *value)
@@ -304,6 +340,8 @@ static int yellow_carp_get_smu_metrics_data(struct smu_context *smu,
 
 	SmuMetrics_t *metrics = (SmuMetrics_t *)smu_table->metrics_table;
 	int ret = 0;
+	uint32_t apu_percent = 0;
+	uint32_t dgpu_percent = 0;
 
 	mutex_lock(&smu->metrics_lock);
 
@@ -356,26 +394,18 @@ static int yellow_carp_get_smu_metrics_data(struct smu_context *smu,
 		*value = metrics->Voltage[1];
 		break;
 	case METRICS_SS_APU_SHARE:
-		/* return the percentage of APU power with respect to APU's power limit.
-		 * percentage is reported, this isn't boost value. Smartshift power
-		 * boost/shift is only when the percentage is more than 100.
+		/* return the percentage of APU power boost
+		 * with respect to APU's power limit.
 		 */
-		if (metrics->StapmOpnLimit > 0)
-			*value =  (metrics->ApuPower * 100) / metrics->StapmOpnLimit;
-		else
-			*value = 0;
+		yellow_carp_get_ss_power_percent(metrics, &apu_percent, &dgpu_percent);
+		*value = apu_percent;
 		break;
 	case METRICS_SS_DGPU_SHARE:
-		/* return the percentage of dGPU power with respect to dGPU's power limit.
-		 * percentage is reported, this isn't boost value. Smartshift power
-		 * boost/shift is only when the percentage is more than 100.
+		/* return the percentage of dGPU power boost
+		 * with respect to dGPU's power limit.
 		 */
-		if ((metrics->dGpuPower > 0) &&
-		    (metrics->StapmCurrentLimit > metrics->StapmOpnLimit))
-			*value = (metrics->dGpuPower * 100) /
-				  (metrics->StapmCurrentLimit - metrics->StapmOpnLimit);
-		else
-			*value = 0;
+		yellow_carp_get_ss_power_percent(metrics, &apu_percent, &dgpu_percent);
+		*value = dgpu_percent;
 		break;
 	default:
 		*value = UINT_MAX;
-- 
2.35.1



