Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403C2119C82
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfLJWbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:31:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbfLJWbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:31:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030C120838;
        Tue, 10 Dec 2019 22:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017075;
        bh=Xd752C+IVCZ0sm9nxYhtVz0fUF142BHtq4iOXmpz0+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eelbaeht+2Ta/0tjebPcXCEkTwK1V/n9sRvZGKq34ljM/q38lsOBetM/CMVncNHRk
         RWYogj+2mEY7hnsbB+VK0uQrGcU5eDVjrEDo/hH2v61e8Mz+XqUsvYR6O0Q/SeX17L
         DjM9Q0q+VAf3kNrPtWBK90CNc0HQpz3vgdqv8NNM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ingo Rohloff <ingo.rohloff@lauterbach.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 33/91] usb: usbfs: Suppress problematic bind and unbind uevents.
Date:   Tue, 10 Dec 2019 17:29:37 -0500
Message-Id: <20191210223035.14270-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 06a8f645106bf..059e71d71b666 100644
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

