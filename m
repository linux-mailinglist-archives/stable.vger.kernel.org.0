Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F37650F871
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345898AbiDZJDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345874AbiDZJCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:02:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B158CC3E2C;
        Tue, 26 Apr 2022 01:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7241B81C76;
        Tue, 26 Apr 2022 08:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5FDC385A0;
        Tue, 26 Apr 2022 08:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962617;
        bh=nyzb5SSmK/jZCYBddQRdW43tebhvDVL3O1UKfr9EU3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RA0DX9TxMNHrEJbnVT+RLRCJF0prFrNgz0cd5HCVqRE8I4zsOnWqHd2C35kIZZyjn
         4mf7QyR/jNOa7fL27W8oQ6SP1DcOwGdIkqaU7m2xJFvR5dYVxwhSYV3B+MWX4vh2IL
         RIGAjxBcHbjBMZxzEs0Xh+rrULj7xcNmm62ux70M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Pundir <amit.pundir@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 015/146] ASoC: codecs: wcd934x: do not switch off SIDO Buck when codec is in use
Date:   Tue, 26 Apr 2022 10:20:10 +0200
Message-Id: <20220426081750.493500101@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit db6dd1bee63d1d88fbddfe07af800af5948ac28e ]

SIDO(Single-Inductor Dual-Ouput) Buck powers up both analog and digital
circuits along with internal memory, powering off this is the last thing
that codec should do when going to very low power.

Current code was powering off this Buck if there are no users of sysclk,
which is not correct. Powering off this buck will result in no register access.
This code path was never tested until recently after adding pm support
in SoundWire controller. Fix this by removing the buck poweroff when the
codec is active and also the code that is not used.

Without this patch all the read/write transactions will never complete and
results in SLIMBus Errors like:

qcom,slim-ngd qcom,slim-ngd.1: Tx:MT:0x0, MC:0x60, LA:0xcf failed:-110
wcd934x-codec wcd934x-codec.1.auto: ASoC: error at soc_component_read_no_lock
	on wcd934x-codec.1.auto for register: [0x00000d05] -110
qcom,slim-ngd-ctrl 171c0000.slim: Error Interrupt received 0x82000000

Reported-by: Amit Pundir <amit.pundir@linaro.org>
Fixes: a61f3b4f476e ("ASoC: wcd934x: add support to wcd9340/wcd9341 codec")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Link: https://lore.kernel.org/r/20220407094313.2880-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd934x.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index 1e75e93cf28f..6298ebe96e94 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -1274,29 +1274,7 @@ static int wcd934x_set_sido_input_src(struct wcd934x_codec *wcd, int sido_src)
 	if (sido_src == wcd->sido_input_src)
 		return 0;
 
-	if (sido_src == SIDO_SOURCE_INTERNAL) {
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_HI_ACCU_EN_MASK, 0);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_HI_ACCU_PRE_ENX_MASK, 0x0);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_RCO,
-				   WCD934X_ANA_RCO_BG_EN_MASK, 0);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_PRE_EN1_MASK,
-				   WCD934X_ANA_BUCK_PRE_EN1_ENABLE);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_PRE_EN2_MASK,
-				   WCD934X_ANA_BUCK_PRE_EN2_ENABLE);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_HI_ACCU_EN_MASK,
-				   WCD934X_ANA_BUCK_HI_ACCU_ENABLE);
-		usleep_range(100, 110);
-	} else if (sido_src == SIDO_SOURCE_RCO_BG) {
+	if (sido_src == SIDO_SOURCE_RCO_BG) {
 		regmap_update_bits(wcd->regmap, WCD934X_ANA_RCO,
 				   WCD934X_ANA_RCO_BG_EN_MASK,
 				   WCD934X_ANA_RCO_BG_ENABLE);
@@ -1382,8 +1360,6 @@ static int wcd934x_disable_ana_bias_and_syclk(struct wcd934x_codec *wcd)
 	regmap_update_bits(wcd->regmap, WCD934X_CLK_SYS_MCLK_PRG,
 			   WCD934X_EXT_CLK_BUF_EN_MASK |
 			   WCD934X_MCLK_EN_MASK, 0x0);
-	wcd934x_set_sido_input_src(wcd, SIDO_SOURCE_INTERNAL);
-
 	regmap_update_bits(wcd->regmap, WCD934X_ANA_BIAS,
 			   WCD934X_ANA_BIAS_EN_MASK, 0);
 	regmap_update_bits(wcd->regmap, WCD934X_ANA_BIAS,
-- 
2.35.1



