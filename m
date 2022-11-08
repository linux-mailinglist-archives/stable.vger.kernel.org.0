Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209136213F8
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbiKHNzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiKHNzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:55:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A4965E64
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:55:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32B6CB81AE4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F478C433C1;
        Tue,  8 Nov 2022 13:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915748;
        bh=R/bhI66ecWDIn8SjSDZdEz8MHQi0reqDsLoKRnzYV+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzLHlu0eFiXPW0pHkBMF8c04KAuTLSk3qoONoljGpg/kfdaqU5pay1ne4/so1e9fs
         1SUsNE4hh6RsdkZDbE2fUo3WGzc9zDhvcjNxiGQCYrOsetjS2Zhl2HZlo8Misph+py
         ewSjvNRMcboc7DeStWEqCJdjSXQYbKxgZz0ubFtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Veness <john-linux@pelago.org.uk>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 079/118] ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices
Date:   Tue,  8 Nov 2022 14:39:17 +0100
Message-Id: <20221108133344.156636479@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Veness <john-linux@pelago.org.uk>

commit 6e2c9105e0b743c92a157389d40f00b81bdd09fe upstream.

Treat the claimed 96kHz 1ch in the descriptors as 48kHz 2ch, so that
the audio stream doesn't sound mono. Also fix initial stream
alignment, so that left and right channels are in the correct order.

Signed-off-by: John Veness <john-linux@pelago.org.uk>
Link: https://lore.kernel.org/r/20220624140757.28758-1-john-linux@pelago.org.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 sound/usb/quirks.c       |    1 
 2 files changed, 53 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3657,6 +3657,58 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge
 },
 
 /*
+ * MacroSilicon MS2100/MS2106 based AV capture cards
+ *
+ * These claim 96kHz 1ch in the descriptors, but are actually 48kHz 2ch.
+ * They also need QUIRK_AUDIO_ALIGN_TRANSFER, which makes one wonder if
+ * they pretend to be 96kHz mono as a workaround for stereo being broken
+ * by that...
+ *
+ * They also have an issue with initial stream alignment that causes the
+ * channels to be swapped and out of phase, which is dealt with in quirks.c.
+ */
+{
+	USB_AUDIO_DEVICE(0x534d, 0x0021),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "MacroSilicon",
+		.product_name = "MS210x",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_STANDARD_MIXER,
+			},
+			{
+				.ifnum = 3,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S16_LE,
+					.channels = 2,
+					.iface = 3,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.attributes = 0,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_CONTINUOUS,
+					.rate_min = 48000,
+					.rate_max = 48000,
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+
+/*
  * MacroSilicon MS2109 based HDMI capture cards
  *
  * These claim 96kHz 1ch in the descriptors, but are actually 48kHz 2ch.
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1508,6 +1508,7 @@ void snd_usb_set_format_quirk(struct snd
 	case USB_ID(0x2b73, 0x0017): /* Pioneer DJ DJM-250MK2 */
 		pioneer_djm_set_format_quirk(subs);
 		break;
+	case USB_ID(0x534d, 0x0021): /* MacroSilicon MS2100/MS2106 */
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;


