Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09CB8DBAA
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfHNREB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729092AbfHNREB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D8772084D;
        Wed, 14 Aug 2019 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802240;
        bh=JF5p7eFdyL2uDlvITnkiJ4pO6uUc14BJq2mRocluJ2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKxc6PqY7wXzW/LKoEnRsfdWnT6YJIXl2MtmbBh/utNjhuctvSBS57nUSDS5CJP0s
         f45+ZZAnVp1a4k8sTXNjJBl+It3hSnWwwIvKrgtK8HShoPpSJkONOMs42FSR/8+8Ow
         7j737waoRJ8ED/X9cWkVLeodwMxjbm7ucpGDkQnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.2 048/144] can: peak_usb: fix potential double kfree_skb()
Date:   Wed, 14 Aug 2019 19:00:04 +0200
Message-Id: <20190814165801.836883958@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
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
@@ -568,16 +568,16 @@ static int peak_usb_ndo_stop(struct net_
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


