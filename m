Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0704847F449
	for <lists+stable@lfdr.de>; Sat, 25 Dec 2021 20:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhLYTL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 14:11:28 -0500
Received: from mail.mutex.one ([62.77.152.124]:52340 "EHLO mail.mutex.one"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhLYTL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Dec 2021 14:11:28 -0500
X-Greylist: delayed 1286 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Dec 2021 14:11:28 EST
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.mutex.one (Postfix) with ESMTP id AF33916C0012;
        Sat, 25 Dec 2021 20:50:00 +0200 (EET)
X-Virus-Scanned: Debian amavisd-new at mail.mutex.one
Received: from mail.mutex.one ([127.0.0.1])
        by localhost (mail.mutex.one [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uZxLKFDwP8yE; Sat, 25 Dec 2021 20:50:00 +0200 (EET)
From:   Marian Postevca <posteuca@mutex.one>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mutex.one; s=default;
        t=1640458200; bh=LspfzkAz2+IQMFp44TPzSHwDjnOm3MbwNAydkgMlUz4=;
        h=From:To:Cc:Subject:Date:From;
        b=epbInGF7cM8r9zGAvNXN80tQijeg09hni53Mz5zzFSzW+6dg1mSAyhg9zTtyAGSRq
         xW96ZS1BKhgG1kcykR4G78/Sun+XYxT/Bw5hFTBHdCnXjLqOe1JhTGAh4Es7vYHVNy
         1mVQFOrU3aa2V2PrfA0qsLrQhZHvqy/nhuoLvVjw=
To:     stable@vger.kernel.org
Cc:     Marian Postevca <posteuca@mutex.one>
Subject: [PATCH 4.14] usb: gadget: u_ether: fix race in setting MAC address in setup phase
Date:   Sat, 25 Dec 2021 20:46:01 +0200
Message-Id: <20211225184559.15492-1-posteuca@mutex.one>
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
index 38a35f57b22c0..f59c20457e658 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -864,19 +864,23 @@ int gether_register_netdev(struct net_device *net)
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
@@ -884,15 +888,6 @@ int gether_register_netdev(struct net_device *net)
 		 */
 		netif_carrier_off(net);
 	}
-	sa.sa_family = net->type;
-	memcpy(sa.sa_data, dev->dev_mac, ETH_ALEN);
-	rtnl_lock();
-	status = dev_set_mac_address(net, &sa);
-	rtnl_unlock();
-	if (status)
-		pr_warn("cannot set self ethernet address: %d\n", status);
-	else
-		INFO(dev, "MAC %pM\n", dev->dev_mac);
 
 	return status;
 }
-- 
2.32.0

