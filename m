Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D6F20D4DD
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731024AbgF2TK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730972AbgF2TKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:10:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9FD9254B9;
        Mon, 29 Jun 2020 15:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446012;
        bh=roBeJzdPDztMiw2+5KYWfWWVCKJXTBepawuz9UREOb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfpWiWuecqf7050qe5gF/C+Zk5t/B81XmLGQpy8gaV7kpOY8w5Eej17uhfUDkStNm
         /tyT8eDEWcgSIGUflBYKy6LjI2QyzL5lemRNPOs1DooGL/1hxACKQok8iLMndGo+Wb
         xkir7FWnbywBZ2nNT0t/QKNP5T1OoNBAp1sijHZA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Tsoy <alexander@tsoy.me>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 019/135] ALSA: usb-audio: Improve frames size computation
Date:   Mon, 29 Jun 2020 11:51:13 -0400
Message-Id: <20200629155309.2495516-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

[ Upstream commit f0bd62b64016508938df9babe47f65c2c727d25c ]

For computation of the the next frame size current value of fs/fps and
accumulated fractional parts of fs/fps are used, where values are stored
in Q16.16 format. This is quite natural for computing frame size for
asynchronous endpoints driven by explicit feedback, since in this case
fs/fps is a value provided by the feedback endpoint and it's already in
the Q format. If an error is accumulated over time, the device can
adjust fs/fps value to prevent buffer overruns/underruns.

But for synchronous endpoints the accuracy provided by these computations
is not enough. Due to accumulated error the driver periodically produces
frames with incorrect size (+/- 1 audio sample).

This patch fixes this issue by implementing a different algorithm for
frame size computation. It is based on accumulating of the remainders
from division fs/fps and it doesn't accumulate errors over time. This
new method is enabled for synchronous and adaptive playback endpoints.

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Link: https://lore.kernel.org/r/20200424022449.14972-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.h     |  4 ++++
 sound/usb/endpoint.c | 43 ++++++++++++++++++++++++++++++++++++++-----
 sound/usb/endpoint.h |  1 +
 sound/usb/pcm.c      |  2 ++
 4 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index 71778ca4b26aa..844c688638105 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -80,6 +80,10 @@ struct snd_usb_endpoint {
 	dma_addr_t sync_dma;		/* DMA address of syncbuf */
 
 	unsigned int pipe;		/* the data i/o pipe */
+	unsigned int framesize[2];	/* small/large frame sizes in samples */
+	unsigned int sample_rem;	/* remainder from division fs/fps */
+	unsigned int sample_accum;	/* sample accumulator */
+	unsigned int fps;		/* frames per second */
 	unsigned int freqn;		/* nominal sampling rate in fs/fps in Q16.16 format */
 	unsigned int freqm;		/* momentary sampling rate in fs/fps in Q16.16 format */
 	int	   freqshift;		/* how much to shift the feedback value to get Q16.16 */
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 66648b4bdd289..666731317b332 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -137,12 +137,12 @@ int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep)
 
 /*
  * For streaming based on information derived from sync endpoints,
- * prepare_outbound_urb_sizes() will call next_packet_size() to
+ * prepare_outbound_urb_sizes() will call slave_next_packet_size() to
  * determine the number of samples to be sent in the next packet.
  *
- * For implicit feedback, next_packet_size() is unused.
+ * For implicit feedback, slave_next_packet_size() is unused.
  */
-int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_slave_next_packet_size(struct snd_usb_endpoint *ep)
 {
 	unsigned long flags;
 	int ret;
@@ -159,6 +159,29 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep)
 	return ret;
 }
 
+/*
+ * For adaptive and synchronous endpoints, prepare_outbound_urb_sizes()
+ * will call next_packet_size() to determine the number of samples to be
+ * sent in the next packet.
+ */
+int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep)
+{
+	int ret;
+
+	if (ep->fill_max)
+		return ep->maxframesize;
+
+	ep->sample_accum += ep->sample_rem;
+	if (ep->sample_accum >= ep->fps) {
+		ep->sample_accum -= ep->fps;
+		ret = ep->framesize[1];
+	} else {
+		ret = ep->framesize[0];
+	}
+
+	return ret;
+}
+
 static void retire_outbound_urb(struct snd_usb_endpoint *ep,
 				struct snd_urb_ctx *urb_ctx)
 {
@@ -203,6 +226,8 @@ static void prepare_silent_urb(struct snd_usb_endpoint *ep,
 
 		if (ctx->packet_size[i])
 			counts = ctx->packet_size[i];
+		else if (ep->sync_master)
+			counts = snd_usb_endpoint_slave_next_packet_size(ep);
 		else
 			counts = snd_usb_endpoint_next_packet_size(ep);
 
@@ -879,10 +904,17 @@ int snd_usb_endpoint_set_params(struct snd_usb_endpoint *ep,
 	ep->maxpacksize = fmt->maxpacksize;
 	ep->fill_max = !!(fmt->attributes & UAC_EP_CS_ATTR_FILL_MAX);
 
-	if (snd_usb_get_speed(ep->chip->dev) == USB_SPEED_FULL)
+	if (snd_usb_get_speed(ep->chip->dev) == USB_SPEED_FULL) {
 		ep->freqn = get_usb_full_speed_rate(rate);
-	else
+		ep->fps = 1000;
+	} else {
 		ep->freqn = get_usb_high_speed_rate(rate);
+		ep->fps = 8000;
+	}
+
+	ep->sample_rem = rate % ep->fps;
+	ep->framesize[0] = rate / ep->fps;
+	ep->framesize[1] = (rate + (ep->fps - 1)) / ep->fps;
 
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
@@ -941,6 +973,7 @@ int snd_usb_endpoint_start(struct snd_usb_endpoint *ep)
 	ep->active_mask = 0;
 	ep->unlink_mask = 0;
 	ep->phase = 0;
+	ep->sample_accum = 0;
 
 	snd_usb_endpoint_start_quirk(ep);
 
diff --git a/sound/usb/endpoint.h b/sound/usb/endpoint.h
index 584f295d7c773..4aad49cbeb5f1 100644
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -27,6 +27,7 @@ void snd_usb_endpoint_release(struct snd_usb_endpoint *ep);
 void snd_usb_endpoint_free(struct snd_usb_endpoint *ep);
 
 int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep);
+int snd_usb_endpoint_slave_next_packet_size(struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep);
 
 void snd_usb_handle_sync_urb(struct snd_usb_endpoint *ep,
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index f84c55ecd0fb4..53d91cae86f96 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1473,6 +1473,8 @@ static void prepare_playback_urb(struct snd_usb_substream *subs,
 	for (i = 0; i < ctx->packets; i++) {
 		if (ctx->packet_size[i])
 			counts = ctx->packet_size[i];
+		else if (ep->sync_master)
+			counts = snd_usb_endpoint_slave_next_packet_size(ep);
 		else
 			counts = snd_usb_endpoint_next_packet_size(ep);
 
-- 
2.25.1

