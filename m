Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F6B2E6969
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgL1Mwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:52:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgL1Mwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:52:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE30222573;
        Mon, 28 Dec 2020 12:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159905;
        bh=WtlSLN4XZP4ZNu6wKgOsvW+Y/Df6jIb8sTST1jujJt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhKh2yImDny+kNLtflPlyJjLftO15qZ02+LAiMKI+DGxPZMmolyjUW2qgN1bDAlrZ
         0yG3SkreLhdTLuAZnlqcH1SJ+Xbrnfuf25xOv5CQ8MgO+BRk2zRvedCiSIeAzncxX7
         PUFsJ3sVipKrhQclJNdM5yAx37u3CA0gxzFW80r4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 016/132] ALSA: usb-audio: Fix control access overflow errors from chmap
Date:   Mon, 28 Dec 2020 13:48:20 +0100
Message-Id: <20201228124847.189863677@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
@@ -187,16 +187,16 @@ static int usb_chmap_ctl_get(struct snd_
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
 


