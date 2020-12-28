Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFDD2E3BB4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407348AbgL1Nxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:53:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407344AbgL1Nxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47D6120731;
        Mon, 28 Dec 2020 13:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163580;
        bh=pbobAFUnOF/65W7j61JcGSUmojDKO3JIaZhZY4U1Wis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vt6VqjQw/8YXWQpZUpCI84GYgIS1DD+RKx8AGI53QCQb2MnP6tMPxNJZgg4C6G7vi
         5hwENDtub3GSqFXy+aie1nEXmpgVaJ1Z/sL2Mx3CAIyAgqDg0fMUs8nUjnLKMqiw+6
         I6zBtAr6E9PgaHwJK7Zie+HAwz1mfy2JVh6ILJQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 334/453] ALSA: hda: Fix regressions on clear and reconfig sysfs
Date:   Mon, 28 Dec 2020 13:49:30 +0100
Message-Id: <20201228124953.292687207@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -1798,7 +1798,7 @@ int snd_hda_codec_reset(struct hda_codec
 		return -EBUSY;
 
 	/* OK, let it free */
-	snd_hdac_device_unregister(&codec->core);
+	device_release_driver(hda_codec_dev(codec));
 
 	/* allow device access again */
 	snd_hda_unlock_devices(bus);
--- a/sound/pci/hda/hda_sysfs.c
+++ b/sound/pci/hda/hda_sysfs.c
@@ -139,7 +139,7 @@ static int reconfig_codec(struct hda_cod
 			   "The codec is being used, can't reconfigure.\n");
 		goto error;
 	}
-	err = snd_hda_codec_configure(codec);
+	err = device_reprobe(hda_codec_dev(codec));
 	if (err < 0)
 		goto error;
 	err = snd_card_register(codec->card);


