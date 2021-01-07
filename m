Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FD52ED285
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbhAGOdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728877AbhAGOdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2145C23380;
        Thu,  7 Jan 2021 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029990;
        bh=HWZ5pUcIh7vnOZHAitYCW+LIBduAShSCNQC8VP8tyzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAxj6WKokAr9AKACmGUyaxLa5TciQ3xCHJZi30SnPoOHKDqU0cu1l5flrBhPErfGP
         +JhLPiv9wzfl4PMZlnCWH+anHcvHmV2I5OsYl1cD5M96RMxrOZw443o3XI/A1xWl5/
         dcfx4ESMtdT80AqtSFEmDxbSGTHaNu/g9siBSZm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/20] RDMA/siw,rxe: Make emulated devices virtual in the device tree
Date:   Thu,  7 Jan 2021 15:34:09 +0100
Message-Id: <20210107143054.379194121@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit a9d2e9ae953f0ddd0327479c81a085adaa76d903 ]

This moves siw and rxe to be virtual devices in the device tree:

lrwxrwxrwx 1 root root 0 Nov  6 13:55 /sys/class/infiniband/rxe0 -> ../../devices/virtual/infiniband/rxe0/

Previously they were trying to parent themselves to the physical device of
their attached netdev, which doesn't make alot of sense.

My hope is this will solve some weird syzkaller hits related to sysfs as
it could be possible that the parent of a netdev is another netdev, eg
under bonding or some other syzkaller found netdev configuration.

Nesting a ib_device under anything but a physical device is going to cause
inconsistencies in sysfs during destructions.

Link: https://lore.kernel.org/r/0-v1-dcbfc68c4b4a+d6-virtual_dev_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c   | 12 ------------
 drivers/infiniband/sw/rxe/rxe_verbs.c |  1 -
 drivers/infiniband/sw/siw/siw_main.c  | 19 +------------------
 3 files changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 34bef7d8e6b41..943914c2a50c7 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -20,18 +20,6 @@
 
 static struct rxe_recv_sockets recv_sockets;
 
-struct device *rxe_dma_device(struct rxe_dev *rxe)
-{
-	struct net_device *ndev;
-
-	ndev = rxe->ndev;
-
-	if (is_vlan_dev(ndev))
-		ndev = vlan_dev_real_dev(ndev);
-
-	return ndev->dev.parent;
-}
-
 int rxe_mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
 {
 	int err;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 9c66f76545b3c..512868c230238 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1124,7 +1124,6 @@ int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name)
 	dev->node_type = RDMA_NODE_IB_CA;
 	dev->phys_port_cnt = 1;
 	dev->num_comp_vectors = num_possible_cpus();
-	dev->dev.parent = rxe_dma_device(rxe);
 	dev->local_dma_lkey = 0;
 	addrconf_addr_eui48((unsigned char *)&dev->node_guid,
 			    rxe->ndev->dev_addr);
diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index c62a7a0d423c0..9d152e198a59b 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -305,24 +305,8 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 {
 	struct siw_device *sdev = NULL;
 	struct ib_device *base_dev;
-	struct device *parent = netdev->dev.parent;
 	int rv;
 
-	if (!parent) {
-		/*
-		 * The loopback device has no parent device,
-		 * so it appears as a top-level device. To support
-		 * loopback device connectivity, take this device
-		 * as the parent device. Skip all other devices
-		 * w/o parent device.
-		 */
-		if (netdev->type != ARPHRD_LOOPBACK) {
-			pr_warn("siw: device %s error: no parent device\n",
-				netdev->name);
-			return NULL;
-		}
-		parent = &netdev->dev;
-	}
 	sdev = ib_alloc_device(siw_device, base_dev);
 	if (!sdev)
 		return NULL;
@@ -381,7 +365,6 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 	 * per physical port.
 	 */
 	base_dev->phys_port_cnt = 1;
-	base_dev->dev.parent = parent;
 	base_dev->num_comp_vectors = num_possible_cpus();
 
 	xa_init_flags(&sdev->qp_xa, XA_FLAGS_ALLOC1);
@@ -423,7 +406,7 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 	atomic_set(&sdev->num_mr, 0);
 	atomic_set(&sdev->num_pd, 0);
 
-	sdev->numa_node = dev_to_node(parent);
+	sdev->numa_node = dev_to_node(&netdev->dev);
 	spin_lock_init(&sdev->lock);
 
 	return sdev;
-- 
2.27.0



