Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A8B1FE466
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgFRBTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730193AbgFRBTo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:19:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A2F21D90;
        Thu, 18 Jun 2020 01:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443183;
        bh=a5pDMc14w/TcwDYckXhJRYFVJx/0LAUFdG2XZNCys74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udCU7FRBUE86UNDU8itVOn8UjcIUeckypLTlZDlgazT3qbN6y4TSo6Kaz00T736wx
         pqzz0KjUTkduT1C9z2RhknLsaG/KhitpBzD+ZntEeOYIjPklwIJ/asj3Bj9N9uOow1
         oA27nN30SNOau6nOODyXDnvSC2Zm20D5RQzt/cyI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erwin Burema <e.burema@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 145/266] ALSA: usb-audio: Add duplex sound support for USB devices using implicit feedback
Date:   Wed, 17 Jun 2020 21:14:30 -0400
Message-Id: <20200618011631.604574-145-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwin Burema <e.burema@gmail.com>

[ Upstream commit 10ce77e4817fef99e1166be7e6685a80c63bf77f ]

For USB sound devices using implicit feedback the endpoint used for
this feedback should be able to be opened twice, once for required
feedback and second time for audio data. This way these devices can be
put in duplex audio mode. Since this only works if the settings of the
endpoint don't change a check is included for this.

