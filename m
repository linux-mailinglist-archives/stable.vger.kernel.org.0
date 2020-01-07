Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0651133485
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgAGU6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgAGU6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96FD921744;
        Tue,  7 Jan 2020 20:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430720;
        bh=X2T1xFRrwFRlw1ojEn4t8926BuDm9pmQVOKq6aHedYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoaOlbVsjGO5Y50jxwdIXeJYBvUwxug/Wr96ptK1FW/tSQhh1ejcn/b6BVZxccTus
         Xx/SDCz0uqf/xbWyEj6JMFyJiUZhByc372pVONqvsxwUqbZzd66zNClpVInYoZ19B3
         oO02VKQ45gkp1T9PssxsDKb4H8RhRIwQRhK7A/FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 068/191] ALSA: usb-audio: set the interface format after resume on Dell WD19
Date:   Tue,  7 Jan 2020 21:53:08 +0100
Message-Id: <20200107205336.629523055@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 92adc96f8eecd9522a907c197cc3d62e405539fe upstream.

Recently we found the headset-mic on the Dell Dock WD19 doesn't work
anymore after s3 (s2i or deep), this problem could be workarounded by
closing (pcm_close) the app and then reopening (pcm_open) the app, so
this bug is not easy to be detected by users.

When problem happens, retire_capture_urb() could still be called
periodically, but the size of captured data is always 0, it could be
a firmware bug on the dock. Anyway I found after resuming, the
snd_usb_pcm_prepare() will be called, and if we forcibly run
set_format() to set the interface and its endpoint, the capture
size will be normal again. This problem and workaound also apply to
playback.

To fix it in the kernel, add a quirk to let set_format() run
forcibly once after resume.

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191218132650.6303-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.h         |    1 +
 sound/usb/pcm.c          |   21 +++++++++++++++++++--
 sound/usb/quirks-table.h |    3 ++-
 sound/usb/quirks.c       |   11 +++++++++++
 sound/usb/usbaudio.h     |    3 ++-
 5 files changed, 35 insertions(+), 4 deletions(-)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -145,6 +145,7 @@ struct snd_usb_substream {
 	struct snd_usb_endpoint *sync_endpoint;
 	unsigned long flags;
 	bool need_setup_ep;		/* (re)configure EP at prepare? */
+	bool need_setup_fmt;		/* (re)configure fmt after resume? */
 	unsigned int speed;		/* USB_SPEED_XXX */
 
 	u64 formats;			/* format bitmasks (all or'ed) */
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -510,11 +510,11 @@ static int set_format(struct snd_usb_sub
 		return -EINVAL;
 	altsd = get_iface_desc(alts);
 
-	if (fmt == subs->cur_audiofmt)
+	if (fmt == subs->cur_audiofmt && !subs->need_setup_fmt)
 		return 0;
 
 	/* close the old interface */
-	if (subs->interface >= 0 && subs->interface != fmt->iface) {
+	if (subs->interface >= 0 && (subs->interface != fmt->iface || subs->need_setup_fmt)) {
 		if (!subs->stream->chip->keep_iface) {
 			err = usb_set_interface(subs->dev, subs->interface, 0);
 			if (err < 0) {
@@ -528,6 +528,9 @@ static int set_format(struct snd_usb_sub
 		subs->altset_idx = 0;
 	}
 
+	if (subs->need_setup_fmt)
+		subs->need_setup_fmt = false;
+
 	/* set interface */
 	if (iface->cur_altsetting != alts) {
 		err = snd_usb_select_mode_quirk(subs, fmt);
@@ -1735,6 +1738,13 @@ static int snd_usb_substream_playback_tr
 		subs->data_endpoint->retire_data_urb = retire_playback_urb;
 		subs->running = 0;
 		return 0;
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+		if (subs->stream->chip->setup_fmt_after_resume_quirk) {
+			stop_endpoints(subs, true);
+			subs->need_setup_fmt = true;
+			return 0;
+		}
+		break;
 	}
 
 	return -EINVAL;
@@ -1767,6 +1777,13 @@ static int snd_usb_substream_capture_tri
 		subs->data_endpoint->retire_data_urb = retire_capture_urb;
 		subs->running = 1;
 		return 0;
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+		if (subs->stream->chip->setup_fmt_after_resume_quirk) {
+			stop_endpoints(subs, true);
+			subs->need_setup_fmt = true;
+			return 0;
+		}
+		break;
 	}
 
 	return -EINVAL;
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3466,7 +3466,8 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge
 		.vendor_name = "Dell",
 		.product_name = "WD19 Dock",
 		.profile_name = "Dell-WD15-Dock",
-		.ifnum = QUIRK_NO_INTERFACE
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_SETUP_FMT_AFTER_RESUME
 	}
 },
 /* MOTU Microbook II */
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -508,6 +508,16 @@ static int create_standard_mixer_quirk(s
 	return snd_usb_create_mixer(chip, quirk->ifnum, 0);
 }
 
+
+static int setup_fmt_after_resume_quirk(struct snd_usb_audio *chip,
+				       struct usb_interface *iface,
+				       struct usb_driver *driver,
+				       const struct snd_usb_audio_quirk *quirk)
+{
+	chip->setup_fmt_after_resume_quirk = 1;
+	return 1;	/* Continue with creating streams and mixer */
+}
+
 /*
  * audio-interface quirks
  *
@@ -546,6 +556,7 @@ int snd_usb_create_quirk(struct snd_usb_
 		[QUIRK_AUDIO_EDIROL_UAXX] = create_uaxx_quirk,
 		[QUIRK_AUDIO_ALIGN_TRANSFER] = create_align_transfer_quirk,
 		[QUIRK_AUDIO_STANDARD_MIXER] = create_standard_mixer_quirk,
+		[QUIRK_SETUP_FMT_AFTER_RESUME] = setup_fmt_after_resume_quirk,
 	};
 
 	if (quirk->type < QUIRK_TYPE_COUNT) {
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -33,7 +33,7 @@ struct snd_usb_audio {
 	wait_queue_head_t shutdown_wait;
 	unsigned int txfr_quirk:1; /* Subframe boundaries on transfers */
 	unsigned int tx_length_quirk:1; /* Put length specifier in transfers */
-	
+	unsigned int setup_fmt_after_resume_quirk:1; /* setup the format to interface after resume */
 	int num_interfaces;
 	int num_suspended_intf;
 	int sample_rate_read_error;
@@ -98,6 +98,7 @@ enum quirk_type {
 	QUIRK_AUDIO_EDIROL_UAXX,
 	QUIRK_AUDIO_ALIGN_TRANSFER,
 	QUIRK_AUDIO_STANDARD_MIXER,
+	QUIRK_SETUP_FMT_AFTER_RESUME,
 
 	QUIRK_TYPE_COUNT
 };


