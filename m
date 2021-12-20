Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D620747A70E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhLTJbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:31:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53900 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhLTJbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 04:31:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C357EB80E28
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 09:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F6DC36AE9;
        Mon, 20 Dec 2021 09:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639992696;
        bh=m30LXElpwWxalnxadpwm74+YT9dAFKZ0PyM+AtMaHeU=;
        h=Subject:To:Cc:From:Date:From;
        b=Js5LLle8KaZS0+gsXGrNF3Z8wY4yxVrCJK3CCbeH/BteCX3r49xsyzf3+iJteyvGH
         Dj+m3f8mo2W5tgAGd3m9hrbkW+0mIgBIPlieRLMqiiujXDgCFzxXncXGOMAP4rLqHk
         mc+IsCqG5snEP1mliuVuK6qPYhbiaS3C9xHCSZps=
Subject: FAILED: patch "[PATCH] usb: gadget: u_ether: fix race in setting MAC address in" failed to apply to 4.14-stable tree
To:     posteuca@mutex.one, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 10:31:24 +0100
Message-ID: <163999268461194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 890d5b40908bfd1a79be018d2d297cf9df60f4ee Mon Sep 17 00:00:00 2001
From: Marian Postevca <posteuca@mutex.one>
Date: Sat, 4 Dec 2021 23:49:12 +0200
Subject: [PATCH] usb: gadget: u_ether: fix race in setting MAC address in
 setup phase

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

Fixes: bcd4a1c40bee885e ("usb: gadget: u_ether: construct with default values and add setters/getters")
Cc: stable@vger.kernel.org
Signed-off-by: Marian Postevca <posteuca@mutex.one>
Link: https://lore.kernel.org/r/20211204214912.17627-1-posteuca@mutex.one
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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

