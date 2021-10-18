Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F628431BC9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhJRNfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232171AbhJRNdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:33:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E43A06138D;
        Mon, 18 Oct 2021 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563784;
        bh=dS1l6cmDtpKP0CXwcPBikpJdGvUAu4BVH1AykBE/SJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMieOoZDROA9u02v8t3ww7+vvW7u8o9CBshNGH3GnnKP4Yt13IMKM0A8Uyo6g/lDg
         6PMB3A9He/XbctnvwlPbSkCXDODcmxfNVa0c4fMG0ckFop9k+oenfIdN2F8g5+j5Qf
         MOPPbZECm4CSiy7DtwdWd9C3ydOWrGpih2x17vCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Hahnfeld <hahnjo@hahnjo.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 02/69] ALSA: usb-audio: Add quirk for VF0770
Date:   Mon, 18 Oct 2021 15:24:00 +0200
Message-Id: <20211018132329.531997168@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Hahnfeld <hahnjo@hahnjo.de>

commit 48827e1d6af58f219e89c7ec08dccbca28c7694e upstream.

The device advertises 8 formats, but only a rate of 48kHz is honored
by the hardware and 24 bits give chopped audio, so only report the
one working combination. This fixes out-of-the-box audio experience
with PipeWire which otherwise attempts to choose S24_3LE (while
PulseAudio defaulted to S16_LE).

Signed-off-by: Jonas Hahnfeld <hahnjo@hahnjo.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211012200906.3492-1-hahnjo@hahnjo.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -126,6 +126,48 @@
 },
 
 /*
+ * Creative Technology, Ltd Live! Cam Sync HD [VF0770]
+ * The device advertises 8 formats, but only a rate of 48kHz is honored by the
+ * hardware and 24 bits give chopped audio, so only report the one working
+ * combination.
+ */
+{
+	USB_DEVICE(0x041e, 0x4095),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
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
+					.fmt_bits = 16,
+					.iface = 3,
+					.altsetting = 4,
+					.altset_idx = 4,
+					.endpoint = 0x82,
+					.ep_attr = 0x05,
+					.rates = SNDRV_PCM_RATE_48000,
+					.rate_min = 48000,
+					.rate_max = 48000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 48000 },
+				},
+			},
+			{
+				.ifnum = -1
+			},
+		},
+	},
+},
+
+/*
  * HP Wireless Audio
  * When not ignored, causes instability issues for some users, forcing them to
  * blacklist the entire module.


