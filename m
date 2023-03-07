Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652526AE921
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjCGRV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCGRVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:21:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68981A17C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F38D66150C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FC2C433D2;
        Tue,  7 Mar 2023 17:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209371;
        bh=KcgCFjXN/XioDmxCudT+85UbRTxCeCPW6sqVygo/LSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbG1/ka6dEcVfcXig1La/+Re1iimxqYBNbL6hW1+22Ypvxpu9kqgXrqzh0sPlEpxR
         sqVwjDt137JeiDBxb1YoQP1SgQmc9SukQSbvvnC6jAKMVad9VfCk7HEP2p5WGxhA9h
         KtyEJQgl+Vc1FErT+681XF9TLorMTreAwIuXIV08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0198/1001] thermal/drivers/tsens: fix slope values for msm8939
Date:   Tue,  7 Mar 2023 17:49:30 +0100
Message-Id: <20230307170030.493314169@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 5aec3b035e0cbf3f042c2a03d654e5ad6748feb7 ]

According to the vendor kernels (msm-3.10, 3.14 and 3.18), msm8939
uses non-standard slope values for calibrating the sensors. Fill them
accordingly.

Fixes: 332bc8ebab2c ("thermal: qcom: tsens-v0_1: Add support for MSM8939")
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20230101194034.831222-8-dmitry.baryshkov@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-v0_1.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/tsens-v0_1.c b/drivers/thermal/qcom/tsens-v0_1.c
index 04d012e4f7288..af2659037f010 100644
--- a/drivers/thermal/qcom/tsens-v0_1.c
+++ b/drivers/thermal/qcom/tsens-v0_1.c
@@ -534,6 +534,21 @@ static int calibrate_9607(struct tsens_priv *priv)
 	return 0;
 }
 
+static int __init init_8939(struct tsens_priv *priv) {
+	priv->sensor[0].slope = 2911;
+	priv->sensor[1].slope = 2789;
+	priv->sensor[2].slope = 2906;
+	priv->sensor[3].slope = 2763;
+	priv->sensor[4].slope = 2922;
+	priv->sensor[5].slope = 2867;
+	priv->sensor[6].slope = 2833;
+	priv->sensor[7].slope = 2838;
+	priv->sensor[8].slope = 2840;
+	priv->sensor[9].slope = 2852;
+
+	return init_common(priv);
+}
+
 /* v0.1: 8916, 8939, 8974, 9607 */
 
 static struct tsens_features tsens_v0_1_feat = {
@@ -599,7 +614,7 @@ struct tsens_plat_data data_8916 = {
 };
 
 static const struct tsens_ops ops_8939 = {
-	.init		= init_common,
+	.init		= init_8939,
 	.calibrate	= calibrate_8939,
 	.get_temp	= get_temp_common,
 };
-- 
2.39.2



