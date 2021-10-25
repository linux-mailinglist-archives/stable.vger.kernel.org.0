Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1599A43A2C1
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbhJYTwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236044AbhJYTt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:49:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C97A6124B;
        Mon, 25 Oct 2021 19:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190934;
        bh=XCtuBFO7A7elME7lZJFXAnt+QDL91B0SnpAzlcfySfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbN9TxOHghOat/+VPu3ZZgi3HZFDRxfn0zfGY1HNZ0w+0Cu+3qRkVIrhInLewabs9
         vZ3inLaMA6RYg3byDCd2hp8y7L5TGvY3sCR2Pmp6BV/ROs6/pEPxb79XUKOYCiKRT8
         9sPKjiFowaYF+oJL8cjME2ly/g7TZfUyGlLhNq+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Grieve <brendan@grieve.com.au>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 086/169] ALSA: usb-audio: Provide quirk for Sennheiser GSP670 Headset
Date:   Mon, 25 Oct 2021 21:14:27 +0200
Message-Id: <20211025191028.132516026@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Grieve <brendan@grieve.com.au>

commit 3c414eb65c294719a91a746260085363413f91c1 upstream.

As per discussion at: https://github.com/szszoke/sennheiser-gsp670-pulseaudio-profile/issues/13

The GSP670 has 2 playback and 1 recording device that by default are
detected in an incompatible order for alsa. This may have been done to make
it compatible for the console by the manufacturer and only affects the
latest firmware which uses its own ID.

This quirk will resolve this by reordering the channels.

Signed-off-by: Brendan Grieve <brendan@grieve.com.au>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211015025335.196592-1-brendan@grieve.com.au
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -4080,6 +4080,38 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge
 		}
 	}
 },
+{
+	/*
+	 * Sennheiser GSP670
+	 * Change order of interfaces loaded
+	 */
+	USB_DEVICE(0x1395, 0x0300),
+	.bInterfaceClass = USB_CLASS_PER_INTERFACE,
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			// Communication
+			{
+				.ifnum = 3,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			// Recording
+			{
+				.ifnum = 4,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			// Main
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 #undef USB_DEVICE_VENDOR_SPEC
 #undef USB_AUDIO_DEVICE


