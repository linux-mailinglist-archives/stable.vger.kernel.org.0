Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568F67F967
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394695AbfHBN0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394683AbfHBN0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:26:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FDEE21874;
        Fri,  2 Aug 2019 13:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752413;
        bh=hX593VyfC/7Z4qDZX8BNdFpN6206bbCN8USs9PuL6qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsUB9obIG3Pn6rzXuxHCDVKfye7rH6zBYCylQRION9hm+bhdvObxlH5kwDCUY1xBc
         vycol7ZBfnpCbJJk1bwo0YOlHu7czxMrFoj6rFIoyABnCieNcB23a/9IFzg0ISwyOW
         DBbZ7OhkimA2ADk4MSh7KNdP+XBZrmFko3UE6/QU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 09/17] ALSA: compress: Fix regression on compressed capture streams
Date:   Fri,  2 Aug 2019 09:26:26 -0400
Message-Id: <20190802132635.14885-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132635.14885-1-sashal@kernel.org>
References: <20190802132635.14885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 4475f8c4ab7b248991a60d9c02808dbb813d6be8 ]

A previous fix to the stop handling on compressed capture streams causes
some knock on issues. The previous fix updated snd_compr_drain_notify to
set the state back to PREPARED for capture streams. This causes some
issues however as the handling for snd_compr_poll differs between the
two states and some user-space applications were relying on the poll
failing after the stream had been stopped.

To correct this regression whilst still fixing the original problem the
patch was addressing, update the capture handling to skip the PREPARED
state rather than skipping the SETUP state as it has done until now.

Fixes: 4f2ab5e1d13d ("ALSA: compress: Fix stop handling on compressed capture streams")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/compress_driver.h |  5 +----
 sound/core/compress_offload.c   | 16 +++++++++++-----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/sound/compress_driver.h b/include/sound/compress_driver.h
index 85ff3181e6f11..a5c6e6da3d3d4 100644
--- a/include/sound/compress_driver.h
+++ b/include/sound/compress_driver.h
@@ -178,10 +178,7 @@ static inline void snd_compr_drain_notify(struct snd_compr_stream *stream)
 	if (snd_BUG_ON(!stream))
 		return;
 
-	if (stream->direction == SND_COMPRESS_PLAYBACK)
-		stream->runtime->state = SNDRV_PCM_STATE_SETUP;
-	else
-		stream->runtime->state = SNDRV_PCM_STATE_PREPARED;
+	stream->runtime->state = SNDRV_PCM_STATE_SETUP;
 
 	wake_up(&stream->runtime->sleep);
 }
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 3c88a33840645..16269e7ff3904 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -551,10 +551,7 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 		stream->metadata_set = false;
 		stream->next_track = false;
 
-		if (stream->direction == SND_COMPRESS_PLAYBACK)
-			stream->runtime->state = SNDRV_PCM_STATE_SETUP;
-		else
-			stream->runtime->state = SNDRV_PCM_STATE_PREPARED;
+		stream->runtime->state = SNDRV_PCM_STATE_SETUP;
 	} else {
 		return -EPERM;
 	}
@@ -670,8 +667,17 @@ static int snd_compr_start(struct snd_compr_stream *stream)
 {
 	int retval;
 
-	if (stream->runtime->state != SNDRV_PCM_STATE_PREPARED)
+	switch (stream->runtime->state) {
+	case SNDRV_PCM_STATE_SETUP:
+		if (stream->direction != SND_COMPRESS_CAPTURE)
+			return -EPERM;
+		break;
+	case SNDRV_PCM_STATE_PREPARED:
+		break;
+	default:
 		return -EPERM;
+	}
+
 	retval = stream->ops->trigger(stream, SNDRV_PCM_TRIGGER_START);
 	if (!retval)
 		stream->runtime->state = SNDRV_PCM_STATE_RUNNING;
-- 
2.20.1

