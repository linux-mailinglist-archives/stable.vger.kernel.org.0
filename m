Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A25C4095F9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347010AbhIMOqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347918AbhIMOof (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 544BF6321F;
        Mon, 13 Sep 2021 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541473;
        bh=gkbd6KZwY2GXH6dZuCRcGA3iVHbbJaEbEHDTVkIl0l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gflkU40IG6gnwmBQE5e7Ew7LZ1a5BLxiry4ljCVdvqF/8v5Xp+lFNyZX+Y6BlAn3D
         wsiguaK/ejl2rHILNY9/Psslbh9w2tKrHSxCaaycDm1R/mS2j+pzDqYz9oRMhyUH4J
         80wxwY4uN/gvK8e0NWhzGu1Re419gkieJSjZnAxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 280/334] ALSA: usb-audio: Add lowlatency module option
Date:   Mon, 13 Sep 2021 15:15:34 +0200
Message-Id: <20210913131122.894905589@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4801bee7d5a36c199b734a28cde5259183aff822 ]

For making user to switch back to the old playback mode, this patch
adds a new module option 'lowlatency' to snd-usb-audio driver.
When user face a regression due to the recent low-latency playback
support, they can test easily by passing lowlatency=0 option without
rebuilding the kernel.

Fixes: 307cc9baac5c ("ALSA: usb-audio: Reduce latency at playback start, take#2")
Link: https://lore.kernel.org/r/20210829073830.22686-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c     | 4 ++++
 sound/usb/pcm.c      | 3 ++-
 sound/usb/usbaudio.h | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index a1f8c3a026f5..6abfc9d079e7 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -68,6 +68,7 @@ static int pid[SNDRV_CARDS] = { [0 ... (SNDRV_CARDS-1)] = -1 };
 static int device_setup[SNDRV_CARDS]; /* device parameter for this card */
 static bool ignore_ctl_error;
 static bool autoclock = true;
+static bool lowlatency = true;
 static char *quirk_alias[SNDRV_CARDS];
 static char *delayed_register[SNDRV_CARDS];
 static bool implicit_fb[SNDRV_CARDS];
@@ -92,6 +93,8 @@ MODULE_PARM_DESC(ignore_ctl_error,
 		 "Ignore errors from USB controller for mixer interfaces.");
 module_param(autoclock, bool, 0444);
 MODULE_PARM_DESC(autoclock, "Enable auto-clock selection for UAC2 devices (default: yes).");
+module_param(lowlatency, bool, 0444);
+MODULE_PARM_DESC(lowlatency, "Enable low latency playback (default: yes).");
 module_param_array(quirk_alias, charp, NULL, 0444);
 MODULE_PARM_DESC(quirk_alias, "Quirk aliases, e.g. 0123abcd:5678beef.");
 module_param_array(delayed_register, charp, NULL, 0444);
@@ -599,6 +602,7 @@ static int snd_usb_audio_create(struct usb_interface *intf,
 	chip->setup = device_setup[idx];
 	chip->generic_implicit_fb = implicit_fb[idx];
 	chip->autoclock = autoclock;
+	chip->lowlatency = lowlatency;
 	atomic_set(&chip->active, 1); /* avoid autopm during probing */
 	atomic_set(&chip->usage_count, 0);
 	atomic_set(&chip->shutdown, 0);
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index f5cbf61ac366..5dc9266180e3 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -617,7 +617,8 @@ static int snd_usb_pcm_prepare(struct snd_pcm_substream *substream)
 	/* check whether early start is needed for playback stream */
 	subs->early_playback_start =
 		subs->direction == SNDRV_PCM_STREAM_PLAYBACK &&
-		subs->data_endpoint->nominal_queue_size >= subs->buffer_bytes;
+		(!chip->lowlatency ||
+		 (subs->data_endpoint->nominal_queue_size >= subs->buffer_bytes));
 
 	if (subs->early_playback_start)
 		ret = start_endpoints(subs);
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 538831cbd925..8b70c9ea91b9 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -57,6 +57,7 @@ struct snd_usb_audio {
 	bool generic_implicit_fb;	/* from the 'implicit_fb' module param */
 	bool autoclock;			/* from the 'autoclock' module param */
 
+	bool lowlatency;		/* from the 'lowlatency' module param */
 	struct usb_host_interface *ctrl_intf;	/* the audio control interface */
 	struct media_device *media_dev;
 	struct media_intf_devnode *ctl_intf_media_devnode;
-- 
2.30.2



