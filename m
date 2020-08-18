Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1EC2486DC
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 16:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgHRONO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 10:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgHRONF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 10:13:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAA20207FF;
        Tue, 18 Aug 2020 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597759984;
        bh=vc4g7F9aaVhEifQEhvEqrMH8luckly4hNFdkM/DNNHw=;
        h=Subject:To:From:Date:From;
        b=G6Ht1OSPEAn1tVAVH5linuvBaISxKmcqsNriiMUQEpGpwZpIOYgiY3pIF9WdmPsmU
         Hvee1GOWrZV9oXje5ta1ov0VxepNn5PXIvajctHO/5dlaoKHMbrkdWncyoUwYsaNlr
         UsCbpcp5MohtWYByaHqdLwCIV2n7oBPi8b+7shNw=
Subject: patch "staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()" added to staging-linus
To:     rkovhaev@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 16:13:19 +0200
Message-ID: <1597759999100233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fea22e159d51c766ba70473f473a0ec914cc7e92 Mon Sep 17 00:00:00 2001
From: Rustam Kovhaev <rkovhaev@gmail.com>
Date: Tue, 4 Aug 2020 07:56:14 -0700
Subject: staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()

let's use usb_find_common_endpoints() to discover endpoints, it does all
necessary checks for type and xfer direction

remove memset() in hfa384x_create(), because we now assign endpoints in
prism2sta_probe_usb() and because create_wlan() uses kzalloc() to
allocate hfa384x struct before calling hfa384x_create()

Fixes: faaff9765664 ("staging: wlan-ng: properly check endpoint types")
Reported-and-tested-by: syzbot+22794221ab96b0bab53a@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=22794221ab96b0bab53a
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200804145614.104320-1-rkovhaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |  5 -----
 drivers/staging/wlan-ng/prism2usb.c   | 19 ++++++-------------
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index fa1bf8b069fd..2720f7319a3d 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -524,13 +524,8 @@ static void hfa384x_usb_defer(struct work_struct *data)
  */
 void hfa384x_create(struct hfa384x *hw, struct usb_device *usb)
 {
-	memset(hw, 0, sizeof(*hw));
 	hw->usb = usb;
 
-	/* set up the endpoints */
-	hw->endp_in = usb_rcvbulkpipe(usb, 1);
-	hw->endp_out = usb_sndbulkpipe(usb, 2);
-
 	/* Set up the waitq */
 	init_waitqueue_head(&hw->cmdq);
 
diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 456603fd26c0..4b08dc1da4f9 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -61,23 +61,14 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
 	struct usb_device *dev;
-	const struct usb_endpoint_descriptor *epd;
-	const struct usb_host_interface *iface_desc = interface->cur_altsetting;
+	struct usb_endpoint_descriptor *bulk_in, *bulk_out;
+	struct usb_host_interface *iface_desc = interface->cur_altsetting;
 	struct wlandevice *wlandev = NULL;
 	struct hfa384x *hw = NULL;
 	int result = 0;
 
-	if (iface_desc->desc.bNumEndpoints != 2) {
-		result = -ENODEV;
-		goto failed;
-	}
-
-	result = -EINVAL;
-	epd = &iface_desc->endpoint[1].desc;
-	if (!usb_endpoint_is_bulk_in(epd))
-		goto failed;
-	epd = &iface_desc->endpoint[2].desc;
-	if (!usb_endpoint_is_bulk_out(epd))
+	result = usb_find_common_endpoints(iface_desc, &bulk_in, &bulk_out, NULL, NULL);
+	if (result)
 		goto failed;
 
 	dev = interface_to_usbdev(interface);
@@ -96,6 +87,8 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 	}
 
 	/* Initialize the hw data */
+	hw->endp_in = usb_rcvbulkpipe(dev, bulk_in->bEndpointAddress);
+	hw->endp_out = usb_sndbulkpipe(dev, bulk_out->bEndpointAddress);
 	hfa384x_create(hw, dev);
 	hw->wlandev = wlandev;
 
-- 
2.28.0


