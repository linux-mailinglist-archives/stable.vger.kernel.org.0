Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5E249989B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378196AbiAXV2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39294 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358044AbiAXVQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2671F61484;
        Mon, 24 Jan 2022 21:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A19C340E4;
        Mon, 24 Jan 2022 21:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058988;
        bh=0mn07Z63UB9WDnRDyK8KAWId9NRvMSa9a8fRkkhTd6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WYYDxYIwiBdDKG44Ou6Nvzvyfc/WtxSYU0TSFcmgj8si2atExbXCzDyas8Z9Edko
         Yiv6cWVRhBRpyhvVTqLA8/ex552bWcTgT2RKy6P/VyhyErwqgRlzxTzXz5Ev50lNoy
         acwW6BC0LK94UTnmh4ZKyJXdL9jWinfpQSFge9uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0467/1039] ALSA: usb-audio: Drop superfluous 0 in Presonus Studio 1810cs ID
Date:   Mon, 24 Jan 2022 19:37:36 +0100
Message-Id: <20220124184140.976598511@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1e583aef12aa74afd37c1418255cc4b74e023236 ]

The vendor ID of Presonus Studio 1810c had a superfluous '0' in its
USB ID.  Drop it.

Fixes: 8dc5efe3d17c ("ALSA: usb-audio: Add support for Presonus Studio 1810c")
Link: https://lore.kernel.org/r/20211202083833.17784-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/format.c       | 2 +-
 sound/usb/mixer_quirks.c | 2 +-
 sound/usb/quirks.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index f5e676a51b30d..405dc0bf6678c 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -375,7 +375,7 @@ static int parse_uac2_sample_rate_range(struct snd_usb_audio *chip,
 		for (rate = min; rate <= max; rate += res) {
 
 			/* Filter out invalid rates on Presonus Studio 1810c */
-			if (chip->usb_id == USB_ID(0x0194f, 0x010c) &&
+			if (chip->usb_id == USB_ID(0x194f, 0x010c) &&
 			    !s1810c_valid_sample_rate(fp, rate))
 				goto skip_rate;
 
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 823b6b8de942d..d48729e6a3b0a 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3254,7 +3254,7 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 		err = snd_rme_controls_create(mixer);
 		break;
 
-	case USB_ID(0x0194f, 0x010c): /* Presonus Studio 1810c */
+	case USB_ID(0x194f, 0x010c): /* Presonus Studio 1810c */
 		err = snd_sc1810_init_mixer(mixer);
 		break;
 	case USB_ID(0x2a39, 0x3fb0): /* RME Babyface Pro FS */
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 64e1c20311ed4..ab9f3da49941f 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1290,7 +1290,7 @@ int snd_usb_apply_interface_quirk(struct snd_usb_audio *chip,
 	if (chip->usb_id == USB_ID(0x0763, 0x2012))
 		return fasttrackpro_skip_setting_quirk(chip, iface, altno);
 	/* presonus studio 1810c: skip altsets incompatible with device_setup */
-	if (chip->usb_id == USB_ID(0x0194f, 0x010c))
+	if (chip->usb_id == USB_ID(0x194f, 0x010c))
 		return s1810c_skip_setting_quirk(chip, iface, altno);
 
 
-- 
2.34.1



