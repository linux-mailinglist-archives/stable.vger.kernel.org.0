Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1844EB8638
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733287AbfISWTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733275AbfISWTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F2C82196E;
        Thu, 19 Sep 2019 22:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931591;
        bh=nAw+mjrA2cfa8qu24PORy/zf/HdZRGm9KA0xAPav0dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBTL73ypP2VUIdGhVIbuKV0FWmuZ8Yw8YIO784pGTjm7/qmxmLtZa8g2Be0QkZKTX
         dHUsnxZi/5nyUPhgARSZ+2q8hutwDsgVbHGyfewujeCLDQ33sXVT/oxRN20CzRFvN5
         hii8WL6qbhpMibxvGLsrv0hjbFbwHG+8i8c6eBcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+35f4d916c623118d576e@syzkaller.appspotmail.com
Subject: [PATCH 4.9 35/74] USB: usbcore: Fix slab-out-of-bounds bug during device reset
Date:   Fri, 20 Sep 2019 00:03:48 +0200
Message-Id: <20190919214808.367451699@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 3dd550a2d36596a1b0ee7955da3b611c031d3873 upstream.

The syzbot fuzzer provoked a slab-out-of-bounds error in the USB core:

BUG: KASAN: slab-out-of-bounds in memcmp+0xa6/0xb0 lib/string.c:904
Read of size 1 at addr ffff8881d175bed6 by task kworker/0:3/2746

CPU: 0 PID: 2746 Comm: kworker/0:3 Not tainted 5.3.0-rc5+ #28
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  print_address_description+0x6a/0x32c mm/kasan/report.c:351
  __kasan_report.cold+0x1a/0x33 mm/kasan/report.c:482
  kasan_report+0xe/0x12 mm/kasan/common.c:612
  memcmp+0xa6/0xb0 lib/string.c:904
  memcmp include/linux/string.h:400 [inline]
  descriptors_changed drivers/usb/core/hub.c:5579 [inline]
  usb_reset_and_verify_device+0x564/0x1300 drivers/usb/core/hub.c:5729
  usb_reset_device+0x4c1/0x920 drivers/usb/core/hub.c:5898
  rt2x00usb_probe+0x53/0x7af
drivers/net/wireless/ralink/rt2x00/rt2x00usb.c:806

The error occurs when the descriptors_changed() routine (called during
a device reset) attempts to compare the old and new BOS and capability
descriptors.  The length it uses for the comparison is the
wTotalLength value stored in BOS descriptor, but this value is not
necessarily the same as the length actually allocated for the
descriptors.  If it is larger the routine will call memcmp() with a
length that is too big, thus reading beyond the end of the allocated
region and leading to this fault.

The kernel reads the BOS descriptor twice: first to get the total
length of all the capability descriptors, and second to read it along
with all those other descriptors.  A malicious (or very faulty) device
may send different values for the BOS descriptor fields each time.
The memory area will be allocated using the wTotalLength value read
the first time, but stored within it will be the value read the second
time.

To prevent this possibility from causing any errors, this patch
modifies the BOS descriptor after it has been read the second time:
It sets the wTotalLength field to the actual length of the descriptors
that were read in and validated.  Then the memcpy() call, or any other
code using these descriptors, will be able to rely on wTotalLength
being valid.

Reported-and-tested-by: syzbot+35f4d916c623118d576e@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1909041154260.1722-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/config.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -920,7 +920,7 @@ int usb_get_bos_descriptor(struct usb_de
 	struct usb_bos_descriptor *bos;
 	struct usb_dev_cap_header *cap;
 	struct usb_ssp_cap_descriptor *ssp_cap;
-	unsigned char *buffer;
+	unsigned char *buffer, *buffer0;
 	int length, total_len, num, i, ssac;
 	__u8 cap_type;
 	int ret;
@@ -965,10 +965,12 @@ int usb_get_bos_descriptor(struct usb_de
 			ret = -ENOMSG;
 		goto err;
 	}
+
+	buffer0 = buffer;
 	total_len -= length;
+	buffer += length;
 
 	for (i = 0; i < num; i++) {
-		buffer += length;
 		cap = (struct usb_dev_cap_header *)buffer;
 
 		if (total_len < sizeof(*cap) || total_len < cap->bLength) {
@@ -982,8 +984,6 @@ int usb_get_bos_descriptor(struct usb_de
 			break;
 		}
 
-		total_len -= length;
-
 		if (cap->bDescriptorType != USB_DT_DEVICE_CAPABILITY) {
 			dev_warn(ddev, "descriptor type invalid, skip\n");
 			continue;
@@ -1018,7 +1018,11 @@ int usb_get_bos_descriptor(struct usb_de
 		default:
 			break;
 		}
+
+		total_len -= length;
+		buffer += length;
 	}
+	dev->bos->desc->wTotalLength = cpu_to_le16(buffer - buffer0);
 
 	return 0;
 


