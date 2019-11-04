Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 003D2EEE14
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390648AbfKDWLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:11:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390672AbfKDWLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:11:20 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DBE9214E0;
        Mon,  4 Nov 2019 22:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905480;
        bh=8z0qBlbEOBQDp32X8e2iJrESJlQsT7JkSfkozigVFNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOK6O+1g5LF5O7bm27UyKPeF79FeAurDJ0f2F4OwDd66vu4tWK7fMS45gRyMeTj15
         nyD3j5DkAe6z9DN1Fq42SA7Irz38AXkHCSem0YHUSq0YDqJeOMp9aZ/wQvXxt6tEns
         ZsnwS+mwDjDmXuwsa9ogTH4xO75yIXLMyf/TDj7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Laako <jussi@sonarnerd.net>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 160/163] ALSA: usb-audio: Update DSD support quirks for Oppo and Rotel
Date:   Mon,  4 Nov 2019 22:45:50 +0100
Message-Id: <20191104212151.876934624@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jussi Laako <jussi@sonarnerd.net>

[ Upstream commit 0067e154b11e236d62a7a8205f321b097c21a35b ]

Oppo has issued firmware updates that change alt setting used for DSD
support. However, these devices seem to support auto-detection, so
support is moved from explicit whitelisting to auto-detection.

Also Rotel devices have USB interfaces that support DSD with
auto-detection.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 6f228b4ec8c3e..33d52ab6ebad0 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1581,9 +1581,6 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	/* XMOS based USB DACs */
 	switch (chip->usb_id) {
 	case USB_ID(0x1511, 0x0037): /* AURALiC VEGA */
-	case USB_ID(0x22d9, 0x0416): /* OPPO HA-1 */
-	case USB_ID(0x22d9, 0x0436): /* OPPO Sonica */
-	case USB_ID(0x22d9, 0x0461): /* OPPO UDP-205 */
 	case USB_ID(0x2522, 0x0012): /* LH Labs VI DAC Infinity */
 	case USB_ID(0x2772, 0x0230): /* Pro-Ject Pre Box S2 Digital */
 		if (fp->altsetting == 2)
@@ -1597,7 +1594,6 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	case USB_ID(0x16d0, 0x0733): /* Furutech ADL Stratos */
 	case USB_ID(0x16d0, 0x09db): /* NuPrime Audio DAC-9 */
 	case USB_ID(0x1db5, 0x0003): /* Bryston BDA3 */
-	case USB_ID(0x22d9, 0x0426): /* OPPO HA-2 */
 	case USB_ID(0x22e1, 0xca01): /* HDTA Serenade DSD */
 	case USB_ID(0x249c, 0x9326): /* M2Tech Young MkIII */
 	case USB_ID(0x2616, 0x0106): /* PS Audio NuWave DAC */
@@ -1654,8 +1650,10 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	switch (USB_ID_VENDOR(chip->usb_id)) {
 	case 0x152a:  /* Thesycon devices */
 	case 0x20b1:  /* XMOS based devices */
+	case 0x22d9:  /* Oppo */
 	case 0x23ba:  /* Playback Designs */
 	case 0x25ce:  /* Mytek devices */
+	case 0x278b:  /* Rotel? */
 	case 0x2ab6:  /* T+A devices */
 	case 0x3842:  /* EVGA */
 	case 0xc502:  /* HiBy devices */
-- 
2.20.1



