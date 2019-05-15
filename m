Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C0A1F308
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfEOLH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbfEOLH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:07:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB282084E;
        Wed, 15 May 2019 11:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918448;
        bh=08Z4xd9D9Qz6dSAragbPoj3DMIMll9Ryx2BIS7iaqD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QN/OssqEhC7rF4QO6+fwiPlqonkeDBsDwR48wCmyY2XgHPhxTUU2HcckUP1WtMYlw
         CEpYlkapJECOdbqdxSbBuUF7ASHeiOs68xGiP8iNKcd1njzC0W5F6UdQpczueSsDjr
         Zt/VXcv9fMdVQCUxt0312xVN5wOuVZVb4pkN69rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malte Leip <malte@leip.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 135/266] usb: usbip: fix isoc packet num validation in get_pipe
Date:   Wed, 15 May 2019 12:54:02 +0200
Message-Id: <20190515090727.498704313@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c409ca3be3c6ff3a1eeb303b191184e80d412862 upstream.

Backport of the upstream commit, which fixed c6688ef9f297.
c6688ef9f297 got backported as commit b6f826ba10dc, as the unavailable
function usb_endpoint_maxp_mult had to be replaced. The upstream commit
removed the call to this function, so the backport is straightforward.

Original commit message:

Change the validation of number_of_packets in get_pipe to compare the
number of packets to a fixed maximum number of packets allowed, set to
be 1024. This number was chosen due to it being used by other drivers as
well, for example drivers/usb/host/uhci-q.c

Background/reason:
The get_pipe function in stub_rx.c validates the number of packets in
isochronous mode and aborts with an error if that number is too large,
in order to prevent malicious input from possibly triggering large
memory allocations. This was previously done by checking whether
pdu->u.cmd_submit.number_of_packets is bigger than the number of packets
that would be needed for pdu->u.cmd_submit.transfer_buffer_length bytes
if all except possibly the last packet had maximum length, given by
usb_endpoint_maxp(epd) *  usb_endpoint_maxp_mult(epd). This leads to an
error if URBs with packets shorter than the maximum possible length are
submitted, which is allowed according to
Documentation/driver-api/usb/URB.rst and occurs for example with the
snd-usb-audio driver.

Fixes: b6f826ba10dc ("usbip: fix stub_rx: harden CMD_SUBMIT path to handle malicious input")
Signed-off-by: Malte Leip <malte@leip.net>
Cc: stable <stable@vger.kernel.org> # 4.4.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/stub_rx.c      | 18 +++---------------
 drivers/usb/usbip/usbip_common.h |  7 +++++++
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index 56cacb68040c..808e3a317954 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -380,22 +380,10 @@ static int get_pipe(struct stub_device *sdev, struct usbip_header *pdu)
 	}
 
 	if (usb_endpoint_xfer_isoc(epd)) {
-		/* validate packet size and number of packets */
-		unsigned int maxp, packets, bytes;
-
-#define USB_EP_MAXP_MULT_SHIFT  11
-#define USB_EP_MAXP_MULT_MASK   (3 << USB_EP_MAXP_MULT_SHIFT)
-#define USB_EP_MAXP_MULT(m) \
-	(((m) & USB_EP_MAXP_MULT_MASK) >> USB_EP_MAXP_MULT_SHIFT)
-
-		maxp = usb_endpoint_maxp(epd);
-		maxp *= (USB_EP_MAXP_MULT(
-				__le16_to_cpu(epd->wMaxPacketSize)) + 1);
-		bytes = pdu->u.cmd_submit.transfer_buffer_length;
-		packets = DIV_ROUND_UP(bytes, maxp);
-
+		/* validate number of packets */
 		if (pdu->u.cmd_submit.number_of_packets < 0 ||
-		    pdu->u.cmd_submit.number_of_packets > packets) {
+		    pdu->u.cmd_submit.number_of_packets >
+		    USBIP_MAX_ISO_PACKETS) {
 			dev_err(&sdev->udev->dev,
 				"CMD_SUBMIT: isoc invalid num packets %d\n",
 				pdu->u.cmd_submit.number_of_packets);
diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
index 0fc5ace57c0e..af903aa4ad90 100644
--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -134,6 +134,13 @@ extern struct device_attribute dev_attr_usbip_debug;
 #define USBIP_DIR_OUT	0x00
 #define USBIP_DIR_IN	0x01
 
+/*
+ * Arbitrary limit for the maximum number of isochronous packets in an URB,
+ * compare for example the uhci_submit_isochronous function in
+ * drivers/usb/host/uhci-q.c
+ */
+#define USBIP_MAX_ISO_PACKETS 1024
+
 /**
  * struct usbip_header_basic - data pertinent to every request
  * @command: the usbip request type
-- 
2.20.1



