Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A58490E90
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242972AbiAQRLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55978 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242991AbiAQRH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:07:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76EBD61287;
        Mon, 17 Jan 2022 17:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72900C36AE3;
        Mon, 17 Jan 2022 17:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439275;
        bh=/hdemuENqnf/jOGaiRcSiGH0J0G5zPzuLXuG/sxnf9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=db1n6wy5A8U09z41Z+0R7+mV0nFfCnc4ya2Pr2kV3bwAdQlLQ45Z4jULyh9iGOPvD
         f11dAc15mbwyz8UZGEpE+sbNauBdm7LpMfiy42HsllyQ+AfgzLLg7hqiodeaH8lbNJ
         xYPRJKTzMatL6kWhvuCQ3SUZXgVwvaej6ZTeTASp+UxAL500FTxtq0juCFeoqfgvU9
         M44NXMYFuMyFpC5ZyEmIRyUI2cpE4yPIOTeOfOFfWzh5dcyZ6g7nYbvWsZyber5Fw7
         BySL5LDcSrFt8BthQ33e5106wQRnGMRuHaTkWlcVvJjnOlfnX2gAydwnpp+lWorGrf
         R+M7bG7aMcAEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        jiaxin.yu@mediatek.com, angelogioacchino.delregno@collabora.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 13/13] ASoC: mediatek: mt8173: fix device_node leak
Date:   Mon, 17 Jan 2022 12:07:21 -0500
Message-Id: <20220117170722.1473137-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170722.1473137-1-sashal@kernel.org>
References: <20220117170722.1473137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 493433785df0075afc0c106ab65f10a605d0b35d ]

Fixes the device_node leak.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20211224064719.2031210-2-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-max98090.c      | 3 +++
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c | 2 ++
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c | 2 ++
 sound/soc/mediatek/mt8173/mt8173-rt5650.c        | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/sound/soc/mediatek/mt8173/mt8173-max98090.c b/sound/soc/mediatek/mt8173/mt8173-max98090.c
index 5524a2c727ec7..cab30cb48366d 100644
--- a/sound/soc/mediatek/mt8173/mt8173-max98090.c
+++ b/sound/soc/mediatek/mt8173/mt8173-max98090.c
@@ -183,6 +183,9 @@ static int mt8173_max98090_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(codec_node);
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
index 467f7049a2886..52fdd766ee82c 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
@@ -228,6 +228,8 @@ static int mt8173_rt5650_rt5514_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
index 1b8b2a7788450..5d75b04f074fe 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
@@ -285,6 +285,8 @@ static int mt8173_rt5650_rt5676_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650.c b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
index ba65f4157a7e0..d02a90201b13b 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
@@ -317,6 +317,8 @@ static int mt8173_rt5650_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(platform_node);
 	return ret;
 }
 
-- 
2.34.1

