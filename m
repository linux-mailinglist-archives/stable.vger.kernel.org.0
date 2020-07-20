Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A403122639E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgGTPio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729264AbgGTPio (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:38:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B64C22CB2;
        Mon, 20 Jul 2020 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259523;
        bh=PdWIbI7vkbelWceLiDpR3vy41889LxRcLx+CKRmuGSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5jSHZu6ujA1e39gth/yoW61JtGDdiyGcsuTdDvravA1mODtLIIwv9aOixz1nTF2g
         X9SKZEyUaqnV9izHDhByXuyg/k9kciapMmGaWxvwixcT+c9+wIZS7ejTte8AkzKZ9/
         pZgx8WCTNCDgR+aBdPkuoOUgC9vvVGnIp959vks0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/58] ALSA: compress: fix partial_drain completion state
Date:   Mon, 20 Jul 2020 17:36:24 +0200
Message-Id: <20200720152747.563143461@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit f79a732a8325dfbd570d87f1435019d7e5501c6d ]

On partial_drain completion we should be in SNDRV_PCM_STATE_RUNNING
state, so set that for partially draining streams in
snd_compr_drain_notify() and use a flag for partially draining streams

While at it, add locks for stream state change in
snd_compr_drain_notify() as well.

Fixes: f44f2a5417b2 ("ALSA: compress: fix drain calls blocking other compress functions (v6)")
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Tested-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20200629134737.105993-4-vkoul@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/compress_driver.h | 10 +++++++++-
 sound/core/compress_offload.c   |  4 ++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/sound/compress_driver.h b/include/sound/compress_driver.h
index a5c6e6da3d3d4..57872c8f11512 100644
--- a/include/sound/compress_driver.h
+++ b/include/sound/compress_driver.h
@@ -71,6 +71,7 @@ struct snd_compr_runtime {
  * @direction: stream direction, playback/recording
  * @metadata_set: metadata set flag, true when set
  * @next_track: has userspace signal next track transition, true when set
+ * @partial_drain: undergoing partial_drain for stream, true when set
  * @private_data: pointer to DSP private data
  */
 struct snd_compr_stream {
@@ -81,6 +82,7 @@ struct snd_compr_stream {
 	enum snd_compr_direction direction;
 	bool metadata_set;
 	bool next_track;
+	bool partial_drain;
 	void *private_data;
 };
 
@@ -178,7 +180,13 @@ static inline void snd_compr_drain_notify(struct snd_compr_stream *stream)
 	if (snd_BUG_ON(!stream))
 		return;
 
-	stream->runtime->state = SNDRV_PCM_STATE_SETUP;
+	/* for partial_drain case we are back to running state on success */
+	if (stream->partial_drain) {
+		stream->runtime->state = SNDRV_PCM_STATE_RUNNING;
+		stream->partial_drain = false; /* clear this flag as well */
+	} else {
+		stream->runtime->state = SNDRV_PCM_STATE_SETUP;
+	}
 
 	wake_up(&stream->runtime->sleep);
 }
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 07f5017cbea2a..e788c7e1929bd 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -699,6 +699,9 @@ static int snd_compr_stop(struct snd_compr_stream *stream)
 
 	retval = stream->ops->trigger(stream, SNDRV_PCM_TRIGGER_STOP);
 	if (!retval) {
+		/* clear flags and stop any drain wait */
+		stream->partial_drain = false;
+		stream->metadata_set = false;
 		snd_compr_drain_notify(stream);
 		stream->runtime->total_bytes_available = 0;
 		stream->runtime->total_bytes_transferred = 0;
@@ -809,6 +812,7 @@ static int snd_compr_partial_drain(struct snd_compr_stream *stream)
 	if (stream->next_track == false)
 		return -EPERM;
 
+	stream->partial_drain = true;
 	retval = stream->ops->trigger(stream, SND_COMPR_TRIGGER_PARTIAL_DRAIN);
 	if (retval) {
 		pr_debug("Partial drain returned failure\n");
-- 
2.25.1



