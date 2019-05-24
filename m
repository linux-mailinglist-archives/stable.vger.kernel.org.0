Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890D729ED5
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 21:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391131AbfEXTJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 15:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391113AbfEXTJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 15:09:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D3BE21850;
        Fri, 24 May 2019 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558724988;
        bh=vOIV47M1Z84E3D/E63ZUfJD6M2E7Ym18u5nSkbPy9v8=;
        h=Subject:To:From:Date:From;
        b=vd9u+aKTDzBfXE9dRr4M/g1zERPjo23Te/WTJzEFNrPoqVrzvd1vWEA1x2YGr09Gs
         8C+Am8U2ZOItlccF/yHb2FzF7LYaEqfOC+F6t12kE5SfOQCu84lexSBq9QpQzjz/og
         bi9ucuVRjmolknY1ieP7iG4wRYjlxTXuXUfGDwlM=
Subject: patch "media: smsusb: better handle optional alignment" added to usb-linus
To:     mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 May 2019 21:09:46 +0200
Message-ID: <155872498624655@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    media: smsusb: better handle optional alignment

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a47686636d84eaec5c9c6e84bd5f96bed34d526d Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date: Fri, 24 May 2019 10:59:43 -0400
Subject: media: smsusb: better handle optional alignment

Most Siano devices require an alignment for the response.

Changeset f3be52b0056a ("media: usb: siano: Fix general protection fault in smsusb")
changed the logic with gets such aligment, but it now produces a
sparce warning:

drivers/media/usb/siano/smsusb.c: In function 'smsusb_init_device':
drivers/media/usb/siano/smsusb.c:447:37: warning: 'in_maxp' may be used uninitialized in this function [-Wmaybe-uninitialized]
  447 |   dev->response_alignment = in_maxp - sizeof(struct sms_msg_hdr);
      |                             ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~

The sparse message itself is bogus, but a broken (or fake) USB
eeprom could produce a negative value for response_alignment.

So, change the code in order to check if the result is not
negative.

Fixes: 31e0456de5be ("media: usb: siano: Fix general protection fault in smsusb")
CC: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/siano/smsusb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 59b3c124b49d..e39f3f40dfdd 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -400,7 +400,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	struct smsusb_device_t *dev;
 	void *mdev;
 	int i, rc;
-	int in_maxp = 0;
+	int align = 0;
 
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);
@@ -418,14 +418,14 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 
 		if (desc->bEndpointAddress & USB_DIR_IN) {
 			dev->in_ep = desc->bEndpointAddress;
-			in_maxp = usb_endpoint_maxp(desc);
+			align = usb_endpoint_maxp(desc) - sizeof(struct sms_msg_hdr);
 		} else {
 			dev->out_ep = desc->bEndpointAddress;
 		}
 	}
 
 	pr_debug("in_ep = %02x, out_ep = %02x\n", dev->in_ep, dev->out_ep);
-	if (!dev->in_ep || !dev->out_ep) {	/* Missing endpoints? */
+	if (!dev->in_ep || !dev->out_ep || align < 0) {  /* Missing endpoints? */
 		smsusb_term_device(intf);
 		return -ENODEV;
 	}
@@ -444,7 +444,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		/* fall-thru */
 	default:
 		dev->buffer_size = USB2_BUFFER_SIZE;
-		dev->response_alignment = in_maxp - sizeof(struct sms_msg_hdr);
+		dev->response_alignment = align;
 
 		params.flags |= SMS_DEVICE_FAMILY2;
 		break;
-- 
2.21.0


