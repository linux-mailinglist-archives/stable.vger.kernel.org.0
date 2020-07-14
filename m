Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF98021FB8E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbgGNS6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731163AbgGNS6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DB3D22B4E;
        Tue, 14 Jul 2020 18:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753080;
        bh=LEm6qLaFUGYEBOM3tsUktJ9zfuWVzPIUFUl8ws+gysI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b36bvhxj7hP5BrOMtV+kpt/oWUjvW2G/ymmXfTHq6cMwNnsM5ET84UMPX3Tkd9VUw
         wTD0ByuxzzzdYhm1fsd4JLe1xWq7Jkzw6U/pHTZSal4CKKCh7leiU1Z3hN9DrtbymE
         VHFgxGpBDqp7NvKJ788C+EDgY1bbHjiArHaCr+oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 111/166] ALSA: usb-audio: add quirk for MacroSilicon MS2109
Date:   Tue, 14 Jul 2020 20:44:36 +0200
Message-Id: <20200714184121.153270017@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

commit e337bf19f6af38d5c3fa6d06cd594e0f890ca1ac upstream.

These devices claim to be 96kHz mono, but actually are 48kHz stereo with
swapped channels and unaligned transfers.

Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20200702071433.237843-1-marcan@marcan.st
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks-table.h |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3611,4 +3611,56 @@ ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* A
 	}
 },
 
+/*
+ * MacroSilicon MS2109 based HDMI capture cards
+ *
+ * These claim 96kHz 1ch in the descriptors, but are actually 48kHz 2ch.
+ * They also need QUIRK_AUDIO_ALIGN_TRANSFER, which makes one wonder if
+ * they pretend to be 96kHz mono as a workaround for stereo being broken
+ * by that...
+ *
+ * They also have swapped L-R channels, but that's for userspace to deal
+ * with.
+ */
+{
+	USB_DEVICE(0x534d, 0x2109),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "MacroSilicon",
+		.product_name = "MS2109",
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
 #undef USB_DEVICE_VENDOR_SPEC


