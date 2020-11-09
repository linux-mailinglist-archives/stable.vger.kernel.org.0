Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230472ABA52
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733197AbgKINRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:17:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387633AbgKINRs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31CBD20731;
        Mon,  9 Nov 2020 13:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927867;
        bh=CEZbi1kVf0xhXwPVHKSR9gv71nyLzjje+/DpAtNGJD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtgSPLA2vx1qIKXGEnlCFePm1DO13qF+UWGK+wgDQt2Ak2VcMvdrJMZrA4exOreAN
         1va0WV/QQDvt+vgWYa5pgp534lF6HpCqgddxSI9q8sC65CGbqik7J1kGNqLagmblxG
         YHtyyKloWw6Te3lZ4UJxO6yF4R/HBydkuvKCkxvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Winstein <keithw@cs.stanford.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 048/133] ALSA: usb-audio: Add implicit feedback quirk for Zoom UAC-2
Date:   Mon,  9 Nov 2020 13:55:10 +0100
Message-Id: <20201109125033.028794993@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Winstein <keithw@cs.stanford.edu>

commit f15cfca818d756dd1c9492530091dfd583359db3 upstream.

The Zoom UAC-2 USB audio interface provides an async playback endpoint
("1 OUT (ASYNC)") and capture endpoint ("2 IN (ASYNC)"), both with
2-channel S32_LE in 44.1, 48, 88.2, 96, 176.4, or 192
kilosamples/s. The device provides explicit feedback to adjust the
host's playback rate, but the feedback appears unstable and biased
relative to the device's capture rate.

"alsaloop -t 1000" experiences playback underruns and tries to
resample the captured audio to match the varying playback
rate. Forcing the kernel to use implicit feedback appears to
produce more stable results. This causes the host to transmit one
playback sample for each capture sample received. (Zoom North America
has been notified of this change.)

Signed-off-by: Keith Winstein <keithw@cs.stanford.edu>
Tested-by: Keith Winstein <keithw@cs.stanford.edu>
Cc: <stable@vger.kernel.org>
BugLink: https://lore.kernel.org/r/20201027071841.GA164525@trolley.csail.mit.edu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -352,6 +352,10 @@ static int set_sync_ep_implicit_fb_quirk
 		ep = 0x81;
 		ifnum = 2;
 		goto add_sync_ep_from_ifnum;
+	case USB_ID(0x1686, 0xf029): /* Zoom UAC-2 */
+		ep = 0x82;
+		ifnum = 2;
+		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x1397, 0x0001): /* Behringer UFX1604 */
 	case USB_ID(0x1397, 0x0002): /* Behringer UFX1204 */
 		ep = 0x81;


