Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C842B1D4D
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 15:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgKMO0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 09:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgKMO0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 09:26:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F7B822242;
        Fri, 13 Nov 2020 14:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605277567;
        bh=sszQCEzWvOA/1E1RBxQRT5gt9ut1mil9btUJlEe75w4=;
        h=Subject:To:From:Date:From;
        b=XfPVPcTyWBTgS4Huvhp99EvgmZJHE+igWDWl1oFEgYMaT/59XAfSsO2yH+Td7TpAZ
         BBNh6JVZZzwg2N7XAdm11U6Fr7q/4J/JaaOfWeFP4N30vw9x2A0O07bl1J+gr0rlL5
         moV1thQ624OpEplz8Auwp2XtyzariDKzfGj1DTRQ=
Subject: patch "usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode" added to usb-linus
To:     chris.brandt@renesas.com, gregkh@linuxfoundation.org,
        oneukum@suse.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 Nov 2020 15:27:03 +0100
Message-ID: <1605277623101117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6d853c9e4104b4fc8d55dc9cd3b99712aa347174 Mon Sep 17 00:00:00 2001
From: Chris Brandt <chris.brandt@renesas.com>
Date: Wed, 11 Nov 2020 08:12:09 -0500
Subject: usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode

Renesas R-Car and RZ/G SoCs have a firmware download mode over USB.
However, on reset a banner string is transmitted out which is not expected
to be echoed back and will corrupt the protocol.

Cc: stable <stable@vger.kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Link: https://lore.kernel.org/r/20201111131209.3977903-1-chris.brandt@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 1e7568867910..f52f1bc0559f 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1693,6 +1693,15 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0870, 0x0001), /* Metricom GS Modem */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x045b, 0x023c),	/* Renesas USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
+	{ USB_DEVICE(0x045b, 0x0248),	/* Renesas USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
+	{ USB_DEVICE(0x045b, 0x024D),	/* Renesas USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
 	{ USB_DEVICE(0x0e8d, 0x0003), /* FIREFLY, MediaTek Inc; andrey.arapov@gmail.com */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
-- 
2.29.2


