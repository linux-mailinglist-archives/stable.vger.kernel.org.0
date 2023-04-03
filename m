Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D066D3C26
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 05:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjDCDbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Apr 2023 23:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjDCDbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Apr 2023 23:31:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE8A10D7
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 20:31:47 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso31093233pjb.3
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 20:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680492707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zi3AbqssZhLRzQZCxgwndBo4lN8HKlNHh+obXfpLWY8=;
        b=Xn2kpI+S4tNJ6L34vPgpY2lJnIFNk45groHQjGvRTvuK04c/sW51msSYGtuVykKWd7
         EHbtsI9axAxW0ozZfxRWmTi90d4eZpghVf4JjLhvLvM3krWzmYbtpy0x3dMj2xG6PI+h
         mgvKexwAvwl1THtbjDo9HfEvNvidclwQuqNvE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680492707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zi3AbqssZhLRzQZCxgwndBo4lN8HKlNHh+obXfpLWY8=;
        b=MGyy8X+s6xB9448jEgOQfSztaqROHMq+EoS+xagQ0VKuipQymmUvXwdnP22Hv1WttM
         4BSR0EuDfxL90j6IP/ibcV5bePkBFFlKF/JocTyFUSrXFU2RBpcxKegEPz2B5dECfoGy
         lRuTT60GcmlTFkdNj8ywaIJb6cpFfrD4sZp0rNmbiaSJYUy4CofnhoUqvmlpw6erOyv4
         yZiGxXpc1gksqZYBAndip4FpDs5rNwFtOiBl0V6VI/use0vG5KcIniVwZgdhLAVVSFSc
         KrqcQASKOYNZ2ugSdM8mKNOOR0beiHr3xn9PRb9/3wllFiAndaO6RKTJLhmDKLLnMKhG
         wMyQ==
X-Gm-Message-State: AAQBX9ewQPnxPUpHaq4zE/qTnYJXjbhD9aj92qqy9HS8Lw+nScLsG9SZ
        r7McoPWFn2ESuNjR2oY1FzNHyew/CUDYt7TVJL8=
X-Google-Smtp-Source: AKy350ZqzU5A4LPy8hdNM1jeNqAzROIHLOLOuED/9v6dVLZXjOR6Yds5HW+nVKm5X+AP9zllFvZPyA==
X-Received: by 2002:a17:90b:4c8b:b0:23f:44da:208d with SMTP id my11-20020a17090b4c8b00b0023f44da208dmr40290638pjb.47.1680492706878;
        Sun, 02 Apr 2023 20:31:46 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:9d:2:cc81:d874:d668:3a88])
        by smtp.googlemail.com with ESMTPSA id mh11-20020a17090b4acb00b0023cfbe7d62esm17597811pjb.1.2023.04.02.20.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 20:31:46 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
X-Google-Original-From: Zubin Mithra <zsm@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        edumazet@google.com, vladbu@mellanox.com, davem@davemloft.net,
        xiyou.wangcong@gmail.com, kuba@kernel.org, dvyukov@google.com
Subject: [PATCH v5.4.y 1/2] net_sched: add __rcu annotation to netdev->qdisc
Date:   Sun,  2 Apr 2023 20:31:39 -0700
Message-Id: <20230403033140.3229863-1-zsm@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 5891cd5ec46c2c2eb6427cb54d214b149635dd0e upstream.

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
Signed-off-by: Zubin Mithra <zsm@google.com>
---
 include/linux/netdevice.h |  2 +-
 net/core/rtnetlink.c      |  6 ++++--
 net/sched/cls_api.c       |  6 +++---
 net/sched/sch_api.c       | 22 ++++++++++++----------
 net/sched/sch_generic.c   | 22 ++++++++++++----------
 5 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 14183cbf0f0d..125542f305fa 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1986,7 +1986,7 @@ struct net_device {
 	struct netdev_queue	*_tx ____cacheline_aligned_in_smp;
 	unsigned int		num_tx_queues;
 	unsigned int		real_num_tx_queues;
-	struct Qdisc		*qdisc;
+	struct Qdisc __rcu	*qdisc;
 #ifdef CONFIG_NET_SCHED
 	DECLARE_HASHTABLE	(qdisc_hash, 4);
 #endif
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index dbc9b2f53649..da1ef00fc9cc 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1593,6 +1593,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
+	struct Qdisc *qdisc;
 
 	ASSERT_RTNL();
 	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*ifm), flags);
@@ -1610,6 +1611,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (tgt_netnsid >= 0 && nla_put_s32(skb, IFLA_TARGET_NETNSID, tgt_netnsid))
 		goto nla_put_failure;
 