This fixes bug 207023 ("MOTU M2 regression on duplex audio") and
should also fix bug 103751 ("M-Audio Fast Track Ultra usb audio device
will not operate full-duplex")

Fixes: c249177944b6 ("ALSA: usb-audio: add implicit fb quirk for MOTU M Series")
Signed-off-by: Erwin Burema <e.burema@gmail.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207023
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=103751
Link: https://lore.kernel.org/r/2410739.SCZni40SNb@alpha-wolf
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.h     |   1 +
 sound/usb/endpoint.c | 195 ++++++++++++++++++++++++++++++++++++++++++-
 sound/usb/pcm.c      |   5 ++
 3 files changed, 197 insertions(+), 4 deletions(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index 820e564656ed..d6219fba9699 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -108,6 +108,7 @@ struct snd_usb_endpoint {
 	int iface, altsetting;
 	int skip_packets;		/* quirks for devices to ignore the first n packets
 					   in a stream */
+	bool is_implicit_feedback;      /* This endpoint is used as implicit feedback */
 
 	spinlock_t lock;
 	struct list_head list;
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 50104f658ed4..9bea7d3f99f8 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -522,6 +522,8 @@ struct snd_usb_endpoint *snd_usb_add_endpoint(struct snd_usb_audio *chip,
 
 	list_add_tail(&ep->list, &chip->ep_list);
 
+	ep->is_implicit_feedback = 0;
+
 __exit_unlock:
 	mutex_unlock(&chip->mutex);
 
@@ -621,6 +623,178 @@ static void release_urbs(struct snd_usb_endpoint *ep, int force)
 	ep->nurbs = 0;
 }
 
+/*
+ * Check data endpoint for format differences
+ */
+static bool check_ep_params(struct snd_usb_endpoint *ep,
+			      snd_pcm_format_t pcm_format,
+			      unsigned int channels,
+			      unsigned int period_bytes,
+			      unsigned int frames_per_period,
+			      unsigned int periods_per_buffer,
+			      struct audioformat *fmt,
+			      struct snd_usb_endpoint *sync_ep)
+{
+	unsigned int maxsize, minsize, packs_per_ms, max_packs_per_urb;
+	unsigned int max_packs_per_period, urbs_per_period, urb_packs;
+	unsigned int max_urbs;
+	int frame_bits = snd_pcm_format_physical_width(pcm_format) * channels;
+	int tx_length_quirk = (ep->chip->tx_length_quirk &&
+			       usb_pipeout(ep->pipe));
+	bool ret = 1;
+
+	if (pcm_format == SNDRV_PCM_FORMAT_DSD_U16_LE && fmt->dsd_dop) {
+		/*
+		 * When operating in DSD DOP mode, the size of a sample frame
+		 * in hardware differs from the actual physical format width
+		 * because we need to make room for the DOP markers.
+		 */
+		frame_bits += channels << 3;
+	}
+
+	ret = ret && (ep->datainterval == fmt->datainterval);
+	ret = ret && (ep->stride == frame_bits >> 3);
+
+	switch (pcm_format) {
+	case SNDRV_PCM_FORMAT_U8:
+		ret = ret && (ep->silence_value == 0x80);
+		break;
+	case SNDRV_PCM_FORMAT_DSD_U8:
+	case SNDRV_PCM_FORMAT_DSD_U16_LE:
+	case SNDRV_PCM_FORMAT_DSD_U32_LE:
+	case SNDRV_PCM_FORMAT_DSD_U16_BE:
+	case SNDRV_PCM_FORMAT_DSD_U32_BE:
+		ret = ret && (ep->silence_value == 0x69);
+		break;
+	default:
+		ret = ret && (ep->silence_value == 0);
+	}
+
+	/* assume max. frequency is 50% higher than nominal */
+	ret = ret && (ep->freqmax == ep->freqn + (ep->freqn >> 1));
+	/* Round up freqmax to nearest integer in order to calculate maximum
+	 * packet size, which must represent a whole number of frames.
+	 * This is accomplished by adding 0x0.ffff before converting the
+	 * Q16.16 format into integer.
+	 * In order to accurately calculate the maximum packet size when
+	 * the data interval is more than 1 (i.e. ep->datainterval > 0),
+	 * multiply by the data interval prior to rounding. For instance,
+	 * a freqmax of 41 kHz will result in a max packet size of 6 (5.125)
+	 * frames with a data interval of 1, but 11 (10.25) frames with a
+	 * data interval of 2.
+	 * (ep->freqmax << ep->datainterval overflows at 8.192 MHz for the
+	 * maximum datainterval value of 3, at USB full speed, higher for
+	 * USB high speed, noting that ep->freqmax is in units of
+	 * frames per packet in Q16.16 format.)
+	 */
+	maxsize = (((ep->freqmax << ep->datainterval) + 0xffff) >> 16) *
+			 (frame_bits >> 3);
+	if (tx_length_quirk)
+		maxsize += sizeof(__le32); /* Space for length descriptor */
+	/* but wMaxPacketSize might reduce this */
+	if (ep->maxpacksize && ep->maxpacksize < maxsize) {
+		/* whatever fits into a max. size packet */
+		unsigned int data_maxsize = maxsize = ep->maxpacksize;
+
+		if (tx_length_quirk)
+			/* Need to remove the length descriptor to calc freq */
+			data_maxsize -= sizeof(__le32);
+		ret = ret && (ep->freqmax == (data_maxsize / (frame_bits >> 3))
+				<< (16 - ep->datainterval));
+	}
+
+	if (ep->fill_max)
+		ret = ret && (ep->curpacksize == ep->maxpacksize);
+	else
+		ret = ret && (ep->curpacksize == maxsize);
+
+	if (snd_usb_get_speed(ep->chip->dev) != USB_SPEED_FULL) {
+		packs_per_ms = 8 >> ep->datainterval;
+		max_packs_per_urb = MAX_PACKS_HS;
+	} else {
+		packs_per_ms = 1;
+		max_packs_per_urb = MAX_PACKS;
+	}
+	if (sync_ep && !snd_usb_endpoint_implicit_feedback_sink(ep))
+		max_packs_per_urb = min(max_packs_per_urb,
+					1U << sync_ep->syncinterval);
+	max_packs_per_urb = max(1u, max_packs_per_urb >> ep->datainterval);
+
+	/*
+	 * Capture endpoints need to use small URBs because there's no way
+	 * to tell in advance where the next period will end, and we don't
+	 * want the next URB to complete much after the period ends.
+	 *
+	 * Playback endpoints with implicit sync much use the same parameters
+	 * as their corresponding capture endpoint.
+	 */
+	if (usb_pipein(ep->pipe) ||
+			snd_usb_endpoint_implicit_feedback_sink(ep)) {
+
+		urb_packs = packs_per_ms;
+		/*
+		 * Wireless devices can poll at a max rate of once per 4ms.
+		 * For dataintervals less than 5, increase the packet count to
+		 * allow the host controller to use bursting to fill in the
+		 * gaps.
+		 */
+		if (snd_usb_get_speed(ep->chip->dev) == USB_SPEED_WIRELESS) {
+			int interval = ep->datainterval;
+
+			while (interval < 5) {
+				urb_packs <<= 1;
+				++interval;
+			}
+		}
+		/* make capture URBs <= 1 ms and smaller than a period */
+		urb_packs = min(max_packs_per_urb, urb_packs);
+		while (urb_packs > 1 && urb_packs * maxsize >= period_bytes)
+			urb_packs >>= 1;
+		ret = ret && (ep->nurbs == MAX_URBS);
+
+	/*
+	 * Playback endpoints without implicit sync are adjusted so that
+	 * a period fits as evenly as possible in the smallest number of
+	 * URBs.  The total number of URBs is adjusted to the size of the
+	 * ALSA buffer, subject to the MAX_URBS and MAX_QUEUE limits.
+	 */
+	} else {
+		/* determine how small a packet can be */
+		minsize = (ep->freqn >> (16 - ep->datainterval)) *
+				(frame_bits >> 3);
+		/* with sync from device, assume it can be 12% lower */
+		if (sync_ep)
+			minsize -= minsize >> 3;
+		minsize = max(minsize, 1u);
+
+		/* how many packets will contain an entire ALSA period? */
+		max_packs_per_period = DIV_ROUND_UP(period_bytes, minsize);
+
+		/* how many URBs will contain a period? */
+		urbs_per_period = DIV_ROUND_UP(max_packs_per_period,
+				max_packs_per_urb);
+		/* how many packets are needed in each URB? */
+		urb_packs = DIV_ROUND_UP(max_packs_per_period, urbs_per_period);
+
+		/* limit the number of frames in a single URB */
+		ret = ret && (ep->max_urb_frames ==
+			DIV_ROUND_UP(frames_per_period, urbs_per_period));
+
+		/* try to use enough URBs to contain an entire ALSA buffer */
+		max_urbs = min((unsigned) MAX_URBS,
+				MAX_QUEUE * packs_per_ms / urb_packs);
+		ret = ret && (ep->nurbs == min(max_urbs,
+				urbs_per_period * periods_per_buffer));
+	}
+
+	ret = ret && (ep->datainterval == fmt->datainterval);
+	ret = ret && (ep->maxpacksize == fmt->maxpacksize);
+	ret = ret &&
+		(ep->fill_max == !!(fmt->attributes & UAC_EP_CS_ATTR_FILL_MAX));
+
+	return ret;
+}
+
 /*
  * configure a data endpoint
  */
@@ -886,10 +1060,23 @@ int snd_usb_endpoint_set_params(struct snd_usb_endpoint *ep,
 	int err;
 
 	if (ep->use_count != 0) {
-		usb_audio_warn(ep->chip,
-			 "Unable to change format on ep #%x: already in use\n",
-			 ep->ep_num);
-		return -EBUSY;
+		bool check = ep->is_implicit_feedback &&
+			check_ep_params(ep, pcm_format,
+					     channels, period_bytes,
+					     period_frames, buffer_periods,
+					     fmt, sync_ep);
+
+		if (!check) {
+			usb_audio_warn(ep->chip,
+				"Unable to change format on ep #%x: already in use\n",
+				ep->ep_num);
+			return -EBUSY;
+		}
+
+		usb_audio_dbg(ep->chip,
+			      "Ep #%x already in use as implicit feedback but format not changed\n",
+			      ep->ep_num);
+		return 0;
 	}
 
 	/* release old buffers, if any */
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index e52d129085c0..6c391e5fad2a 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -386,6 +386,8 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb_substream *subs,
 	if (!subs->sync_endpoint)
 		return -EINVAL;
 
+	subs->sync_endpoint->is_implicit_feedback = 1;
+
 	subs->data_endpoint->sync_master = subs->sync_endpoint;
 
 	return 1;
@@ -484,12 +486,15 @@ static int set_sync_endpoint(struct snd_usb_substream *subs,
 						   implicit_fb ?
 							SND_USB_ENDPOINT_TYPE_DATA :
 							SND_USB_ENDPOINT_TYPE_SYNC);
+
 	if (!subs->sync_endpoint) {
 		if (is_playback && attr == USB_ENDPOINT_SYNC_NONE)
 			return 0;
 		return -EINVAL;
 	}
 
+	subs->sync_endpoint->is_implicit_feedback = implicit_fb;
+
 	subs->data_endpoint->sync_master = subs->sync_endpoint;
 
 	return 0;
-- 
2.25.1

