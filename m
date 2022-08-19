Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B565959A215
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352772AbiHSQcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352844AbiHSQaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:30:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E728511B4DE;
        Fri, 19 Aug 2022 09:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9630A61698;
        Fri, 19 Aug 2022 16:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FC9C433C1;
        Fri, 19 Aug 2022 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925072;
        bh=jNC4ksYrbcdVJ5/4F+p0COllB0jcUIbNIjJwPtYxzzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aS+ruwY+hkcQGoVBN6FEPXzGc9HgJfTL/9V6HyhJhykst9hdRcmIHcBgV5CpaEJh
         l6aT2t/pkhQGHouDAVT0SmKe5oWHwxJqagXzuIlkUFvbmIs6ViGjO4y9C0GKg+bdNP
         gID//+ZK/rlkhEx7vTa7XCS8XASXpSDrCRhpXcNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/545] ASoC: codecs: wcd9335: move gains from SX_TLV to S8_TLV
Date:   Fri, 19 Aug 2022 17:42:23 +0200
Message-Id: <20220819153846.110072186@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 2fbe0953732e06b471cdedbf6f615b84235580d8 ]

move all the digital gains form using SX_TLV to S8_TLV, these gains are
actually 8 bit gains with 7th signed bit and ranges from -84dB to +40dB

rest of the Qualcomm wcd codecs uses these properly.

Fixes: 8c4f021d806a ("ASoC: wcd9335: add basic controls")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220609111901.318047-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 81 +++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 45 deletions(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 2677d0c3b19b..8f4ed39c49de 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -2252,51 +2252,42 @@ static int wcd9335_rx_hph_mode_put(struct snd_kcontrol *kc,
 
 static const struct snd_kcontrol_new wcd9335_snd_controls[] = {
 	/* -84dB min - 40dB max */
-	SOC_SINGLE_SX_TLV("RX0 Digital Volume", WCD9335_CDC_RX0_RX_VOL_CTL,
-		0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX1 Digital Volume", WCD9335_CDC_RX1_RX_VOL_CTL,
-		0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX2 Digital Volume", WCD9335_CDC_RX2_RX_VOL_CTL,
-		0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX3 Digital Volume", WCD9335_CDC_RX3_RX_VOL_CTL,
-		0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX4 Digital Volume", WCD9335_CDC_RX4_RX_VOL_CTL,
-		0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX5 Digital Volume", WCD9335_CDC_RX5_RX_VOL_CTL,
-		0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX6 Digital Volume", WCD9335_CDC_RX6_RX_VOL_CTL,
-		0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX7 Digital Volume", WCD9335_CDC_RX7_RX_VOL_CTL,
-		0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX8 Digital Volume", WCD9335_CDC_RX8_RX_VOL_CTL,
-		0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX0 Mix Digital Volume",
-			  WCD9335_CDC_RX0_RX_VOL_MIX_CTL,
-			  0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX1 Mix Digital Volume",
-			  WCD9335_CDC_RX1_RX_VOL_MIX_CTL,
-			  0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX2 Mix Digital Volume",
-			  WCD9335_CDC_RX2_RX_VOL_MIX_CTL,
-			  0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX3 Mix Digital Volume",
-			  WCD9335_CDC_RX3_RX_VOL_MIX_CTL,
-			  0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX4 Mix Digital Volume",
-			  WCD9335_CDC_RX4_RX_VOL_MIX_CTL,
-			  0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX5 Mix Digital Volume",
-			  WCD9335_CDC_RX5_RX_VOL_MIX_CTL,
-			  0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX6 Mix Digital Volume",
-			  WCD9335_CDC_RX6_RX_VOL_MIX_CTL,
-			  0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX7 Mix Digital Volume",
-			  WCD9335_CDC_RX7_RX_VOL_MIX_CTL,
-			  0, -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("RX8 Mix Digital Volume",
-			  WCD9335_CDC_RX8_RX_VOL_MIX_CTL,
-			  0, -84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX0 Digital Volume", WCD9335_CDC_RX0_RX_VOL_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX1 Digital Volume", WCD9335_CDC_RX1_RX_VOL_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX2 Digital Volume", WCD9335_CDC_RX2_RX_VOL_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX3 Digital Volume", WCD9335_CDC_RX3_RX_VOL_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX4 Digital Volume", WCD9335_CDC_RX4_RX_VOL_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX5 Digital Volume", WCD9335_CDC_RX5_RX_VOL_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX6 Digital Volume", WCD9335_CDC_RX6_RX_VOL_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX7 Digital Volume", WCD9335_CDC_RX7_RX_VOL_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX8 Digital Volume", WCD9335_CDC_RX8_RX_VOL_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX0 Mix Digital Volume", WCD9335_CDC_RX0_RX_VOL_MIX_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX1 Mix Digital Volume", WCD9335_CDC_RX1_RX_VOL_MIX_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX2 Mix Digital Volume", WCD9335_CDC_RX2_RX_VOL_MIX_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX3 Mix Digital Volume", WCD9335_CDC_RX3_RX_VOL_MIX_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX4 Mix Digital Volume", WCD9335_CDC_RX4_RX_VOL_MIX_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX5 Mix Digital Volume", WCD9335_CDC_RX5_RX_VOL_MIX_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX6 Mix Digital Volume", WCD9335_CDC_RX6_RX_VOL_MIX_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX7 Mix Digital Volume", WCD9335_CDC_RX7_RX_VOL_MIX_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("RX8 Mix Digital Volume", WCD9335_CDC_RX8_RX_VOL_MIX_CTL,
+			-84, 40, digital_gain),
 	SOC_ENUM("RX INT0_1 HPF cut off", cf_int0_1_enum),
 	SOC_ENUM("RX INT0_2 HPF cut off", cf_int0_2_enum),
 	SOC_ENUM("RX INT1_1 HPF cut off", cf_int1_1_enum),
-- 
2.35.1



