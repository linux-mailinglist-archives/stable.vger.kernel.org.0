Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBDA38EE17
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhEXPp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233068AbhEXPn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:43:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50E73613CB;
        Mon, 24 May 2021 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870531;
        bh=z2Q84x/PMx6tNKzEBq9m3j2/Hn3rXvFptlwTMlAzxnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkAU+1o/BN9SldNIVTAUkTPJGkhPBbXw2WTqWQsBA6CdnXVHAUwrj0CA4LYfo2Ye0
         SsRdo4+MkVTIa6ERrWWrMhdv98auRVqx4zEsuMkSjsBekLdQz8m3fiuOuLyFFxeDDE
         YGhMbe9532RBhIOr6OrGQpJJgH/ho2Qs2qJo3A/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 15/49] ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro
Date:   Mon, 24 May 2021 17:25:26 +0200
Message-Id: <20210524152324.874466729@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
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
@@ -37,7 +37,7 @@ config SND_OXFW
 	   * Mackie(Loud) Onyx 1640i (former model)
 	   * Mackie(Loud) Onyx Satellite
 	   * Mackie(Loud) Tapco Link.Firewire
-	   * Mackie(Loud) d.2 pro/d.4 pro
+	   * Mackie(Loud) d.4 pro
 	   * Mackie(Loud) U.420/U.420d
 	   * TASCAM FireOne
 	   * Stanton Controllers & Systems 1 Deck/Mixer
@@ -83,7 +83,7 @@ config SND_BEBOB
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
@@ -414,7 +414,7 @@ static const struct ieee1394_device_id b
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
@@ -400,7 +400,6 @@ static const struct ieee1394_device_id o
 	 *  Onyx-i series (former models):	0x081216
 	 *  Mackie Onyx Satellite:		0x00200f
 	 *  Tapco LINK.firewire 4x6:		0x000460
-	 *  d.2 pro:				Unknown
 	 *  d.4 pro:				Unknown
 	 *  U.420:				Unknown
 	 *  U.420d:				Unknown


