Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CBD490DF5
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbiAQRGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50952 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241748AbiAQRDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:03:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DDA2B81136;
        Mon, 17 Jan 2022 17:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B319C36B00;
        Mon, 17 Jan 2022 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438988;
        bh=dPNDS9c1FKRDuq5vFo9z89Gbkjn2n1/fPgl2lhDlYk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGFsLMOdU22eRUaMirhqSQ/YGhpUEkBVn549ynxQBxEUvdDWM73l2lsWkraG4TECE
         idny53MbxKH3/7qoSIWA1XqdQ+MNJPPxd6qEsPXRXQ4eYpN40ZRiWfykAosjqr6dAw
         /Qy3SKv0qeFZhUol0IPq7OMLIMGow/efHRcosLmrKXfgFeH5dJczrJOX6YCfWYauEf
         qNMGHxFzYbkMiES3/HyDbhp09m9hrPxA7CaW1wSMSMiLG6EI+hwnZeA/o/Sk14zgdV
         azyVu+Bljeuek/hb+kkY1KuT6yjc0cctRX+tc4KVmPb/abjqBMKcMrsix3bKFkDpIP
         6OGJ0u0xclfpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        jiaxin.yu@mediatek.com, angelogioacchino.delregno@collabora.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 39/44] ASoC: mediatek: mt8173: fix device_node leak
Date:   Mon, 17 Jan 2022 12:01:22 -0500
Message-Id: <20220117170127.1471115-39-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
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
index fc94314bfc02f..3bdd4931316cd 100644
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
index 0f28dc2217c09..390da5bf727eb 100644
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
index 077c6ee067806..c8e4e85e10575 100644
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
index c28ebf891cb05..e168d31f44459 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
@@ -323,6 +323,8 @@ static int mt8173_rt5650_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(platform_node);
 	return ret;
 }
 
-- 
2.34.1

