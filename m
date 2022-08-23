Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AEA59D3B2
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242214AbiHWING (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241817AbiHWILu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:11:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7056B16A;
        Tue, 23 Aug 2022 01:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 242126122D;
        Tue, 23 Aug 2022 08:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED48C433D6;
        Tue, 23 Aug 2022 08:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242134;
        bh=F9SU6UtgP0gCccx4Zboydln91y1JAzmAWCxO5fihL5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whYeu29QEkuLhQrXkjSO/LSDjE2yL52Ei0F7mn6fQP10nodCtHGXxAdnn6+AGjUY0
         kZrI+yGu0GokZzyRk8A6KYGsJZ8bgs+5E5iFDtkas8wNDZ6WqL1Kbzy9LvZ5MmlpLU
         52Xbid9WRlZefAHjNcg/rWxJH0jalC906dZIOAc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 037/365] ALSA: usb-audio: More comprehensive mixer map for ASUS ROG Zenith II
Date:   Tue, 23 Aug 2022 09:58:58 +0200
Message-Id: <20220823080119.744796915@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 6bc2906253e723d1ab1acc652b55b83e286bfec2 upstream.

ASUS ROG Zenith II has two USB interfaces, one for the front headphone
and another for the rest I/O.  Currently we provided the mixer mapping
for the latter but with an incomplete form.

This patch corrects and provides more comprehensive mixer mapping, as
well as providing the proper device names for both the front headphone
and main audio.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211005
Fixes: 2a48218f8e23 ("ALSA: usb-audio: Add mixer workaround for TRX40 and co")
Link: https://lore.kernel.org/r/20220809073259.18849-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.c       |    8 ++++++++
 sound/usb/mixer_maps.c |   34 +++++++++++++++++++++++++---------
 2 files changed, 33 insertions(+), 9 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -387,6 +387,14 @@ static const struct usb_audio_device_nam
 	DEVICE_NAME(0x05e1, 0x0408, "Syntek", "STK1160"),
 	DEVICE_NAME(0x05e1, 0x0480, "Hauppauge", "Woodbury"),
 
+	/* ASUS ROG Zenith II: this machine has also two devices, one for
+	 * the front headphone and another for the rest
+	 */
+	PROFILE_NAME(0x0b05, 0x1915, "ASUS", "Zenith II Front Headphone",
+		     "Zenith-II-Front-Headphone"),
+	PROFILE_NAME(0x0b05, 0x1916, "ASUS", "Zenith II Main Audio",
+		     "Zenith-II-Main-Audio"),
+
 	/* ASUS ROG Strix */
 	PROFILE_NAME(0x0b05, 0x1917,
 		     "Realtek", "ALC1220-VB-DT", "Realtek-ALC1220-VB-Desktop"),
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -374,13 +374,28 @@ static const struct usbmix_name_map cors
 	{ 0 }
 };
 
-/* Some mobos shipped with a dummy HD-audio show the invalid GET_MIN/GET_MAX
- * response for Input Gain Pad (id=19, control=12) and the connector status
- * for SPDIF terminal (id=18).  Skip them.
- */
-static const struct usbmix_name_map asus_rog_map[] = {
-	{ 18, NULL }, /* OT, connector control */
-	{ 19, NULL, 12 }, /* FU, Input Gain Pad */
+/* ASUS ROG Zenith II with Realtek ALC1220-VB */
+static const struct usbmix_name_map asus_zenith_ii_map[] = {
+	{ 19, NULL, 12 }, /* FU, Input Gain Pad - broken response, disabled */
+	{ 16, "Speaker" },		/* OT */
+	{ 22, "Speaker Playback" },	/* FU */
+	{ 7, "Line" },			/* IT */
+	{ 19, "Line Capture" },		/* FU */
+	{ 8, "Mic" },			/* IT */
+	{ 20, "Mic Capture" },		/* FU */
+	{ 9, "Front Mic" },		/* IT */
+	{ 21, "Front Mic Capture" },	/* FU */
+	{ 17, "IEC958" },		/* OT */
+	{ 23, "IEC958 Playback" },	/* FU */
+	{}
+};
+
+static const struct usbmix_connector_map asus_zenith_ii_connector_map[] = {
+	{ 10, 16 },	/* (Back) Speaker */
+	{ 11, 17 },	/* SPDIF */
+	{ 13, 7 },	/* Line */
+	{ 14, 8 },	/* Mic */
+	{ 15, 9 },	/* Front Mic */
 	{}
 };
 
@@ -611,9 +626,10 @@ static const struct usbmix_ctl_map usbmi
 		.map = gigabyte_b450_map,
 		.connector_map = gigabyte_b450_connector_map,
 	},
-	{	/* ASUS ROG Zenith II */
+	{	/* ASUS ROG Zenith II (main audio) */
 		.id = USB_ID(0x0b05, 0x1916),
-		.map = asus_rog_map,
+		.map = asus_zenith_ii_map,
+		.connector_map = asus_zenith_ii_connector_map,
 	},
 	{	/* ASUS ROG Strix */
 		.id = USB_ID(0x0b05, 0x1917),


