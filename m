Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABB43D5DE3
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbhGZPET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235576AbhGZPEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:04:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEF3F60F22;
        Mon, 26 Jul 2021 15:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314284;
        bh=el6tkVb4lJ9KT+q1In3s+lhL4jmAmJqbJ1PlydAWZVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTb5Ip79WIEa0FVAHNPtjzljL/cZTfD7c/DutI/w6bboKbl5B59yT3OcHys7/LZOO
         an7viEwUASFWubpYgmMR/fdwn8Kxuwwdk0Pt4hz72rbmVd/pusqQcTxfD7Xjg+du0c
         exU97nOf334vCVM6SDXD6idc4tholBTJGdSwgkuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH 4.9 50/60] usb: max-3421: Prevent corruption of freed memory
Date:   Mon, 26 Jul 2021 17:39:04 +0200
Message-Id: <20210726153826.441231274@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

commit b5fdf5c6e6bee35837e160c00ac89327bdad031b upstream.

The MAX-3421 USB driver remembers the state of the USB toggles for a
device/endpoint. To save SPI writes, this was only done when a new
device/endpoint was being used. Unfortunately, if the old device was
removed, this would cause writes to freed memory.

To fix this, a simpler scheme is used. The toggles are read from
hardware when a URB is completed, and the toggles are always written to
hardware when any URB transaction is started. This will cause a few more
SPI transactions, but no causes kernel panics.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20210625031456.8632-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/max3421-hcd.c |   44 +++++++++++++----------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -149,8 +149,6 @@ struct max3421_hcd {
 	 */
 	struct urb *curr_urb;
 	enum scheduling_pass sched_pass;
-	struct usb_device *loaded_dev;	/* dev that's loaded into the chip */
-	int loaded_epnum;		/* epnum whose toggles are loaded */
 	int urb_done;			/* > 0 -> no errors, < 0: errno */
 	size_t curr_len;
 	u8 hien;
@@ -488,39 +486,17 @@ max3421_set_speed(struct usb_hcd *hcd, s
  * Caller must NOT hold HCD spinlock.
  */
 static void
-max3421_set_address(struct usb_hcd *hcd, struct usb_device *dev, int epnum,
-		    int force_toggles)
+max3421_set_address(struct usb_hcd *hcd, struct usb_device *dev, int epnum)
 {
-	struct max3421_hcd *max3421_hcd = hcd_to_max3421(hcd);
-	int old_epnum, same_ep, rcvtog, sndtog;
-	struct usb_device *old_dev;
+	int rcvtog, sndtog;
 	u8 hctl;
 
-	old_dev = max3421_hcd->loaded_dev;
-	old_epnum = max3421_hcd->loaded_epnum;
-
-	same_ep = (dev == old_dev && epnum == old_epnum);
-	if (same_ep && !force_toggles)
-		return;
-
-	if (old_dev && !same_ep) {
-		/* save the old end-points toggles: */
-		u8 hrsl = spi_rd8(hcd, MAX3421_REG_HRSL);
-
-		rcvtog = (hrsl >> MAX3421_HRSL_RCVTOGRD_BIT) & 1;
-		sndtog = (hrsl >> MAX3421_HRSL_SNDTOGRD_BIT) & 1;
-
-		/* no locking: HCD (i.e., we) own toggles, don't we? */
-		usb_settoggle(old_dev, old_epnum, 0, rcvtog);
-		usb_settoggle(old_dev, old_epnum, 1, sndtog);
-	}
 	/* setup new endpoint's toggle bits: */
 	rcvtog = usb_gettoggle(dev, epnum, 0);
 	sndtog = usb_gettoggle(dev, epnum, 1);
 	hctl = (BIT(rcvtog + MAX3421_HCTL_RCVTOG0_BIT) |
 		BIT(sndtog + MAX3421_HCTL_SNDTOG0_BIT));
 
-	max3421_hcd->loaded_epnum = epnum;
 	spi_wr8(hcd, MAX3421_REG_HCTL, hctl);
 
 	/*
@@ -528,7 +504,6 @@ max3421_set_address(struct usb_hcd *hcd,
 	 * address-assignment so it's best to just always load the
 	 * address whenever the end-point changed/was forced.
 	 */
-	max3421_hcd->loaded_dev = dev;
 	spi_wr8(hcd, MAX3421_REG_PERADDR, dev->devnum);
 }
 
@@ -663,7 +638,7 @@ max3421_select_and_start_urb(struct usb_
 	struct max3421_hcd *max3421_hcd = hcd_to_max3421(hcd);
 	struct urb *urb, *curr_urb = NULL;
 	struct max3421_ep *max3421_ep;
-	int epnum, force_toggles = 0;
+	int epnum;
 	struct usb_host_endpoint *ep;
 	struct list_head *pos;
 	unsigned long flags;
@@ -773,7 +748,6 @@ done:
 			usb_settoggle(urb->dev, epnum, 0, 1);
 			usb_settoggle(urb->dev, epnum, 1, 1);
 			max3421_ep->pkt_state = PKT_STATE_SETUP;
-			force_toggles = 1;
 		} else
 			max3421_ep->pkt_state = PKT_STATE_TRANSFER;
 	}
@@ -781,7 +755,7 @@ done:
 	spin_unlock_irqrestore(&max3421_hcd->lock, flags);
 
 	max3421_ep->last_active = max3421_hcd->frame_number;
-	max3421_set_address(hcd, urb->dev, epnum, force_toggles);
+	max3421_set_address(hcd, urb->dev, epnum);
 	max3421_set_speed(hcd, urb->dev);
 	max3421_next_transfer(hcd, 0);
 	return 1;
@@ -1376,6 +1350,16 @@ max3421_urb_done(struct usb_hcd *hcd)
 		status = 0;
 	urb = max3421_hcd->curr_urb;
 	if (urb) {
+		/* save the old end-points toggles: */
+		u8 hrsl = spi_rd8(hcd, MAX3421_REG_HRSL);
+		int rcvtog = (hrsl >> MAX3421_HRSL_RCVTOGRD_BIT) & 1;
+		int sndtog = (hrsl >> MAX3421_HRSL_SNDTOGRD_BIT) & 1;
+		int epnum = usb_endpoint_num(&urb->ep->desc);
+
+		/* no locking: HCD (i.e., we) own toggles, don't we? */
+		usb_settoggle(urb->dev, epnum, 0, rcvtog);
+		usb_settoggle(urb->dev, epnum, 1, sndtog);
+
 		max3421_hcd->curr_urb = NULL;
 		spin_lock_irqsave(&max3421_hcd->lock, flags);
 		usb_hcd_unlink_urb_from_ep(hcd, urb);


