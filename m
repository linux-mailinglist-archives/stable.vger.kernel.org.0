Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C8C373A3C
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhEEMI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233473AbhEEMHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:07:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5DB361222;
        Wed,  5 May 2021 12:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216409;
        bh=Ud597iU/8P0D7b52x+XioGu5P2ZyZ8koVkfoMggNh1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQMKTFDpgKIbVatQfoS+2hS8NEiQQ0nxm4A2GtqDWEbZxKCwH3gJO5YVdRgz4MSnx
         jrLtJefsAA+E8VvfoqHZNRVDNqVFnxp36ZfrSvG59kd1CUMdoKSf85SaUBrtEZfkfV
         iP+5mE3jihPsqhT57JzbQArvSOacnrg0Vhj5efJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 23/29] ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX
Date:   Wed,  5 May 2021 14:05:26 +0200
Message-Id: <20210505112326.972075365@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
References: <20210505112326.195493232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 64f40f9be14106e7df0098c427cb60be645bddb7 upstream.

ToneLab EX guitar pedal device requires the same quirk like ToneLab ST
for supporting the MIDI.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212593
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210407144549.1530-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2376,6 +2376,16 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+{
+	USB_DEVICE_VENDOR_SPEC(0x0944, 0x0204),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		.vendor_name = "KORG, Inc.",
+		/* .product_name = "ToneLab EX", */
+		.ifnum = 3,
+		.type = QUIRK_MIDI_STANDARD_INTERFACE,
+	}
+},
+
 /* AKAI devices */
 {
 	USB_DEVICE(0x09e8, 0x0062),


