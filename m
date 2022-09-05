Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E868C5ACFE7
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbiIEKQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237662AbiIEKP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:15:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F51558D1;
        Mon,  5 Sep 2022 03:14:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 333B5B80F9F;
        Mon,  5 Sep 2022 10:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30264C433D6;
        Mon,  5 Sep 2022 10:14:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SZvuZopv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662372851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UO/uIGz46h4XuIh+JAdYBh0EejT1+cIt+fJ9H+yuVxo=;
        b=SZvuZopvi3gMMCdwskYBHmixh+8f8fR66hOVYX/QcJlGDoO4iIbPQmhtOV03x+FBH6JUNt
        2nhiCNUji1jOV//KaZ34G+4pvOHn+QKeD6+dfcCaQpAATz5aa6Oaklsvt7r2eiyWcVd8gO
        +jYN2ZEcObpI1MWgVDAr8VtGmKBqY/w=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c5c2d679 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 5 Sep 2022 10:14:11 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        =?UTF-8?q?Nikl=C4=81vs=20Ko=C4=BCes=C5=86ikovs?= 
        <89q1r14hd@relay.firefox.com>, Wim Taymans <wtaymans@redhat.com>
Subject: [PATCH] ALSA: usb-audio: Don't refcount multiple accesses on the single clock
Date:   Mon,  5 Sep 2022 12:14:03 +0200
Message-Id: <20220905101403.1435037-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 03a8b0df757f1beb21ba1626e23ca7412e48b525.
This reverts commit c11117b634f4f832c4420d3cf41c44227f140ce1.

Pipewire and PulseAudio start devices with 44.1khz before changing them
to 48khz (or something different). By locking the rate, daemons are
unable to enumerate possible rates, and so they never change them to a
more optimal rate. This revert patch should allow 48khz audio again.

