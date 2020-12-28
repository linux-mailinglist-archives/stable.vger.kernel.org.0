Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9812E37C4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgL1NAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:00:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbgL1NAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B850121D94;
        Mon, 28 Dec 2020 12:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160371;
        bh=i4mlgf1ETnynvb/IiFRi9wV8TT8jHuPnzxerrq2DIbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12qWBZh2Wy1Al3MhgLfAZyifZsduR6XnibgxTdDaV0PLtuxq9uGGx/8e4ceoWqP0O
         COC1E/SW/of2+Pn45vvtVdkPfmv98DYAL7hZvG8efENeBn36ZBlnOWmKgZ8Gr2i8rT
         YWiGO5QaMhp+3fqiwfxkGTcIIRtWJGDULT6v6Ob0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 021/175] ALSA: usb-audio: Fix control access overflow errors from chmap
Date:   Mon, 28 Dec 2020 13:47:54 +0100
Message-Id: <20201228124854.282228656@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c6dde8ffd071aea9d1ce64279178e470977b235c upstream.

The current channel-map control implementation in USB-audio driver may
lead to an error message like
  "control 3:0:0:Playback Channel Map:0: access overflow"
when CONFIG_SND_CTL_VALIDATION is set.  It's because the chmap get
callback clears the whole array no matter which count is set, and
rather the false-positive detection.

This patch fixes the problem by clearing only the needed array range
at usb_chmap_ctl_get().

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201211130048.6358-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/stream.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -185,16 +185,16 @@ static int usb_chmap_ctl_get(struct snd_
 	struct snd_pcm_chmap *info = snd_kcontrol_chip(kcontrol);
 	struct snd_usb_substream *subs = info->private_data;
 	struct snd_pcm_chmap_elem *chmap = NULL;
-	int i;
+	int i = 0;
 
-	memset(ucontrol->value.integer.value, 0,
-	       sizeof(ucontrol->value.integer.value));
 	if (subs->cur_audiofmt)
 		chmap = subs->cur_audiofmt->chmap;
 	if (chmap) {
 		for (i = 0; i < chmap->channels; i++)
 			ucontrol->value.integer.value[i] = chmap->map[i];
 	}
+	for (; i < subs->channels_max; i++)
+		ucontrol->value.integer.value[i] = 0;
 	return 0;
 }
 


