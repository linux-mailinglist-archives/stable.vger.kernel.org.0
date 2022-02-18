Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFEF4BBADC
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbiBROq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:46:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiBROq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:46:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEAB3EF08
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:46:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAE32B82657
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1885C340E9;
        Fri, 18 Feb 2022 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645195566;
        bh=ZKKS192vo9eH5Ouf5D4Q8haoklhK8WvR0WQ0xHrw0cY=;
        h=Subject:To:Cc:From:Date:From;
        b=o8Yn0gQCEiYnKoOFmE04/opdCLdzcelMAZbdSq44KgIKoDNvyEe0aOZVx0+zhvSc8
         ny5gmgIxffV6Lgeli9EozFzXzY60ADeEKjE51he0Wi5Zg3qg/ycjhG4Ien7hT/oEqw
         eJHMOW08JQKOpeXvW5yhpwjjsbpCyKJMr63hayXA=
Subject: FAILED: patch "[PATCH] net_sched: add __rcu annotation to netdev->qdisc" failed to apply to 5.4-stable tree
To:     edumazet@google.com, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, syzkaller@googlegroups.com, vladbu@mellanox.com,
        xiyou.wangcong@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:46:03 +0100
Message-ID: <164519556377148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5891cd5ec46c2c2eb6427cb54d214b149635dd0e Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 11 Feb 2022 12:06:23 -0800
Subject: [PATCH] net_sched: add __rcu annotation to netdev->qdisc

syzbot found a data-race [1] which lead me to add __rcu
annotations to netdev->qdisc, and proper accessors
to get LOCKDEP support.

[1]
BUG: KCSAN: data-race in dev_activate / qdisc_lookup_rcu

write to 0xffff888168ad6410 of 8 bytes by task 13559 on cpu 1:
 attach_default_qdiscs net/sched/sch_generic.c:1167 [inline]
 dev_activate+0x2ed/0x8f0 net/sched/sch_generic.c:1221
 __dev_open+0x2e9/0x3a0 net/core/dev.c:1416
 __dev_change_flags+0x167/0x3f0 net/core/dev.c:8139
 rtnl_configure_link+0xc2/0x150 net/core/rtnetlink.c:3150
 __rtnl_newlink net/core/rtnetlink.c:3489 [inline]
 rtnl_newlink+0xf4d/0x13e0 net/core/rtnetlink.c:3529
 rtnetlink_rcv_msg+0x745/0x7e0 net/core/rtnetlink.c:5594
 netlink_rcv_skb+0x14e/0x250 net/netlink/af_netlink.c:2494
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:5612
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x602/0x6d0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x728/0x850 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmsg+0x195/0x230 net/socket.c:2496
 __do_sys_sendmsg net/socket.c:2505 [inline]
 __se_sys_sendmsg net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2503
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888168ad6410 of 8 bytes by task 13560 on cpu 0:
 qdisc_lookup_rcu+0x30/0x2e0 net/sched/sch_api.c:323
 __tcf_qdisc_find+0x74/0x3a0 net/sched/cls_api.c:1050
 tc_del_tfilter+0x1c7/0x1350 net/sched/cls_api.c:2211
 rtnetlink_rcv_msg+0x5ba/0x7e0 net/core/rtnetlink.c:5585
 netlink_rcv_skb+0x14e/0x250 net/netlink/af_netlink.c:2494
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:5612
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x602/0x6d0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x728/0x850 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmsg+0x195/0x230 net/socket.c:2496
 __do_sys_sendmsg net/socket.c:2505 [inline]
 __se_sys_sendmsg net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2503
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xffffffff85dee080 -> 0xffff88815d96ec00

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 13560 Comm: syz-executor.2 Not tainted 5.17.0-rc3-syzkaller-00116-gf1baf68e1383-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 470502de5bdb ("net: sched: unlock rules update API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vlad Buslov <vladbu@mellanox.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e490b84732d1..8b5a314db167 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2158,7 +2158,7 @@ struct net_device {
 	struct netdev_queue	*_tx ____cacheline_aligned_in_smp;
 	unsigned int		num_tx_queues;
 	unsigned int		real_num_tx_queues;
-	struct Qdisc		*qdisc;
+	struct Qdisc __rcu	*qdisc;
 	unsigned int		tx_queue_len;
 	spinlock_t		tx_global_lock;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 710da8a36729..2fb8eb6791e8 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1699,6 +1699,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
+	struct Qdisc *qdisc;
 
 	ASSERT_RTNL();
 	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*ifm), flags);
