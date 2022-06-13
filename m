Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767DD5496EE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356033AbiFMLrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356359AbiFMLoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:44:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF494704E;
        Mon, 13 Jun 2022 03:50:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4061C61306;
        Mon, 13 Jun 2022 10:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C85EC34114;
        Mon, 13 Jun 2022 10:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117435;
        bh=QeQg3hA5x9OrSaQpUJVXP7E9MxhSc4xird1zk6F7M0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PisOQSrF9uigMk3jic4bIAo+ftTwAgMj655PGHeVVGRS7YITdl8REwjfPN9E2LXaB
         1nV9bgu6DxJ48tL16aUxkmUK6EgohSbRx8ZDKWgKFqn/rdmS1k1ykzHUZhJE/tslWL
         2Fi4Dt47IrrT2MxG5G2yrPkcMpiLmr55AHSycA+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/287] ASoC: tscs454: Add endianness flag in snd_soc_component_driver
Date:   Mon, 13 Jun 2022 12:07:34 +0200
Message-Id: <20220613094924.778294963@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ff69ec96b87dccb3a29edef8cec5d4fefbbc2055 ]

The endianness flag is used on the CODEC side to specify an
ambivalence to endian, typically because it is lost over the hardware
link. This device receives audio over an I2S DAI and as such should
have endianness applied.

A fixup is also required to use the width directly rather than relying
on the format in hw_params, now both little and big endian would be
supported. It is worth noting this changes the behaviour of S24_LE to
use a word length of 24 rather than 32. This would appear to be a
correction since the fact S24_LE is stored as 32 bits should not be
presented over the bus.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220504170905.332415-26-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tscs454.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/tscs454.c b/sound/soc/codecs/tscs454.c
index ff85a0bf6170..00a90ccd6566 100644
--- a/sound/soc/codecs/tscs454.c
+++ b/sound/soc/codecs/tscs454.c
@@ -3129,18 +3129,17 @@ static int set_aif_sample_format(struct snd_soc_component *component,
 	unsigned int width;
 	int ret;
 
-	switch (format) {
-	case SNDRV_PCM_FORMAT_S16_LE:
+	switch (snd_pcm_format_width(format)) {
+	case 16:
 		width = FV_WL_16;
 		break;
-	case SNDRV_PCM_FORMAT_S20_3LE:
+	case 20:
 		width = FV_WL_20;
 		break;
-	case SNDRV_PCM_FORMAT_S24_3LE:
+	case 24:
 		width = FV_WL_24;
 		break;
-	case SNDRV_PCM_FORMAT_S24_LE:
-	case SNDRV_PCM_FORMAT_S32_LE:
+	case 32:
 		width = FV_WL_32;
 		break;
 	default:
@@ -3338,6 +3337,7 @@ static const struct snd_soc_component_driver soc_component_dev_tscs454 = {
 	.num_dapm_routes = ARRAY_SIZE(tscs454_intercon),
 	.controls =	tscs454_snd_controls,
 	.num_controls = ARRAY_SIZE(tscs454_snd_controls),
+	.endianness = 1,
 };
 
 #define TSCS454_RATES SNDRV_PCM_RATE_8000_96000
-- 
2.35.1