Fixes: c11117b634f4 ("ALSA: usb-audio: Refcount multiple accesses on the single clock")
Cc: stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Niklāvs Koļesņikovs <89q1r14hd@relay.firefox.com>
Cc: Wim Taymans <wtaymans@redhat.com>
Link: https://lore.kernel.org/all/YxXIWv8dYmg1tnXP@zx2c4.com/
Link: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/2620
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 sound/usb/card.c     |  1 -
 sound/usb/card.h     |  3 +-
 sound/usb/endpoint.c | 90 +++++---------------------------------------
 sound/usb/usbaudio.h |  1 -
 4 files changed, 10 insertions(+), 85 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index d356743de2ff..12bca2e85505 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -643,7 +643,6 @@ static int snd_usb_audio_create(struct usb_interface *intf,
 	INIT_LIST_HEAD(&chip->pcm_list);
 	INIT_LIST_HEAD(&chip->ep_list);
 	INIT_LIST_HEAD(&chip->iface_ref_list);
-	INIT_LIST_HEAD(&chip->clock_ref_list);
 	INIT_LIST_HEAD(&chip->midi_list);
 	INIT_LIST_HEAD(&chip->mixer_list);
 
diff --git a/sound/usb/card.h b/sound/usb/card.h
index ca75f2206170..87f042d06ce0 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -44,7 +44,6 @@ struct audioformat {
 
 struct snd_usb_substream;
 struct snd_usb_iface_ref;
-struct snd_usb_clock_ref;
 struct snd_usb_endpoint;
 struct snd_usb_power_domain;
 
@@ -63,7 +62,6 @@ struct snd_urb_ctx {
 struct snd_usb_endpoint {
 	struct snd_usb_audio *chip;
 	struct snd_usb_iface_ref *iface_ref;
-	struct snd_usb_clock_ref *clock_ref;
 
 	int opened;		/* open refcount; protect with chip->mutex */
 	atomic_t running;	/* running status */
@@ -140,6 +138,7 @@ struct snd_usb_endpoint {
 	unsigned int cur_period_frames;
 	unsigned int cur_period_bytes;
 	unsigned int cur_buffer_periods;
+	unsigned char cur_clock;
 
 	spinlock_t lock;
 	struct list_head list;
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 0d7b73bf7945..0f5e9224a799 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -35,14 +35,6 @@ struct snd_usb_iface_ref {
 	struct list_head list;
 };
 
-/* clock refcounting */
-struct snd_usb_clock_ref {
-	unsigned char clock;
-	atomic_t locked;
-	int rate;
-	struct list_head list;
-};
-
 /*
  * snd_usb_endpoint is a model that abstracts everything related to an
  * USB endpoint and its streaming.
@@ -599,25 +591,6 @@ iface_ref_find(struct snd_usb_audio *chip, int iface)
 	return ip;
 }
 
-/* Similarly, a refcount object for clock */
-static struct snd_usb_clock_ref *
-clock_ref_find(struct snd_usb_audio *chip, int clock)
-{
-	struct snd_usb_clock_ref *ref;
-
-	list_for_each_entry(ref, &chip->clock_ref_list, list)
-		if (ref->clock == clock)
-			return ref;
-
-	ref = kzalloc(sizeof(*ref), GFP_KERNEL);
-	if (!ref)
-		return NULL;
-	ref->clock = clock;
-	atomic_set(&ref->locked, 0);
-	list_add_tail(&ref->list, &chip->clock_ref_list);
-	return ref;
-}
-
 /*
  * Get the existing endpoint object corresponding EP
  * Returns NULL if not present.
@@ -795,14 +768,6 @@ snd_usb_endpoint_open(struct snd_usb_audio *chip,
 			goto unlock;
 		}
 
-		if (fp->protocol != UAC_VERSION_1) {
-			ep->clock_ref = clock_ref_find(chip, fp->clock);
-			if (!ep->clock_ref) {
-				ep = NULL;
-				goto unlock;
-			}
-		}
-
 		ep->cur_audiofmt = fp;
 		ep->cur_channels = fp->channels;
 		ep->cur_rate = params_rate(params);
@@ -812,6 +777,7 @@ snd_usb_endpoint_open(struct snd_usb_audio *chip,
 		ep->cur_period_frames = params_period_size(params);
 		ep->cur_period_bytes = ep->cur_period_frames * ep->cur_frame_bytes;
 		ep->cur_buffer_periods = params_periods(params);
+		ep->cur_clock = fp->clock;
 
 		if (ep->type == SND_USB_ENDPOINT_TYPE_SYNC)
 			endpoint_set_syncinterval(chip, ep);
@@ -928,8 +894,8 @@ void snd_usb_endpoint_close(struct snd_usb_audio *chip,
 		ep->altsetting = 0;
 		ep->cur_audiofmt = NULL;
 		ep->cur_rate = 0;
+		ep->cur_clock = 0;
 		ep->iface_ref = NULL;
-		ep->clock_ref = NULL;
 		usb_audio_dbg(chip, "EP 0x%x closed\n", ep->ep_num);
 	}
 	mutex_unlock(&chip->mutex);
@@ -941,8 +907,6 @@ void snd_usb_endpoint_suspend(struct snd_usb_endpoint *ep)
 	ep->need_setup = true;
 	if (ep->iface_ref)
 		ep->iface_ref->need_setup = true;
-	if (ep->clock_ref)
-		ep->clock_ref->rate = 0;
 }
 
 /*
@@ -1350,33 +1314,6 @@ static int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
 	return 0;
 }
 
-static int init_sample_rate(struct snd_usb_audio *chip,
-			    struct snd_usb_endpoint *ep)
-{
-	struct snd_usb_clock_ref *clock = ep->clock_ref;
-	int err;
-
-	if (clock) {
-		if (atomic_read(&clock->locked))
-			return 0;
-		if (clock->rate == ep->cur_rate)
-			return 0;
-		if (clock->rate && clock->rate != ep->cur_rate) {
-			usb_audio_dbg(chip, "Mismatched sample rate %d vs %d for EP 0x%x\n",
-				      clock->rate, ep->cur_rate, ep->ep_num);
-			return -EINVAL;
-		}
-	}
-
-	err = snd_usb_init_sample_rate(chip, ep->cur_audiofmt, ep->cur_rate);
-	if (err < 0)
-		return err;
-
-	if (clock)
-		clock->rate = ep->cur_rate;
-	return 0;
-}
-
 /*
  * snd_usb_endpoint_configure: Configure the endpoint
  *
@@ -1406,7 +1343,8 @@ int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
 		 * to update at each EP configuration
 		 */
 		if (ep->cur_audiofmt->protocol == UAC_VERSION_1) {
-			err = init_sample_rate(chip, ep);
+			err = snd_usb_init_sample_rate(chip, ep->cur_audiofmt,
+						       ep->cur_rate);
 			if (err < 0)
 				goto unlock;
 		}
@@ -1436,7 +1374,7 @@ int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
 	if (err < 0)
 		goto unlock;
 
-	err = init_sample_rate(chip, ep);
+	err = snd_usb_init_sample_rate(chip, ep->cur_audiofmt, ep->cur_rate);
 	if (err < 0)
 		goto unlock;
 
@@ -1469,15 +1407,15 @@ int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
 /* get the current rate set to the given clock by any endpoint */
 int snd_usb_endpoint_get_clock_rate(struct snd_usb_audio *chip, int clock)
 {
-	struct snd_usb_clock_ref *ref;
+	struct snd_usb_endpoint *ep;
 	int rate = 0;
 
 	if (!clock)
 		return 0;
 	mutex_lock(&chip->mutex);
-	list_for_each_entry(ref, &chip->clock_ref_list, list) {
-		if (ref->clock == clock) {
-			rate = ref->rate;
+	list_for_each_entry(ep, &chip->ep_list, list) {
+		if (ep->cur_clock == clock && ep->cur_rate) {
+			rate = ep->cur_rate;
 			break;
 		}
 	}
@@ -1518,9 +1456,6 @@ int snd_usb_endpoint_start(struct snd_usb_endpoint *ep)
 	if (atomic_inc_return(&ep->running) != 1)
 		return 0;
 
-	if (ep->clock_ref)
-		atomic_inc(&ep->clock_ref->locked);
-
 	ep->active_mask = 0;
 	ep->unlink_mask = 0;
 	ep->phase = 0;
@@ -1630,9 +1565,6 @@ void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep, bool keep_pending)
 		if (ep->sync_source)
 			WRITE_ONCE(ep->sync_source->sync_sink, NULL);
 		stop_urbs(ep, false, keep_pending);
-		if (ep->clock_ref)
-			if (!atomic_dec_return(&ep->clock_ref->locked))
-				ep->clock_ref->rate = 0;
 	}
 }
 
@@ -1659,16 +1591,12 @@ void snd_usb_endpoint_free_all(struct snd_usb_audio *chip)
 {
 	struct snd_usb_endpoint *ep, *en;
 	struct snd_usb_iface_ref *ip, *in;
-	struct snd_usb_clock_ref *cp, *cn;
 
 	list_for_each_entry_safe(ep, en, &chip->ep_list, list)
 		kfree(ep);
 
 	list_for_each_entry_safe(ip, in, &chip->iface_ref_list, list)
 		kfree(ip);
-
-	list_for_each_entry_safe(cp, cn, &chip->clock_ref_list, list)
-		kfree(cp);
 }
 
 /*
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index ffbb4b0d09a0..044cd7ab27cb 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -45,7 +45,6 @@ struct snd_usb_audio {
 	struct list_head pcm_list;	/* list of pcm streams */
 	struct list_head ep_list;	/* list of audio-related endpoints */
 	struct list_head iface_ref_list; /* list of interface refcounts */
-	struct list_head clock_ref_list; /* list of clock refcounts */
 	int pcm_devs;
 
 	struct list_head midi_list;	/* list of midi interfaces */
-- 
2.37.3

