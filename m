Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871B8490E37
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241429AbiAQRII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:08:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50204 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiAQRFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:05:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44AE5B8114E;
        Mon, 17 Jan 2022 17:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917E2C36AEC;
        Mon, 17 Jan 2022 17:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439151;
        bh=IsB6GP+yJnWzUkvkzrdDk9FmxGEtrdhq6Spim46u5qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCM8PrdFQlfwlPelzrZ4wK97kgGw+uFfgRcrFU/Dit5wgKPB1Ug4evcbli/H2F01e
         z0XfuSzUnYaJIf2nsfSHsGESvt0ERsrxH2hfBgBMg5KYdVGeApadYFyhE60DVMt5WO
         xnDbpVBZyA64p/DMbYR8V+ZlmqilwA6GCuI0NuZHKbFeOg9XkbxJjIomttSMYzUVjh
         7rOe2NH6RWalMS9Zoi3SztnIKulOvXRqnb6Nt+C1KkvyG6gcvwgWwdjkr5nwr2TkeK
         F/5UAUs1GfWU3yQtCcXI4tdbpyRtnRuL6QwZTji/vb4S2wwPkldy0govJKG4BmUkaW
         /sLXSz5lSqeOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        jiaxin.yu@mediatek.com, angelogioacchino.delregno@collabora.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 21/21] ASoC: mediatek: mt8173: fix device_node leak
Date:   Mon, 17 Jan 2022 12:04:53 -0500
Message-Id: <20220117170454.1472347-21-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170454.1472347-1-sashal@kernel.org>
References: <20220117170454.1472347-1-sashal@kernel.org>
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
index 22c00600c999f..de1410c2c446f 100644
--- a/sound/soc/mediatek/mt8173/mt8173-max98090.c
+++ b/sound/soc/mediatek/mt8173/mt8173-max98090.c
@@ -180,6 +180,9 @@ static int mt8173_max98090_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(codec_node);
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
index 8717e87bfe264..6f8542329bab9 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
@@ -218,6 +218,8 @@ static int mt8173_rt5650_rt5514_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
index 9d4dd97211548..727ff0f7f20b1 100644
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
index ef6f236752867..21e7d4d3ded5a 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
@@ -309,6 +309,8 @@ static int mt8173_rt5650_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(platform_node);
 	return ret;
 }
 
-- 
2.34.1

