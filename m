Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6832E579D0E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241601AbiGSMp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241863AbiGSMop (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:44:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5396887F4A;
        Tue, 19 Jul 2022 05:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6CFB617DF;
        Tue, 19 Jul 2022 12:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C874BC341C6;
        Tue, 19 Jul 2022 12:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233042;
        bh=RErdYp/saWbXBtDS7TGY/5ALVxq4blsMtCQT7X3SQkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtN+zoX3GiUnJXHhDMMBqO18j0FY2jOywRh4AMnPLsLUWZb3Xai7S8p+qfli8Nyf8
         HqgGhpJMmV0m3cvpuxF11zJ4eANNdJV/GH6pUKPg6kpq2aN1sT19lQkKJ+oc+F8yBW
         JGiSEtTapw6TN1FPbUZOMoKtSJmiaTdu2bM/QXJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Egor Vorontsov <sdoregor@sdore.me>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/167] ALSA: usb-audio: Add quirk for Fiero SC-01
Date:   Tue, 19 Jul 2022 13:54:46 +0200
Message-Id: <20220719114711.388636038@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 sound/usb/quirks-table.h |   68 +++++++++++++++++++++++++++++++++++++++++++++++
 sound/usb/quirks.c       |    2 +
 2 files changed, 70 insertions(+)

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
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1915,6 +1915,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */


