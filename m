Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2F7348F81
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhCYL15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231209AbhCYL0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1FFF61A2E;
        Thu, 25 Mar 2021 11:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671597;
        bh=sZroW6ZD33NImc7OmNg0DCW18XpmCtLFFO8WzF2ZY0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDHwCLkKWGCpnQUh7rLv1BBU3gZFjs3lY6yon63MdYSvkYeqYR99OtL7mMKapPOea
         fn27ALXE1id2IOA1SMIvByS2AySwbjnez29URWFz3Id7MpXKbprlEGyy7MMz+FaJuk
         ef1y0KxH24jZYtx/lSt+fULVf4YZhXZ3je6b4WutM5eEM4YLIagI5DzU02kAItvNgz
         TwQ0LCtQ6wQXMRRl3RE2L5lTcqan6ot82S79XiM+/O+SWgV/eor2aoExwzpibA6DUF
         RVgV0Gf9+zDocjDoqLBAHfo4NSS80p7KBwrmkoZhNtOAB947hBNctvq7tbIJE+cdDy
         LikrNQKhvoW2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bard Liao <yung-chuan.liao@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 29/39] ASoC: rt711: add snd_soc_component remove callback
Date:   Thu, 25 Mar 2021 07:25:48 -0400
Message-Id: <20210325112558.1927423-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 899b12542b0897f92de9ba30944937c39ebb246d ]

We do some IO operations in the snd_soc_component_set_jack callback
function and snd_soc_component_set_jack() will be called when soc
component is removed. However, we should not access SoundWire registers
when the bus is suspended.
So set regcache_cache_only(regmap, true) to avoid accessing in the
soc component removal process.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Link: https://lore.kernel.org/r/20210316005254.29699-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index a9b1b4180c47..93d86f7558e0 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -895,6 +895,13 @@ static int rt711_probe(struct snd_soc_component *component)
 	return 0;
 }
 
+static void rt711_remove(struct snd_soc_component *component)
+{
+	struct rt711_priv *rt711 = snd_soc_component_get_drvdata(component);
+
+	regcache_cache_only(rt711->regmap, true);
+}
+
 static const struct snd_soc_component_driver soc_codec_dev_rt711 = {
 	.probe = rt711_probe,
 	.set_bias_level = rt711_set_bias_level,
@@ -905,6 +912,7 @@ static const struct snd_soc_component_driver soc_codec_dev_rt711 = {
 	.dapm_routes = rt711_audio_map,
 	.num_dapm_routes = ARRAY_SIZE(rt711_audio_map),
 	.set_jack = rt711_set_jack_detect,
+	.remove = rt711_remove,
 };
 
 static int rt711_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
-- 
2.30.1

