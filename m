Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E77119D68
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbfLJWdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:33:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbfLJWdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:33:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DA902077B;
        Tue, 10 Dec 2019 22:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017228;
        bh=GI466eaFq8/XIs0M1Zy1iGa8Bm7REhY6rlR8sEXAIbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqSjANwS+++UTv87EcwWeIoE3Mv1fSeiwCCfw94r2Ky2CpygIZvPFya5ffpWVjJJ4
         JWAMGWWcEr2TRZICm8YZoQpZRwg7G7Q8soQEVTu/d+8XFk0hmDmvjzV0ilsbUskfHp
         mAIqq4cUoGRvRm1OYZoVc/aA4FTSxHxk06DFUask=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ingo Rohloff <ingo.rohloff@lauterbach.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 26/71] usb: usbfs: Suppress problematic bind and unbind uevents.
Date:   Tue, 10 Dec 2019 17:32:31 -0500
Message-Id: <20191210223316.14988-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
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
index 7559d96695da6..4ef2484cf9935 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -640,8 +640,15 @@ static int claimintf(struct usb_dev_state *ps, unsigned int ifnum)
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
@@ -661,7 +668,13 @@ static int releaseintf(struct usb_dev_state *ps, unsigned int ifnum)
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

