Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC80C6AF359
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjCGTEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjCGTDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:03:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F32B06FB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 746BAB819D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D6CC433D2;
        Tue,  7 Mar 2023 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214935;
        bh=fO7/lgjjghii3T68CVoI6cy7l8u0idyM6lQ8ig5in+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWNsFkVwzaa6B7W3JLjNfxwj13LonzFiEea8DDnKm+/xMOYMak3C938q9fbq6Omjb
         h5qh7vbso4newMi63eE8Nad/xMVILKHSafnspKClQADLX6AqiT1ldgWPUeckJhAbzN
         uH/Uw2ux1qX1IR3KdIcJsn1I56ERKksajeU3UBcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/567] thermal/drivers/tsens: limit num_sensors to 9 for msm8939
Date:   Tue,  7 Mar 2023 17:57:14 +0100
Message-Id: <20230307165910.120538582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 903238a33c116edf5f64f7a3fd246e6169cccfa6 ]

On msm8939 last (hwid=10) sensor was added in the hw revision 3.0.
Calibration data for it was placed outside of the main calibration data
blob, so it is not accessible by the current blob-parsing code.

Moreover data for the sensor's p2 is not contiguous in the fuses. This
makes it hard to use nvmem_cell API to parse calibration data in a
generic way.

Since the sensor doesn't seem to be actually used by the existing
hardware, disable the sensor for now.

Fixes: 332bc8ebab2c ("thermal: qcom: tsens-v0_1: Add support for MSM8939")
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20230101194034.831222-9-dmitry.baryshkov@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-v0_1.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/qcom/tsens-v0_1.c b/drivers/thermal/qcom/tsens-v0_1.c
index f6d55e6d85dde..8d036727b99fe 100644
--- a/drivers/thermal/qcom/tsens-v0_1.c
+++ b/drivers/thermal/qcom/tsens-v0_1.c
@@ -285,7 +285,7 @@ static int calibrate_8939(struct tsens_priv *priv)
 	u32 p1[10], p2[10];
 	int mode = 0;
 	u32 *qfprom_cdata;
-	u32 cdata[6];
+	u32 cdata[4];
 
 	qfprom_cdata = (u32 *)qfprom_read(priv->dev, "calib");
 	if (IS_ERR(qfprom_cdata))
@@ -296,8 +296,6 @@ static int calibrate_8939(struct tsens_priv *priv)
 	cdata[1] = qfprom_cdata[13];
 	cdata[2] = qfprom_cdata[0];
 	cdata[3] = qfprom_cdata[1];
-	cdata[4] = qfprom_cdata[22];
-	cdata[5] = qfprom_cdata[21];
 
 	mode = (cdata[0] & MSM8939_CAL_SEL_MASK) >> MSM8939_CAL_SEL_SHIFT;
 	dev_dbg(priv->dev, "calibration mode is %d\n", mode);
@@ -314,8 +312,6 @@ static int calibrate_8939(struct tsens_priv *priv)
 		p2[6] = (cdata[2] & MSM8939_S6_P2_MASK) >> MSM8939_S6_P2_SHIFT;
 		p2[7] = (cdata[3] & MSM8939_S7_P2_MASK) >> MSM8939_S7_P2_SHIFT;
 		p2[8] = (cdata[3] & MSM8939_S8_P2_MASK) >> MSM8939_S8_P2_SHIFT;
-		p2[9] = (cdata[4] & MSM8939_S9_P2_MASK_0_4) >> MSM8939_S9_P2_SHIFT_0_4;
-		p2[9] |= ((cdata[5] & MSM8939_S9_P2_MASK_5) >> MSM8939_S9_P2_SHIFT_5) << 5;
 		for (i = 0; i < priv->num_sensors; i++)
 			p2[i] = (base1 + p2[i]) << 2;
 		fallthrough;
@@ -331,7 +327,6 @@ static int calibrate_8939(struct tsens_priv *priv)
 		p1[6] = (cdata[2] & MSM8939_S6_P1_MASK) >> MSM8939_S6_P1_SHIFT;
 		p1[7] = (cdata[3] & MSM8939_S7_P1_MASK) >> MSM8939_S7_P1_SHIFT;
 		p1[8] = (cdata[3] & MSM8939_S8_P1_MASK) >> MSM8939_S8_P1_SHIFT;
-		p1[9] = (cdata[4] & MSM8939_S9_P1_MASK) >> MSM8939_S9_P1_SHIFT;
 		for (i = 0; i < priv->num_sensors; i++)
 			p1[i] = ((base0) + p1[i]) << 2;
 		break;
@@ -544,7 +539,7 @@ static int __init init_8939(struct tsens_priv *priv) {
 	priv->sensor[6].slope = 2833;
 	priv->sensor[7].slope = 2838;
 	priv->sensor[8].slope = 2840;
-	priv->sensor[9].slope = 2852;
+	/* priv->sensor[9].slope = 2852; */
 
 	return init_common(priv);
 }
@@ -617,9 +612,9 @@ static const struct tsens_ops ops_8939 = {
 };
 
 struct tsens_plat_data data_8939 = {
-	.num_sensors	= 10,
+	.num_sensors	= 9,
 	.ops		= &ops_8939,
-	.hw_ids		= (unsigned int []){ 0, 1, 2, 3, 5, 6, 7, 8, 9, 10 },
+	.hw_ids		= (unsigned int []){ 0, 1, 2, 3, 5, 6, 7, 8, 9, /* 10 */ },
 
 	.feat		= &tsens_v0_1_feat,
 	.fields	= tsens_v0_1_regfields,
-- 
2.39.2



