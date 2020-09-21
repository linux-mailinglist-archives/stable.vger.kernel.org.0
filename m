Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A000027284F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgIUOmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbgIUOlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:41:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A78623788;
        Mon, 21 Sep 2020 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699278;
        bh=807vuyse8ZjeQhILT+YEPTWpW3Dob9DBrVPV2RT9sPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jgw/f4qfEgNEo5+t1SBrmVd+GTF6fTbUJ9qTWBAFruvHjYGA42E2emY21H9bF8Hd1
         gMcV8qvojVbsoMqGSXxbsUZcsoDhUveJATqTKOvLdxAh+8FxKxdLFtCpfPk2jglfjJ
         jqrAXHCIv6HBQO/4EyJ5/rHDWv4+REMwFYaSIDS8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 2/9] ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions
Date:   Mon, 21 Sep 2020 10:41:07 -0400
Message-Id: <20200921144114.2135773-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144114.2135773-1-sashal@kernel.org>
References: <20200921144114.2135773-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

[ Upstream commit f5a2cda4f1db89776b64c4f0f2c2ac609527ac70 ]

When the wm8958_mic_detect, wm8994_mic_detect functions get called from
the machine driver, e.g. from the card's late_probe() callback, the CODEC
device may be PM runtime suspended and any regmap writes have no effect.
Add PM runtime calls to these functions to ensure the device registers
are updated as expected.
This suppresses an error during boot
"wm8994-codec: ASoC: error at snd_soc_component_update_bits on wm8994-codec"
caused by the regmap access error due to the cache_only flag being set.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200827173357.31891-2-s.nawrocki@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index cd089b4143029..e3e069277a3ff 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3376,6 +3376,8 @@ int wm8994_mic_detect(struct snd_soc_component *component, struct snd_soc_jack *
 		return -EINVAL;
 	}
 
+	pm_runtime_get_sync(component->dev);
+
 	switch (micbias) {
 	case 1:
 		micdet = &wm8994->micdet[0];
@@ -3423,6 +3425,8 @@ int wm8994_mic_detect(struct snd_soc_component *component, struct snd_soc_jack *
 
 	snd_soc_dapm_sync(dapm);
 
+	pm_runtime_put(component->dev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm8994_mic_detect);
@@ -3790,6 +3794,8 @@ int wm8958_mic_detect(struct snd_soc_component *component, struct snd_soc_jack *
 		return -EINVAL;
 	}
 
+	pm_runtime_get_sync(component->dev);
+
 	if (jack) {
 		snd_soc_dapm_force_enable_pin(dapm, "CLK_SYS");
 		snd_soc_dapm_sync(dapm);
@@ -3858,6 +3864,8 @@ int wm8958_mic_detect(struct snd_soc_component *component, struct snd_soc_jack *
 		snd_soc_dapm_sync(dapm);
 	}
 
+	pm_runtime_put(component->dev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm8958_mic_detect);
-- 
2.25.1

