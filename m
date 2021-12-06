Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22137469F16
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391367AbhLFPpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390507AbhLFPm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BE5C0A8887;
        Mon,  6 Dec 2021 07:26:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A3CBB81126;
        Mon,  6 Dec 2021 15:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B04C34900;
        Mon,  6 Dec 2021 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804414;
        bh=CnKad2KUeEF6EYBGmfXHutwjSQIaiXQ+nm3oakBq6mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFr8oD6fmalpk8PDaFGqnh4WVrHf1B2OZ7skK3OLUt9z2D8PWm5X/tF1yO9lgHd3a
         sI294HBPgqsB7tmrBI4ll1kztF2whxX1wgpvt0DoqOnxflb7z4RUIdQPlhX1QW9dQn
         Vo3GN0FevlRUJwbtR2iu3zG17DGlJ4I/xmsxwl6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Poirier <bpoirier@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 106/207] net: mpls: Fix notifications when deleting a device
Date:   Mon,  6 Dec 2021 15:56:00 +0100
Message-Id: <20211206145613.915776828@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Poirier <bpoirier@nvidia.com>

commit 7d4741eacdefa5f0475431645b56baf00784df1f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mpls/af_mpls.c |   68 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 16 deletions(-)

--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1491,22 +1491,52 @@ static void mpls_dev_destroy_rcu(struct
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
 
@@ -1530,16 +1560,15 @@ static void mpls_ifdown(struct net_devic
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
@@ -1597,8 +1626,12 @@ static int mpls_dev_notify(struct notifi
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
@@ -1609,13 +1642,18 @@ static int mpls_dev_notify(struct notifi
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
@@ -1626,8 +1664,6 @@ static int mpls_dev_notify(struct notifi
 	case NETDEV_CHANGENAME:
 		mdev = mpls_dev_get(dev);
 		if (mdev) {
-			int err;
-
 			mpls_dev_sysctl_unregister(dev, mdev);
 			err = mpls_dev_sysctl_register(dev, mdev);
 			if (err)


