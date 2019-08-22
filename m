Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A4F99DBB
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392828AbfHVRo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403863AbfHVRXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:12 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8472B23405;
        Thu, 22 Aug 2019 17:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494591;
        bh=g7i6WLTZ5rxEErYhZhpqbhfqKOn6PGX5ztul/t3P0PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOtcFiSPu6AIJhZZsRqlB+zoH4AI9tbiGk3RDkgin678qO5LxfOPMvJPn/BNVtuu1
         dvGmzxq8UoBomUtXXxbZRx8DZDNm9wYCQfiQl8837kVv8sEqEGsEpnJq1IjMFCWXWG
         VNRrK3XfV9xh0NEsRIsbsYvlGZCxTFJ5uNBG+w1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.9 011/103] can: peak_usb: fix potential double kfree_skb()
Date:   Thu, 22 Aug 2019 10:17:59 -0700
Message-Id: <20190822171729.313350455@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit fee6a8923ae0d318a7f7950c6c6c28a96cea099b upstream.

When closing the CAN device while tx skbs are inflight, echo skb could
be released twice. By calling close_candev() before unlinking all
pending tx urbs, then the internal echo_skb[] array is fully and
correctly cleared before the USB write callback and, therefore,
can_get_echo_skb() are called, for each aborted URB.

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -592,16 +592,16 @@ static int peak_usb_ndo_stop(struct net_
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


