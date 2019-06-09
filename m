Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641063A7BB
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732268AbfFIQwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731715AbfFIQwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B20AC205ED;
        Sun,  9 Jun 2019 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099163;
        bh=W4xXiCNpUlaK05IXKCxUYEQDrxsvb0sVGBlb/OnFcPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFbiZMHYhQ7Zs6A1QjizPXF6fPbrbxQwCj18eOiX9r5eCjK5cpbYFwc7xPDJEqhhr
         rFsJdSV89SaC3chcUUqYoDiiBgmZjAP44E1pCiuOUSgHYx9GQYB429PWjiBZT1h/b0
         QCtQllcpZlXrAPLxUkOlnFF1k4c/PHcGkbZqnKsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.9 33/83] media: smsusb: better handle optional alignment
Date:   Sun,  9 Jun 2019 18:42:03 +0200
Message-Id: <20190609164130.527247035@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

commit a47686636d84eaec5c9c6e84bd5f96bed34d526d upstream.

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
 drivers/media/usb/siano/smsusb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -402,7 +402,7 @@ static int smsusb_init_device(struct usb
 	struct smsusb_device_t *dev;
 	void *mdev;
 	int i, rc;
-	int in_maxp = 0;
+	int align = 0;
 
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);
@@ -420,14 +420,14 @@ static int smsusb_init_device(struct usb
 
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
@@ -446,7 +446,7 @@ static int smsusb_init_device(struct usb
 		/* fall-thru */
 	default:
 		dev->buffer_size = USB2_BUFFER_SIZE;
-		dev->response_alignment = in_maxp - sizeof(struct sms_msg_hdr);
+		dev->response_alignment = align;
 
 		params.flags |= SMS_DEVICE_FAMILY2;
 		break;


