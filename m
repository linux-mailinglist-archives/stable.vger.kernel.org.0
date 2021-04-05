Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F1D353FA3
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbhDEJN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239482AbhDEJNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7949361002;
        Mon,  5 Apr 2021 09:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614000;
        bh=ih4y904yWzaAhA7DVefag97qpt+xUl+gClXPC0J6d0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUoJHrhyC+0pT4ujmPtcOEuGuFC2xaCemYmyU/WhC+4sO3/jN5L79YihJLLp60PZ5
         kJyegMC++Wpryia/6tCAEu9vmw90WpXtnZd8O+SBe2sKr6Rb19iRk9nknzEsDbpKkd
         MnfqgDh8pD+QCkTrXqUnnWeQSZHr/C9oF9EJ6C2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 029/152] ASoC: rt711: add snd_soc_component remove callback
Date:   Mon,  5 Apr 2021 10:52:58 +0200
Message-Id: <20210405085035.200100334@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 85f744184a60..047f4e677d78 100644
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



