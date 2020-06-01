Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC7B1EAAC1
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgFASLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731070AbgFASLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:11:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A4012065C;
        Mon,  1 Jun 2020 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035066;
        bh=WnB/Fc9lXO7F0GBQ1/4jTWlZdcne6aVsVA7YQnii9vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3J9BWjJIbC5nUCg7xsjym62cDzAHFoCjsrM0MfWgiM1iIQF/SUUQkGPKLpHA0nZt
         EHlr618r9qH+QSoFhFdwKi0isErbEyVRR9WAhXqJWvCyHVVJtsYhWDKCMExZV+mWXv
         D1J89jzb0BAbfJzDwe3OtJAadpM9EhxG+5nn6FVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 136/142] net: dsa: declare lockless TX feature for slave ports
Date:   Mon,  1 Jun 2020 19:54:54 +0200
Message-Id: <20200601174051.789807524@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 2b86cb8299765688c5119fd18d5f436716c81010 upstream.

Be there a platform with the following layout:

      Regular NIC
       |
       +----> DSA master for switch port
               |
               +----> DSA master for another switch port

After changing DSA back to static lockdep class keys in commit
1a33e10e4a95 ("net: partially revert dynamic lockdep key changes"), this
kernel splat can be seen:

[   13.361198] ============================================
[   13.366524] WARNING: possible recursive locking detected
[   13.371851] 5.7.0-rc4-02121-gc32a05ecd7af-dirty #988 Not tainted
[   13.377874] --------------------------------------------
[   13.383201] swapper/0/0 is trying to acquire lock:
[   13.388004] ffff0000668ff298 (&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at: __dev_queue_xmit+0x84c/0xbe0
[   13.397879]
[   13.397879] but task is already holding lock:
[   13.403727] ffff0000661a1698 (&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at: __dev_queue_xmit+0x84c/0xbe0
[   13.413593]
[   13.413593] other info that might help us debug this:
[   13.420140]  Possible unsafe locking scenario:
[   13.420140]
[   13.426075]        CPU0
[   13.428523]        ----
[   13.430969]   lock(&dsa_slave_netdev_xmit_lock_key);
[   13.435946]   lock(&dsa_slave_netdev_xmit_lock_key);
[   13.440924]
[   13.440924]  *** DEADLOCK ***
[   13.440924]
[   13.446860]  May be due to missing lock nesting notation
[   13.446860]
[   13.453668] 6 locks held by swapper/0/0:
[   13.457598]  #0: ffff800010003de0 ((&idev->mc_ifc_timer)){+.-.}-{0:0}, at: call_timer_fn+0x0/0x400
[   13.466593]  #1: ffffd4d3fb478700 (rcu_read_lock){....}-{1:2}, at: mld_sendpack+0x0/0x560
[   13.474803]  #2: ffffd4d3fb478728 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x64/0xb10
[   13.483886]  #3: ffffd4d3fb478728 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x6c/0xbe0
[   13.492793]  #4: ffff0000661a1698 (&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at: __dev_queue_xmit+0x84c/0xbe0
[   13.503094]  #5: ffffd4d3fb478728 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x6c/0xbe0
[   13.512000]
[   13.512000] stack backtrace:
[   13.516369] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.7.0-rc4-02121-gc32a05ecd7af-dirty #988
[   13.530421] Call trace:
[   13.532871]  dump_backtrace+0x0/0x1d8
[   13.536539]  show_stack+0x24/0x30
[   13.539862]  dump_stack+0xe8/0x150
[   13.543271]  __lock_acquire+0x1030/0x1678
[   13.547290]  lock_acquire+0xf8/0x458
[   13.550873]  _raw_spin_lock+0x44/0x58
[   13.554543]  __dev_queue_xmit+0x84c/0xbe0
[   13.558562]  dev_queue_xmit+0x24/0x30
[   13.562232]  dsa_slave_xmit+0xe0/0x128
[   13.565988]  dev_hard_start_xmit+0xf4/0x448
[   13.570182]  __dev_queue_xmit+0x808/0xbe0
[   13.574200]  dev_queue_xmit+0x24/0x30
[   13.577869]  neigh_resolve_output+0x15c/0x220
[   13.582237]  ip6_finish_output2+0x244/0xb10
[   13.586430]  __ip6_finish_output+0x1dc/0x298
[   13.590709]  ip6_output+0x84/0x358
[   13.594116]  mld_sendpack+0x2bc/0x560
[   13.597786]  mld_ifc_timer_expire+0x210/0x390
[   13.602153]  call_timer_fn+0xcc/0x400
[   13.605822]  run_timer_softirq+0x588/0x6e0
[   13.609927]  __do_softirq+0x118/0x590
[   13.613597]  irq_exit+0x13c/0x148
[   13.616918]  __handle_domain_irq+0x6c/0xc0
[   13.621023]  gic_handle_irq+0x6c/0x160
[   13.624779]  el1_irq+0xbc/0x180
[   13.627927]  cpuidle_enter_state+0xb4/0x4d0
[   13.632120]  cpuidle_enter+0x3c/0x50
[   13.635703]  call_cpuidle+0x44/0x78
[   13.639199]  do_idle+0x228/0x2c8
[   13.642433]  cpu_startup_entry+0x2c/0x48
[   13.646363]  rest_init+0x1ac/0x280
[   13.649773]  arch_call_rest_init+0x14/0x1c
[   13.653878]  start_kernel+0x490/0x4bc

Lockdep keys themselves were added in commit ab92d68fc22f ("net: core:
add generic lockdep keys"), and it's very likely that this splat existed
since then, but I have no real way to check, since this stacked platform
wasn't supported by mainline back then.

>From Taehee's own words:

  This patch was considered that all stackable devices have LLTX flag.
  But the dsa doesn't have LLTX, so this splat happened.
  After this patch, dsa shares the same lockdep class key.
  On the nested dsa interface architecture, which you illustrated,
  the same lockdep class key will be used in __dev_queue_xmit() because
  dsa doesn't have LLTX.
  So that lockdep detects deadlock because the same lockdep class key is
  used recursively although actually the different locks are used.
  There are some ways to fix this problem.

  1. using NETIF_F_LLTX flag.
  If possible, using the LLTX flag is a very clear way for it.
  But I'm so sorry I don't know whether the dsa could have LLTX or not.

  2. using dynamic lockdep again.
  It means that each interface uses a separate lockdep class key.
  So, lockdep will not detect recursive locking.
  But this way has a problem that it could consume lockdep class key
  too many.
  Currently, lockdep can have 8192 lockdep class keys.
   - you can see this number with the following command.
     cat /proc/lockdep_stats
     lock-classes:                         1251 [max: 8192]
     ...
     The [max: 8192] means that the maximum number of lockdep class keys.
  If too many lockdep class keys are registered, lockdep stops to work.
  So, using a dynamic(separated) lockdep class key should be considered
  carefully.
  In addition, updating lockdep class key routine might have to be existing.
  (lockdep_register_key(), lockdep_set_class(), lockdep_unregister_key())

  3. Using lockdep subclass.
  A lockdep class key could have 8 subclasses.
  The different subclass is considered different locks by lockdep
  infrastructure.
  But "lock-classes" is not counted by subclasses.
  So, it could avoid stopping lockdep infrastructure by an overflow of
  lockdep class keys.
  This approach should also have an updating lockdep class key routine.
  (lockdep_set_subclass())

  4. Using nonvalidate lockdep class key.
  The lockdep infrastructure supports nonvalidate lockdep class key type.
  It means this lockdep is not validated by lockdep infrastructure.
  So, the splat will not happen but lockdep couldn't detect real deadlock
  case because lockdep really doesn't validate it.
  I think this should be used for really special cases.
  (lockdep_set_novalidate_class())

Further discussion here:
https://patchwork.ozlabs.org/project/netdev/patch/20200503052220.4536-2-xiyou.wangcong@gmail.com/

There appears to be no negative side-effect to declaring lockless TX for
the DSA virtual interfaces, which means they handle their own locking.
So that's what we do to make the splat go away.

Patch tested in a wide variety of cases: unicast, multicast, PTP, etc.

Fixes: ab92d68fc22f ("net: core: add generic lockdep keys")
Suggested-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/dsa/slave.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1409,6 +1409,7 @@ int dsa_slave_create(struct dsa_port *po
 	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
 		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
+	slave_dev->features |= NETIF_F_LLTX;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
 	if (!IS_ERR_OR_NULL(port->mac))
 		ether_addr_copy(slave_dev->dev_addr, port->mac);


