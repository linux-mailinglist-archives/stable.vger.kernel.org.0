Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4115CF94
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfGBMhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfGBMhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 08:37:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66D1C2054F;
        Tue,  2 Jul 2019 12:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562071021;
        bh=vR8f62OR3BClMMSg54NfquLPBd/T0YIsB1gCJAUSwk0=;
        h=Subject:To:From:Date:From;
        b=sX5PDT4FyRmRr4qnhRtJKtCYxOr11BYPBmmotdBq4HdtyNihblRz2iHoakw30v658
         yYpWiU/JPaG+TrelC22PK2pkX9g1sAA4mST/yTDgm2rkf3NDWywZeQDZUPmXFP5nEO
         FetD0hkqR3lSf25LJtQLJRJgdhVhhek+WdSb7+2I=
Subject: patch "usb: gadget: ether: Fix race between gether_disconnect and rx_submit" added to usb-next
To:     Kiruthika.Varadarajan@harman.com, felipe.balbi@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Jul 2019 14:29:54 +0200
Message-ID: <15620705943771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: ether: Fix race between gether_disconnect and rx_submit

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From d29fcf7078bc8be2b6366cbd4418265b53c94fac Mon Sep 17 00:00:00 2001
From: Kiruthika Varadarajan <Kiruthika.Varadarajan@harman.com>
Date: Tue, 18 Jun 2019 08:39:06 +0000
Subject: usb: gadget: ether: Fix race between gether_disconnect and rx_submit

On spin lock release in rx_submit, gether_disconnect get a chance to
run, it makes port_usb NULL, rx_submit access NULL port USB, hence null
pointer crash.

Fixed by releasing the lock in rx_submit after port_usb is used.

Fixes: 2b3d942c4878 ("usb ethernet gadget: split out network core")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kiruthika Varadarajan <Kiruthika.Varadarajan@harman.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/usb/gadget/function/u_ether.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 737bd77a575d..2929bb47a618 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -186,11 +186,12 @@ rx_submit(struct eth_dev *dev, struct usb_request *req, gfp_t gfp_flags)
 		out = dev->port_usb->out_ep;
 	else
 		out = NULL;
-	spin_unlock_irqrestore(&dev->lock, flags);
 
 	if (!out)
+	{
+		spin_unlock_irqrestore(&dev->lock, flags);
 		return -ENOTCONN;
-
+	}
 
 	/* Padding up to RX_EXTRA handles minor disagreements with host.
 	 * Normally we use the USB "terminate on short read" convention;
@@ -214,6 +215,7 @@ rx_submit(struct eth_dev *dev, struct usb_request *req, gfp_t gfp_flags)
 
 	if (dev->port_usb->is_fixed)
 		size = max_t(size_t, size, dev->port_usb->fixed_out_len);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	skb = __netdev_alloc_skb(dev->net, size + NET_IP_ALIGN, gfp_flags);
 	if (skb == NULL) {
-- 
2.22.0


