Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1CB88DA5
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfHJUoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:44:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54986 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726824AbfHJUoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:03 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDY-00053P-9e; Sat, 10 Aug 2019 21:44:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003hP-4y; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Shuah Khan" <skhan@linuxfoundation.org>,
        "Malte Leip" <malte@leip.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.616399710@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 109/157] usb: usbip: fix isoc packet num validation
 in get_pipe
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Malte Leip <malte@leip.net>

commit c409ca3be3c6ff3a1eeb303b191184e80d412862 upstream.

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
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust filenames]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/usbip/stub_rx.c      | 12 +++---------
 drivers/staging/usbip/usbip_common.h |  7 +++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -375,16 +375,10 @@ static int get_pipe(struct stub_device *
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
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -134,6 +134,13 @@ extern struct device_attribute dev_attr_
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

