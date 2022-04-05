Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94814F28F3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiDEIYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbiDEISH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409A86B0B5;
        Tue,  5 Apr 2022 01:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 350D4617F3;
        Tue,  5 Apr 2022 08:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F7AC385A0;
        Tue,  5 Apr 2022 08:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146019;
        bh=r91jElRvQN2IYdOEUX6cggvgiowglxtTlKd9Phaicio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVGf5B6Kzdz+um4wi0oHJvQZxH+Dp1UrkwBPblc6Y+jSius7Tbez2zeqYzN7VndGB
         WYToNIaFKfiRE4ML6jd1d92JkN73D1HYD+eIg/yfnRx7JzGWWdu77f08p4Op2bNd7+
         XOVOgf1+b2DhRS4rJ8koDpRl4QcWHkRvKENjCx2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0613/1126] RDMA/irdma: Fix netdev notifications for vlans
Date:   Tue,  5 Apr 2022 09:22:40 +0200
Message-Id: <20220405070425.627703461@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 6702bc14744847842a87fed21a795b6e8bab6965 ]

Currently, events on vlan netdevs are being ignored. Fix this by finding
the real netdev and processing the notifications for vlan netdevs.

Fixes: 915cc7ac0f8e ("RDMA/irdma: Add miscellaneous utility definitions")
Link: https://lore.kernel.org/r/20220225163211.127-2-shiraz.saleem@intel.com
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/utils.c | 48 ++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 398736d8c78a..e81b74a518dd 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -150,31 +150,35 @@ int irdma_inetaddr_event(struct notifier_block *notifier, unsigned long event,
 			 void *ptr)
 {
 	struct in_ifaddr *ifa = ptr;
-	struct net_device *netdev = ifa->ifa_dev->dev;
+	struct net_device *real_dev, *netdev = ifa->ifa_dev->dev;
 	struct irdma_device *iwdev;
 	struct ib_device *ibdev;
 	u32 local_ipaddr;
 
-	ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_IRDMA);
+	real_dev = rdma_vlan_dev_real_dev(netdev);
+	if (!real_dev)
+		real_dev = netdev;
+
+	ibdev = ib_device_get_by_netdev(real_dev, RDMA_DRIVER_IRDMA);
 	if (!ibdev)
 		return NOTIFY_DONE;
 
 	iwdev = to_iwdev(ibdev);
 	local_ipaddr = ntohl(ifa->ifa_address);
 	ibdev_dbg(&iwdev->ibdev,
-		  "DEV: netdev %p event %lu local_ip=%pI4 MAC=%pM\n", netdev,
-		  event, &local_ipaddr, netdev->dev_addr);
+		  "DEV: netdev %p event %lu local_ip=%pI4 MAC=%pM\n", real_dev,
+		  event, &local_ipaddr, real_dev->dev_addr);
 	switch (event) {
 	case NETDEV_DOWN:
-		irdma_manage_arp_cache(iwdev->rf, netdev->dev_addr,
+		irdma_manage_arp_cache(iwdev->rf, real_dev->dev_addr,
 				       &local_ipaddr, true, IRDMA_ARP_DELETE);
-		irdma_if_notify(iwdev, netdev, &local_ipaddr, true, false);
+		irdma_if_notify(iwdev, real_dev, &local_ipaddr, true, false);
 		irdma_gid_change_event(&iwdev->ibdev);
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGEADDR:
-		irdma_add_arp(iwdev->rf, &local_ipaddr, true, netdev->dev_addr);
-		irdma_if_notify(iwdev, netdev, &local_ipaddr, true, true);
+		irdma_add_arp(iwdev->rf, &local_ipaddr, true, real_dev->dev_addr);
+		irdma_if_notify(iwdev, real_dev, &local_ipaddr, true, true);
 		irdma_gid_change_event(&iwdev->ibdev);
 		break;
 	default:
@@ -196,32 +200,36 @@ int irdma_inet6addr_event(struct notifier_block *notifier, unsigned long event,
 			  void *ptr)
 {
 	struct inet6_ifaddr *ifa = ptr;
-	struct net_device *netdev = ifa->idev->dev;
+	struct net_device *real_dev, *netdev = ifa->idev->dev;
 	struct irdma_device *iwdev;
 	struct ib_device *ibdev;
 	u32 local_ipaddr6[4];
 
-	ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_IRDMA);
+	real_dev = rdma_vlan_dev_real_dev(netdev);
+	if (!real_dev)
+		real_dev = netdev;
+
+	ibdev = ib_device_get_by_netdev(real_dev, RDMA_DRIVER_IRDMA);
 	if (!ibdev)
 		return NOTIFY_DONE;
 
 	iwdev = to_iwdev(ibdev);
 	irdma_copy_ip_ntohl(local_ipaddr6, ifa->addr.in6_u.u6_addr32);
 	ibdev_dbg(&iwdev->ibdev,
-		  "DEV: netdev %p event %lu local_ip=%pI6 MAC=%pM\n", netdev,
-		  event, local_ipaddr6, netdev->dev_addr);
+		  "DEV: netdev %p event %lu local_ip=%pI6 MAC=%pM\n", real_dev,
+		  event, local_ipaddr6, real_dev->dev_addr);
 	switch (event) {
 	case NETDEV_DOWN:
-		irdma_manage_arp_cache(iwdev->rf, netdev->dev_addr,
+		irdma_manage_arp_cache(iwdev->rf, real_dev->dev_addr,
 				       local_ipaddr6, false, IRDMA_ARP_DELETE);
-		irdma_if_notify(iwdev, netdev, local_ipaddr6, false, false);
+		irdma_if_notify(iwdev, real_dev, local_ipaddr6, false, false);
 		irdma_gid_change_event(&iwdev->ibdev);
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGEADDR:
 		irdma_add_arp(iwdev->rf, local_ipaddr6, false,
-			      netdev->dev_addr);
-		irdma_if_notify(iwdev, netdev, local_ipaddr6, false, true);
+			      real_dev->dev_addr);
+		irdma_if_notify(iwdev, real_dev, local_ipaddr6, false, true);
 		irdma_gid_change_event(&iwdev->ibdev);
 		break;
 	default:
@@ -243,14 +251,18 @@ int irdma_net_event(struct notifier_block *notifier, unsigned long event,
 		    void *ptr)
 {
 	struct neighbour *neigh = ptr;
+	struct net_device *real_dev, *netdev = (struct net_device *)neigh->dev;
 	struct irdma_device *iwdev;
 	struct ib_device *ibdev;
 	__be32 *p;
 	u32 local_ipaddr[4] = {};
 	bool ipv4 = true;
 
-	ibdev = ib_device_get_by_netdev((struct net_device *)neigh->dev,
-					RDMA_DRIVER_IRDMA);
+	real_dev = rdma_vlan_dev_real_dev(netdev);
+	if (!real_dev)
+		real_dev = netdev;
+
+	ibdev = ib_device_get_by_netdev(real_dev, RDMA_DRIVER_IRDMA);
 	if (!ibdev)
 		return NOTIFY_DONE;
 
-- 
2.34.1



