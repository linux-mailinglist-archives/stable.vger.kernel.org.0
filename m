Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876552E3A2F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387852AbgL1NdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390032AbgL1NdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:33:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1567822B45;
        Mon, 28 Dec 2020 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162344;
        bh=dGAgfHUs7t+JBDelGoAfsLvxPHJH/k+xqXBdSFcwdqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ox8v0E3tTlgo7otARhmDjYgNEJ437a0HCSpOGofxjw4KgMmbKwxlnHbKzcOKylcd9
         +YPWFI/CVLBzbuNKXidb7CdkiMsHsW/jua9o8YMdp4eIuZlL8cLkxKo5AW3KEIpxha
         /dncZBhCzuIqbB8ulyRB3m7qnp++2N+0kj3azj5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 271/346] ALSA: hda: Fix regressions on clear and reconfig sysfs
Date:   Mon, 28 Dec 2020 13:49:50 +0100
Message-Id: <20201228124932.871835037@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2506318e382c4c7daa77bdc48f80a0ee82804588 upstream.

It seems that the HD-audio clear and reconfig sysfs don't work any
longer after the recent driver core change.  There are multiple issues
around that: the linked list corruption and the dead device handling.
The former issue is fixed by another patch for the driver core itself,
while the latter patch needs to be addressed in HD-audio side.

This patch corresponds to the latter, it recovers those broken
functions by replacing the device detach and attach actions with the
standard core API functions, which are almost equivalent with unbind
and bind actions.

Fixes: 654888327e9f ("driver core: Avoid binding drivers to dead devices")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209207
Link: https://lore.kernel.org/r/20201209150119.7705-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    2 +-
 sound/pci/hda/hda_sysfs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1782,7 +1782,7 @@ int snd_hda_codec_reset(struct hda_codec
 		return -EBUSY;
 
 	/* OK, let it free */
-	snd_hdac_device_unregister(&codec->core);
+	device_release_driver(hda_codec_dev(codec));
 
 	/* allow device access again */
 	snd_hda_unlock_devices(bus);
--- a/sound/pci/hda/hda_sysfs.c
+++ b/sound/pci/hda/hda_sysfs.c
@@ -138,7 +138,7 @@ static int reconfig_codec(struct hda_cod
 			   "The codec is being used, can't reconfigure.\n");
 		goto error;
 	}
-	err = snd_hda_codec_configure(codec);
+	err = device_reprobe(hda_codec_dev(codec));
 	if (err < 0)
 		goto error;
 	err = snd_card_register(codec->card);


