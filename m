Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF6711970C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfLJVaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727704AbfLJVJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15D06246A7;
        Tue, 10 Dec 2019 21:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012180;
        bh=ExUDjvtm01aCy1m6j1T8rrhTrcy9sZWU0k3WFEOT2v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEJmvFdh7D3Faqw/zNynkcPmUu4kDNzD1pCTBwaaNoU3a53QyXtuS7pejAqMSXtrq
         gLHUtguuNCKI0lsIcZVtXCtizjzeX5Sop+wKfnBxi/KmgApiCUY8WEbTwQHTAj17Yy
         queCkgydcRpcmEda5zXdkJ8M9uesDCMg1scM2YVs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 138/350] ASoC: soc-pcm: fixup dpcm_prune_paths() loop continue
Date:   Tue, 10 Dec 2019 16:04:03 -0500
Message-Id: <20191210210735.9077-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b600d3eaaf5cd..cdce96a3051bf 100644
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

