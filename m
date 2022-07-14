Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AD55742A8
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbiGNEZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiGNEYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FA92A404;
        Wed, 13 Jul 2022 21:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADDE261E1C;
        Thu, 14 Jul 2022 04:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AE2C385A9;
        Thu, 14 Jul 2022 04:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772592;
        bh=URhcXxTWUNtIzStOAzJURnj/9iuxRya7GBYaj5eiSz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssTvIt2cxGxgLw8ZtXQOiKXvOscSx1+RyQQs1MK9JSySpqOe89xJPt99A5QNa92cn
         Be7q2KvEsuIXfDm3IhTzWb2XaVdZ2YCuem6C1dk08RLueyK0102I3Exyrr46+etFmN
         NKgEG9mtHYb7KYYYu4xt336hQDKPcBauQTsxhLAO5derIIYUph9dqHrAN91unAKA70
         pPJA1Zi6uRZIYVmlmu23cYs2Q9F2FEp1mGd3/LQLOt7YU3DLBBxXQM4U6Bjm38gUb5
         hjGdrLyFAsJBsQV3BOJ/FzChTdjWGsnR1YoSm6UOpFmZb+0Dd3ZWZUmEmn8kZSJneN
         hZ8hrcUL1c9OQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, simont@opensource.cirrus.com,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 18/41] ASoC: wm5110: Fix DRE control
Date:   Thu, 14 Jul 2022 00:21:58 -0400
Message-Id: <20220714042221.281187-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 0bc0ae9a5938d512fd5d44f11c9c04892dcf4961 ]

The DRE controls on wm5110 should return a value of 1 if the DRE state
is actually changed, update to fix this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220621102041.1713504-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5110.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 4973ba1ed779..4ab7a672f8de 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -413,6 +413,7 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	unsigned int rnew = (!!ucontrol->value.integer.value[1]) << mc->rshift;
 	unsigned int lold, rold;
 	unsigned int lena, rena;
+	bool change = false;
 	int ret;
 
 	snd_soc_dapm_mutex_lock(dapm);
@@ -440,8 +441,8 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 		goto err;
 	}
 
-	ret = regmap_update_bits(arizona->regmap, ARIZONA_DRE_ENABLE,
-				 mask, lnew | rnew);
+	ret = regmap_update_bits_check(arizona->regmap, ARIZONA_DRE_ENABLE,
+				       mask, lnew | rnew, &change);
 	if (ret) {
 		dev_err(arizona->dev, "Failed to set DRE: %d\n", ret);
 		goto err;
@@ -454,6 +455,9 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	if (!rnew && rold)
 		wm5110_clear_pga_volume(arizona, mc->rshift);
 
+	if (change)
+		ret = 1;
+
 err:
 	snd_soc_dapm_mutex_unlock(dapm);
 
-- 
2.35.1

