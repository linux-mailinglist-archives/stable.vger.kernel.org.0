Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5628938EE8A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhEXPvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234745AbhEXPti (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:49:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4708961581;
        Mon, 24 May 2021 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870677;
        bh=mMlqg+1kuydYP6/gPCSIx8G3XbYCfhPxdIoiQLITTds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BD/iyYADN3aZX99OFj5+v6G/X2ZpL4X5C7X4wgEbPzbYcBYnF7f3RtQk8xTv7p20n
         AHKKYWWC0ACBVhpWvNaZ2pR5lHM4Ett+elFX09IJTTbbTI/99CmDxMNejU0leks6KX
         h+IAGxSQ9iSRO8uLbWgauaxE6RZ8TZBGXvxo85JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 24/71] ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro
Date:   Mon, 24 May 2021 17:25:30 +0200
Message-Id: <20210524152327.245332229@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 0edabdfe89581669609eaac5f6a8d0ae6fe95e7f upstream.

Mackie d.2 has an extension card for IEEE 1394 communication, which uses
BridgeCo DM1000 ASIC. On the other hand, Mackie d.4 Pro has built-in
function for IEEE 1394 communication by Oxford Semiconductor OXFW971,
according to schematic diagram available in Mackie website. Although I
misunderstood that Mackie d.2 Pro would be also a model with OXFW971,
it's wrong. Mackie d.2 Pro is a model which includes the extension card
as factory settings.

This commit fixes entries in Kconfig and comment in ALSA OXFW driver.

Cc: <stable@vger.kernel.org>
Fixes: fd6f4b0dc167 ("ALSA: bebob: Add skelton for BeBoB based devices")
Fixes: ec4dba5053e1 ("ALSA: oxfw: Add support for Behringer/Mackie devices")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210513125652.110249-3-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/Kconfig       |    4 ++--
 sound/firewire/bebob/bebob.c |    2 +-
 sound/firewire/oxfw/oxfw.c   |    1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/sound/firewire/Kconfig
+++ b/sound/firewire/Kconfig
@@ -38,7 +38,7 @@ config SND_OXFW
 	   * Mackie(Loud) Onyx 1640i (former model)
 	   * Mackie(Loud) Onyx Satellite
 	   * Mackie(Loud) Tapco Link.Firewire
-	   * Mackie(Loud) d.2 pro/d.4 pro
+	   * Mackie(Loud) d.4 pro
 	   * Mackie(Loud) U.420/U.420d
 	   * TASCAM FireOne
 	   * Stanton Controllers & Systems 1 Deck/Mixer
@@ -84,7 +84,7 @@ config SND_BEBOB
 	  * PreSonus FIREBOX/FIREPOD/FP10/Inspire1394
 	  * BridgeCo RDAudio1/Audio5
 	  * Mackie Onyx 1220/1620/1640 (FireWire I/O Card)
-	  * Mackie d.2 (FireWire Option)
+	  * Mackie d.2 (FireWire Option) and d.2 Pro
 	  * Stanton FinalScratch 2 (ScratchAmp)
 	  * Tascam IF-FW/DM
 	  * Behringer XENIX UFX 1204/1604
--- a/sound/firewire/bebob/bebob.c
+++ b/sound/firewire/bebob/bebob.c
@@ -387,7 +387,7 @@ static const struct ieee1394_device_id b
 	SND_BEBOB_DEV_ENTRY(VEN_BRIDGECO, 0x00010049, &spec_normal),
 	/* Mackie, Onyx 1220/1620/1640 (Firewire I/O Card) */
 	SND_BEBOB_DEV_ENTRY(VEN_MACKIE2, 0x00010065, &spec_normal),
-	/* Mackie, d.2 (Firewire Option) */
+	// Mackie, d.2 (Firewire option card) and d.2 Pro (the card is built-in).
 	SND_BEBOB_DEV_ENTRY(VEN_MACKIE1, 0x00010067, &spec_normal),
 	/* Stanton, ScratchAmp */
 	SND_BEBOB_DEV_ENTRY(VEN_STANTON, 0x00000001, &spec_normal),
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -350,7 +350,6 @@ static const struct ieee1394_device_id o
 	 *  Onyx-i series (former models):	0x081216
 	 *  Mackie Onyx Satellite:		0x00200f
 	 *  Tapco LINK.firewire 4x6:		0x000460
-	 *  d.2 pro:				Unknown
 	 *  d.4 pro:				Unknown
 	 *  U.420:				Unknown
 	 *  U.420d:				Unknown


