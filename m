Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3EF401BEE
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242865AbhIFNAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243553AbhIFM7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 301C161027;
        Mon,  6 Sep 2021 12:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933121;
        bh=I/NLYrDuphiqD/WjAPPv3UBO4x4TyMqvKU9dWDJ9zgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjwLG+h0eb5XS/uMyHYHk/RlDXOgavIbGb8HeAfByzJyRmhxFYhr6tWFnaGWUiWDR
         S0kX8jaIZUI5aiB4+L7ntb+cm8h+PJnJ7b8j7Drn9KfEtMzj2AV+sqCeMZgCDJ3fDl
         WImHnEV3616oFBb1Wk/j5eub6tSnWTIJ+xs1fXfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 13/14] ALSA: usb-audio: Work around for XRUN with low latency playback
Date:   Mon,  6 Sep 2021 14:55:59 +0200
Message-Id: <20210906125448.624783028@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 4267c5a8f3133db0572cd9abee059b42cafbbdad upstream.

The recent change for low latency playback works in most of test cases
but it turned out still to hit errors on some use cases, most notably
with JACK with small buffer sizes.  This is because USB-audio driver
fills up and submits full URBs at the beginning, while the URBs would
return immediately and try to fill more -- that can easily trigger
XRUN.  It was more or less expected, but in the small buffer size, the
problem became pretty obvious.

Fixing this behavior properly would require the change of the
fundamental driver design, so it's no trivial task, unfortunately.
Instead, here we work around the problem just by switching back to the
old method when the given configuration is too fragile with the low
latency stream handling.  As a threshold, we calculate the total
buffer bytes in all plus one URBs, and check whether it's beyond the
PCM buffer bytes.  The one extra URB is needed because XRUN happens at
the next submission after the first round.

Fixes: 307cc9baac5c ("ALSA: usb-audio: Reduce latency at playback start, take#2")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210827203311.5987-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.h     |    2 ++
 sound/usb/endpoint.c |    4 ++++
 sound/usb/pcm.c      |   13 +++++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -94,6 +94,7 @@ struct snd_usb_endpoint {
 	struct list_head ready_playback_urbs; /* playback URB FIFO for implicit fb */
 
 	unsigned int nurbs;		/* # urbs */
+	unsigned int nominal_queue_size; /* total buffer sizes in URBs */
 	unsigned long active_mask;	/* bitmask of active urbs */
 	unsigned long unlink_mask;	/* bitmask of unlinked urbs */
 	char *syncbuf;			/* sync buffer for all sync URBs */
@@ -187,6 +188,7 @@ struct snd_usb_substream {
 	} dsd_dop;
 
 	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
+	bool early_playback_start;	/* early start needed for playback? */
 	struct media_ctl *media_ctl;
 };
 
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1126,6 +1126,10 @@ static int data_ep_set_params(struct snd
 		INIT_LIST_HEAD(&u->ready_list);
 	}
 
+	/* total buffer bytes of all URBs plus the next queue;
+	 * referred in pcm.c
+	 */
+	ep->nominal_queue_size = maxsize * urb_packs * (ep->nurbs + 1);
 	return 0;
 
 out_of_memory:
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -614,6 +614,14 @@ static int snd_usb_pcm_prepare(struct sn
 	subs->period_elapsed_pending = 0;
 	runtime->delay = 0;
 
+	/* check whether early start is needed for playback stream */
+	subs->early_playback_start =
+		subs->direction == SNDRV_PCM_STREAM_PLAYBACK &&
+		subs->data_endpoint->nominal_queue_size >= subs->buffer_bytes;
+
+	if (subs->early_playback_start)
+		ret = start_endpoints(subs);
+
  unlock:
 	snd_usb_unlock_shutdown(chip);
 	return ret;
@@ -1394,7 +1402,7 @@ static void prepare_playback_urb(struct
 		subs->trigger_tstamp_pending_update = false;
 	}
 
-	if (period_elapsed && !subs->running) {
+	if (period_elapsed && !subs->running && !subs->early_playback_start) {
 		subs->period_elapsed_pending = 1;
 		period_elapsed = 0;
 	}
@@ -1448,7 +1456,8 @@ static int snd_usb_substream_playback_tr
 					      prepare_playback_urb,
 					      retire_playback_urb,
 					      subs);
-		if (cmd == SNDRV_PCM_TRIGGER_START) {
+		if (!subs->early_playback_start &&
+		    cmd == SNDRV_PCM_TRIGGER_START) {
 			err = start_endpoints(subs);
 			if (err < 0) {
 				snd_usb_endpoint_set_callback(subs->data_endpoint,


