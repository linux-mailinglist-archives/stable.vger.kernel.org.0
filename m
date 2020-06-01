Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088691EADA3
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgFASIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729939AbgFASH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:07:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E34207D0;
        Mon,  1 Jun 2020 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034878;
        bh=LCb0BPBCPLfJYFVSLYtRYnj3F1oTG9ETz6UsGfqX4Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRsOb+D3U6ju4k8/ydmSQd/USnH+338YjRFvW+AIBI93GCYmfpOw2tzF4BuRN8yvB
         af6vbjpJf7qsBYoNbn+/oqeGjVgDUMNEOQ3w9WrCVgewOkyKWpYK4eks/7vkDkhQBY
         ktoUWzPa4Op5U8hRaL4FLuGkmsIRMlflmNNWNwt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/142] IB/i40iw: Remove bogus call to netdev_master_upper_dev_get()
Date:   Mon,  1 Jun 2020 19:53:30 +0200
Message-Id: <20200601174043.197275387@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis V. Lunev <den@openvz.org>

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
index 2d6a378e8560..b1df93b69df4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1987,7 +1987,6 @@ static int i40iw_addr_resolve_neigh(struct i40iw_device *iwdev,
 	struct rtable *rt;
 	struct neighbour *neigh;
 	int rc = arpindex;
-	struct net_device *netdev = iwdev->netdev;
 	__be32 dst_ipaddr = htonl(dst_ip);
 	__be32 src_ipaddr = htonl(src_ip);
 
@@ -1997,9 +1996,6 @@ static int i40iw_addr_resolve_neigh(struct i40iw_device *iwdev,
 		return rc;
 	}
 
-	if (netif_is_bond_slave(netdev))
-		netdev = netdev_master_upper_dev_get(netdev);
-
 	neigh = dst_neigh_lookup(&rt->dst, &dst_ipaddr);
 
 	rcu_read_lock();
@@ -2065,7 +2061,6 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 {
 	struct neighbour *neigh;
 	int rc = arpindex;
-	struct net_device *netdev = iwdev->netdev;
 	struct dst_entry *dst;
 	struct sockaddr_in6 dst_addr;
 	struct sockaddr_in6 src_addr;
@@ -2086,9 +2081,6 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 		return rc;
 	}
 
-	if (netif_is_bond_slave(netdev))
-		netdev = netdev_master_upper_dev_get(netdev);
-
 	neigh = dst_neigh_lookup(dst, dst_addr.sin6_addr.in6_u.u6_addr32);
 
 	rcu_read_lock();
-- 
2.25.1



