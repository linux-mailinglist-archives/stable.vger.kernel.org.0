Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C2712ED6E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgABW2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729919AbgABW2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:28:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A045A222C3;
        Thu,  2 Jan 2020 22:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004096;
        bh=K0mf4DwA2SgNLoG6tok4AMxYIa9rnH7Df8yEE6LbeMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xa7urK43eriNZ+OtI7oBkmIQv7RO1WNEPxNiy/jJz+cgr2I35bQB7nRHBEOdX50rk
         p1Z8pyDApIpDslWDLoTGE+p9niYf0deyqLbrZJrmr22rwN4r4tILoheUzPuRdIvIB1
         LqUccglZB7uJ16jjiwKvcDhV7cZAXtwge3QNeVJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Rohloff <ingo.rohloff@lauterbach.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 035/171] usb: usbfs: Suppress problematic bind and unbind uevents.
Date:   Thu,  2 Jan 2020 23:06:06 +0100
Message-Id: <20200102220551.928295408@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingo Rohloff <ingo.rohloff@lauterbach.com>

[ Upstream commit abb0b3d96a1f9407dd66831ae33985a386d4200d ]

commit 1455cf8dbfd0 ("driver core: emit uevents when device is bound
to a driver") added bind and unbind uevents when a driver is bound or
unbound to a physical device.

For USB devices which are handled via the generic usbfs layer (via
libusb for example), this is problematic:
Each time a user space program calls
   ioctl(usb_fd, USBDEVFS_CLAIMINTERFACE, &usb_intf_nr);
and then later
   ioctl(usb_fd, USBDEVFS_RELEASEINTERFACE, &usb_intf_nr);
The kernel will now produce a bind or unbind event, which does not
really contain any useful information.

This allows a user space program to run a DoS attack against programs
which listen to uevents (in particular systemd/eudev/upowerd):
A malicious user space program just has to call in a tight loop

   ioctl(usb_fd, USBDEVFS_CLAIMINTERFACE, &usb_intf_nr);
   ioctl(usb_fd, USBDEVFS_RELEASEINTERFACE, &usb_intf_nr);

With this loop the malicious user space program floods the kernel and
all programs listening to uevents with tons of bind and unbind
events.

This patch suppresses uevents for ioctls USBDEVFS_CLAIMINTERFACE and
USBDEVFS_RELEASEINTERFACE.

Signed-off-by: Ingo Rohloff <ingo.rohloff@lauterbach.com>
Link: https://lore.kernel.org/r/20191011115518.2801-1-ingo.rohloff@lauterbach.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/devio.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 06a8f645106b..059e71d71b66 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -754,8 +754,15 @@ static int claimintf(struct usb_dev_state *ps, unsigned int ifnum)
 	intf = usb_ifnum_to_if(dev, ifnum);
 	if (!intf)
 		err = -ENOENT;
-	else
+	else {
+		unsigned int old_suppress;
+
+		/* suppress uevents while claiming interface */
+		old_suppress = dev_get_uevent_suppress(&intf->dev);
+		dev_set_uevent_suppress(&intf->dev, 1);
 		err = usb_driver_claim_interface(&usbfs_driver, intf, ps);
+		dev_set_uevent_suppress(&intf->dev, old_suppress);
+	}
 	if (err == 0)
 		set_bit(ifnum, &ps->ifclaimed);
 	return err;
@@ -775,7 +782,13 @@ static int releaseintf(struct usb_dev_state *ps, unsigned int ifnum)
 	if (!intf)
 		err = -ENOENT;
 	else if (test_and_clear_bit(ifnum, &ps->ifclaimed)) {
+		unsigned int old_suppress;
+
+		/* suppress uevents while releasing interface */
+		old_suppress = dev_get_uevent_suppress(&intf->dev);
+		dev_set_uevent_suppress(&intf->dev, 1);
 		usb_driver_release_interface(&usbfs_driver, intf);
+		dev_set_uevent_suppress(&intf->dev, old_suppress);
 		err = 0;
 	}
 	return err;
-- 
2.20.1



