Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5897FE5309
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731691AbfJYSG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46794 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731438AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0008OQ-R9; Fri, 25 Oct 2019 19:05:35 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0001ig-EO; Fri, 25 Oct 2019 19:05:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Felipe Balbi" <felipe.balbi@linux.intel.com>,
        "Kiruthika Varadarajan" <Kiruthika.Varadarajan@harman.com>
Date:   Fri, 25 Oct 2019 19:03:16 +0100
Message-ID: <lsq.1572026582.212582703@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 15/47] usb: gadget: ether: Fix race between
 gether_disconnect and rx_submit
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kiruthika Varadarajan <Kiruthika.Varadarajan@harman.com>

commit d29fcf7078bc8be2b6366cbd4418265b53c94fac upstream.

On spin lock release in rx_submit, gether_disconnect get a chance to
run, it makes port_usb NULL, rx_submit access NULL port USB, hence null
pointer crash.

Fixed by releasing the lock in rx_submit after port_usb is used.

Fixes: 2b3d942c4878 ("usb ethernet gadget: split out network core")
Signed-off-by: Kiruthika Varadarajan <Kiruthika.Varadarajan@harman.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/u_ether.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -202,11 +202,12 @@ rx_submit(struct eth_dev *dev, struct us
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
@@ -227,6 +228,7 @@ rx_submit(struct eth_dev *dev, struct us
 
 	if (dev->port_usb->is_fixed)
 		size = max_t(size_t, size, dev->port_usb->fixed_out_len);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	skb = alloc_skb(size + NET_IP_ALIGN, gfp_flags);
 	if (skb == NULL) {