@@ -1716,6 +1717,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (tgt_netnsid >= 0 && nla_put_s32(skb, IFLA_TARGET_NETNSID, tgt_netnsid))
 		goto nla_put_failure;
 
+	qdisc = rtnl_dereference(dev->qdisc);
 	if (nla_put_string(skb, IFLA_IFNAME, dev->name) ||
 	    nla_put_u32(skb, IFLA_TXQLEN, dev->tx_queue_len) ||
 	    nla_put_u8(skb, IFLA_OPERSTATE,
@@ -1735,8 +1737,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 #endif
 	    put_master_ifindex(skb, dev) ||
 	    nla_put_u8(skb, IFLA_CARRIER, netif_carrier_ok(dev)) ||
-	    (dev->qdisc &&
-	     nla_put_string(skb, IFLA_QDISC, dev->qdisc->ops->id)) ||
+	    (qdisc &&
+	     nla_put_string(skb, IFLA_QDISC, qdisc->ops->id)) ||
 	    nla_put_ifalias(skb, dev) ||
 	    nla_put_u32(skb, IFLA_CARRIER_CHANGES,
 			atomic_read(&dev->carrier_up_count) +
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 5f0f346b576f..5ce1208a6ea3 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1044,7 +1044,7 @@ static int __tcf_qdisc_find(struct net *net, struct Qdisc **q,
 
 	/* Find qdisc */
 	if (!*parent) {
-		*q = dev->qdisc;
+		*q = rcu_dereference(dev->qdisc);
 		*parent = (*q)->handle;
 	} else {
 		*q = qdisc_lookup_rcu(dev, TC_H_MAJ(*parent));
@@ -2587,7 +2587,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 
 		parent = tcm->tcm_parent;
 		if (!parent)
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		else
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
 		if (!q)
@@ -2962,7 +2962,7 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 			return skb->len;
 
 		if (!tcm->tcm_parent)
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		else
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
 
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 179825a3b2fd..e3c0e8ea2dbb 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -301,7 +301,7 @@ struct Qdisc *qdisc_lookup(struct net_device *dev, u32 handle)
 
 	if (!handle)
 		return NULL;
-	q = qdisc_match_from_root(dev->qdisc, handle);
+	q = qdisc_match_from_root(rtnl_dereference(dev->qdisc), handle);
 	if (q)
 		goto out;
 
@@ -320,7 +320,7 @@ struct Qdisc *qdisc_lookup_rcu(struct net_device *dev, u32 handle)
 
 	if (!handle)
 		return NULL;
-	q = qdisc_match_from_root(dev->qdisc, handle);
+	q = qdisc_match_from_root(rcu_dereference(dev->qdisc), handle);
 	if (q)
 		goto out;
 
@@ -1082,10 +1082,10 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 skip:
 		if (!ingress) {
 			notify_and_destroy(net, skb, n, classid,
-					   dev->qdisc, new);
+					   rtnl_dereference(dev->qdisc), new);
 			if (new && !new->ops->attach)
 				qdisc_refcount_inc(new);
-			dev->qdisc = new ? : &noop_qdisc;
+			rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
 
 			if (new && new->ops->attach)
 				new->ops->attach(new);
@@ -1451,7 +1451,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
 		} else {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		}
 		if (!q) {
 			NL_SET_ERR_MSG(extack, "Cannot find specified qdisc on specified device");
@@ -1540,7 +1540,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
 		} else {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		}
 
 		/* It may be default qdisc, ignore it */
@@ -1762,7 +1762,8 @@ static int tc_dump_qdisc(struct sk_buff *skb, struct netlink_callback *cb)
 			s_q_idx = 0;
 		q_idx = 0;
 
-		if (tc_dump_qdisc_root(dev->qdisc, skb, cb, &q_idx, s_q_idx,
+		if (tc_dump_qdisc_root(rtnl_dereference(dev->qdisc),
+				       skb, cb, &q_idx, s_q_idx,
 				       true, tca[TCA_DUMP_INVISIBLE]) < 0)
 			goto done;
 
@@ -2033,7 +2034,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 		} else if (qid1) {
 			qid = qid1;
 		} else if (qid == 0)
-			qid = dev->qdisc->handle;
+			qid = rtnl_dereference(dev->qdisc)->handle;
 
 		/* Now qid is genuine qdisc handle consistent
 		 * both with parent and child.
@@ -2044,7 +2045,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 			portid = TC_H_MAKE(qid, portid);
 	} else {
 		if (qid == 0)
-			qid = dev->qdisc->handle;
+			qid = rtnl_dereference(dev->qdisc)->handle;
 	}
 
 	/* OK. Locate qdisc */
@@ -2205,7 +2206,8 @@ static int tc_dump_tclass(struct sk_buff *skb, struct netlink_callback *cb)
 	s_t = cb->args[0];
 	t = 0;
 
-	if (tc_dump_tclass_root(dev->qdisc, skb, tcm, cb, &t, s_t, true) < 0)
+	if (tc_dump_tclass_root(rtnl_dereference(dev->qdisc),
+				skb, tcm, cb, &t, s_t, true) < 0)
 		goto done;
 
 	dev_queue = dev_ingress_queue(dev);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index f893d9a81b01..5bab9f8b8f45 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1164,30 +1164,33 @@ static void attach_default_qdiscs(struct net_device *dev)
 	if (!netif_is_multiqueue(dev) ||
 	    dev->priv_flags & IFF_NO_QUEUE) {
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
-		dev->qdisc = txq->qdisc_sleeping;
-		qdisc_refcount_inc(dev->qdisc);
+		qdisc = txq->qdisc_sleeping;
+		rcu_assign_pointer(dev->qdisc, qdisc);
+		qdisc_refcount_inc(qdisc);
 	} else {
 		qdisc = qdisc_create_dflt(txq, &mq_qdisc_ops, TC_H_ROOT, NULL);
 		if (qdisc) {
-			dev->qdisc = qdisc;
+			rcu_assign_pointer(dev->qdisc, qdisc);
 			qdisc->ops->attach(qdisc);
 		}
 	}
+	qdisc = rtnl_dereference(dev->qdisc);
 
 	/* Detect default qdisc setup/init failed and fallback to "noqueue" */
-	if (dev->qdisc == &noop_qdisc) {
+	if (qdisc == &noop_qdisc) {
 		netdev_warn(dev, "default qdisc (%s) fail, fallback to %s\n",
 			    default_qdisc_ops->id, noqueue_qdisc_ops.id);
 		dev->priv_flags |= IFF_NO_QUEUE;
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
-		dev->qdisc = txq->qdisc_sleeping;
-		qdisc_refcount_inc(dev->qdisc);
+		qdisc = txq->qdisc_sleeping;
+		rcu_assign_pointer(dev->qdisc, qdisc);
+		qdisc_refcount_inc(qdisc);
 		dev->priv_flags ^= IFF_NO_QUEUE;
 	}
 
 #ifdef CONFIG_NET_SCHED
-	if (dev->qdisc != &noop_qdisc)
-		qdisc_hash_add(dev->qdisc, false);
+	if (qdisc != &noop_qdisc)
+		qdisc_hash_add(qdisc, false);
 #endif
 }
 
@@ -1217,7 +1220,7 @@ void dev_activate(struct net_device *dev)
 	 * and noqueue_qdisc for virtual interfaces
 	 */
 
-	if (dev->qdisc == &noop_qdisc)
+	if (rtnl_dereference(dev->qdisc) == &noop_qdisc)
 		attach_default_qdiscs(dev);
 
 	if (!netif_carrier_ok(dev))
@@ -1383,7 +1386,7 @@ static int qdisc_change_tx_queue_len(struct net_device *dev,
 void dev_qdisc_change_real_num_tx(struct net_device *dev,
 				  unsigned int new_real_tx)
 {
-	struct Qdisc *qdisc = dev->qdisc;
+	struct Qdisc *qdisc = rtnl_dereference(dev->qdisc);
 
 	if (qdisc->ops->change_real_num_tx)
 		qdisc->ops->change_real_num_tx(qdisc, new_real_tx);
@@ -1447,7 +1450,7 @@ static void dev_init_scheduler_queue(struct net_device *dev,
 
 void dev_init_scheduler(struct net_device *dev)
 {
-	dev->qdisc = &noop_qdisc;
+	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 	netdev_for_each_tx_queue(dev, dev_init_scheduler_queue, &noop_qdisc);
 	if (dev_ingress_queue(dev))
 		dev_init_scheduler_queue(dev, dev_ingress_queue(dev), &noop_qdisc);
@@ -1475,8 +1478,8 @@ void dev_shutdown(struct net_device *dev)
 	netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
 	if (dev_ingress_queue(dev))
 		shutdown_scheduler_queue(dev, dev_ingress_queue(dev), &noop_qdisc);
-	qdisc_put(dev->qdisc);
-	dev->qdisc = &noop_qdisc;
+	qdisc_put(rtnl_dereference(dev->qdisc));
+	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 
 	WARN_ON(timer_pending(&dev->watchdog_timer));
 }

