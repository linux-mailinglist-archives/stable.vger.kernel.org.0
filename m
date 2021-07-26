Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9AF3D619D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhGZPc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhGZPaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EC7160240;
        Mon, 26 Jul 2021 16:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315847;
        bh=cmrJYhBCUI46U+cwR+izsNCqYWxffPLc0a0uRZx1n+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ws9vaVitKpvwCttUTUWGr/2ZnKw/hqBM6gG6IdrwxLf8BcfNykirVYKqLMF4Dhs7I
         qAii0LgdGODuqQm6cgf1HgdlNOOIK3/1qAUnpDRJFvlhChRxie51UnwiZC9iQoQME8
         Jx3HWXmqjEh7w67BNjt0IKUhaQy8GWhOMCBLOuTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 090/223] ASoC: soc-pcm: add a flag to reverse the stop sequence
Date:   Mon, 26 Jul 2021 17:38:02 +0200
Message-Id: <20210726153849.195273853@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vijendar Mukunda <vijendar.mukunda@amd.com>

[ Upstream commit 59dd33f82dc0975c55d3d46801e7ca45532d7673 ]

On stream stop, currently CPU DAI stop sequence invoked first
followed by DMA. For Few platforms, it is required to stop the
DMA first before stopping CPU DAI.

Introduced new flag in dai_link structure for reordering stop sequence.
Based on flag check, ASoC core will re-order the stop sequence.

Fixes: 4378f1fbe92405 ("ASoC: soc-pcm: Use different sequence for start/stop trigger")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20210716123015.15697-1-vijendar.mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h |  6 ++++++
 sound/soc/soc-pcm.c | 22 ++++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index e746da996351..723eeb1c3f78 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -712,6 +712,12 @@ struct snd_soc_dai_link {
 	/* Do not create a PCM for this DAI link (Backend link) */
 	unsigned int ignore:1;
 
+	/* This flag will reorder stop sequence. By enabling this flag
+	 * DMA controller stop sequence will be invoked first followed by
+	 * CPU DAI driver stop sequence
+	 */
+	unsigned int stop_dma_first:1;
+
 #ifdef CONFIG_SND_SOC_TOPOLOGY
 	struct snd_soc_dobj dobj; /* For topology */
 #endif
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 46513bb97904..d1c570ca21ea 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1015,6 +1015,7 @@ out:
 
 static int soc_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 {
+	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
 	int ret = -EINVAL, _ret = 0;
 	int rollback = 0;
 
@@ -1055,14 +1056,23 @@ start_err:
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		ret = snd_soc_pcm_dai_trigger(substream, cmd, rollback);
-		if (ret < 0)
-			break;
+		if (rtd->dai_link->stop_dma_first) {
+			ret = snd_soc_pcm_component_trigger(substream, cmd, rollback);
+			if (ret < 0)
+				break;
 
-		ret = snd_soc_pcm_component_trigger(substream, cmd, rollback);
-		if (ret < 0)
-			break;
+			ret = snd_soc_pcm_dai_trigger(substream, cmd, rollback);
+			if (ret < 0)
+				break;
+		} else {
+			ret = snd_soc_pcm_dai_trigger(substream, cmd, rollback);
+			if (ret < 0)
+				break;
 
+			ret = snd_soc_pcm_component_trigger(substream, cmd, rollback);
+			if (ret < 0)
+				break;
+		}
 		ret = snd_soc_link_trigger(substream, cmd, rollback);
 		break;
 	}
-- 
2.30.2



