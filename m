Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA22A12C7E5
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731392AbfL2RsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:48:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731388AbfL2RsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E29C206A4;
        Sun, 29 Dec 2019 17:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641684;
        bh=rnb0vu0KmkeJvqYe577EHVGM+RcrITfTqVqyyjunlJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEOI7MqNUqKUjDBs//dla1VIFEPx/3TwN6w7zjf3Dzc2FnBEV0EgbBFeobtggcHax
         btZJCMdiDtaVx7WT/ACnzaDXh5/c2ahCqPcquGp4dYg5Zd0R7KabVTDs6mTDavPma5
         AKffeEM8zIQ0pEcpduldVLH20ag7f0FjeopEVSVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/434] ASoC: soc-pcm: fixup dpcm_prune_paths() loop continue
Date:   Sun, 29 Dec 2019 18:23:41 +0100
Message-Id: <20191229172712.962202715@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit bed646dc3f7bcec91178c278deaf969cce0700a8 ]

dpcm_prune_paths() is checking widget at 2 parts.
(A) is for CPU, (B) is for Codec.
If we focus to (A) part, continue at (a) is for (1) loop. But,
if we focus to (B) part, continue at (b) is for (2) loop, not for (1).
This is bug.
This patch fixup this issue.

	static int dpcm_prune_paths(...)
	{
		...
   (1)		for_each_dpcm_be(fe, stream, dpcm) {
			...

 ^			widget = dai_get_widget(...);
 |
(A)			if (widget && widget_in_list(...))
 | (a)				continue;
 v
 ^ (2)			for_each_rtd_codec_dai(...) {
 |				widget = dai_get_widget(...);
(B)
 |				if (widget && widget_in_list(...))
 v (b)					continue;
			}
			...

Fixes: 2e5894d73789 ("ASoC: pcm: Add support for DAI multicodec")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87blui64mf.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index b600d3eaaf5c..cdce96a3051b 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1385,6 +1385,7 @@ static int dpcm_prune_paths(struct snd_soc_pcm_runtime *fe, int stream,
 	struct snd_soc_dapm_widget *widget;
 	struct snd_soc_dai *dai;
 	int prune = 0;
+	int do_prune;
 
 	/* Destroy any old FE <--> BE connections */
 	for_each_dpcm_be(fe, stream, dpcm) {
@@ -1398,13 +1399,16 @@ static int dpcm_prune_paths(struct snd_soc_pcm_runtime *fe, int stream,
 			continue;
 
 		/* is there a valid CODEC DAI widget for this BE */
+		do_prune = 1;
 		for_each_rtd_codec_dai(dpcm->be, i, dai) {
 			widget = dai_get_widget(dai, stream);
 
 			/* prune the BE if it's no longer in our active list */
 			if (widget && widget_in_list(list, widget))
-				continue;
+				do_prune = 0;
 		}
+		if (!do_prune)
+			continue;
 
 		dev_dbg(fe->dev, "ASoC: pruning %s BE %s for %s\n",
 			stream ? "capture" : "playback",
-- 
2.20.1



