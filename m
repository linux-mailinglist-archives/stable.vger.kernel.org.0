Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C895742DB
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiGNE1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbiGNE0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:26:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C8A2AE09;
        Wed, 13 Jul 2022 21:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AC6CB82371;
        Thu, 14 Jul 2022 04:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C00EC34114;
        Thu, 14 Jul 2022 04:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772631;
        bh=4I+WRiPzBjwV0G9wDCU33RqIzOOfegthaq5dsSyHFGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfkJAD3QMdDmxGS3H89RoGWXIsjdV4SRrLjmV64ZUbmlWG8dBG0YRmJ4xWrTAW2ff
         dJ/nybz6XUpGWCLOa85olScvLOqDMWjR9LSr9tt2EpWHBJ8NHPwWhE8KfJUEhg6E9x
         Zxo80H6oEHsJXm0FVzFoQUJTM9g0QfW3Pbjbmhkx5vEU1eOJoQUVELCezgSU8cq3a8
         +s8kF23iYvjF8mse6Io9w7LrTe7Zs2KannVBIYHdU/uZ/aOsNQ/W94eFFajwPAd3NS
         oEkJ+cF6OJuvRYdNasZRgURxuJnzQdyj+Hz0R5j6KHcbhF5b1ETd8sugIbVOdrBYsD
         RiMXWWQKjyYOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Egor Vorontsov <sdoregor@sdore.me>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, hahnjo@hahnjo.de, brendan@grieve.com.au,
        john-linux@pelago.org.uk, willovertonuk@gmail.com,
        alexander@tsoy.me, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 34/41] ALSA: usb-audio: Add quirk for Fiero SC-01
Date:   Thu, 14 Jul 2022 00:22:14 -0400
Message-Id: <20220714042221.281187-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Egor Vorontsov <sdoregor@sdore.me>

[ Upstream commit 4fb7c24f69c48fdc02ea7858dbd5a60ff08bf7e5 ]

Fiero SC-01 is a USB sound card with two mono inputs and a single
stereo output. The inputs are composed into a single stereo stream.

The device uses a vendor-provided driver on Windows and does not work
at all without it. The driver mostly provides ASIO functionality, but
also alters the way the sound card is queried for sample rates and
clocks.

ALSA queries those failing with an EPIPE (same as Windows 10 does).
Presumably, the vendor-provided driver does not query it at all, simply
matching by VID:PID. Thus, I consider this a buggy firmware and adhere
to a set of fixed endpoint quirks instead.

The soundcard has an internal clock. Implicit feedback mode is required
for the playback.

I have updated my device to v1.1.0 from a Windows 10 VM using a vendor-
provided binary prior to the development, hoping for it to just begin
working. The device provides no obvious way to downgrade the firmware,
and regardless, there's no binary available for v1.0.0 anyway.

Thus, I will be getting another unit to extend the patch with support
for that. Expected to be a simple copy-paste of the existing one,
though.

There were no previous reports of that device in context of Linux
anywhere. Other issues have been reported though, but that's out of the
scope.

Signed-off-by: Egor Vorontsov <sdoregor@sdore.me>
Link: https://lore.kernel.org/r/20220627100041.2861494-1-sdoregor@sdore.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 68 ++++++++++++++++++++++++++++++++++++++++
 sound/usb/quirks.c       |  2 ++
 2 files changed, 70 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 853da162fd18..7067d314fecd 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -4167,6 +4167,74 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	/*
+	 * Fiero SC-01 (firmware v1.1.0)
+	 */
+	USB_DEVICE(0x2b53, 0x0031),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Fiero",
+		.product_name = "SC-01",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			/* Playback */
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 2,
+					.fmt_bits = 24,
+					.iface = 1,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_48000 |
+						 SNDRV_PCM_RATE_96000,
+					.rate_min = 48000,
+					.rate_max = 96000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 48000, 96000 },
+					.clock = 0x29
+				}
+			},
+			/* Capture */
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 2,
+					.fmt_bits = 24,
+					.iface = 2,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC |
+						   USB_ENDPOINT_USAGE_IMPLICIT_FB,
+					.rates = SNDRV_PCM_RATE_48000 |
+						 SNDRV_PCM_RATE_96000,
+					.rate_min = 48000,
+					.rate_max = 96000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 48000, 96000 },
+					.clock = 0x29
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 #undef USB_DEVICE_VENDOR_SPEC
 #undef USB_AUDIO_DEVICE
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index a72874bc0936..d42a59609886 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1911,6 +1911,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */
-- 
2.35.1

