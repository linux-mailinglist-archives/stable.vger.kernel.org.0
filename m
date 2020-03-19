Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120C218B60B
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgCSNXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730360AbgCSNXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ADFA21556;
        Thu, 19 Mar 2020 13:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624214;
        bh=vxseYOJeQCS6fWbwxaaYEYi2MoV+stP5GL0I0dHdpzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hO1alwnVRWHY5lEeXUYqhw4AnEKmqE+lZz5e6jIXS2OmKQ2dqwCISaFh+spWCo9L
         L5MNZppUa8LP3rS/nv/vQqemv1jbF4m1WZv9mev+0vUFo8SqinFL5tna1wPNYAjtkC
         BRQbr3E4kj4+Ona7ALMGxnXTuJ/VoDFIYZIrgGfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/60] net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
Date:   Thu, 19 Mar 2020 14:04:23 +0100
Message-Id: <20200319123933.890081453@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit c026d970102e9af9958edefb4a015702c6aab636 ]

The notifier_call() of the slave interface removes rmnet interface with
unregister_netdevice_queue().
But, before calling unregister_netdevice_queue(), it acquires
rcu readlock.
In the RCU critical section, sleeping isn't be allowed.
But, unregister_netdevice_queue() internally calls synchronize_net(),
which would sleep.
So, suspicious RCU usage warning occurs.

Test commands:
    modprobe rmnet
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link set dummy1 master rmnet0
    ip link del dummy0

Splat looks like:
[   79.639245][ T1195] =============================
[   79.640134][ T1195] WARNING: suspicious RCU usage
[   79.640852][ T1195] 5.6.0-rc1+ #447 Not tainted
[   79.641657][ T1195] -----------------------------
[   79.642472][ T1195] ./include/linux/rcupdate.h:273 Illegal context switch in RCU read-side critical section!
[   79.644043][ T1195]
[   79.644043][ T1195] other info that might help us debug this:
[   79.644043][ T1195]
[   79.645682][ T1195]
[   79.645682][ T1195] rcu_scheduler_active = 2, debug_locks = 1
[   79.646980][ T1195] 2 locks held by ip/1195:
[   79.647629][ T1195]  #0: ffffffffa3cf64f0 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x457/0x890
[   79.649312][ T1195]  #1: ffffffffa39256c0 (rcu_read_lock){....}, at: rmnet_config_notify_cb+0xf0/0x590 [rmnet]
[   79.651717][ T1195]
[   79.651717][ T1195] stack backtrace:
[   79.652650][ T1195] CPU: 3 PID: 1195 Comm: ip Not tainted 5.6.0-rc1+ #447
[   79.653702][ T1195] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   79.655037][ T1195] Call Trace:
[   79.655560][ T1195]  dump_stack+0x96/0xdb
[   79.656252][ T1195]  ___might_sleep+0x345/0x440
[   79.656994][ T1195]  synchronize_net+0x18/0x30
[   79.661132][ T1195]  netdev_rx_handler_unregister+0x40/0xb0
[   79.666266][ T1195]  rmnet_unregister_real_device+0x42/0xb0 [rmnet]
[   79.667211][ T1195]  rmnet_config_notify_cb+0x1f7/0x590 [rmnet]
[   79.668121][ T1195]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[   79.669166][ T1195]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[   79.670286][ T1195]  ? __module_text_address+0x13/0x140
[   79.671139][ T1195]  notifier_call_chain+0x90/0x160
[   79.671973][ T1195]  rollback_registered_many+0x660/0xcf0
[   79.672893][ T1195]  ? netif_set_real_num_tx_queues+0x780/0x780
[   79.675091][ T1195]  ? __lock_acquire+0xdfe/0x3de0
[   79.675825][ T1195]  ? memset+0x1f/0x40
[   79.676367][ T1195]  ? __nla_validate_parse+0x98/0x1ab0
[   79.677290][ T1195]  unregister_netdevice_many.part.133+0x13/0x1b0
[   79.678163][ T1195]  rtnl_delete_link+0xbc/0x100
[ ... ]

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fc68ecdd804bc..0ad64aa665925 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -230,7 +230,6 @@ static void rmnet_force_unassociate_device(struct net_device *dev)
 
 	port = rmnet_get_port_rtnl(dev);
 
-	rcu_read_lock();
 	rmnet_unregister_bridge(dev, port);
 
 	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
@@ -241,7 +240,6 @@ static void rmnet_force_unassociate_device(struct net_device *dev)
 		kfree(ep);
 	}
 
-	rcu_read_unlock();
 	unregister_netdevice_many(&list);
 
 	rmnet_unregister_real_device(real_dev, port);
-- 
2.20.1



