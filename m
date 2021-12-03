Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091714677B6
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 13:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344940AbhLCNAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 08:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243331AbhLCNAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 08:00:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE52C06173E
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 04:57:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67C75B8268B
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 12:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C5DC53FAD;
        Fri,  3 Dec 2021 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638536232;
        bh=f6ne/ZW8zcgDbvaddv3Z0NWZ89z+6A4TLZoKceyTbrU=;
        h=Subject:To:From:Date:From;
        b=GFRwImgC0mgq53/Dw2j/CvL+g6sRY41nirj7x01zmv0Nd7PxJVCAJeb0vw/kJ1QJt
         nDrx9lMJvLSKgR5kx6Ou759xShxsDWuMAlXPT5UzmuqH/9dIQfrxykd3YopOvtItVV
         bFqvKkyaPaCJz6tzMqAzFXaK/k3yxxXsN6M4Bgos=
Subject: patch "USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub" added to usb-linus
To:     olebowle@gmx.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Dec 2021 13:57:01 +0100
Message-ID: <1638536221252173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d2a004037c3c6afd36d40c384d2905f47cd51c57 Mon Sep 17 00:00:00 2001
From: Ole Ernst <olebowle@gmx.com>
Date: Sat, 27 Nov 2021 10:05:45 +0100
Subject: USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

This is another branded 8153 device that doesn't work well with LPM:
r8152 2-2.1:1.0 enp0s13f0u2u1: Stop submitting intr, status -71

Disable LPM to resolve the issue.

Signed-off-by: Ole Ernst <olebowle@gmx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211127090546.52072-1-olebowle@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 8239fe7129dd..019351c0b52c 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -434,6 +434,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo Powered USB-C Travel Hub (4X90S92381, RTL8153 GigE) */
+	{ USB_DEVICE(0x17ef, 0x721e), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Lenovo ThinkCenter A630Z TI024Gen3 usb-audio */
 	{ USB_DEVICE(0x17ef, 0xa012), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
-- 
2.34.1


