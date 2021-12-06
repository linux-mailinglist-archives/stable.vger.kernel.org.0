Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB30469D48
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347626AbhLFP2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58706 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377693AbhLFPYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD5A4B810F1;
        Mon,  6 Dec 2021 15:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C90C341C1;
        Mon,  6 Dec 2021 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804080;
        bh=N8d10ml9/+265R5r2LNqI+lphWN7NU7aTHDDTA85+LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVdammH78g9m4ex5Ldkclh8BbgKooUwTLjR+DXf9g2o5cEfgrParvmq2oGSZb24zz
         HcAIyTgRB/Bj/DukkgYcFOjDZVbvGj5F2UYvaAgmU9viT8lJhTEH8FdKZA5hzYkF+3
         GGCjJdWcP+v+XHD9SLDK7jxciwLqWh6Kz5hxLE+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 002/207] ALSA: usb-audio: Rename early_playback_start flag with lowlatency_playback
Date:   Mon,  6 Dec 2021 15:54:16 +0100
Message-Id: <20211206145610.259843454@linuxfoundation.org>
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

commit 9c9a3b9da891cc70405a544da6855700eddcbb71 upstream.

This is a preparation patch for the upcoming low-latency improvement
changes.

Rename early_playback_start flag with lowlatency_playback as it's more
intuitive.  The new flag is basically a reverse meaning.

Along with the rename, factor out the code to set the flag to a
function.  This makes the complex condition checks simpler.

Also, the same flag is introduced to snd_usb_endpoint, too, that is
carried from the snd_usb_substream flag.  Currently the endpoint flag
isn't still referred, but will be used in later patches.

Link: https://lore.kernel.org/r/20210929080844.11583-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.h     |    3 ++-
 sound/usb/endpoint.c |    4 ++++
 sound/usb/pcm.c      |   29 ++++++++++++++++++++---------
 3 files changed, 26 insertions(+), 10 deletions(-)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -126,6 +126,7 @@ struct snd_usb_endpoint {
 	int skip_packets;		/* quirks for devices to ignore the first n packets
 					   in a stream */
 	bool implicit_fb_sync;		/* syncs with implicit feedback */
+	bool lowlatency_playback;	/* low-latency playback mode */
 	bool need_setup;		/* (re-)need for configure? */
 
 	/* for hw constraints */
@@ -190,7 +191,7 @@ struct snd_usb_substream {
 	} dsd_dop;
 
 	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
-	bool early_playback_start;	/* early start needed for playback? */
+	bool lowlatency_playback;	/* low-latency playback mode */
 	struct media_ctl *media_ctl;
 };
 
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -794,6 +794,10 @@ void snd_usb_endpoint_set_callback(struc
 {
 	ep->prepare_data_urb = prepare;
 	ep->retire_data_urb = retire;
+	if (data_subs)
+		ep->lowlatency_playback = data_subs->lowlatency_playback;
+	else
+		ep->lowlatency_playback = false;
 	WRITE_ONCE(ep->data_subs, data_subs);
 }
 
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -581,6 +581,22 @@ static int snd_usb_hw_free(struct snd_pc
 	return 0;
 }
 
+/* check whether early start is needed for playback stream */
+static int lowlatency_playback_available(struct snd_usb_substream *subs)
+{
+	struct snd_usb_audio *chip = subs->stream->chip;
+
+	if (subs->direction == SNDRV_PCM_STREAM_CAPTURE)
+		return false;
+	/* disabled via module option? */
+	if (!chip->lowlatency)
+		return false;
+	/* too short periods? */
+	if (subs->data_endpoint->nominal_queue_size >= subs->buffer_bytes)
+		return false;
+	return true;
+}
+
 /*
  * prepare callback
  *
@@ -614,13 +630,8 @@ static int snd_usb_pcm_prepare(struct sn
 	subs->period_elapsed_pending = 0;
 	runtime->delay = 0;
 
-	/* check whether early start is needed for playback stream */
-	subs->early_playback_start =
-		subs->direction == SNDRV_PCM_STREAM_PLAYBACK &&
-		(!chip->lowlatency ||
-		 (subs->data_endpoint->nominal_queue_size >= subs->buffer_bytes));
-
-	if (subs->early_playback_start)
+	subs->lowlatency_playback = lowlatency_playback_available(subs);
+	if (!subs->lowlatency_playback)
 		ret = start_endpoints(subs);
 
  unlock:
@@ -1412,7 +1423,7 @@ static void prepare_playback_urb(struct
 		subs->trigger_tstamp_pending_update = false;
 	}
 
-	if (period_elapsed && !subs->running && !subs->early_playback_start) {
+	if (period_elapsed && !subs->running && subs->lowlatency_playback) {
 		subs->period_elapsed_pending = 1;
 		period_elapsed = 0;
 	}
@@ -1466,7 +1477,7 @@ static int snd_usb_substream_playback_tr
 					      prepare_playback_urb,
 					      retire_playback_urb,
 					      subs);
-		if (!subs->early_playback_start &&
+		if (subs->lowlatency_playback &&
 		    cmd == SNDRV_PCM_TRIGGER_START) {
 			err = start_endpoints(subs);
 			if (err < 0) {


