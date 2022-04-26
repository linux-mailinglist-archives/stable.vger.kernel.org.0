Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A331F510813
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346208AbiDZTGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353851AbiDZTGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:06:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451B019AD99;
        Tue, 26 Apr 2022 12:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D68C66199A;
        Tue, 26 Apr 2022 19:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220CDC385A4;
        Tue, 26 Apr 2022 19:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999772;
        bh=kP8vkEbi7l6zQ+HStJBxrehrXF5ycY+sgq3il3p6mlc=;
        h=From:To:Cc:Subject:Date:From;
        b=pv4jE7oz4cREnzsC9jWLHwd8bKJWSFKuA0PCanCVAtztxNAPhMenjPqkQOSYnpx2w
         3KUax3XwOyZFlh8oJ+ZE3zm75A4k4MXR9M4RRLeQo9mn0qKoz71AZ0H/moTvahAkBu
         j9LBdJI6MCCGGn8KJHot5QlVhQN15LAvlIVoKgcWndPSLRXma64EcHLnbgKv8qzmg7
         Ev1AOuoIX5ixSRuxub2KDtMy7lkvYQpPB0+BlGBic3YI9SHeBUmNevbhup9x74T5Rq
         obNflKBVs0XEJQlMLxjImWT9KE7sW61OXU0ZE5p31yyt3YvDrGsKkp+kcudBWAX5L6
         Yyi8ACmQ5VW+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, ckeepax@opensource.cirrus.com,
        u.kleine-koenig@pengutronix.de, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 1/6] ASoC: wm8731: Disable the regulator when probing fails
Date:   Tue, 26 Apr 2022 15:02:44 -0400
Message-Id: <20220426190251.2351817-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 92ccbf17eeacf510cf1eed9c252d9332ca24f02d ]

When the driver fails during probing, the driver should disable the
regulator, not just handle it in wm8731_hw_init().

The following log reveals it:

[   17.812483] WARNING: CPU: 1 PID: 364 at drivers/regulator/core.c:2257 _regulator_put+0x3ec/0x4e0
[   17.815958] RIP: 0010:_regulator_put+0x3ec/0x4e0
[   17.824467] Call Trace:
[   17.824774]  <TASK>
[   17.825040]  regulator_bulk_free+0x82/0xe0
[   17.825514]  devres_release_group+0x319/0x3d0
[   17.825882]  i2c_device_probe+0x766/0x940
[   17.829198]  i2c_register_driver+0xb5/0x130

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/20220405121038.4094051-1-zheyuma97@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8731.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 7c8fad865d6b..3c5c02b034a9 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -604,7 +604,7 @@ static int wm8731_hw_init(struct device *dev, struct wm8731_priv *wm8731)
 	ret = wm8731_reset(wm8731->regmap);
 	if (ret < 0) {
 		dev_err(dev, "Failed to issue reset: %d\n", ret);
-		goto err_regulator_enable;
+		goto err;
 	}
 
 	/* Clear POWEROFF, keep everything else disabled */
@@ -621,10 +621,7 @@ static int wm8731_hw_init(struct device *dev, struct wm8731_priv *wm8731)
 
 	regcache_mark_dirty(wm8731->regmap);
 
-err_regulator_enable:
-	/* Regulators will be enabled by bias management */
-	regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies), wm8731->supplies);
-
+err:
 	return ret;
 }
 
@@ -768,21 +765,27 @@ static int wm8731_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(wm8731->regmap);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
 			ret);
-		return ret;
+		goto err_regulator_enable;
 	}
 
 	ret = wm8731_hw_init(&i2c->dev, wm8731);
 	if (ret != 0)
-		return ret;
+		goto err_regulator_enable;
 
 	ret = devm_snd_soc_register_component(&i2c->dev,
 			&soc_component_dev_wm8731, &wm8731_dai, 1);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to register CODEC: %d\n", ret);
-		return ret;
+		goto err_regulator_enable;
 	}
 
 	return 0;
+
+err_regulator_enable:
+	/* Regulators will be enabled by bias management */
+	regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies), wm8731->supplies);
+
+	return ret;
 }
 
 static int wm8731_i2c_remove(struct i2c_client *client)
-- 
2.35.1

