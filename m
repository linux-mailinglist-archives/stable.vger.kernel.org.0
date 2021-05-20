Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D297738A166
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhETJbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232316AbhETJ3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:29:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E81C46135C;
        Thu, 20 May 2021 09:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502828;
        bh=VDUosEsJvzk5DKSA2eIVQH5GA6mro6Oe7eIha4U+KJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMMpAMRcR8Bs4M/49gldnP0H0KV7+lRrZaMAXPOzw7vrMszk0OWYW4fjafFep67jY
         yzQ4N0EzKF+/w1XqnJUvBTILUah4PjPLIJRZ5dhgjj3/NW3U941c6BenZaOXMK+I88
         YuWssznmkxsadp8ULhwUHVpKNTcb3e8nYEjbuZ0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Zhengming <zhangzhengming@huawei.com>,
        Zhao Lei <zhaolei69@huawei.com>,
        Wang Xiaogang <wangxiaogang3@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/47] bridge: Fix possible races between assigning rx_handler_data and setting IFF_BRIDGE_PORT bit
Date:   Thu, 20 May 2021 11:22:30 +0200
Message-Id: <20210520092054.578583294@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Zhengming <zhangzhengming@huawei.com>

[ Upstream commit 59259ff7a81b9eb6213891c6451221e567f8f22f ]

There is a crash in the function br_get_link_af_size_filtered,
as the port_exists(dev) is true and the rx_handler_data of dev is NULL.
But the rx_handler_data of dev is correct saved in vmcore.

The oops looks something like:
 ...
 pc : br_get_link_af_size_filtered+0x28/0x1c8 [bridge]
 ...
 Call trace:
  br_get_link_af_size_filtered+0x28/0x1c8 [bridge]
  if_nlmsg_size+0x180/0x1b0
  rtnl_calcit.isra.12+0xf8/0x148
  rtnetlink_rcv_msg+0x334/0x370
  netlink_rcv_skb+0x64/0x130
  rtnetlink_rcv+0x28/0x38
  netlink_unicast+0x1f0/0x250
  netlink_sendmsg+0x310/0x378
  sock_sendmsg+0x4c/0x70
  __sys_sendto+0x120/0x150
  __arm64_sys_sendto+0x30/0x40
  el0_svc_common+0x78/0x130
  el0_svc_handler+0x38/0x78
  el0_svc+0x8/0xc

In br_add_if(), we found there is no guarantee that
assigning rx_handler_data to dev->rx_handler_data
will before setting the IFF_BRIDGE_PORT bit of priv_flags.
So there is a possible data competition:

CPU 0:                                                        CPU 1:
(RCU read lock)                                               (RTNL lock)
rtnl_calcit()                                                 br_add_slave()
  if_nlmsg_size()                                               br_add_if()
    br_get_link_af_size_filtered()                              -> netdev_rx_handler_register
                                                                    ...
                                                                    // The order is not guaranteed
      ...                                                           -> dev->priv_flags |= IFF_BRIDGE_PORT;
      // The IFF_BRIDGE_PORT bit of priv_flags has been set
      -> if (br_port_exists(dev)) {
        // The dev->rx_handler_data has NOT been assigned
        -> p = br_port_get_rcu(dev);
        ....
                                                                    -> rcu_assign_pointer(dev->rx_handler_data, rx_handler_data);
                                                                     ...

Fix it in br_get_link_af_size_filtered, using br_port_get_check_rcu() and checking the return value.

Signed-off-by: Zhang Zhengming <zhangzhengming@huawei.com>
Reviewed-by: Zhao Lei <zhaolei69@huawei.com>
Reviewed-by: Wang Xiaogang <wangxiaogang3@huawei.com>
Suggested-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 92d64abffa87..73f71c22f4c0 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -99,8 +99,9 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 
 	rcu_read_lock();
 	if (netif_is_bridge_port(dev)) {
-		p = br_port_get_rcu(dev);
-		vg = nbp_vlan_group_rcu(p);
+		p = br_port_get_check_rcu(dev);
+		if (p)
+			vg = nbp_vlan_group_rcu(p);
 	} else if (dev->priv_flags & IFF_EBRIDGE) {
 		br = netdev_priv(dev);
 		vg = br_vlan_group_rcu(br);
-- 
2.30.2



