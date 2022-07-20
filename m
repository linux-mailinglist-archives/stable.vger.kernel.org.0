Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542C857ABA2
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbiGTBOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241006AbiGTBOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:14:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF49167CB5;
        Tue, 19 Jul 2022 18:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63F0DB81DEC;
        Wed, 20 Jul 2022 01:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A60C341CB;
        Wed, 20 Jul 2022 01:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279577;
        bh=xwqQwlX7XMzhwZjDOpafQbywxNNxJ+MX2kfIncl+xMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ltl4vQgBScVimj2MklTeZm/s+VJWCew84muFYavF+VLOf1SwEh96WcSxINSIDzFEj
         YtkEsXdobTfm9c0pWMNPjF7oFB2ceuZmhdt1637jPneqQP8/wh4A1Yvf4dGJwIGqU+
         dKw5+JtBI/GD0BFYu53sDBisdmCr6eYWK1nN8xDTdy0L238i5evj/Zht50OTOca8mM
         uey4cTwvpKmtI4aH/g6EV1DsoFbMZThBvYX4YLsg5I1op2X/42AdFZntHohUweRNkd
         m8cuSF9ct7qmATCr+NmQKdLggp4Df6u6dQIDBjDk0K+jS21/qFQa+OJqUwk9rYUSOk
         Q/8m9Y2Y15odA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, steve@sk2.org, zheyuma97@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 37/54] ASoC: tlv320adcx140: Fix tx_mask check
Date:   Tue, 19 Jul 2022 21:10:14 -0400
Message-Id: <20220720011031.1023305-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 7d90c8e6396ba245da16bedd789df6d669375408 ]

The tx_mask check doesn't reflect what the driver and the chip support.

The check currently checks for exactly two slots being enabled. The
tlv320adcx140 supports anything between one and eight channels, so relax
the check accordingly.

The tlv320adcx140 supports arbitrary tx_mask settings, but the driver
currently only supports adjacent slots beginning with the first slot,
so extend the check to check that the first slot is being used and that
there are no holes in the tx_mask.

Leave a comment to make it's the driver that limits the tx_mask
settings, not the chip itself.

While at it remove the set-but-unused struct adcx140p_priv::tdm_delay
field.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20220624105716.2579539-1-s.hauer@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adcx140.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 32b120d624b2..bf18fcfcaeb9 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -33,7 +33,6 @@ struct adcx140_priv {
 	bool micbias_vg;
 
 	unsigned int dai_fmt;
-	unsigned int tdm_delay;
 	unsigned int slot_width;
 };
 
@@ -792,12 +791,13 @@ static int adcx140_set_dai_tdm_slot(struct snd_soc_dai *codec_dai,
 {
 	struct snd_soc_component *component = codec_dai->component;
 	struct adcx140_priv *adcx140 = snd_soc_component_get_drvdata(component);
-	unsigned int lsb;
 
-	/* TDM based on DSP mode requires slots to be adjacent */
-	lsb = __ffs(tx_mask);
-	if ((lsb + 1) != __fls(tx_mask)) {
-		dev_err(component->dev, "Invalid mask, slots must be adjacent\n");
+	/*
+	 * The chip itself supports arbitrary masks, but the driver currently
+	 * only supports adjacent slots beginning at the first slot.
+	 */
+	if (tx_mask != GENMASK(__fls(tx_mask), 0)) {
+		dev_err(component->dev, "Only lower adjacent slots are supported\n");
 		return -EINVAL;
 	}
 
@@ -812,7 +812,6 @@ static int adcx140_set_dai_tdm_slot(struct snd_soc_dai *codec_dai,
 		return -EINVAL;
 	}
 
-	adcx140->tdm_delay = lsb;
 	adcx140->slot_width = slot_width;
 
 	return 0;
-- 
2.35.1

