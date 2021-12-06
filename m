Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2270D469D56
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378287AbhLFP3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43224 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385664AbhLFPZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:25:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C430C612EB;
        Mon,  6 Dec 2021 15:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D50C341C1;
        Mon,  6 Dec 2021 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804125;
        bh=sOjh7qNKcpi7EOwiCOWMa8U8UyAgKJLZIem88OhWlb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M96x3/C9uGuhm+EO+Kbu1KO81R3E10bg8JyIZeZXUWBN0UlB7sQ8ikBeSiqLkgwl9
         OR6nKJIi2qn/h5k2NGZcVGRwX+7ROYVOxQk0HhialoHg2UsqQCsYmJtAVnxDAW+Uah
         yMrEdnwWYVmpMMTmMpaL68cDQcx0izE/XVaxaxZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 008/207] ALSA: usb-audio: Avoid killing in-flight URBs during draining
Date:   Mon,  6 Dec 2021 15:54:22 +0100
Message-Id: <20211206145610.470336808@linuxfoundation.org>
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

commit 813a17cab9b708bbb1e0db8902e19857b57196ec upstream.

While draining a stream, ALSA PCM core stops the stream by issuing
snd_pcm_stop() after all data has been sent out.  And, at PCM trigger
stop, currently USB-audio driver kills the in-flight URBs explicitly,
then at sync-stop ops, sync with the finish of all remaining URBs.
This might result in a drop of the drained samples as most of
USB-audio devices / hosts allow relatively long in-flight samples (as
a sort of FIFO).

For avoiding the trimming, this patch changes the stream-stop behavior
during PCM draining state.  Under that condition, the pending URBs
won't be killed.  The leftover in-flight URBs are caught by the
sync-stop operation that shall be performed after the trigger-stop
operation.

