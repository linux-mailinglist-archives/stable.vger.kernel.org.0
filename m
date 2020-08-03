Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9A123A5A5
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgHCMj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbgHCMdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:33:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1B382076B;
        Mon,  3 Aug 2020 12:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457990;
        bh=U+chRqPGR8rJrwHBA7q6Oj2Gm8e0BLsd3/ugWeyaAfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ws2yKnk4wkhScCQKX14C1y7PiOu68M+O3ST5iXvjB45OPuiCLTTCjd30srMSTkhQY
         SEQhTmTiEcPh8bciYHEUInrawJWfr1ST7g2vp1MChO99c5XBrhg2WqeZuCTM2FcDwK
         ytURaAJLlj5/D4u8yLrTtL1O4571LmTltwwRCg9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/56] xen-netfront: fix potential deadlock in xennet_remove()
Date:   Mon,  3 Aug 2020 14:20:09 +0200
Message-Id: <20200803121852.973030494@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit c2c633106453611be07821f53dff9e93a9d1c3f0 ]

There's a potential race in xennet_remove(); this is what the driver is
doing upon unregistering a network device:

  1. state = read bus state
  2. if state is not "Closed":
  3.    request to set state to "Closing"
  4.    wait for state to be set to "Closing"
  5.    request to set state to "Closed"
  6.    wait for state to be set to "Closed"

If the state changes to "Closed" immediately after step 1 we are stuck
forever in step 4, because the state will never go back from "Closed" to
"Closing".

Make sure to check also for state == "Closed" in step 4 to prevent the
deadlock.

Also add a 5 sec timeout any time we wait for the bus state to change,
to avoid getting stuck forever in wait_event().

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netfront.c | 64 +++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 6b4675a9494b2..c8e84276e6397 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -63,6 +63,8 @@ module_param_named(max_queues, xennet_max_queues, uint, 0644);
 MODULE_PARM_DESC(max_queues,
 		 "Maximum number of queues per virtual interface");
 
+#define XENNET_TIMEOUT  (5 * HZ)
+
 static const struct ethtool_ops xennet_ethtool_ops;
 
 struct netfront_cb {
@@ -1337,12 +1339,15 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 
 	netif_carrier_off(netdev);
 
-	xenbus_switch_state(dev, XenbusStateInitialising);
-	wait_event(module_wq,
-		   xenbus_read_driver_state(dev->otherend) !=
-		   XenbusStateClosed &&
-		   xenbus_read_driver_state(dev->otherend) !=
-		   XenbusStateUnknown);
+	do {
+		xenbus_switch_state(dev, XenbusStateInitialising);
+		err = wait_event_timeout(module_wq,
+				 xenbus_read_driver_state(dev->otherend) !=
+				 XenbusStateClosed &&
+				 xenbus_read_driver_state(dev->otherend) !=
+				 XenbusStateUnknown, XENNET_TIMEOUT);
+	} while (!err);
+
 	return netdev;
 
  exit:
@@ -2142,28 +2147,43 @@ static const struct attribute_group xennet_dev_group = {
 };
 #endif /* CONFIG_SYSFS */
 
-static int xennet_remove(struct xenbus_device *dev)
+static void xennet_bus_close(struct xenbus_device *dev)
 {
-	struct netfront_info *info = dev_get_drvdata(&dev->dev);
-
-	dev_dbg(&dev->dev, "%s\n", dev->nodename);
+	int ret;
 
-	if (xenbus_read_driver_state(dev->otherend) != XenbusStateClosed) {
+	if (xenbus_read_driver_state(dev->otherend) == XenbusStateClosed)
+		return;
+	do {
 		xenbus_switch_state(dev, XenbusStateClosing);
-		wait_event(module_wq,
-			   xenbus_read_driver_state(dev->otherend) ==
-			   XenbusStateClosing ||
-			   xenbus_read_driver_state(dev->otherend) ==
-			   XenbusStateUnknown);
+		ret = wait_event_timeout(module_wq,
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateClosing ||
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateClosed ||
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateUnknown,
+				   XENNET_TIMEOUT);
+	} while (!ret);
+
+	if (xenbus_read_driver_state(dev->otherend) == XenbusStateClosed)
+		return;
 
+	do {
 		xenbus_switch_state(dev, XenbusStateClosed);
-		wait_event(module_wq,
-			   xenbus_read_driver_state(dev->otherend) ==
-			   XenbusStateClosed ||
-			   xenbus_read_driver_state(dev->otherend) ==
-			   XenbusStateUnknown);
-	}
+		ret = wait_event_timeout(module_wq,
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateClosed ||
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateUnknown,
+				   XENNET_TIMEOUT);
+	} while (!ret);
+}
+
+static int xennet_remove(struct xenbus_device *dev)
+{
+	struct netfront_info *info = dev_get_drvdata(&dev->dev);
 
+	xennet_bus_close(dev);
 	xennet_disconnect_backend(info);
 
 	if (info->netdev->reg_state == NETREG_REGISTERED)
-- 
2.25.1



