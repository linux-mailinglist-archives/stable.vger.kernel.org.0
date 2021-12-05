Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B371468AEE
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhLENG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:06:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42614 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhLENG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:06:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34EC960F50
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18474C341C1;
        Sun,  5 Dec 2021 13:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638709409;
        bh=GY/e4bOQy27rJTlNqKPP0Qm4ncqXjub5PD2dwT3WLgE=;
        h=Subject:To:Cc:From:Date:From;
        b=wQEq/V17ia4Ag5KoDQaQibYR5W8YIG1qFsX6H5O4BcS0lpaJX/qv5pajYp6538PCL
         G1yYsy92j0E/JxdhUj5ooPMouTSlDRRnCIg7Z9gGgNc8Np5NWu6gYEf9Av/LEe/Kbq
         p7Kn7NTEKKJVCuAna1fqKmFN7uRmp6px4JstsQd0=
Subject: FAILED: patch "[PATCH] net: mpls: Fix notifications when deleting a device" failed to apply to 4.4-stable tree
To:     bpoirier@nvidia.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:03:27 +0100
Message-ID: <1638709407226195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7d4741eacdefa5f0475431645b56baf00784df1f Mon Sep 17 00:00:00 2001
From: Benjamin Poirier <bpoirier@nvidia.com>
Date: Mon, 29 Nov 2021 15:15:05 +0900
Subject: [PATCH] net: mpls: Fix notifications when deleting a device

There are various problems related to netlink notifications for mpls route
changes in response to interfaces being deleted:
* delete interface of only nexthop
	DELROUTE notification is missing RTA_OIF attribute
* delete interface of non-last nexthop
	NEWROUTE notification is missing entirely
* delete interface of last nexthop
	DELROUTE notification is missing nexthop

All of these problems stem from the fact that existing routes are modified
in-place before sending a notification. Restructure mpls_ifdown() to avoid
changing the route in the DELROUTE cases and to create a copy in the
NEWROUTE case.

Fixes: f8efb73c97e2 ("mpls: multipath route support")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index ffeb2df8be7a..6e587feb705c 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1491,22 +1491,52 @@ static void mpls_dev_destroy_rcu(struct rcu_head *head)
 	kfree(mdev);
 }
 
-static void mpls_ifdown(struct net_device *dev, int event)
+static int mpls_ifdown(struct net_device *dev, int event)
 {
 	struct mpls_route __rcu **platform_label;
 	struct net *net = dev_net(dev);
-	u8 alive, deleted;
 	unsigned index;
 
 	platform_label = rtnl_dereference(net->mpls.platform_label);
 	for (index = 0; index < net->mpls.platform_labels; index++) {
 		struct mpls_route *rt = rtnl_dereference(platform_label[index]);
+		bool nh_del = false;
+		u8 alive = 0;
 
 		if (!rt)
 			continue;
 
-		alive = 0;
-		deleted = 0;
+		if (event == NETDEV_UNREGISTER) {
+			u8 deleted = 0;
+
+			for_nexthops(rt) {
+				struct net_device *nh_dev =
+					rtnl_dereference(nh->nh_dev);
+
+				if (!nh_dev || nh_dev == dev)
+					deleted++;
+				if (nh_dev == dev)
+					nh_del = true;
+			} endfor_nexthops(rt);
+
+			/* if there are no more nexthops, delete the route */
+			if (deleted == rt->rt_nhn) {
+				mpls_route_update(net, index, NULL, NULL);
+				continue;
+			}
+
+			if (nh_del) {
+				size_t size = sizeof(*rt) + rt->rt_nhn *
+					rt->rt_nh_size;
+				struct mpls_route *orig = rt;
+
+				rt = kmalloc(size, GFP_KERNEL);
+				if (!rt)
+					return -ENOMEM;
+				memcpy(rt, orig, size);
+			}
+		}
+
 		change_nexthops(rt) {
 			unsigned int nh_flags = nh->nh_flags;
 
@@ -1530,16 +1560,15 @@ static void mpls_ifdown(struct net_device *dev, int event)
 next:
 			if (!(nh_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)))
 				alive++;
-			if (!rtnl_dereference(nh->nh_dev))
-				deleted++;
 		} endfor_nexthops(rt);
 
 		WRITE_ONCE(rt->rt_nhn_alive, alive);
 
-		/* if there are no more nexthops, delete the route */
-		if (event == NETDEV_UNREGISTER && deleted == rt->rt_nhn)
-			mpls_route_update(net, index, NULL, NULL);
+		if (nh_del)
+			mpls_route_update(net, index, rt, NULL);
 	}
+
+	return 0;
 }
 
 static void mpls_ifup(struct net_device *dev, unsigned int flags)
@@ -1597,8 +1626,12 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		return NOTIFY_OK;
 
 	switch (event) {
+		int err;
+
 	case NETDEV_DOWN:
-		mpls_ifdown(dev, event);
+		err = mpls_ifdown(dev, event);
+		if (err)
+			return notifier_from_errno(err);
 		break;
 	case NETDEV_UP:
 		flags = dev_get_flags(dev);
@@ -1609,13 +1642,18 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		break;
 	case NETDEV_CHANGE:
 		flags = dev_get_flags(dev);
-		if (flags & (IFF_RUNNING | IFF_LOWER_UP))
+		if (flags & (IFF_RUNNING | IFF_LOWER_UP)) {
 			mpls_ifup(dev, RTNH_F_DEAD | RTNH_F_LINKDOWN);
-		else
-			mpls_ifdown(dev, event);
+		} else {
+			err = mpls_ifdown(dev, event);
+			if (err)
+				return notifier_from_errno(err);
+		}
 		break;
 	case NETDEV_UNREGISTER:
-		mpls_ifdown(dev, event);
+		err = mpls_ifdown(dev, event);
+		if (err)
+			return notifier_from_errno(err);
 		mdev = mpls_dev_get(dev);
 		if (mdev) {
 			mpls_dev_sysctl_unregister(dev, mdev);
@@ -1626,8 +1664,6 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 	case NETDEV_CHANGENAME:
 		mdev = mpls_dev_get(dev);
 		if (mdev) {
-			int err;
-
 			mpls_dev_sysctl_unregister(dev, mdev);
 			err = mpls_dev_sysctl_register(dev, mdev);
 			if (err)

