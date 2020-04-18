Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E891AF0F1
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgDROmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726625AbgDROmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:42:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 676292224F;
        Sat, 18 Apr 2020 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220920;
        bh=SC/vqzeMx1k3k9AAbtjSE5BmU6VVJ9MANDBe3abuSXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJ3ujVtXKNApUgyMIYJ5qtwCHZ3xirDfQyarkQxK95iX5NO3tOiartrji0/IL0/I1
         UJWRM/QzuZgxKL8zt/kYGYdQoEw49Z0mYxd6zhmgUSCiv9yYeaXn85tXsWGXKQBeXU
         nwFgkvqky+qqr89+NaH4ApIhfLgga5GNnMVW/Tqc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Franti=C5=A1ek=20Ku=C4=8Dera?= <franta-linux@frantovo.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 58/78] ALSA: usb-audio: Add Pioneer DJ DJM-250MK2 quirk
Date:   Sat, 18 Apr 2020 10:40:27 -0400
Message-Id: <20200418144047.9013-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: František Kučera <franta-linux@frantovo.cz>

[ Upstream commit 73d8c94084341e2895169a0462dbc18167f01683 ]

Pioneer DJ DJM-250MK2 is a mixer that acts like a USB sound card.
The MIDI controller part is standard but the PCM part is "vendor specific".
Output is enabled by this quirk: 8 channels, 48 000 Hz, S24_3LE.
Input is not working.

Signed-off-by: František Kučera <franta-linux@frantovo.cz>
Link: https://lore.kernel.org/r/20200401095907.3387-1-konference@frantovo.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index d187aa6d50db0..dcaf9eed9a415 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3592,5 +3592,47 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 		}
 	}
 },
+{
+	/*
+	 * Pioneer DJ DJM-250MK2
+	 * PCM is 8 channels out @ 48 fixed (endpoints 0x01).
+	 * The output from computer to the mixer is usable.
+	 *
+	 * The input (phono or line to computer) is not working.
+	 * It should be at endpoint 0x82 and probably also 8 channels,
+	 * but it seems that it works only with Pioneer proprietary software.
+	 * Even on officially supported OS, the Audacity was unable to record
+	 * and Mixxx to recognize the control vinyls.
+	 */
+	USB_DEVICE_VENDOR_SPEC(0x2b73, 0x0017),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 8, // outputs
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_48000,
+					.rate_min = 48000,
+					.rate_max = 48000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 48000 }
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 #undef USB_DEVICE_VENDOR_SPEC
-- 
2.20.1

