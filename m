Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E089D217009
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgGGPO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbgGGPO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78A492078A;
        Tue,  7 Jul 2020 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134866;
        bh=0PjnaFB8qFssY3A57pl7TnOgE1vV7Usyl3IKqXZ7e58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmpMFvpFNUs+kb24RZZNeA7/JFpwKyBZpzE5BCkABOnUcWbBEOw9REJh3qdMygAPq
         Vok4ppKT5LL4o3ZtpkOVjLXOhRjtSnmBEZIRYnKbVK0CkZyrVGSlrqeCXG6l1QVF6i
         qRSYxHPHkx6fy8EEs5XBIcxK27jqKQm0U5a27PU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        Hans de Goede <jwrdegoede@fedoraproject.org>
Subject: [PATCH 4.9 18/24] Revert "ALSA: usb-audio: Improve frames size computation"
Date:   Tue,  7 Jul 2020 17:13:50 +0200
Message-Id: <20200707145749.849989609@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
References: <20200707145748.952502272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 5ef30e443e6d3654cccecec99cf481a69a0a6d3b which is
commit f0bd62b64016508938df9babe47f65c2c727d25c upstream.

It causes a number of reported issues and a fix for it has not hit
Linus's tree yet.  Revert this to resolve those problems.

Cc: Alexander Tsoy <alexander@tsoy.me>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Hans de Goede <jwrdegoede@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.h     |    4 ----
 sound/usb/endpoint.c |   43 +++++--------------------------------------
 sound/usb/endpoint.h |    1 -
 sound/usb/pcm.c      |    2 --
 4 files changed, 5 insertions(+), 45 deletions(-)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -80,10 +80,6 @@ struct snd_usb_endpoint {
 	dma_addr_t sync_dma;		/* DMA address of syncbuf */
 
 	unsigned int pipe;		/* the data i/o pipe */
-	unsigned int framesize[2];	/* small/large frame sizes in samples */
-	unsigned int sample_rem;	/* remainder from division fs/fps */
-	unsigned int sample_accum;	/* sample accumulator */
-	unsigned int fps;		/* frames per second */
 	unsigned int freqn;		/* nominal sampling rate in fs/fps in Q16.16 format */
 	unsigned int freqm;		/* momentary sampling rate in fs/fps in Q16.16 format */
 	int	   freqshift;		/* how much to shift the feedback value to get Q16.16 */
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -137,12 +137,12 @@ int snd_usb_endpoint_implicit_feedback_s
 
 /*
  * For streaming based on information derived from sync endpoints,
- * prepare_outbound_urb_sizes() will call slave_next_packet_size() to
+ * prepare_outbound_urb_sizes() will call next_packet_size() to
  * determine the number of samples to be sent in the next packet.
  *
- * For implicit feedback, slave_next_packet_size() is unused.
+ * For implicit feedback, next_packet_size() is unused.
  */
-int snd_usb_endpoint_slave_next_packet_size(struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep)
 {
 	unsigned long flags;
 	int ret;
@@ -159,29 +159,6 @@ int snd_usb_endpoint_slave_next_packet_s
 	return ret;
 }
 
-/*
- * For adaptive and synchronous endpoints, prepare_outbound_urb_sizes()
- * will call next_packet_size() to determine the number of samples to be
- * sent in the next packet.
- */
-int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep)
-{
-	int ret;
-
-	if (ep->fill_max)
-		return ep->maxframesize;
-
-	ep->sample_accum += ep->sample_rem;
-	if (ep->sample_accum >= ep->fps) {
-		ep->sample_accum -= ep->fps;
-		ret = ep->framesize[1];
-	} else {
-		ret = ep->framesize[0];
-	}
-
-	return ret;
-}
-
 static void retire_outbound_urb(struct snd_usb_endpoint *ep,
 				struct snd_urb_ctx *urb_ctx)
 {
@@ -226,8 +203,6 @@ static void prepare_silent_urb(struct sn
 
 		if (ctx->packet_size[i])
 			counts = ctx->packet_size[i];
-		else if (ep->sync_master)
-			counts = snd_usb_endpoint_slave_next_packet_size(ep);
 		else
 			counts = snd_usb_endpoint_next_packet_size(ep);
 
@@ -900,17 +875,10 @@ int snd_usb_endpoint_set_params(struct s
 	ep->maxpacksize = fmt->maxpacksize;
 	ep->fill_max = !!(fmt->attributes & UAC_EP_CS_ATTR_FILL_MAX);
 
-	if (snd_usb_get_speed(ep->chip->dev) == USB_SPEED_FULL) {
+	if (snd_usb_get_speed(ep->chip->dev) == USB_SPEED_FULL)
 		ep->freqn = get_usb_full_speed_rate(rate);
-		ep->fps = 1000;
-	} else {
+	else
 		ep->freqn = get_usb_high_speed_rate(rate);
-		ep->fps = 8000;
-	}
-
-	ep->sample_rem = rate % ep->fps;
-	ep->framesize[0] = rate / ep->fps;
-	ep->framesize[1] = (rate + (ep->fps - 1)) / ep->fps;
 
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
@@ -969,7 +937,6 @@ int snd_usb_endpoint_start(struct snd_us
 	ep->active_mask = 0;
 	ep->unlink_mask = 0;
 	ep->phase = 0;
-	ep->sample_accum = 0;
 
 	snd_usb_endpoint_start_quirk(ep);
 
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -27,7 +27,6 @@ void snd_usb_endpoint_release(struct snd
 void snd_usb_endpoint_free(struct snd_usb_endpoint *ep);
 
 int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep);
-int snd_usb_endpoint_slave_next_packet_size(struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep);
 
 void snd_usb_handle_sync_urb(struct snd_usb_endpoint *ep,
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1483,8 +1483,6 @@ static void prepare_playback_urb(struct
 	for (i = 0; i < ctx->packets; i++) {
 		if (ctx->packet_size[i])
 			counts = ctx->packet_size[i];
-		else if (ep->sync_master)
-			counts = snd_usb_endpoint_slave_next_packet_size(ep);
 		else
 			counts = snd_usb_endpoint_next_packet_size(ep);
 


