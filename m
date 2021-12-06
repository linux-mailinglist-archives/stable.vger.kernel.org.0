Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCF7469D3E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359794AbhLFP2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55328 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358407AbhLFPY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE9FCB81129;
        Mon,  6 Dec 2021 15:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22128C341C2;
        Mon,  6 Dec 2021 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804049;
        bh=bb8VV4UOkcXQ2S3DG58Wji7Kw+ufngEyp62kV9aSHo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmXOaPbaBQha8pnkDeNwNPmToMRsLXzZuWFzN9qkiatXPE+gs53JrYahiMukVs6eR
         r5t/hyLauF5sl+S26h3slRyZLqLugoAJfyISZr8cLLWrhXbntf3TPNFU8wU1V/mU28
         WnR8/+YUv2t9WhWHM1lK2IzA1OF6OntvF2FXW2dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 001/207] ALSA: usb-audio: Restrict rates for the shared clocks
Date:   Mon,  6 Dec 2021 15:54:15 +0100
Message-Id: <20211206145610.228600778@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 4e7cf1fbb34ecb472c073980458cbe413afd4d64 upstream.

When a single clock source is shared among several endpoints, we have
to keep the same rate on all active endpoints as long as the clock is
being used.  For dealing with such a case, this patch adds one more
check in the hw params constraint for the rate to take the shared
clocks into account.  The current rate is evaluated from the endpoint
list that applies the same clock source.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1190418
Link: https://lore.kernel.org/r/20210929080844.11583-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.h     |    1 +
 sound/usb/endpoint.c |   21 +++++++++++++++++++++
 sound/usb/endpoint.h |    1 +
 sound/usb/pcm.c      |    9 +++++++++
 4 files changed, 32 insertions(+)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -137,6 +137,7 @@ struct snd_usb_endpoint {
 	unsigned int cur_period_frames;
 	unsigned int cur_period_bytes;
 	unsigned int cur_buffer_periods;
+	unsigned char cur_clock;
 
 	spinlock_t lock;
 	struct list_head list;
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -726,6 +726,7 @@ snd_usb_endpoint_open(struct snd_usb_aud
 		ep->cur_period_frames = params_period_size(params);
 		ep->cur_period_bytes = ep->cur_period_frames * ep->cur_frame_bytes;
 		ep->cur_buffer_periods = params_periods(params);
+		ep->cur_clock = fp->clock;
 
 		if (ep->type == SND_USB_ENDPOINT_TYPE_SYNC)
 			endpoint_set_syncinterval(chip, ep);
@@ -837,6 +838,7 @@ void snd_usb_endpoint_close(struct snd_u
 		ep->altsetting = 0;
 		ep->cur_audiofmt = NULL;
 		ep->cur_rate = 0;
+		ep->cur_clock = 0;
 		ep->iface_ref = NULL;
 		usb_audio_dbg(chip, "EP 0x%x closed\n", ep->ep_num);
 	}
@@ -1344,6 +1346,25 @@ unlock:
 	return err;
 }
 
+/* get the current rate set to the given clock by any endpoint */
+int snd_usb_endpoint_get_clock_rate(struct snd_usb_audio *chip, int clock)
+{
+	struct snd_usb_endpoint *ep;
+	int rate = 0;
+
+	if (!clock)
+		return 0;
+	mutex_lock(&chip->mutex);
+	list_for_each_entry(ep, &chip->ep_list, list) {
+		if (ep->cur_clock == clock && ep->cur_rate) {
+			rate = ep->cur_rate;
+			break;
+		}
+	}
+	mutex_unlock(&chip->mutex);
+	return rate;
+}
+
 /**
  * snd_usb_endpoint_start: start an snd_usb_endpoint
  *
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -19,6 +19,7 @@ void snd_usb_endpoint_close(struct snd_u
 			    struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
 			       struct snd_usb_endpoint *ep);
+int snd_usb_endpoint_get_clock_rate(struct snd_usb_audio *chip, int clock);
 
 bool snd_usb_endpoint_compatible(struct snd_usb_audio *chip,
 				 struct snd_usb_endpoint *ep,
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -734,6 +734,7 @@ static int hw_rule_rate(struct snd_pcm_h
 			struct snd_pcm_hw_rule *rule)
 {
 	struct snd_usb_substream *subs = rule->private;
+	struct snd_usb_audio *chip = subs->stream->chip;
 	const struct audioformat *fp;
 	struct snd_interval *it = hw_param_interval(params, SNDRV_PCM_HW_PARAM_RATE);
 	unsigned int rmin, rmax, r;
@@ -745,6 +746,14 @@ static int hw_rule_rate(struct snd_pcm_h
 	list_for_each_entry(fp, &subs->fmt_list, list) {
 		if (!hw_check_valid_format(subs, params, fp))
 			continue;
+		r = snd_usb_endpoint_get_clock_rate(chip, fp->clock);
+		if (r > 0) {
+			if (!snd_interval_test(it, r))
+				continue;
+			rmin = min(rmin, r);
+			rmax = max(rmax, r);
+			continue;
+		}
 		if (fp->rate_table && fp->nr_rates) {
 			for (i = 0; i < fp->nr_rates; i++) {
 				r = fp->rate_table[i];


