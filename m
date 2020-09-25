Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956352787CD
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgIYMua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729069AbgIYMu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E06421741;
        Fri, 25 Sep 2020 12:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038229;
        bh=Wa6lp2KfEOHpGQk2Kgnuy5TbQ9xJQay4N3ygIa6prt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTw3OY7pyXqPB5HEpwMZ7vzrerzEzWjKkFncjplcancq5iJKX48chxKa4GRrVerH1
         11uwJgIFjA89uVhgwN7o5HsNSj8RSpJ/kOua4OaEW/fWk/xcNhNstf/qizb9+HExWY
         6keiMTRx6VdaZYYfiFFTS84NxEeSYaPQfylifmAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 50/56] net: dsa: link interfaces with the DSA master to get rid of lockdep warnings
Date:   Fri, 25 Sep 2020 14:48:40 +0200
Message-Id: <20200925124735.338900089@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 2f1e8ea726e9020e01e9e2ae29c2d5eb11133032 ]

Since commit 845e0ebb4408 ("net: change addr_list_lock back to static
key"), cascaded DSA setups (DSA switch port as DSA master for another
DSA switch port) are emitting this lockdep warning:

============================================
WARNING: possible recursive locking detected
5.8.0-rc1-00133-g923e4b5032dd-dirty #208 Not tainted
--------------------------------------------
dhcpcd/323 is trying to acquire lock:
ffff000066dd4268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90

but task is already holding lock:
ffff00006608c268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&dsa_master_addr_list_lock_key/1);
  lock(&dsa_master_addr_list_lock_key/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by dhcpcd/323:
 #0: ffffdbd1381dda18 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x24/0x30
 #1: ffff00006614b268 (_xmit_ETHER){+...}-{2:2}, at: dev_set_rx_mode+0x28/0x48
 #2: ffff00006608c268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90

stack backtrace:
Call trace:
 dump_backtrace+0x0/0x1e0
 show_stack+0x20/0x30
 dump_stack+0xec/0x158
 __lock_acquire+0xca0/0x2398
 lock_acquire+0xe8/0x440
 _raw_spin_lock_nested+0x64/0x90
 dev_mc_sync+0x44/0x90
 dsa_slave_set_rx_mode+0x34/0x50
 __dev_set_rx_mode+0x60/0xa0
 dev_mc_sync+0x84/0x90
 dsa_slave_set_rx_mode+0x34/0x50
 __dev_set_rx_mode+0x60/0xa0
 dev_set_rx_mode+0x30/0x48
 __dev_open+0x10c/0x180
 __dev_change_flags+0x170/0x1c8
 dev_change_flags+0x2c/0x70
 devinet_ioctl+0x774/0x878
 inet_ioctl+0x348/0x3b0
 sock_do_ioctl+0x50/0x310
 sock_ioctl+0x1f8/0x580
 ksys_ioctl+0xb0/0xf0
 __arm64_sys_ioctl+0x28/0x38
 el0_svc_common.constprop.0+0x7c/0x180
 do_el0_svc+0x2c/0x98
 el0_sync_handler+0x9c/0x1b8
 el0_sync+0x158/0x180

Since DSA never made use of the netdev API for describing links between
upper devices and lower devices, the dev->lower_level value of a DSA
switch interface would be 1, which would warn when it is a DSA master.

We can use netdev_upper_dev_link() to describe the relationship between
a DSA slave and a DSA master. To be precise, a DSA "slave" (switch port)
is an "upper" to a DSA "master" (host port). The relationship is "many
uppers to one lower", like in the case of VLAN. So, for that reason, we
use the same function as VLAN uses.

There might be a chance that somebody will try to take hold of this
interface and use it immediately after register_netdev() and before
netdev_upper_dev_link(). To avoid that, we do the registration and
linkage while holding the RTNL, and we use the RTNL-locked cousin of
register_netdev(), which is register_netdevice().

Since this warning was not there when lockdep was using dynamic keys for
addr_list_lock, we are blaming the lockdep patch itself. The network
stack _has_ been using static lockdep keys before, and it _is_ likely
that stacked DSA setups have been triggering these lockdep warnings
since forever, however I can't test very old kernels on this particular
stacked DSA setup, to ensure I'm not in fact introducing regressions.

Fixes: 845e0ebb4408 ("net: change addr_list_lock back to static key")
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/slave.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1801,15 +1801,27 @@ int dsa_slave_create(struct dsa_port *po
 
 	dsa_slave_notify(slave_dev, DSA_PORT_REGISTER);
 
-	ret = register_netdev(slave_dev);
+	rtnl_lock();
+
+	ret = register_netdevice(slave_dev);
 	if (ret) {
 		netdev_err(master, "error %d registering interface %s\n",
 			   ret, slave_dev->name);
+		rtnl_unlock();
 		goto out_phy;
 	}
 
+	ret = netdev_upper_dev_link(master, slave_dev, NULL);
+
+	rtnl_unlock();
+
+	if (ret)
+		goto out_unregister;
+
 	return 0;
 
+out_unregister:
+	unregister_netdev(slave_dev);
 out_phy:
 	rtnl_lock();
 	phylink_disconnect_phy(p->dp->pl);
@@ -1826,16 +1838,18 @@ out_free:
 
 void dsa_slave_destroy(struct net_device *slave_dev)
 {
+	struct net_device *master = dsa_slave_to_master(slave_dev);
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
 	struct dsa_slave_priv *p = netdev_priv(slave_dev);
 
 	netif_carrier_off(slave_dev);
 	rtnl_lock();
+	netdev_upper_dev_unlink(master, slave_dev);
+	unregister_netdevice(slave_dev);
 	phylink_disconnect_phy(dp->pl);
 	rtnl_unlock();
 
 	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
-	unregister_netdev(slave_dev);
 	phylink_destroy(dp->pl);
 	gro_cells_destroy(&p->gcells);
 	free_percpu(p->stats64);


