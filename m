Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE51323CE6
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhBXM6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235362AbhBXMy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:54:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7239164F20;
        Wed, 24 Feb 2021 12:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171091;
        bh=kzVKGCQ6HF9WnYSw5/VgvvEwufPow9Ok0gOs9lYLebE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQGmbzbstksFVe/E123NUpPNzQpD+y906dAKo44KvrllHYPZEUWpTmws/YGaCNPhq
         qbMAoQ9qdD40XCjDPZ9urnQwQSUT86fE0R0LMr0bScDR0EtR2qxyq4T9GRwm8HyAoc
         5NbaeoM6iq1dr3rbq6GL9Ly0+ya9YOAUbSr+ZW75KSiAN3yswzEt13P9Ebd59wl4U4
         20jlGMOlJtOPhmFnFY51S6TRUJsFdH+F2RfrT+wsr5PdT/6TIuXmnBVP6qOxt+qFvf
         5rpcQu4keu3XClFWBx2dmtXqB0P2YmlNBVzQNBljMxQg/irhgpmiuV+B4jyta/kfnZ
         R4yvebFPSgEfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olivia Mackintosh <livvy@base.nu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 48/67] ALSA: usb-audio: Add DJM-450 to the quirks table
Date:   Wed, 24 Feb 2021 07:50:06 -0500
Message-Id: <20210224125026.481804-48-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivia Mackintosh <livvy@base.nu>

[ Upstream commit 9119e5661eab2c56a96b936cde49c6740dc49ff9 ]

As with most Pioneer devices, the device descriptor is vendor specific
and as such, the number of channels, the PCM format, endpoints and
sample rate need to be specified. This device has 8 inputs and 8 outputs
and a sample rate of 48000 only. The PCM format is S24_3LE like other
devices.

There seems to be an appetite for reducing duplication amongs these
Pioneer patches but again, I feel this is a step to be taken after
support has been added as it's not completely clear where the
commonalities are.

Signed-off-by: Olivia Mackintosh <livvy@base.nu>
Link: https://lore.kernel.org/r/20210202134225.3217-3-livvy@base.nu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 57 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 93d55cd1a5a4c..1165a5ac60f22 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3817,6 +3817,63 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 		}
 	}
 },
+{
+	/*
+	 * Pioneer DJ DJM-450
+	 * PCM is 8 channels out @ 48 fixed (endpoint 0x01)
+	 * and 8 channels in @ 48 fixed (endpoint 0x82).
+	 */
+	USB_DEVICE_VENDOR_SPEC(0x2b73, 0x0013),
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
+					}
+			},
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 8, // inputs
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x82,
+					.ep_idx = 1,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						USB_ENDPOINT_SYNC_ASYNC|
+						USB_ENDPOINT_USAGE_IMPLICIT_FB,
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
 #undef USB_AUDIO_DEVICE
-- 
2.27.0

