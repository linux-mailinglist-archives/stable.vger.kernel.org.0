Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1078FDB17
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 11:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfKOKSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 05:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfKOKSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 05:18:32 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C06D2075E;
        Fri, 15 Nov 2019 10:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573813111;
        bh=WcPO7ZCQNgbsbpm3lP/bG/nX+L2kZBYuxiefS9HaR74=;
        h=Subject:To:From:Date:From;
        b=GhhPCZ4myRC1CzMBW1up34r0fMA/5KP+FU+6f+eGZu6kcfeNOxjNPuZiJHLozZR1K
         HoqlWWyV0kSoAIH9deninZDpGtawqyIbg3RJgtZVxLv/F3wHtO2MhrUk02WrvZDZeK
         LyhjW6odYq3xhydGwiyTET77eKX3YZ7w3rkuOIKs=
Subject: patch "USB: serial: mos7840: fix remote wakeup" added to usb-next
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Nov 2019 18:18:23 +0800
Message-ID: <1573813103175192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: mos7840: fix remote wakeup

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 92fe35fb9c70a00d8fbbf5bd6172c921dd9c7815 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 7 Nov 2019 14:21:19 +0100
Subject: USB: serial: mos7840: fix remote wakeup

The driver was setting the device remote-wakeup feature during probe in
violation of the USB specification (which says it should only be set
just prior to suspending the device). This could potentially waste
power during suspend as well as lead to spurious wakeups.

Note that USB core would clear the remote-wakeup feature at first
resume.

Fixes: 3f5429746d91 ("USB: Moschip 7840 USB-Serial Driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/mos7840.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 3eeeee38debc..ab4bf8d6d7df 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2290,11 +2290,6 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			goto error;
 		} else
 			dev_dbg(&port->dev, "ZLP_REG5 Writing success status%d\n", status);
-
-		/* setting configuration feature to one */
-		usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-				0x03, 0x00, 0x01, 0x00, NULL, 0x00,
-				MOS_WDR_TIMEOUT);
 	}
 	return 0;
 error:
-- 
2.24.0


