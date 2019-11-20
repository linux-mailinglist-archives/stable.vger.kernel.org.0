Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A55BC103FE2
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732627AbfKTPrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:47:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52554 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729585AbfKTPkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:15 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004YN-7H; Wed, 20 Nov 2019 15:40:11 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5S-0004Fp-JD; Wed, 20 Nov 2019 15:40:10 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Stephane Grosjean" <s.grosjean@peak-system.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
Date:   Wed, 20 Nov 2019 15:37:15 +0000
Message-ID: <lsq.1574264230.906707029@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 05/83] can: peak_usb: fix potential double kfree_skb()
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit fee6a8923ae0d318a7f7950c6c6c28a96cea099b upstream.

When closing the CAN device while tx skbs are inflight, echo skb could
be released twice. By calling close_candev() before unlinking all
pending tx urbs, then the internal echo_skb[] array is fully and
correctly cleared before the USB write callback and, therefore,
can_get_echo_skb() are called, for each aborted URB.

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -572,16 +572,16 @@ static int peak_usb_ndo_stop(struct net_
 	dev->state &= ~PCAN_USB_STATE_STARTED;
 	netif_stop_queue(netdev);
 
+	close_candev(netdev);
+
+	dev->can.state = CAN_STATE_STOPPED;
+
 	/* unlink all pending urbs and free used memory */
 	peak_usb_unlink_all_urbs(dev);
 
 	if (dev->adapter->dev_stop)
 		dev->adapter->dev_stop(dev);
 
-	close_candev(netdev);
-
-	dev->can.state = CAN_STATE_STOPPED;
-
 	/* can set bus off now */
 	if (dev->adapter->dev_set_bus) {
 		int err = dev->adapter->dev_set_bus(dev, 0);

