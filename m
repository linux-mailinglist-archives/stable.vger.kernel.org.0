Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DB5698628
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjBOUsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjBOUri (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:47:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D69E4393E;
        Wed, 15 Feb 2023 12:46:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B8652CE2702;
        Wed, 15 Feb 2023 20:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68F8C4339B;
        Wed, 15 Feb 2023 20:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493989;
        bh=yopj1Ok402VLqO03d/DGnckaXgp6bdvXmnEXhDwCoZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTYIjoIrgsRA7KMccYgbB0asWKaRTdSszOuNEUFEvriXlkHb+lVywPDMMn78PwEgd
         WGXm8md8p6sLtNkAZ+miTojwtLnrdtlE5a35hc7S9/dTZWqh04MPcKOYETo75ncviH
         ELvL2P4X9GXPctiO+1R85SOXUo/fuzTTTVt6w48JSg+Q7Ik4LJ0OAFVP2FFCLNAv2o
         N3y2iphHAiqXKl1OjQY1DF1TgiuKk/OaB7ov5ao5Dlg0Ts50jO/gXSm80aIjsL1HpC
         tYAWX6qSplzkleSpg1UGJeb1v5mbD3zt8XIQNyzcqt3tSFW55M/w7t7PFWi9QmhN26
         VUez340LvpAJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Firago <a.firago@yadro.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, yangyingliang@huawei.com,
        yangxiaohua@everest-semi.com, zhuning0077@gmail.com,
        u.kleine-koenig@pengutronix.de, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 20/24] ASoC: codecs: es8326: Fix DTS properties reading
Date:   Wed, 15 Feb 2023 15:45:43 -0500
Message-Id: <20230215204547.2760761-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Firago <a.firago@yadro.com>

[ Upstream commit fe1e7e8ce2c47bd8fd9885eab63fca0a522e94c9 ]

Seems like properties parsing and reading was copy-pasted,
so "everest,interrupt-src" and "everest,interrupt-clk" are saved into
the es8326->jack_pol variable. This might lead to wrong settings
being saved into the reg 57 (ES8326_HP_DET).

Fix this by using proper variables while reading properties.

Signed-off-by: Alexey Firago <a.firago@yadro.com>
Reviewed-by: Yang Yingliang <yangyingliang@huawei.com
Link: https://lore.kernel.org/r/20230204195106.46539-1-a.firago@yadro.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 87c1cc16592bb..555125efd9ad3 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -729,14 +729,16 @@ static int es8326_probe(struct snd_soc_component *component)
 	}
 	dev_dbg(component->dev, "jack-pol %x", es8326->jack_pol);
 
-	ret = device_property_read_u8(component->dev, "everest,interrupt-src", &es8326->jack_pol);
+	ret = device_property_read_u8(component->dev, "everest,interrupt-src",
+				      &es8326->interrupt_src);
 	if (ret != 0) {
 		dev_dbg(component->dev, "interrupt-src return %d", ret);
 		es8326->interrupt_src = ES8326_HP_DET_SRC_PIN9;
 	}
 	dev_dbg(component->dev, "interrupt-src %x", es8326->interrupt_src);
 
-	ret = device_property_read_u8(component->dev, "everest,interrupt-clk", &es8326->jack_pol);
+	ret = device_property_read_u8(component->dev, "everest,interrupt-clk",
+				      &es8326->interrupt_clk);
 	if (ret != 0) {
 		dev_dbg(component->dev, "interrupt-clk return %d", ret);
 		es8326->interrupt_clk = 0x45;
-- 
2.39.0

