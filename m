Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526F713F81
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 15:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfEENBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 09:01:17 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:45287 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725873AbfEENBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 09:01:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3676C35C;
        Sun,  5 May 2019 09:01:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 05 May 2019 09:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Zn//iS
        /DVMCohmbgYEOua0+xj5lDSleDC14QPZkhou8=; b=TSuu11ugrZHO/dhrRaZiW3
        8SevZIXTR/CyV/TxXR2jn1e9ywHQF5Lcqm7rA5UIyR+7L7B4QU47ZXYsQabdoiP3
        06YkTYmoDdxOZdhkuUgeSedCkO5sRWjcitrhM+7vuJTPUxA6ZUHl/+SzNHFM5tCc
        hwFyM0rxUI51XyxFB2rOSxwe6RgA1jIVt0J2TExEmIxv9KQq9IItlPY8cn5CPYqk
        Bo4+LpblOtPd5Ye+/O2gKHhWry5WVLZVJ1OwBjZAZ0qcpsBMtioLxH9j5Ylgu7EN
        6wlwNx0jwjLKdstBOXDpUehDW7gr8TQl8yLyHKUY1iyrT43nog2TrMQ4+nMPAeRA
        ==
X-ME-Sender: <xms:m97OXG9yTyAz9VqG2cnLwLcsIMCd5TEufk3cQbTUS8NxAZcd1ji_Xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeehgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:m97OXEK50TXFMNHDFJM2Y7YacQZlCcoBHN7k1NlxWqT1AknEpiwg3w>
    <xmx:m97OXL_o5Xk5EmGwQdCAGffdL7ZucQdqEIxnyqPwUNuy5cc3iMaJ9A>
    <xmx:m97OXAFMWBKUCaXvawUf3rQ5ypvs79nGg1jhrMYnv-l4hLag5VdbTw>
    <xmx:m97OXMK9MunATEvEZU_ZQZMOl1rtSgAJbdTFUQICA_XYG0tVORMRCg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A0D6BE44A1;
        Sun,  5 May 2019 09:01:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: usbip: fix isoc packet num validation in get_pipe" failed to apply to 4.4-stable tree
To:     malte@leip.net, gregkh@linuxfoundation.org,
        skhan@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 May 2019 15:01:12 +0200
Message-ID: <1557061272154142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c409ca3be3c6ff3a1eeb303b191184e80d412862 Mon Sep 17 00:00:00 2001
From: Malte Leip <malte@leip.net>
Date: Sun, 14 Apr 2019 12:00:12 +0200
Subject: [PATCH] usb: usbip: fix isoc packet num validation in get_pipe

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

Fixes: c6688ef9f297 ("usbip: fix stub_rx: harden CMD_SUBMIT path to handle malicious input")
Signed-off-by: Malte Leip <malte@leip.net>
Cc: stable <stable@vger.kernel.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index 97b09a42a10c..dbfb2f24d71e 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -361,16 +361,10 @@ static int get_pipe(struct stub_device *sdev, struct usbip_header *pdu)
 	}
 
 	if (usb_endpoint_xfer_isoc(epd)) {
-		/* validate packet size and number of packets */
-		unsigned int maxp, packets, bytes;
-
-		maxp = usb_endpoint_maxp(epd);
-		maxp *= usb_endpoint_maxp_mult(epd);
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
index bf8afe9b5883..8be857a4fa13 100644
--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -121,6 +121,13 @@ extern struct device_attribute dev_attr_usbip_debug;
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

