Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85ABF240359
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 10:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgHJIZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 04:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgHJIZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 04:25:12 -0400
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32416C061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 01:25:11 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id E619041A78;
        Mon, 10 Aug 2020 08:25:07 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     alsa-devel@alsa-project.org
Cc:     Takashi Iwai <tiwai@suse.de>, Hector Martin <marcan@marcan.st>,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: usb-audio: add quirk for Pioneer DDJ-RB
Date:   Mon, 10 Aug 2020 17:25:02 +0900
Message-Id: <20200810082502.225979-1-marcan@marcan.st>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is just another Pioneer device with fixed endpoints. Input is dummy
but used as feedback (it always returns silence).

Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 sound/usb/quirks-table.h | 56 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 9c3c03dc96d3..d79e3ddc5690 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3558,6 +3558,62 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 		}
 	}
 },
+{
+	/*
+	 * PIONEER DJ DDJ-RB
+	 * PCM is 4 channels out, 2 dummy channels in @ 44.1 fixed
+	 * The feedback for the output is the dummy input.
+	 */
+	USB_DEVICE_VENDOR_SPEC(0x2b73, 0x000e),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 4,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_44100,
+					.rate_min = 44100,
+					.rate_max = 44100,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 44100 }
+				}
+			},
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 2,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						 USB_ENDPOINT_SYNC_ASYNC|
+						 USB_ENDPOINT_USAGE_IMPLICIT_FB,
+					.rates = SNDRV_PCM_RATE_44100,
+					.rate_min = 44100,
+					.rate_max = 44100,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 44100 }
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 #define ALC1220_VB_DESKTOP(vend, prod) { \
 	USB_DEVICE(vend, prod),	\
-- 
2.27.0