Link: https://lore.kernel.org/r/20210929080844.11583-10-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |   14 +++++++++-----
 sound/usb/endpoint.h |    2 +-
 sound/usb/pcm.c      |   16 ++++++++--------
 3 files changed, 18 insertions(+), 14 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -955,7 +955,7 @@ void snd_usb_endpoint_sync_pending_stop(
  *
  * This function moves the EP to STOPPING state if it's being RUNNING.
  */
-static int stop_urbs(struct snd_usb_endpoint *ep, bool force)
+static int stop_urbs(struct snd_usb_endpoint *ep, bool force, bool keep_pending)
 {
 	unsigned int i;
 	unsigned long flags;
@@ -972,6 +972,9 @@ static int stop_urbs(struct snd_usb_endp
 	ep->next_packet_queued = 0;
 	spin_unlock_irqrestore(&ep->lock, flags);
 
+	if (keep_pending)
+		return 0;
+
 	for (i = 0; i < ep->nurbs; i++) {
 		if (test_bit(i, &ep->active_mask)) {
 			if (!test_and_set_bit(i, &ep->unlink_mask)) {
@@ -995,7 +998,7 @@ static int release_urbs(struct snd_usb_e
 	snd_usb_endpoint_set_callback(ep, NULL, NULL, NULL);
 
 	/* stop and unlink urbs */
-	err = stop_urbs(ep, force);
+	err = stop_urbs(ep, force, false);
 	if (err)
 		return err;
 
@@ -1527,7 +1530,7 @@ int snd_usb_endpoint_start(struct snd_us
 	return 0;
 
 __error:
-	snd_usb_endpoint_stop(ep);
+	snd_usb_endpoint_stop(ep, false);
 	return -EPIPE;
 }
 
@@ -1535,6 +1538,7 @@ __error:
  * snd_usb_endpoint_stop: stop an snd_usb_endpoint
  *
  * @ep: the endpoint to stop (may be NULL)
+ * @keep_pending: keep in-flight URBs
  *
  * A call to this function will decrement the running count of the endpoint.
  * In case the last user has requested the endpoint stop, the URBs will
@@ -1545,7 +1549,7 @@ __error:
  * The caller needs to synchronize the pending stop operation via
  * snd_usb_endpoint_sync_pending_stop().
  */
-void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep)
+void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep, bool keep_pending)
 {
 	if (!ep)
 		return;
@@ -1560,7 +1564,7 @@ void snd_usb_endpoint_stop(struct snd_us
 	if (!atomic_dec_return(&ep->running)) {
 		if (ep->sync_source)
 			WRITE_ONCE(ep->sync_source->sync_sink, NULL);
-		stop_urbs(ep, false);
+		stop_urbs(ep, false, keep_pending);
 	}
 }
 
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -38,7 +38,7 @@ void snd_usb_endpoint_set_callback(struc
 				   struct snd_usb_substream *data_subs);
 
 int snd_usb_endpoint_start(struct snd_usb_endpoint *ep);
-void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep);
+void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep, bool keep_pending);
 void snd_usb_endpoint_sync_pending_stop(struct snd_usb_endpoint *ep);
 void snd_usb_endpoint_suspend(struct snd_usb_endpoint *ep);
 int  snd_usb_endpoint_activate(struct snd_usb_endpoint *ep);
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -219,16 +219,16 @@ int snd_usb_init_pitch(struct snd_usb_au
 	return 0;
 }
 
-static bool stop_endpoints(struct snd_usb_substream *subs)
+static bool stop_endpoints(struct snd_usb_substream *subs, bool keep_pending)
 {
 	bool stopped = 0;
 
 	if (test_and_clear_bit(SUBSTREAM_FLAG_SYNC_EP_STARTED, &subs->flags)) {
-		snd_usb_endpoint_stop(subs->sync_endpoint);
+		snd_usb_endpoint_stop(subs->sync_endpoint, keep_pending);
 		stopped = true;
 	}
 	if (test_and_clear_bit(SUBSTREAM_FLAG_DATA_EP_STARTED, &subs->flags)) {
-		snd_usb_endpoint_stop(subs->data_endpoint);
+		snd_usb_endpoint_stop(subs->data_endpoint, keep_pending);
 		stopped = true;
 	}
 	return stopped;
@@ -261,7 +261,7 @@ static int start_endpoints(struct snd_us
 	return 0;
 
  error:
-	stop_endpoints(subs);
+	stop_endpoints(subs, false);
 	return err;
 }
 
@@ -437,7 +437,7 @@ static int configure_endpoints(struct sn
 
 	if (subs->data_endpoint->need_setup) {
 		/* stop any running stream beforehand */
-		if (stop_endpoints(subs))
+		if (stop_endpoints(subs, false))
 			sync_pending_stops(subs);
 		err = snd_usb_endpoint_configure(chip, subs->data_endpoint);
 		if (err < 0)
@@ -572,7 +572,7 @@ static int snd_usb_hw_free(struct snd_pc
 	subs->cur_audiofmt = NULL;
 	mutex_unlock(&chip->mutex);
 	if (!snd_usb_lock_shutdown(chip)) {
-		if (stop_endpoints(subs))
+		if (stop_endpoints(subs, false))
 			sync_pending_stops(subs);
 		close_endpoints(chip, subs);
 		snd_usb_unlock_shutdown(chip);
@@ -1559,7 +1559,7 @@ static int snd_usb_substream_playback_tr
 		return 0;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_STOP:
-		stop_endpoints(subs);
+		stop_endpoints(subs, substream->runtime->status->state == SNDRV_PCM_STATE_DRAINING);
 		snd_usb_endpoint_set_callback(subs->data_endpoint,
 					      NULL, NULL, NULL);
 		subs->running = 0;
@@ -1607,7 +1607,7 @@ static int snd_usb_substream_capture_tri
 		return 0;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_STOP:
-		stop_endpoints(subs);
+		stop_endpoints(subs, false);
 		fallthrough;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		snd_usb_endpoint_set_callback(subs->data_endpoint,


