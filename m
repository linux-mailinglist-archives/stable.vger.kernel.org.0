Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E42C5AEA8C
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbiIFNpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbiIFNoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:44:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00437F128;
        Tue,  6 Sep 2022 06:38:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6A5061566;
        Tue,  6 Sep 2022 13:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987E7C433D6;
        Tue,  6 Sep 2022 13:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471427;
        bh=PIYJa1KBiYj2AUygeIodDHOhfZQu9b2PyJ/Iuilvo1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERrKPBXrcXoirTyscLe5dDiXndxyjxDdvAwWzL2I5NEnKrR5xh9lWlAfHMwK/BE+G
         MzWtZPVaE7cNU141peLnJ7TOCFvEYbrpf/2YFhSer+9oKEji/f8aXNI2i/pk5lGq46
         0NoqoHAzPc6AZrUwWHz+p88hnWkbuJJR49PcBUIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Hai <wanghai38@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/107] net/sched: fix netdevice reference leaks in attach_default_qdiscs()
Date:   Tue,  6 Sep 2022 15:30:03 +0200
Message-Id: <20220906132822.701679869@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit f612466ebecb12a00d9152344ddda6f6345f04dc ]

In attach_default_qdiscs(), if a dev has multiple queues and queue 0 fails
to attach qdisc because there is no memory in attach_one_default_qdisc().
Then dev->qdisc will be noop_qdisc by default. But the other queues may be
able to successfully attach to default qdisc.

In this case, the fallback to noqueue process will be triggered. If the
original attached qdisc is not released and a new one is directly
attached, this will cause netdevice reference leaks.

The following is the bug log:

veth0: default qdisc (fq_codel) fail, fallback to noqueue
unregister_netdevice: waiting for veth0 to become free. Usage count = 32
leaked reference.
 qdisc_alloc+0x12e/0x210
 qdisc_create_dflt+0x62/0x140
 attach_one_default_qdisc.constprop.41+0x44/0x70
 dev_activate+0x128/0x290
 __dev_open+0x12a/0x190
 __dev_change_flags+0x1a2/0x1f0
 dev_change_flags+0x23/0x60
 do_setlink+0x332/0x1150
 __rtnl_newlink+0x52f/0x8e0
 rtnl_newlink+0x43/0x70
 rtnetlink_rcv_msg+0x140/0x3b0
 netlink_rcv_skb+0x50/0x100
 netlink_unicast+0x1bb/0x290
 netlink_sendmsg+0x37c/0x4e0
 sock_sendmsg+0x5f/0x70
 ____sys_sendmsg+0x208/0x280

Fix this bug by clearing any non-noop qdiscs that may have been assigned
before trying to re-attach.

Fixes: bf6dba76d278 ("net: sched: fallback to qdisc noqueue if default qdisc setup fail")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20220826090055.24424-1-wanghai38@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 250d87d993cb7..02299785209c1 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1083,6 +1083,21 @@ struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 }
 EXPORT_SYMBOL(dev_graft_qdisc);
 
+static void shutdown_scheduler_queue(struct net_device *dev,
+				     struct netdev_queue *dev_queue,
+				     void *_qdisc_default)
+{
+	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
+	struct Qdisc *qdisc_default = _qdisc_default;
+
+	if (qdisc) {
+		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
+		dev_queue->qdisc_sleeping = qdisc_default;
+
+		qdisc_put(qdisc);
+	}
+}
+
 static void attach_one_default_qdisc(struct net_device *dev,
 				     struct netdev_queue *dev_queue,
 				     void *_unused)
@@ -1130,6 +1145,7 @@ static void attach_default_qdiscs(struct net_device *dev)
 	if (qdisc == &noop_qdisc) {
 		netdev_warn(dev, "default qdisc (%s) fail, fallback to %s\n",
 			    default_qdisc_ops->id, noqueue_qdisc_ops.id);
+		netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
 		dev->priv_flags |= IFF_NO_QUEUE;
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
 		qdisc = txq->qdisc_sleeping;
@@ -1384,21 +1400,6 @@ void dev_init_scheduler(struct net_device *dev)
 	timer_setup(&dev->watchdog_timer, dev_watchdog, 0);
 }
 
-static void shutdown_scheduler_queue(struct net_device *dev,
-				     struct netdev_queue *dev_queue,
-				     void *_qdisc_default)
-{
-	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
-	struct Qdisc *qdisc_default = _qdisc_default;
-
-	if (qdisc) {
-		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
-		dev_queue->qdisc_sleeping = qdisc_default;
-
-		qdisc_put(qdisc);
-	}
-}
-
 void dev_shutdown(struct net_device *dev)
 {
 	netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
-- 
2.35.1



