Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772B44454F7
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhKDOTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhKDOSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:18:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34D1861213;
        Thu,  4 Nov 2021 14:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035339;
        bh=77wi4y/lbMM1urKFvGO8y+WMJbAl1RX+grqrk/Rarng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bpup8tY++53/27u39e2WtS5DXYarih62fq+6veCeWO+sxILg971aQYmE4AQY13PXT
         gCvM8+Jc5z1G6D9nWvFIcchlt08AmQ3tb5E37LIpceBs32kEZXbFudcSnrM/WiMxwv
         lc7fNrhDu+vazxV3wdenGQg4kNjsV/8tgrcf0cKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 16/16] ALSA: usb-audio: Add Audient iD14 to mixer map quirk table
Date:   Thu,  4 Nov 2021 15:12:55 +0100
Message-Id: <20211104141200.121491758@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.561284732@linuxfoundation.org>
References: <20211104141159.561284732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit df0380b9539b04c1ae8854a984098da06d5f1e67 upstream.

This is a fix equivalent with the upstream commit df0380b9539b ("ALSA:
usb-audio: Add quirk for Audient iD14"), adapted to the earlier
kernels up to 5.14.y.  It adds the quirk entry with the old
ignore_ctl_error flag to the usbmix_ctl_maps, instead.

The original commit description says:
    Audient iD14 (2708:0002) may get a control message error that
    interferes the operation e.g. with alsactl.  Add the quirk to ignore
    such errors like other devices.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_maps.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -529,6 +529,10 @@ static const struct usbmix_ctl_map usbmi
 		.map = maya44_map,
 	},
 	{
+		.id = USB_ID(0x2708, 0x0002), /* Audient iD14 */
+		.ignore_ctl_error = 1,
+	},
+	{
 		/* KEF X300A */
 		.id = USB_ID(0x27ac, 0x1000),
 		.map = scms_usb3318_map,


