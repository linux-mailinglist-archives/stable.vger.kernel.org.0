Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6B829A73
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 17:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404054AbfEXO77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 10:59:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39512 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403981AbfEXO77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 10:59:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lshiZsOEFd0dPqDO61Y6UOKGtKKO4excHyVp2mtvUyw=; b=hhkYHyYHg+VnGChApahUW95Uk
        9yqIcekbu8cN1PqVuy/yaye74wVvS92tGkwoASuFOBARzyoX4ws1SRd9V7NjeTgBGUNql7TbXW16p
        XMv4Q07HgoNzVt4spe/fL/mHEIr8LDeZ4WZKzyxX9ARwFL2W5EMbWXbgUMKxU2SmHo1/g6RQzWkmk
        w4ciYS1SmAPQnZMl8U4ih/8CW0UxfDq5gfc5YyAROXN/FNo5DV3DHyDP/gMRnBn+uXpqVvZGp24Lu
        yMuPM7QF24eV8Td9STEg3weZDsTDFignNj963KnqmVFEme9PPfqKvGpNcroVM9u7CcJkl1UIFuXJX
        FqoliF7UQ==;
Received: from 177.97.63.247.dynamic.adsl.gvt.net.br ([177.97.63.247] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hUBfi-0002GG-58; Fri, 24 May 2019 14:59:50 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hUBfc-00055M-Eg; Fri, 24 May 2019 10:59:44 -0400
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Allison Randal <allison@lohutok.net>,
        Steve Winslow <swinslow@gmail.com>,
        Wen Yang <wen.yang99@zte.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH v2] media: smsusb: better handle optional alignment
Date:   Fri, 24 May 2019 10:59:43 -0400
Message-Id: <c53ea00f339529f69b89deac620e4ab540717eb9.1558709939.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: f3be52b0056a ("media: usb: siano: Fix general protection fault in smsusb")
CC: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---

Greg,

As the Alan patches went via your tree, please apply this one too.

 drivers/media/usb/siano/smsusb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index f5e69fdf1242..9ba3a2ae36e5 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -389,7 +389,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	struct smsusb_device_t *dev;
 	void *mdev;
 	int i, rc;
-	int in_maxp = 0;
+	int align = 0;
 
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);
@@ -407,14 +407,14 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 
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
@@ -433,7 +433,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		/* fall-thru */
 	default:
 		dev->buffer_size = USB2_BUFFER_SIZE;
-		dev->response_alignment = in_maxp - sizeof(struct sms_msg_hdr);
+		dev->response_alignment = align;
 
 		params.flags |= SMS_DEVICE_FAMILY2;
 		break;
-- 
2.21.0


