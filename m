Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0CD5742DD
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiGNE1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiGNE0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:26:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DB52AE12;
        Wed, 13 Jul 2022 21:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BC3DB82374;
        Thu, 14 Jul 2022 04:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94D2C385A2;
        Thu, 14 Jul 2022 04:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772627;
        bh=Yq4+OAykBYjQ9xMianAzkJZwCiKUJxPTc6gaUkZ7J+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjHl/UiCnxuUMJxx1yJwYH51K+XBHKYF0hmX2Wyb4GdzhZE+ZQlOV8hWN7mmqiHC8
         LDPsdHuj0QpGkGJcpw3F/oKJWRB5IdIAe+c+FkrVdhhXXIKAXz9MmtdVICNfcVGNV7
         5g30NuTolyLDOB9+fjRGfgkRBFeEoKCHbFdrAjTFHc6trN3QEYx1R1n+DEjvE1aImg
         0aTm+yU5fGriXLhmW9m4Lei5ukXRHExxBfZnPF+a76LmKgFrrkwnxZcOi3QE3yWP5v
         7iudZ8pYbve70lXkWsDw7RMBKkglxX9jKv4oi+UM5koREu+866SIw8+uQETvkYEO3L
         Em9ClKpFfRoYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Veness <john-linux@pelago.org.uk>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, hahnjo@hahnjo.de,
        sdoregor@sdore.me, brendan@grieve.com.au, willovertonuk@gmail.com,
        alexander@tsoy.me, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 33/41] ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices
Date:   Thu, 14 Jul 2022 00:22:13 -0400
Message-Id: <20220714042221.281187-33-sashal@kernel.org>
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

From: John Veness <john-linux@pelago.org.uk>

[ Upstream commit 6e2c9105e0b743c92a157389d40f00b81bdd09fe ]

Treat the claimed 96kHz 1ch in the descriptors as 48kHz 2ch, so that
the audio stream doesn't sound mono. Also fix initial stream
alignment, so that left and right channels are in the correct order.

Signed-off-by: John Veness <john-linux@pelago.org.uk>
Link: https://lore.kernel.org/r/20220624140757.28758-1-john-linux@pelago.org.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 48 ++++++++++++++++++++++++++++++++++++++++
 sound/usb/quirks.c       |  3 +++
 2 files changed, 51 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 4f56e1784932..853da162fd18 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3802,6 +3802,54 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/*
+ * MacroSilicon MS2100/MS2106 based AV capture cards
+ *
+ * These claim 96kHz 1ch in the descriptors, but are actually 48kHz 2ch.
+ * They also need QUIRK_FLAG_ALIGN_TRANSFER, which makes one wonder if
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
index e8468f9b007d..a72874bc0936 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1478,6 +1478,7 @@ void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 	case USB_ID(0x041e, 0x3f19): /* E-Mu 0204 USB */
 		set_format_emu_quirk(subs, fmt);
 		break;
+	case USB_ID(0x534d, 0x0021): /* MacroSilicon MS2100/MS2106 */
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
@@ -1904,6 +1905,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x534d, 0x0021, /* MacroSilicon MS2100/MS2106 */
+		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x534d, 0x2109, /* MacroSilicon MS2109 */
 		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
-- 
2.35.1

