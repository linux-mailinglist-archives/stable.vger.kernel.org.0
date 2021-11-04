Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CA24454D6
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhKDOSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231919AbhKDORd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06100611C1;
        Thu,  4 Nov 2021 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035295;
        bh=w/K6LTDPvitp77ZJOGzCUIMPaqqj3t9T6pvmK1zUl8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5ekOSnfo7k6X5zhDzSjYPW+RqApj6lSXF2eav3BOPoIdA+4doHk+tLIhELfDaY+M
         Nr3k1dvEpnG6yI4/DYbd+BKIQgADYxyzVeyix224US4vkR/7NqY0p2Y7xxnKK4Sdg8
         ncyQHxA3kANK46ZlTRTVSQqsrADeddTiOKnvevA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 15/16] ALSA: usb-audio: Add Schiit Hel device to mixer map quirk table
Date:   Thu,  4 Nov 2021 15:12:46 +0100
Message-Id: <20211104141200.375518680@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
References: <20211104141159.863820939@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 22390ce786c59328ccd13c329959dee1e8757487 upstream.

This is a fix equivalent with the upstream commit 22390ce786c5 ("ALSA:
usb-audio: add Schiit Hel device to quirk table"), adapted to the
earlier kernels up to 5.14.y.  It adds the quirk entry with the old
ignore_ctl_error flag to the usbmix_ctl_maps, instead.

The original patch description says:
    The Shciit Hel device responds to the ctl message for the mic capture
    switch with a timeout of -EPIPE:

            usb 7-2.2: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x1100, type = 1
            usb 7-2.2: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x1100, type = 1
            usb 7-2.2: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x1100, type = 1
            usb 7-2.2: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x1100, type = 1

    This seems safe to ignore as the device works properly with the control
    message quirk, so add it to the quirk table so all is good.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_maps.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -539,6 +539,10 @@ static const struct usbmix_ctl_map usbmi
 		.map = scms_usb3318_map,
 	},
 	{
+		.id = USB_ID(0x30be, 0x0101), /*  Schiit Hel */
+		.ignore_ctl_error = 1,
+	},
+	{
 		/* Bose Companion 5 */
 		.id = USB_ID(0x05a7, 0x1020),
 		.map = bose_companion5_map,


