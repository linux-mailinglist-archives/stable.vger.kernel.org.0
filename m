Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D89490EB0
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241764AbiAQRLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243058AbiAQRIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:08:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0D6C06161C;
        Mon, 17 Jan 2022 09:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFBA6611BE;
        Mon, 17 Jan 2022 17:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DD8C36AE3;
        Mon, 17 Jan 2022 17:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439088;
        bh=ZqzrJaiaGVNMXGWL+p/VujNjJlhpChX0ptTIT8Wsttc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQ5br7MEbpARGWWkcTUkcqnM7Dqo53FRLNqc4x+dSeJd3iMHGDft6ShRq3P6tL3iM
         srKBVRI3eeiX+zJtYAcdtA9nHW/NMWNi6a/4g+neHxilleckPQZSjY7g4I6sJ1XP9Z
         n0g0cQfU2YYqepbSLL0jnvAEssnt3kJo0/tKDTxeh4anvs1220MTgcTywROL+Zk3MB
         5bo2HxGENvA8Y1JJw+mqIwowyDgnVgHMw0cvSS7iyzOxT7stChAb9r7ZlBIVfuSFjR
         ROWScPLnxmQpZ3zb0uZCThcYzHTBEGWquBEJp4Og/nY76OAONiIdzq2u/gMhSVBgR8
         tQ72AoPHTzHBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        jiaxin.yu@mediatek.com, rikard.falkeborn@gmail.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 32/34] ASoC: mediatek: mt8183: fix device_node leak
Date:   Mon, 17 Jan 2022 12:03:22 -0500
Message-Id: <20220117170326.1471712-32-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit cb006006fe6221f092fadaffd3f219288304c9ad ]

Fixes the device_node leak.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20211224064719.2031210-3-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c         | 6 +++++-
 sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c | 7 ++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
index 20d31b69a5c00..9cc0f26b08fbc 100644
--- a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
@@ -787,7 +787,11 @@ static int mt8183_da7219_max98357_dev_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	return devm_snd_soc_register_card(&pdev->dev, card);
+	ret = devm_snd_soc_register_card(&pdev->dev, card);
+
+	of_node_put(platform_node);
+	of_node_put(hdmi_codec);
+	return ret;
 }
 
 #ifdef CONFIG_OF
diff --git a/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c b/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
index 79ba2f2d84522..14ce8b93597f3 100644
--- a/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
@@ -720,7 +720,12 @@ mt8183_mt6358_ts3a227_max98357_dev_probe(struct platform_device *pdev)
 				 __func__, ret);
 	}
 
-	return devm_snd_soc_register_card(&pdev->dev, card);
+	ret = devm_snd_soc_register_card(&pdev->dev, card);
+
+	of_node_put(platform_node);
+	of_node_put(ec_codec);
+	of_node_put(hdmi_codec);
+	return ret;
 }
 
 #ifdef CONFIG_OF
-- 
2.34.1

