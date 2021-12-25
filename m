Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9777547F49B
	for <lists+stable@lfdr.de>; Sat, 25 Dec 2021 23:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhLYWh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 17:37:28 -0500
Received: from mail.mutex.one ([62.77.152.124]:52416 "EHLO mail.mutex.one"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhLYWh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Dec 2021 17:37:28 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.mutex.one (Postfix) with ESMTP id F321516C0010;
        Sun, 26 Dec 2021 00:37:26 +0200 (EET)
X-Virus-Scanned: Debian amavisd-new at mail.mutex.one
Received: from mail.mutex.one ([127.0.0.1])
        by localhost (mail.mutex.one [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0QsbMxn_r77P; Sun, 26 Dec 2021 00:37:26 +0200 (EET)
From:   Marian Postevca <posteuca@mutex.one>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mutex.one; s=default;
        t=1640471846; bh=/Un4nd1DdX9hcnFAnqHN5d+x9gRdKorqF9NzqGluQQk=;
        h=From:To:Cc:Subject:Date:From;
        b=AzeyEThdVsH5xCXeJyBjdxflI03CFvHO2SvcX3UYSiDGOpeRu7DZhIlkL2wzryfp0
         p314jn8iKCNPC4fgl5F42ZCiDHe95QcD9ltcFbUjHSDbit2vaRMY8Hb4JZPuH6DjjE
         haGxXuqydnHZzksjyxD8RzMjp/qCqXn7Aa56cyyc=
To:     stable@vger.kernel.org
Cc:     Marian Postevca <posteuca@mutex.one>
Subject: [PATCH 5.4] usb: gadget: u_ether: fix race in setting MAC address in setup phase
Date:   Sun, 26 Dec 2021 00:36:29 +0200
Message-Id: <20211225223628.2606-1-posteuca@mutex.one>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 890d5b40908bfd1a79be018d2d297cf9df60f4ee upstream.

When listening for notifications through netlink of a new interface being
registered, sporadically, it is possible for the MAC to be read as zero.
The zero MAC address lasts a short period of time and then switches to a
valid random MAC address.

This causes problems for netd in Android, which assumes that the interface
is malfunctioning and will not use it.

In the good case we get this log:
InterfaceController::getCfg() ifName usb0
 hwAddr 92:a8:f0:73:79:5b ipv4Addr 0.0.0.0 flags 0x1002

In the error case we get these logs:
InterfaceController::getCfg() ifName usb0
 hwAddr 00:00:00:00:00:00 ipv4Addr 0.0.0.0 flags 0x1002

netd : interfaceGetCfg("usb0")
netd : interfaceSetCfg() -> ServiceSpecificException
 (99, "[Cannot assign requested address] : ioctl() failed")

The reason for the issue is the order in which the interface is setup,
it is first registered through register_netdev() and after the MAC
address is set.

Fixed by first setting the MAC address of the net_device and after that
calling register_netdev().

Cc: stable@vger.kernel.org
Signed-off-by: Marian Postevca <posteuca@mutex.one>
Fixes: bcd4a1c40bee885e ("usb: gadget: u_ether: construct with default values and add setters/getters")
---
 drivers/usb/gadget/function/u_ether.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 57da62e331848..271bd08f4a255 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -860,19 +860,23 @@ int gether_register_netdev(struct net_device *net)
 {
 	struct eth_dev *dev;
 	struct usb_gadget *g;
-	struct sockaddr sa;
 	int status;
 
 	if (!net->dev.parent)
 		return -EINVAL;
 	dev = netdev_priv(net);
 	g = dev->gadget;
+
+	memcpy(net->dev_addr, dev->dev_mac, ETH_ALEN);
+	net->addr_assign_type = NET_ADDR_RANDOM;
+
 	status = register_netdev(net);
 	if (status < 0) {
 		dev_dbg(&g->dev, "register_netdev failed, %d\n", status);
 		return status;
 	} else {
 		INFO(dev, "HOST MAC %pM\n", dev->host_mac);
+		INFO(dev, "MAC %pM\n", dev->dev_mac);
 
 		/* two kinds of host-initiated state changes:
 		 *  - iff DATA transfer is active, carrier is "on"
@@ -880,15 +884,6 @@ int gether_register_netdev(struct net_device *net)
 		 */
 		netif_carrier_off(net);
 	}
-	sa.sa_family = net->type;
-	memcpy(sa.sa_data, dev->dev_mac, ETH_ALEN);
-	rtnl_lock();
-	status = dev_set_mac_address(net, &sa, NULL);
-	rtnl_unlock();
-	if (status)
-		pr_warn("cannot set self ethernet address: %d\n", status);
-	else
-		INFO(dev, "MAC %pM\n", dev->dev_mac);
 
 	return status;
 }
-- 
2.32.0

