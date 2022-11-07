Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE2C61F85E
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiKGQHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiKGQGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:06:24 -0500
Received: from mx1.mythic-beasts.com (mx1.mythic-beasts.com [IPv6:2a00:1098:0:86:1000:0:2:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5E1205E5
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:06:21 -0800 (PST)
Received: from [217.155.36.16] (port=44866 helo=Samsung-Ubuntu.fritz.box)
        by mailhub-cam-d.mythic-beasts.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <john-linux@pelago.org.uk>)
        id 1os4da-002Bqs-T8; Mon, 07 Nov 2022 16:06:15 +0000
From:   John Veness <john-linux@pelago.org.uk>
To:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc:     alsa-devel@alsa-project.org,
        John Veness <john-linux@pelago.org.uk>, stable@vger.kernel.org
Subject: [PATCH] ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices (4.9-5.4)
Date:   Mon,  7 Nov 2022 16:05:36 +0000
Message-Id: <20221107160536.27565-1-john-linux@pelago.org.uk>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BlackCat-Spam-Score: 49
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6e2c9105e0b743c92a157389d40f00b81bdd09fe upstream.

Treat the claimed 96kHz 1ch in the descriptors as 48kHz 2ch, so that
the audio stream doesn't sound mono. Also fix initial stream
alignment, so that left and right channels are in the correct order.

Signed-off-by: John Veness <john-linux@pelago.org.uk>
Link: https://lore.kernel.org/r/20220624140757.28758-1-john-linux@pelago.org.uk
Cc: <stable@vger.kernel.org> # 5.4
Cc: <stable@vger.kernel.org> # 4.19
Cc: <stable@vger.kernel.org> # 4.14
Cc: <stable@vger.kernel.org> # 4.9

---
Backported to 4.9-5.4.

 sound/usb/quirks-table.h | 58 ++++++++++++++++++++++++++++++++++++++++
 sound/usb/quirks.c       |  1 +
 2 files changed, 59 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index c29ccdf9e8bc..5f44b142a8b0 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3759,6 +3759,64 @@ ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* Asrock TRX40 Creator */
 	}
 },
 
+/*
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
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x534d,
+	.idProduct = 0x0021,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
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
 /*
  * MacroSilicon MS2109 based HDMI capture cards
  *
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 72223545abfd..d61f95dc1abf 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1440,6 +1440,7 @@ void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 	case USB_ID(0x041e, 0x3f19): /* E-Mu 0204 USB */
 		set_format_emu_quirk(subs, fmt);
 		break;
+	case USB_ID(0x534d, 0x0021): /* MacroSilicon MS2100/MS2106 */
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
-- 
2.34.1

