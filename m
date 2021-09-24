Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C970C417442
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344881AbhIXNES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345488AbhIXNBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAB0761263;
        Fri, 24 Sep 2021 12:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488047;
        bh=OABRhE89etsuzFNPAxoyiMhYCTWy0SWZ4aSURaF22OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqwvMGRtNIMf/2cEnX+AtL5sUVH8j3+qioAU9imcrzyRHwJt5BVImwW5/Orvj27Sp
         nj7gDvShCq4BT+pq3yHvTSIDlG82AdHedBvp2ANlIbN/8jZj69hry6V+pLyXwSn60k
         Ek3dUDSqmqn+3gV0US2H21GG20Obh+S430fuZIWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olivier MOYSAN <olivier.moysan@foss.st.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 062/100] ASoC: audio-graph: respawn Platform Support
Date:   Fri, 24 Sep 2021 14:44:11 +0200
Message-Id: <20210924124343.498797266@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 5f939f49771002f347039edf984aca42f30fc31a ]

commit 63f2f9cceb09f8 ("ASoC: audio-graph: remove Platform support")
removed Platform support from audio-graph, because it doesn't have
"plat" support on DT (simple-card has).
But, Platform support is needed if user is using
snd_dmaengine_pcm_register() which adds generic DMA as Platform.
And this Platform dev is using CPU dev.

Without this patch, at least STM32MP15 audio sound card is no more
functional (v5.13 or later). This patch respawn Platform Support on
audio-graph again.

Reported-by: Olivier MOYSAN <olivier.moysan@foss.st.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Olivier MOYSAN <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/878s0jzrpf.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/generic/audio-graph-card.c b/sound/soc/generic/audio-graph-card.c
index 5e71382467e8..546f6fd0609e 100644
--- a/sound/soc/generic/audio-graph-card.c
+++ b/sound/soc/generic/audio-graph-card.c
@@ -285,6 +285,7 @@ static int graph_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 	if (li->cpu) {
 		struct snd_soc_card *card = simple_priv_to_card(priv);
 		struct snd_soc_dai_link_component *cpus = asoc_link_to_cpu(dai_link, 0);
+		struct snd_soc_dai_link_component *platforms = asoc_link_to_platform(dai_link, 0);
 		int is_single_links = 0;
 
 		/* Codec is dummy */
@@ -313,6 +314,7 @@ static int graph_dai_link_of_dpcm(struct asoc_simple_priv *priv,
 			dai_link->no_pcm = 1;
 
 		asoc_simple_canonicalize_cpu(cpus, is_single_links);
+		asoc_simple_canonicalize_platform(platforms, cpus);
 	} else {
 		struct snd_soc_codec_conf *cconf = simple_props_to_codec_conf(dai_props, 0);
 		struct snd_soc_dai_link_component *codecs = asoc_link_to_codec(dai_link, 0);
@@ -366,6 +368,7 @@ static int graph_dai_link_of(struct asoc_simple_priv *priv,
 	struct snd_soc_dai_link *dai_link = simple_priv_to_link(priv, li->link);
 	struct snd_soc_dai_link_component *cpus = asoc_link_to_cpu(dai_link, 0);
 	struct snd_soc_dai_link_component *codecs = asoc_link_to_codec(dai_link, 0);
+	struct snd_soc_dai_link_component *platforms = asoc_link_to_platform(dai_link, 0);
 	char dai_name[64];
 	int ret, is_single_links = 0;
 
@@ -383,6 +386,7 @@ static int graph_dai_link_of(struct asoc_simple_priv *priv,
 		 "%s-%s", cpus->dai_name, codecs->dai_name);
 
 	asoc_simple_canonicalize_cpu(cpus, is_single_links);
+	asoc_simple_canonicalize_platform(platforms, cpus);
 
 	ret = graph_link_init(priv, cpu_ep, codec_ep, li, dai_name);
 	if (ret < 0)
@@ -608,6 +612,7 @@ static int graph_count_noml(struct asoc_simple_priv *priv,
 
 	li->num[li->link].cpus		= 1;
 	li->num[li->link].codecs	= 1;
+	li->num[li->link].platforms     = 1;
 
 	li->link += 1; /* 1xCPU-Codec */
 
@@ -630,6 +635,7 @@ static int graph_count_dpcm(struct asoc_simple_priv *priv,
 
 	if (li->cpu) {
 		li->num[li->link].cpus		= 1;
+		li->num[li->link].platforms     = 1;
 
 		li->link++; /* 1xCPU-dummy */
 	} else {
-- 
2.33.0



