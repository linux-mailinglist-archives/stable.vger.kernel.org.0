Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B05C259641
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgIAQAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgIAQAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 12:00:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D65B206EB;
        Tue,  1 Sep 2020 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598976022;
        bh=AZgGkmsEKBiJExdxkihjVPR+JtprHDCEAxlOGifQRsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nq6oi/unh9OQ+KrSq/80AUKhuKybZ2qkuGsGRhvsko2ONEYZB++YJA+WVfD3rnc0H
         W1UvZzV0R3teYS9uG4vMOzJYh4lvmqccO8tbEaig1o3wwudZtPatD6PrLr5Au3y8Jw
         HBi5LQ0PlT9IuetXIyMGJ2p8joeHoRY/HpS6LV1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/214] ALSA: usb-audio: Add capture support for Saffire 6 (USB 1.1)
Date:   Tue,  1 Sep 2020 17:09:37 +0200
Message-Id: <20200901150957.640240872@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

[ Upstream commit 470757f5b3a46bd85741bb0d8c1fd3f21048a2af ]

Capture and playback endpoints on Saffire 6 (USB 1.1) resides on the same
interface. This was not supported by the composite quirk back in the day
when initial support for this device was added, thus only playback was
enabled until now.

Fixes: 11e424e88bd4 ("ALSA: usb-audio: Add support for Focusrite Saffire 6 USB")
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Cc: <stable.vger.kernel.org>
Link: https://lore.kernel.org/r/20200815002103.29247-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 1573229d8cf4c..2d335fdae28ed 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2695,6 +2695,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.ifnum = QUIRK_ANY_INTERFACE,
 		.type = QUIRK_COMPOSITE,
 		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_STANDARD_MIXER,
+			},
 			{
 				.ifnum = 0,
 				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
@@ -2707,6 +2711,32 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.attributes = UAC_EP_CS_ATTR_SAMPLE_RATE,
 					.endpoint = 0x01,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC,
+					.datainterval = 1,
+					.maxpacksize = 0x024c,
+					.rates = SNDRV_PCM_RATE_44100 |
+						 SNDRV_PCM_RATE_48000,
+					.rate_min = 44100,
+					.rate_max = 48000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) {
+						44100, 48000
+					}
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
+					.attributes = 0,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC,
+					.datainterval = 1,
+					.maxpacksize = 0x0126,
 					.rates = SNDRV_PCM_RATE_44100 |
 						 SNDRV_PCM_RATE_48000,
 					.rate_min = 44100,
-- 
2.25.1



