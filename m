Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99F7EEE23
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388422AbfKDWMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:12:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390329AbfKDWLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:11:17 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B048220650;
        Mon,  4 Nov 2019 22:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905477;
        bh=fKVtyvE5Vtf/zeKnqiucULgLROOSqzSjwshGsT3tSp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlRvSepN6i3XP06ss1hG2WAgMUuzbUrWx/1r52xi1wHWMEVMj1D2V/jUexk4Y4cGq
         8H1DeNwMD0aopBfADI3zSx6ooZm2scZ1oY0u7K1ND16qNWp6x0RIYDQ6v+nLu5zKLA
         g2Gt6bfdOQSoAr7RG3RUsE52KwTXcQXTZl2SDpgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Laako <jussi@sonarnerd.net>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 159/163] ALSA: usb-audio: DSD auto-detection for Playback Designs
Date:   Mon,  4 Nov 2019 22:45:49 +0100
Message-Id: <20191104212151.793274768@linuxfoundation.org>
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

[ Upstream commit eb7505d52a2f8b0cfc3fd7146d8cb2dab5a73f0d ]

Add DSD support auto-detection for newer Playback Designs devices. Older
device generations have a different USB interface implementation.

Keep the auto-detection VID whitelist sorted.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b6f7b13768a10..6f228b4ec8c3e 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1563,7 +1563,8 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	struct usb_interface *iface;
 
 	/* Playback Designs */
-	if (USB_ID_VENDOR(chip->usb_id) == 0x23ba) {
+	if (USB_ID_VENDOR(chip->usb_id) == 0x23ba &&
+	    USB_ID_PRODUCT(chip->usb_id) < 0x0110) {
 		switch (fp->altsetting) {
 		case 1:
 			fp->dsd_dop = true;
@@ -1651,8 +1652,9 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	 * from XMOS/Thesycon
 	 */
 	switch (USB_ID_VENDOR(chip->usb_id)) {
-	case 0x20b1:  /* XMOS based devices */
 	case 0x152a:  /* Thesycon devices */
+	case 0x20b1:  /* XMOS based devices */
+	case 0x23ba:  /* Playback Designs */
 	case 0x25ce:  /* Mytek devices */
 	case 0x2ab6:  /* T+A devices */
 	case 0x3842:  /* EVGA */
-- 
2.20.1



