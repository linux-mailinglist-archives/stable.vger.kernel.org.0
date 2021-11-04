Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A97445220
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 12:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhKDLZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 07:25:59 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40944 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhKDLZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 07:25:58 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A88551FD33;
        Thu,  4 Nov 2021 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636024999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LiVBXHb/glI4tAzlQeMAXa99YIQ89J0OIky1q+J4odI=;
        b=B147q/W4gpkRlRU39ZswzsqNkbQwvf7IZRhXIjNQq9SwakpIu7C4LCOEKNtL2BLG6TrT3/
        lP1AaFC49PvYb1HxkxXXrZ2gcNp/CemegoqOj8W2Zd+gtAQkgm8gLdGswjuWomwULvx8Hy
        OoL3OklGqmAKEo0Mmr/gHh7QbXeLxVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636024999;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LiVBXHb/glI4tAzlQeMAXa99YIQ89J0OIky1q+J4odI=;
        b=UJI5H5IxE6nYA0cynoZCchgq8NyZJIB51YTL3WjUcaOyM3MKwXRSdjad3OYuSUDW1/i6Pu
        fJ6B2iRJSw58D1AQ==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id A0E222C150;
        Thu,  4 Nov 2021 11:23:19 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.14.y 1/2] ALSA: usb-audio: Add Schiit Hel device to mixer map quirk table
Date:   Thu,  4 Nov 2021 12:23:08 +0100
Message-Id: <20211104112309.30984-2-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211104112309.30984-1-tiwai@suse.de>
References: <20211104112309.30984-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 sound/usb/mixer_maps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index c5794e83fd80..809ac6d18d2b 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -538,6 +538,10 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x25c4, 0x0003),
 		.map = scms_usb3318_map,
 	},
+	{
+		.id = USB_ID(0x30be, 0x0101), /*  Schiit Hel */
+		.ignore_ctl_error = 1,
+	},
 	{
 		/* Bose Companion 5 */
 		.id = USB_ID(0x05a7, 0x1020),
-- 
2.31.1

