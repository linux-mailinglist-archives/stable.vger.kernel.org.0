Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BE454188A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379393AbiFGVMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380273AbiFGVLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4614321911C;
        Tue,  7 Jun 2022 11:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4FE8B82018;
        Tue,  7 Jun 2022 18:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F29C385A5;
        Tue,  7 Jun 2022 18:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628025;
        bh=AXSUpGzFRrsZs0apkR/T9iXU45rGIqbP27cyfYEiBG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPtVeumOIW8hs3+3JEZso3lx31X4KAYpbe9oxiuGxhQI/rzbv7drmDXcOHmKUdiHH
         aYbmkLshpIlQDXNYX8Q7ir4hRDrAveebRJoT7KbBbaDcZvlex41GCEpQrLEqeblWte
         yyCRnSbdigmf+eREqLbrVqsGGev0B0YJNQMA+YGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sathishkumar S <sathishkumar.sundararaju@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 179/879] drm/amd/pm: update smartshift powerboost calc for smu13
Date:   Tue,  7 Jun 2022 18:54:57 +0200
Message-Id: <20220607165008.036733272@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index e2d099409123..87257b1b028f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -276,6 +276,42 @@ static int yellow_carp_mode2_reset(struct smu_context *smu)
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
@@ -284,6 +320,8 @@ static int yellow_carp_get_smu_metrics_data(struct smu_context *smu,
 
 	SmuMetrics_t *metrics = (SmuMetrics_t *)smu_table->metrics_table;
 	int ret = 0;
+	uint32_t apu_percent = 0;
+	uint32_t dgpu_percent = 0;
 
 	ret = smu_cmn_get_metrics_table(smu, NULL, false);
 	if (ret)
@@ -332,26 +370,18 @@ static int yellow_carp_get_smu_metrics_data(struct smu_context *smu,
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



