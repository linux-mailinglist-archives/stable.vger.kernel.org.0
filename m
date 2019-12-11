Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775CD11B842
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbfLKQNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730375AbfLKPI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:08:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A5282173E;
        Wed, 11 Dec 2019 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076907;
        bh=G1JJ7gfWeu4OxtOizcMo67AaxaqVvWp53DVz/+7WWCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICSvGbXxZ3ZAlbLyikzuHTN3EE+c/YM6t2/QdQ82zd0ZpuzNtAOOggUh7LCAkE53d
         ybVxjGCNrCBv4YLbgdS5MXVNE/4ZfMnoLu2WHVzkSuN8UYbLat7ncQAD3VlNFtSkBm
         m7IWfhRquarC73tWWUGHBz5AqwT4X+YJR1yY0aVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Pobega <mpobega@neverware.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 35/92] ALSA: hda: Modify stream stripe mask only when needed
Date:   Wed, 11 Dec 2019 16:05:26 +0100
Message-Id: <20191211150237.977324939@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit e38e486d66e2a3b902768fd71c32dbf10f77e1cb upstream.

The recent commit in HD-audio stream management for changing the
stripe control seems causing a regression on some platforms.  The
stripe control is currently used only by HDMI codec, and applying the
stripe mask unconditionally may lead to scratchy and static noises as
seen on some MacBooks.

For addressing the regression, this patch changes the stream
management code to apply the stripe mask conditionally only when the
codec driver requested.

Fixes: 9b6f7e7a296e ("ALSA: hda: program stripe bits for controller")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204477
Tested-by: Michael Pobega <mpobega@neverware.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191202074947.1617-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/hdaudio.h    |    1 +
 sound/hda/hdac_stream.c    |   19 ++++++++++++-------
 sound/pci/hda/patch_hdmi.c |    5 +++++
 3 files changed, 18 insertions(+), 7 deletions(-)

--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -493,6 +493,7 @@ struct hdac_stream {
 	bool prepared:1;
 	bool no_period_wakeup:1;
 	bool locked:1;
+	bool stripe:1;			/* apply stripe control */
 
 	/* timestamp */
 	unsigned long start_wallclk;	/* start + minimum wallclk */
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -96,12 +96,14 @@ void snd_hdac_stream_start(struct hdac_s
 			      1 << azx_dev->index,
 			      1 << azx_dev->index);
 	/* set stripe control */
-	if (azx_dev->substream)
-		stripe_ctl = snd_hdac_get_stream_stripe_ctl(bus, azx_dev->substream);
-	else
-		stripe_ctl = 0;
-	snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK,
-				stripe_ctl);
+	if (azx_dev->stripe) {
+		if (azx_dev->substream)
+			stripe_ctl = snd_hdac_get_stream_stripe_ctl(bus, azx_dev->substream);
+		else
+			stripe_ctl = 0;
+		snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK,
+					stripe_ctl);
+	}
 	/* set DMA start and interrupt mask */
 	snd_hdac_stream_updateb(azx_dev, SD_CTL,
 				0, SD_CTL_DMA_START | SD_INT_MASK);
@@ -118,7 +120,10 @@ void snd_hdac_stream_clear(struct hdac_s
 	snd_hdac_stream_updateb(azx_dev, SD_CTL,
 				SD_CTL_DMA_START | SD_INT_MASK, 0);
 	snd_hdac_stream_writeb(azx_dev, SD_STS, SD_INT_MASK); /* to be sure */
-	snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK, 0);
+	if (azx_dev->stripe) {
+		snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK, 0);
+		azx_dev->stripe = 0;
+	}
 	azx_dev->running = false;
 }
 EXPORT_SYMBOL_GPL(snd_hdac_stream_clear);
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -32,6 +32,7 @@
 #include <sound/hda_codec.h>
 #include "hda_local.h"
 #include "hda_jack.h"
+#include "hda_controller.h"
 
 static bool static_hdmi_pcm;
 module_param(static_hdmi_pcm, bool, 0644);
@@ -1240,6 +1241,10 @@ static int hdmi_pcm_open(struct hda_pcm_
 	per_pin->cvt_nid = per_cvt->cvt_nid;
 	hinfo->nid = per_cvt->cvt_nid;
 
+	/* flip stripe flag for the assigned stream if supported */
+	if (get_wcaps(codec, per_cvt->cvt_nid) & AC_WCAP_STRIPE)
+		azx_stream(get_azx_dev(substream))->stripe = 1;
+
 	snd_hda_set_dev_select(codec, per_pin->pin_nid, per_pin->dev_id);
 	snd_hda_codec_write_cache(codec, per_pin->pin_nid, 0,
 			    AC_VERB_SET_CONNECT_SEL,


