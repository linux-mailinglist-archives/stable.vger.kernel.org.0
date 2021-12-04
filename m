Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA705468807
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 23:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhLDWOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 17:14:03 -0500
Received: from mail.mutex.one ([62.77.152.124]:43942 "EHLO mail.mutex.one"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345204AbhLDWOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Dec 2021 17:14:02 -0500
X-Greylist: delayed 1275 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Dec 2021 17:14:02 EST
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.mutex.one (Postfix) with ESMTP id F3E0A16C27F2;
        Sat,  4 Dec 2021 23:49:16 +0200 (EET)
X-Virus-Scanned: Debian amavisd-new at mail.mutex.one
Received: from mail.mutex.one ([127.0.0.1])
        by localhost (mail.mutex.one [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eMoWQPvIqDML; Sat,  4 Dec 2021 23:49:16 +0200 (EET)
Received:  [127.0.0.1] (localhost [127.0.0.1])nknown [109.103.89.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mutex.one (Postfix) with ESMTPSA id 9D94F16C08F2;
        Sat,  4 Dec 2021 23:49:15 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mutex.one; s=default;
        t=1638654556; bh=EVhTg8nYuNCbP3r7ALG6+8NWgoFsT6iIYwfUXSTMBzA=;
        h=From:To:Cc:Subject:Date:From;
        b=Mz7Lx+o60D1QKd4Ke8Rslyqwui25ukjc13FPs/g2VZZuVW/0ZycSp+s908bnzbcG3
         On7euWIxjhLt+/shYmapUmW1J8uHvRTmJxkPEs01vyFuitg3uER8hY/0WNUZ6b7Y6F
         BbFlkF3cwoP7b3pgsbncHABJbTyQnpKg/BcLB/aE=
From:   Marian Postevca <posteuca@mutex.one>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Marian Postevca <posteuca@mutex.one>, stable@vger.kernel.org
Subject: [PATCH v2] usb: gadget: u_ether: fix race in setting MAC address in setup phase
Date:   Sat,  4 Dec 2021 23:49:12 +0200
Message-Id: <20211204214912.17627-1-posteuca@mutex.one>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Signed-off-by: Marian Postevca <posteuca@mutex.one>
Fixes: bcd4a1c40bee885e ("usb: gadget: u_ether: construct with default values and add setters/getters")
Cc: stable@vger.kernel.org
---

v2: Added Fixes and Cc tags to commit message.

 drivers/usb/gadget/function/u_ether.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index e0ad5aed6ac9..6f5d45ef2e39 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
+#include <linux/etherdevice.h>
 
 #include "u_ether.h"
 
@@ -863,19 +864,23 @@ int gether_register_netdev(struct net_device *net)
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
+	net->addr_assign_type = NET_ADDR_RANDOM;
+	eth_hw_addr_set(net, dev->dev_mac);
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
@@ -883,15 +888,6 @@ int gether_register_netdev(struct net_device *net)
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