+	qdisc = rtnl_dereference(dev->qdisc);
 	if (nla_put_string(skb, IFLA_IFNAME, dev->name) ||
 	    nla_put_u32(skb, IFLA_TXQLEN, dev->tx_queue_len) ||
 	    nla_put_u8(skb, IFLA_OPERSTATE,
@@ -1628,8 +1630,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
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
index 48a8c7daa635..77a1988d5ddc 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1079,7 +1079,7 @@ static int __tcf_qdisc_find(struct net *net, struct Qdisc **q,
 
 	/* Find qdisc */
 	if (!*parent) {
-		*q = dev->qdisc;
+		*q = rcu_dereference(dev->qdisc);
 		*parent = (*q)->handle;
 	} else {
 		*q = qdisc_lookup_rcu(dev, TC_H_MAJ(*parent));
@@ -2552,7 +2552,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 
 		parent = tcm->tcm_parent;
 		if (!parent)
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		else
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
 		if (!q)
@@ -2938,7 +2938,7 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 
 		parent = tcm->tcm_parent;
 		if (!parent) {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 			parent = q->handle;
 		} else {
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 154d62d8ac16..1d9b9a6e4668 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -298,7 +298,7 @@ struct Qdisc *qdisc_lookup(struct net_device *dev, u32 handle)
 
 	if (!handle)
 		return NULL;
-	q = qdisc_match_from_root(dev->qdisc, handle);
+	q = qdisc_match_from_root(rtnl_dereference(dev->qdisc), handle);
 	if (q)
 		goto out;
 
@@ -317,7 +317,7 @@ struct Qdisc *qdisc_lookup_rcu(struct net_device *dev, u32 handle)
 
 	if (!handle)
 		return NULL;
-	q = qdisc_match_from_root(dev->qdisc, handle);
+	q = qdisc_match_from_root(rcu_dereference(dev->qdisc), handle);
 	if (q)
 		goto out;
 
@@ -1072,10 +1072,10 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
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
@@ -1455,7 +1455,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
 		} else {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		}
 		if (!q) {
 			NL_SET_ERR_MSG(extack, "Cannot find specified qdisc on specified device");
@@ -1544,7 +1544,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
 		} else {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		}
 
 		/* It may be default qdisc, ignore it */
@@ -1766,7 +1766,8 @@ static int tc_dump_qdisc(struct sk_buff *skb, struct netlink_callback *cb)
 			s_q_idx = 0;
 		q_idx = 0;
 
-		if (tc_dump_qdisc_root(dev->qdisc, skb, cb, &q_idx, s_q_idx,
+		if (tc_dump_qdisc_root(rtnl_dereference(dev->qdisc),
+				       skb, cb, &q_idx, s_q_idx,
 				       true, tca[TCA_DUMP_INVISIBLE]) < 0)
 			goto done;
 
@@ -2042,7 +2043,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 		} else if (qid1) {
 			qid = qid1;
 		} else if (qid == 0)
-			qid = dev->qdisc->handle;
+			qid = rtnl_dereference(dev->qdisc)->handle;
 
 		/* Now qid is genuine qdisc handle consistent
 		 * both with parent and child.
@@ -2053,7 +2054,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 			portid = TC_H_MAKE(qid, portid);
 	} else {
 		if (qid == 0)
-			qid = dev->qdisc->handle;
+			qid = rtnl_dereference(dev->qdisc)->handle;
 	}
 
 	/* OK. Locate qdisc */
@@ -2214,7 +2215,8 @@ static int tc_dump_tclass(struct sk_buff *skb, struct netlink_callback *cb)
 	s_t = cb->args[0];
 	t = 0;
 
-	if (tc_dump_tclass_root(dev->qdisc, skb, tcm, cb, &t, s_t, true) < 0)
+	if (tc_dump_tclass_root(rtnl_dereference(dev->qdisc),
+				skb, tcm, cb, &t, s_t, true) < 0)
 		goto done;
 
 	dev_queue = dev_ingress_queue(dev);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 81fcf6c5bde9..1f055c21be4c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1106,18 +1106,20 @@ static void attach_default_qdiscs(struct net_device *dev)
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
+
 #ifdef CONFIG_NET_SCHED
-	if (dev->qdisc != &noop_qdisc)
-		qdisc_hash_add(dev->qdisc, false);
+	if (qdisc != &noop_qdisc)
+		qdisc_hash_add(qdisc, false);
 #endif
 }
 
@@ -1147,7 +1149,7 @@ void dev_activate(struct net_device *dev)
 	 * and noqueue_qdisc for virtual interfaces
 	 */
 
-	if (dev->qdisc == &noop_qdisc)
+	if (rtnl_dereference(dev->qdisc) == &noop_qdisc)
 		attach_default_qdiscs(dev);
 
 	if (!netif_carrier_ok(dev))
@@ -1316,7 +1318,7 @@ static int qdisc_change_tx_queue_len(struct net_device *dev,
 void dev_qdisc_change_real_num_tx(struct net_device *dev,
 				  unsigned int new_real_tx)
 {
-	struct Qdisc *qdisc = dev->qdisc;
+	struct Qdisc *qdisc = rtnl_dereference(dev->qdisc);
 
 	if (qdisc->ops->change_real_num_tx)
 		qdisc->ops->change_real_num_tx(qdisc, new_real_tx);
@@ -1356,7 +1358,7 @@ static void dev_init_scheduler_queue(struct net_device *dev,
 
 void dev_init_scheduler(struct net_device *dev)
 {
-	dev->qdisc = &noop_qdisc;
+	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 	netdev_for_each_tx_queue(dev, dev_init_scheduler_queue, &noop_qdisc);
 	if (dev_ingress_queue(dev))
 		dev_init_scheduler_queue(dev, dev_ingress_queue(dev), &noop_qdisc);
@@ -1384,8 +1386,8 @@ void dev_shutdown(struct net_device *dev)
 	netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
 	if (dev_ingress_queue(dev))
 		shutdown_scheduler_queue(dev, dev_ingress_queue(dev), &noop_qdisc);
-	qdisc_put(dev->qdisc);
-	dev->qdisc = &noop_qdisc;
+	qdisc_put(rtnl_dereference(dev->qdisc));
+	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 
 	WARN_ON(timer_pending(&dev->watchdog_timer));
 }
-- 
2.40.0.348.gf938b09366-goog

