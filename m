Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C7D472566
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhLMJni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbhLMJk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3504C07E5F4;
        Mon, 13 Dec 2021 01:38:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1991B80E25;
        Mon, 13 Dec 2021 09:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02769C341CA;
        Mon, 13 Dec 2021 09:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388329;
        bh=3Jg5iSCEgtIjCZvBxnLvA63JMEDxoMI98Nd4NuuvZvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBXeEYn1LPWclPsDn1rBAtbawWa+jQzGSpgSQqDkA5w8r4cSbCYol9W/H+KAGrzI7
         ROJHc9F8tkW7zG9IaU5SrbgLI2CyqT9E/sUdtm2BJYSGdPEE7Ti07cOjf9IByvAYiC
         mnsEVetID2/t3wdh0qAd5aY06W6UW31Rn62+8hL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Subject: [PATCH 4.19 12/74] net: sched: extend Qdisc with rcu
Date:   Mon, 13 Dec 2021 10:29:43 +0100
Message-Id: <20211213092931.189152188@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 3a7d0d07a386716b459b00783b11a8211cefcc0f ]

Currently, Qdisc API functions assume that users have rtnl lock taken. To
implement rtnl unlocked classifiers update interface, Qdisc API must be
extended with functions that do not require rtnl lock.

Extend Qdisc structure with rcu. Implement special version of put function
qdisc_put_unlocked() that is called without rtnl lock taken. This function
only takes rtnl lock if Qdisc reference counter reached zero and is
intended to be used as optimization.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Lee: Sent to Stable]
Link: https://syzkaller.appspot.com/bug?id=d7e411c5472dd5da33d8cc921ccadc747743a568
Reported-by: syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rtnetlink.h |    5 +++++
 include/net/pkt_sched.h   |    1 +
 include/net/sch_generic.h |    2 ++
 net/sched/sch_api.c       |   18 ++++++++++++++++++
 net/sched/sch_generic.c   |   25 ++++++++++++++++++++++++-
 5 files changed, 50 insertions(+), 1 deletion(-)

--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -85,6 +85,11 @@ static inline struct netdev_queue *dev_i
 	return rtnl_dereference(dev->ingress_queue);
 }
 
+static inline struct netdev_queue *dev_ingress_queue_rcu(struct net_device *dev)
+{
+	return rcu_dereference(dev->ingress_queue);
+}
+
 struct netdev_queue *dev_ingress_queue_create(struct net_device *dev);
 
 #ifdef CONFIG_NET_INGRESS
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -103,6 +103,7 @@ int qdisc_set_default(const char *id);
 void qdisc_hash_add(struct Qdisc *q, bool invisible);
 void qdisc_hash_del(struct Qdisc *q);
 struct Qdisc *qdisc_lookup(struct net_device *dev, u32 handle);
+struct Qdisc *qdisc_lookup_rcu(struct net_device *dev, u32 handle);
 struct qdisc_rate_table *qdisc_get_rtab(struct tc_ratespec *r,
 					struct nlattr *tab,
 					struct netlink_ext_ack *extack);
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -108,6 +108,7 @@ struct Qdisc {
 
 	spinlock_t		busylock ____cacheline_aligned_in_smp;
 	spinlock_t		seqlock;
+	struct rcu_head		rcu;
 };
 
 static inline void qdisc_refcount_inc(struct Qdisc *qdisc)
@@ -560,6 +561,7 @@ struct Qdisc *dev_graft_qdisc(struct net
 			      struct Qdisc *qdisc);
 void qdisc_reset(struct Qdisc *qdisc);
 void qdisc_put(struct Qdisc *qdisc);
+void qdisc_put_unlocked(struct Qdisc *qdisc);
 void qdisc_tree_reduce_backlog(struct Qdisc *qdisc, unsigned int n,
 			       unsigned int len);
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -315,6 +315,24 @@ out:
 	return q;
 }
 
+struct Qdisc *qdisc_lookup_rcu(struct net_device *dev, u32 handle)
+{
+	struct netdev_queue *nq;
+	struct Qdisc *q;
+
+	if (!handle)
+		return NULL;
+	q = qdisc_match_from_root(dev->qdisc, handle);
+	if (q)
+		goto out;
+
+	nq = dev_ingress_queue_rcu(dev);
+	if (nq)
+		q = qdisc_match_from_root(nq->qdisc_sleeping, handle);
+out:
+	return q;
+}
+
 static struct Qdisc *qdisc_leaf(struct Qdisc *p, u32 classid)
 {
 	unsigned long cl;
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -958,6 +958,13 @@ void qdisc_free(struct Qdisc *qdisc)
 	kfree((char *) qdisc - qdisc->padded);
 }
 
+void qdisc_free_cb(struct rcu_head *head)
+{
+	struct Qdisc *q = container_of(head, struct Qdisc, rcu);
+
+	qdisc_free(q);
+}
+
 static void qdisc_destroy(struct Qdisc *qdisc)
 {
 	const struct Qdisc_ops *ops;
@@ -991,7 +998,7 @@ static void qdisc_destroy(struct Qdisc *
 		kfree_skb_list(skb);
 	}
 
-	qdisc_free(qdisc);
+	call_rcu(&qdisc->rcu, qdisc_free_cb);
 }
 
 void qdisc_put(struct Qdisc *qdisc)
@@ -1004,6 +1011,22 @@ void qdisc_put(struct Qdisc *qdisc)
 }
 EXPORT_SYMBOL(qdisc_put);
 
+/* Version of qdisc_put() that is called with rtnl mutex unlocked.
+ * Intended to be used as optimization, this function only takes rtnl lock if
+ * qdisc reference counter reached zero.
+ */
+
+void qdisc_put_unlocked(struct Qdisc *qdisc)
+{
+	if (qdisc->flags & TCQ_F_BUILTIN ||
+	    !refcount_dec_and_rtnl_lock(&qdisc->refcnt))
+		return;
+
+	qdisc_destroy(qdisc);
+	rtnl_unlock();
+}
+EXPORT_SYMBOL(qdisc_put_unlocked);
+
 /* Attach toplevel qdisc to device queue. */
 struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 			      struct Qdisc *qdisc)


