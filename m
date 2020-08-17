Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A31246A5E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgHQPek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730045AbgHQPeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C80D8208B3;
        Mon, 17 Aug 2020 15:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678451;
        bh=Wq/7cUTQI0hPLaWUFiNEOiTy7UhYN+KlR2hy4Nwyiao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhhvKvFU1ww8pyg1Mvr5CKgKXJFaPu7WCoWqxcRoxYBW6jaMOSpDLPR0DhJFwAdg7
         EsLufbo6f9JyA0uxbfRBpDwI3TyWTouVqYpOT2rIbaCDGpD3JZXfqmSewnG8TGLIPK
         xcv+uYHpiQOHJBobNnF6reWpv1Qgf+bDtH0LiXZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 338/464] ASoC: meson: cards: deal dpcm flag change
Date:   Mon, 17 Aug 2020 17:14:51 +0200
Message-Id: <20200817143849.967979700@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit da3f23fde9d7b4a7e0ca9a9a096cec3104df1b82 ]

Commit b73287f0b074 ("ASoC: soc-pcm: dpcm: fix playback/capture checks")
changed the meaning of dpcm_playback/dpcm_capture and now requires the
CPU DAI BE to aligned with those flags.

This broke all Amlogic cards with uni-directional backends (All gx and
most axg cards).

While I'm still confused as to how this change is an improvement, those
cards can't remain broken forever. Hopefully, next time an API change is
done like that, all the users will be updated as part of the change, and
not left to fend for themselves.

Fixes: b73287f0b074 ("ASoC: soc-pcm: dpcm: fix playback/capture checks")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20200731120603.2243261-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-card.c         | 18 ++++++++++--------
 sound/soc/meson/gx-card.c          | 18 +++++++++---------
 sound/soc/meson/meson-card-utils.c |  4 ----
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index 47f2d93224fea..33058518c3da4 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -327,20 +327,22 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
 		return ret;
 
 	if (axg_card_cpu_is_playback_fe(dai_link->cpus->of_node))
-		ret = meson_card_set_fe_link(card, dai_link, np, true);
+		return meson_card_set_fe_link(card, dai_link, np, true);
 	else if (axg_card_cpu_is_capture_fe(dai_link->cpus->of_node))
-		ret = meson_card_set_fe_link(card, dai_link, np, false);
-	else
-		ret = meson_card_set_be_link(card, dai_link, np);
+		return meson_card_set_fe_link(card, dai_link, np, false);
 
+
+	ret = meson_card_set_be_link(card, dai_link, np);
 	if (ret)
 		return ret;
 
-	if (axg_card_cpu_is_tdm_iface(dai_link->cpus->of_node))
-		ret = axg_card_parse_tdm(card, np, index);
-	else if (axg_card_cpu_is_codec(dai_link->cpus->of_node)) {
+	if (axg_card_cpu_is_codec(dai_link->cpus->of_node)) {
 		dai_link->params = &codec_params;
-		dai_link->no_pcm = 0; /* link is not a DPCM BE */
+	} else {
+		dai_link->no_pcm = 1;
+		snd_soc_dai_link_set_capabilities(dai_link);
+		if (axg_card_cpu_is_tdm_iface(dai_link->cpus->of_node))
+			ret = axg_card_parse_tdm(card, np, index);
 	}
 
 	return ret;
diff --git a/sound/soc/meson/gx-card.c b/sound/soc/meson/gx-card.c
index 4abf7efb7eacc..fdd2d5303b2a7 100644
--- a/sound/soc/meson/gx-card.c
+++ b/sound/soc/meson/gx-card.c
@@ -96,21 +96,21 @@ static int gx_card_add_link(struct snd_soc_card *card, struct device_node *np,
 		return ret;
 
 	if (gx_card_cpu_identify(dai_link->cpus, "FIFO"))
-		ret = meson_card_set_fe_link(card, dai_link, np, true);
-	else
-		ret = meson_card_set_be_link(card, dai_link, np);
+		return  meson_card_set_fe_link(card, dai_link, np, true);
 
+	ret = meson_card_set_be_link(card, dai_link, np);
 	if (ret)
 		return ret;
 
-	/* Check if the cpu is the i2s encoder and parse i2s data */
-	if (gx_card_cpu_identify(dai_link->cpus, "I2S Encoder"))
-		ret = gx_card_parse_i2s(card, np, index);
-
 	/* Or apply codec to codec params if necessary */
-	else if (gx_card_cpu_identify(dai_link->cpus, "CODEC CTRL")) {
+	if (gx_card_cpu_identify(dai_link->cpus, "CODEC CTRL")) {
 		dai_link->params = &codec_params;
-		dai_link->no_pcm = 0; /* link is not a DPCM BE */
+	} else {
+		dai_link->no_pcm = 1;
+		snd_soc_dai_link_set_capabilities(dai_link);
+		/* Check if the cpu is the i2s encoder and parse i2s data */
+		if (gx_card_cpu_identify(dai_link->cpus, "I2S Encoder"))
+			ret = gx_card_parse_i2s(card, np, index);
 	}
 
 	return ret;
diff --git a/sound/soc/meson/meson-card-utils.c b/sound/soc/meson/meson-card-utils.c
index 5a4a91c887347..c734131ff0d62 100644
--- a/sound/soc/meson/meson-card-utils.c
+++ b/sound/soc/meson/meson-card-utils.c
@@ -147,10 +147,6 @@ int meson_card_set_be_link(struct snd_soc_card *card,
 	struct device_node *np;
 	int ret, num_codecs;
 
-	link->no_pcm = 1;
-	link->dpcm_playback = 1;
-	link->dpcm_capture = 1;
-
 	num_codecs = of_get_child_count(node);
 	if (!num_codecs) {
 		dev_err(card->dev, "be link %s has no codec\n",
-- 
2.25.1



