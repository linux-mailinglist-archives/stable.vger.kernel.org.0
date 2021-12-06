Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAE1469D55
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359617AbhLFP3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59092 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385584AbhLFPZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:25:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 031A1B8111A;
        Mon,  6 Dec 2021 15:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AC7C341C6;
        Mon,  6 Dec 2021 15:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804116;
        bh=dxWK4vTcWTg6T3RThtJ1CMeqYtLMnfgkk6rXhHwRhvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yquWNrfpjxJQoSakWaaNGjr4ShL/RQvvOSZxUt/Og2LZuRJhML5Fnl2cP8j2Wo48h
         jFLQIrdNmS42LVYkHy7EHJbNcgxkAQTjp14C+K4WgiBVTc5pQctzmn2XRfdkcZm/Qn
         OtH93E1edLH66D7LOBBsL1KlTqTLbF+94jYSUoLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 005/207] ALSA: usb-audio: Check available frames for the next packet size
Date:   Mon,  6 Dec 2021 15:54:19 +0100
Message-Id: <20211206145610.368169339@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit d215f63d49da9a8803af3e81acd6cad743686573 upstream.

This is yet more preparation for the upcoming changes.

Extend snd_usb_endpoint_next_packet_size() to check the available
frames and return -EAGAIN if the next packet size is equal or exceeds
the given size.  This will be needed for avoiding XRUN during the low
latency operation.

As of this patch, avail=0 is passed, i.e. the check is skipped and no
behavior change.

Link: https://lore.kernel.org/r/20210929080844.11583-7-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |   51 ++++++++++++++++++++++++++++++++++++---------------
 sound/usb/endpoint.h |    3 ++-
 sound/usb/pcm.c      |    2 +-
 3 files changed, 39 insertions(+), 17 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -148,18 +148,23 @@ int snd_usb_endpoint_implicit_feedback_s
  * This won't be used for implicit feedback which takes the packet size
  * returned from the sync source
  */
-static int slave_next_packet_size(struct snd_usb_endpoint *ep)
+static int slave_next_packet_size(struct snd_usb_endpoint *ep,
+				  unsigned int avail)
 {
 	unsigned long flags;
+	unsigned int phase;
 	int ret;
 
 	if (ep->fill_max)
 		return ep->maxframesize;
 
 	spin_lock_irqsave(&ep->lock, flags);
-	ep->phase = (ep->phase & 0xffff)
-		+ (ep->freqm << ep->datainterval);
-	ret = min(ep->phase >> 16, ep->maxframesize);
+	phase = (ep->phase & 0xffff) + (ep->freqm << ep->datainterval);
+	ret = min(phase >> 16, ep->maxframesize);
+	if (avail && ret >= avail)
+		ret = -EAGAIN;
+	else
+		ep->phase = phase;
 	spin_unlock_irqrestore(&ep->lock, flags);
 
 	return ret;
@@ -169,20 +174,25 @@ static int slave_next_packet_size(struct
  * Return the number of samples to be sent in the next packet
  * for adaptive and synchronous endpoints
  */
-static int next_packet_size(struct snd_usb_endpoint *ep)
+static int next_packet_size(struct snd_usb_endpoint *ep, unsigned int avail)
 {
+	unsigned int sample_accum;
 	int ret;
 
 	if (ep->fill_max)
 		return ep->maxframesize;
 
-	ep->sample_accum += ep->sample_rem;
-	if (ep->sample_accum >= ep->pps) {
-		ep->sample_accum -= ep->pps;
+	sample_accum += ep->sample_rem;
+	if (sample_accum >= ep->pps) {
+		sample_accum -= ep->pps;
 		ret = ep->packsize[1];
 	} else {
 		ret = ep->packsize[0];
 	}
+	if (avail && ret >= avail)
+		ret = -EAGAIN;
+	else
+		ep->sample_accum = sample_accum;
 
 	return ret;
 }
@@ -190,16 +200,27 @@ static int next_packet_size(struct snd_u
 /*
  * snd_usb_endpoint_next_packet_size: Return the number of samples to be sent
  * in the next packet
+ *
+ * If the size is equal or exceeds @avail, don't proceed but return -EAGAIN
+ * Exception: @avail = 0 for skipping the check.
  */
 int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
-				      struct snd_urb_ctx *ctx, int idx)
+				      struct snd_urb_ctx *ctx, int idx,
+				      unsigned int avail)
 {
-	if (ctx->packet_size[idx])
-		return ctx->packet_size[idx];
-	else if (ep->sync_source)
-		return slave_next_packet_size(ep);
+	unsigned int packet;
+
+	packet = ctx->packet_size[idx];
+	if (packet) {
+		if (avail && packet >= avail)
+			return -EAGAIN;
+		return packet;
+	}
+
+	if (ep->sync_source)
+		return slave_next_packet_size(ep, avail);
 	else
-		return next_packet_size(ep);
+		return next_packet_size(ep, avail);
 }
 
 static void call_retire_callback(struct snd_usb_endpoint *ep,
@@ -263,7 +284,7 @@ static void prepare_silent_urb(struct sn
 		unsigned int length;
 		int counts;
 
-		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i);
+		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, 0);
 		length = counts * ep->stride; /* number of silent bytes */
 		offset = offs * ep->stride + extra * i;
 		urb->iso_frame_desc[i].offset = offset;
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -46,6 +46,7 @@ void snd_usb_endpoint_free_all(struct sn
 
 int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
-				      struct snd_urb_ctx *ctx, int idx);
+				      struct snd_urb_ctx *ctx, int idx,
+				      unsigned int avail);
 
 #endif /* __USBAUDIO_ENDPOINT_H */
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1365,7 +1365,7 @@ static void prepare_playback_urb(struct
 	spin_lock_irqsave(&subs->lock, flags);
 	subs->frame_limit += ep->max_urb_frames;
 	for (i = 0; i < ctx->packets; i++) {
-		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i);
+		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, 0);
 		/* set up descriptor */
 		urb->iso_frame_desc[i].offset = frames * stride;
 		urb->iso_frame_desc[i].length = counts * stride;


