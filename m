Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498686AF34B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbjCGTDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjCGTCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:02:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6DFBC7A5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:48:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38DCAB819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D98FC4339B;
        Tue,  7 Mar 2023 18:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214929;
        bh=24CAfxdjl2qW53RV95Ix8x3b7426/UZlVwwCoL0gMkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GT0fL7dj3TeWLcLMlmGBWvt1pvHK8EasutuaPbVP4Y4zvEqEJ290zMhzert73WU0B
         oU108nwrgfwdXQTInY7SLjegBdZyPPmuPMscJaUzbkc609CCg1xK4eKdcnlXTn7XRW
         W3y+4AnmN4tg3aTEXhRWvbxZPHgU5F7+myHCq/9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/567] thermal/drivers/tsens: Sort out msm8976 vs msm8956 data
Date:   Tue,  7 Mar 2023 17:57:12 +0100
Message-Id: <20230307165910.042389752@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a7d3006be5ca7b04e4b84b5ceaae55a700e511bd ]

Tsens driver mentions that msm8976 data should be used for both msm8976
and msm8956 SoCs. This is not quite correct, as according to the
vendor kernels, msm8976 should use standard slope values (3200), while
msm8956 really uses the slope values found in the driver.

Add separate compatibility string for msm8956, move slope value
overrides to the corresponding init function and use the standard
compute_intercept_slope() function for both platforms.

Fixes: 0e580290170d ("thermal: qcom: tsens-v1: Add support for MSM8956 and MSM8976")
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230101194034.831222-7-dmitry.baryshkov@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-v1.c | 56 ++++++++++++++++++---------------
 drivers/thermal/qcom/tsens.c    |  3 ++
 drivers/thermal/qcom/tsens.h    |  2 +-
 3 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/drivers/thermal/qcom/tsens-v1.c b/drivers/thermal/qcom/tsens-v1.c
index 13624263f1dfe..faa4576fa028f 100644
--- a/drivers/thermal/qcom/tsens-v1.c
+++ b/drivers/thermal/qcom/tsens-v1.c
@@ -137,30 +137,6 @@
 #define CAL_SEL_MASK	7
 #define CAL_SEL_SHIFT	0
 
-static void compute_intercept_slope_8976(struct tsens_priv *priv,
-			      u32 *p1, u32 *p2, u32 mode)
-{
-	int i;
-
-	priv->sensor[0].slope = 3313;
-	priv->sensor[1].slope = 3275;
-	priv->sensor[2].slope = 3320;
-	priv->sensor[3].slope = 3246;
-	priv->sensor[4].slope = 3279;
-	priv->sensor[5].slope = 3257;
-	priv->sensor[6].slope = 3234;
-	priv->sensor[7].slope = 3269;
-	priv->sensor[8].slope = 3255;
-	priv->sensor[9].slope = 3239;
-	priv->sensor[10].slope = 3286;
-
-	for (i = 0; i < priv->num_sensors; i++) {
-		priv->sensor[i].offset = (p1[i] * SLOPE_FACTOR) -
-				(CAL_DEGC_PT1 *
-				priv->sensor[i].slope);
-	}
-}
-
 static int calibrate_v1(struct tsens_priv *priv)
 {
 	u32 base0 = 0, base1 = 0;
@@ -286,7 +262,7 @@ static int calibrate_8976(struct tsens_priv *priv)
 		break;
 	}
 
-	compute_intercept_slope_8976(priv, p1, p2, mode);
+	compute_intercept_slope(priv, p1, p2, mode);
 	kfree(qfprom_cdata);
 
 	return 0;
@@ -357,6 +333,22 @@ static const struct reg_field tsens_v1_regfields[MAX_REGFIELDS] = {
 	[TRDY] = REG_FIELD(TM_TRDY_OFF, 0, 0),
 };
 
+static int __init init_8956(struct tsens_priv *priv) {
+	priv->sensor[0].slope = 3313;
+	priv->sensor[1].slope = 3275;
+	priv->sensor[2].slope = 3320;
+	priv->sensor[3].slope = 3246;
+	priv->sensor[4].slope = 3279;
+	priv->sensor[5].slope = 3257;
+	priv->sensor[6].slope = 3234;
+	priv->sensor[7].slope = 3269;
+	priv->sensor[8].slope = 3255;
+	priv->sensor[9].slope = 3239;
+	priv->sensor[10].slope = 3286;
+
+	return init_common(priv);
+}
+
 static const struct tsens_ops ops_generic_v1 = {
 	.init		= init_common,
 	.calibrate	= calibrate_v1,
@@ -369,13 +361,25 @@ struct tsens_plat_data data_tsens_v1 = {
 	.fields	= tsens_v1_regfields,
 };
 
+static const struct tsens_ops ops_8956 = {
+	.init		= init_8956,
+	.calibrate	= calibrate_8976,
+	.get_temp	= get_temp_tsens_valid,
+};
+
+struct tsens_plat_data data_8956 = {
+	.num_sensors	= 11,
+	.ops		= &ops_8956,
+	.feat		= &tsens_v1_feat,
+	.fields		= tsens_v1_regfields,
+};
+
 static const struct tsens_ops ops_8976 = {
 	.init		= init_common,
 	.calibrate	= calibrate_8976,
 	.get_temp	= get_temp_tsens_valid,
 };
 
-/* Valid for both MSM8956 and MSM8976. */
 struct tsens_plat_data data_8976 = {
 	.num_sensors	= 11,
 	.ops		= &ops_8976,
diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index cef1cbcf03f41..926cd8b41132c 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -978,6 +978,9 @@ static const struct of_device_id tsens_table[] = {
 	}, {
 		.compatible = "qcom,msm8939-tsens",
 		.data = &data_8939,
+	}, {
+		.compatible = "qcom,msm8956-tsens",
+		.data = &data_8956,
 	}, {
 		.compatible = "qcom,msm8960-tsens",
 		.data = &data_8960,
diff --git a/drivers/thermal/qcom/tsens.h b/drivers/thermal/qcom/tsens.h
index 1471a2c00f158..c2e5aee159276 100644
--- a/drivers/thermal/qcom/tsens.h
+++ b/drivers/thermal/qcom/tsens.h
@@ -590,7 +590,7 @@ extern struct tsens_plat_data data_8960;
 extern struct tsens_plat_data data_8916, data_8939, data_8974, data_9607;
 
 /* TSENS v1 targets */
-extern struct tsens_plat_data data_tsens_v1, data_8976;
+extern struct tsens_plat_data data_tsens_v1, data_8976, data_8956;
 
 /* TSENS v2 targets */
 extern struct tsens_plat_data data_8996, data_tsens_v2;
-- 
2.39.2



