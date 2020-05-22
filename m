Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4E21DEA5B
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbgEVOyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731063AbgEVOvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B342145D;
        Fri, 22 May 2020 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159098;
        bh=G02uOQXZHAtlp5iiuYiQJAEfyrr+0VCf29HFdP4vK7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oH/g/x0F+9xXU5KDbvawZAJ4G6qhEINOOGgkbzRdOYoHFM6rGoqOB6etG2ko1HISJ
         J/G3LMkWNAB51UDDaaph2OAw8nFyQqA1yLIbjtA0jfvVl9rSYXM5iYJx2ud2ZaexBU
         AAo5zp5DOEWpHQX/J/vepqVU82hxs/ZiTYl1S5t0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Denis V. Lunev" <den@openvz.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/19] IB/i40iw: Remove bogus call to netdev_master_upper_dev_get()
Date:   Fri, 22 May 2020 10:51:17 -0400
Message-Id: <20200522145120.434921-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145120.434921-1-sashal@kernel.org>
References: <20200522145120.434921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Denis V. Lunev" <den@openvz.org>

[ Upstream commit 856ec7f64688387b100b7083cdf480ce3ac41227 ]

Local variable netdev is not used in these calls.

It should be noted, that this change is required to work in bonded mode.
Otherwise we would get the following assert:

 "RTNL: assertion failed at net/core/dev.c (5665)"

With the calltrace as follows:
	dump_stack+0x19/0x1b
	netdev_master_upper_dev_get+0x61/0x70
	i40iw_addr_resolve_neigh+0x1e8/0x220
	i40iw_make_cm_node+0x296/0x700
	? i40iw_find_listener.isra.10+0xcc/0x110
	i40iw_receive_ilq+0x3d4/0x810
	i40iw_puda_poll_completion+0x341/0x420
	i40iw_process_ceq+0xa5/0x280
	i40iw_ceq_dpc+0x1e/0x40
	tasklet_action+0x83/0x140
	__do_softirq+0x125/0x2bb
	call_softirq+0x1c/0x30
	do_softirq+0x65/0xa0
	irq_exit+0x105/0x110
	do_IRQ+0x56/0xf0
	common_interrupt+0x16a/0x16a
	? cpuidle_enter_state+0x57/0xd0
	cpuidle_idle_call+0xde/0x230
	arch_cpu_idle+0xe/0xc0
	cpu_startup_entry+0x14a/0x1e0
	start_secondary+0x1f7/0x270
	start_cpu+0x5/0x14

Link: https://lore.kernel.org/r/20200428131511.11049-1-den@openvz.org
Signed-off-by: Denis V. Lunev <den@openvz.org>
Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 771eb6bd0785..4321b9e3dbb4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1984,7 +1984,6 @@ static int i40iw_addr_resolve_neigh(struct i40iw_device *iwdev,
 	struct rtable *rt;
 	struct neighbour *neigh;
 	int rc = arpindex;
-	struct net_device *netdev = iwdev->netdev;
 	__be32 dst_ipaddr = htonl(dst_ip);
 	__be32 src_ipaddr = htonl(src_ip);
 
@@ -1994,9 +1993,6 @@ static int i40iw_addr_resolve_neigh(struct i40iw_device *iwdev,
 		return rc;
 	}
 
-	if (netif_is_bond_slave(netdev))
-		netdev = netdev_master_upper_dev_get(netdev);
-
 	neigh = dst_neigh_lookup(&rt->dst, &dst_ipaddr);
 
 	rcu_read_lock();
@@ -2062,7 +2058,6 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 {
 	struct neighbour *neigh;
 	int rc = arpindex;
-	struct net_device *netdev = iwdev->netdev;
 	struct dst_entry *dst;
 	struct sockaddr_in6 dst_addr;
 	struct sockaddr_in6 src_addr;
@@ -2083,9 +2078,6 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 		return rc;
 	}
 
-	if (netif_is_bond_slave(netdev))
-		netdev = netdev_master_upper_dev_get(netdev);
-
 	neigh = dst_neigh_lookup(dst, dst_addr.sin6_addr.in6_u.u6_addr32);
 
 	rcu_read_lock();
-- 
2.25.1

