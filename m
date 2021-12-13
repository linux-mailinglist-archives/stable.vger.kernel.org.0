Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1EB472502
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhLMJkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:40:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33882 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbhLMJiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:38:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7ECA3CE0E79;
        Mon, 13 Dec 2021 09:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C834EC341C8;
        Mon, 13 Dec 2021 09:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388326;
        bh=kygGBBXKyKMowfcCMlQA5kwWcthaCknh2ztXM35bHWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6F6/J3hXs1b4cH0xE5dB+Q0BSOmTIao9GQuEgjKoHn3lSjTUHiRkRNFUSN5NF9SO
         HqXK4h1085mk3A0p+3+Fyqt+owNunKMKbZtey58+n1GNzdracazb5micUcyFbZhMJ4
         Gpw3hCj/xnBESa6FZioQcYetndgh+nBdigDD1x8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Subject: [PATCH 4.19 11/74] net: sched: rename qdisc_destroy() to qdisc_put()
Date:   Mon, 13 Dec 2021 10:29:42 +0100
Message-Id: <20211213092931.157893999@linuxfoundation.org>
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

[ Upstream commit 86bd446b5cebd783187ea3772ff258210de77d99 ]

Current implementation of qdisc_destroy() decrements Qdisc reference
counter and only actually destroy Qdisc if reference counter value reached
zero. Rename qdisc_destroy() to qdisc_put() in order for it to better
describe the way in which this function currently implemented and used.

Extract code that deallocates Qdisc into new private qdisc_destroy()
function. It is intended to be shared between regular qdisc_put() and its
unlocked version that is introduced in next patch in this series.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Lee: Sent to Stable]
Link: https://syzkaller.appspot.com/bug?id=d7e411c5472dd5da33d8cc921ccadc747743a568
Reported-by: syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |    2 +-
 net/sched/sch_api.c       |    6 +++---
 net/sched/sch_atm.c       |    2 +-
 net/sched/sch_cbq.c       |    2 +-
 net/sched/sch_cbs.c       |    2 +-
 net/sched/sch_drr.c       |    4 ++--
 net/sched/sch_dsmark.c    |    2 +-
 net/sched/sch_fifo.c      |    2 +-
 net/sched/sch_generic.c   |   23 ++++++++++++++---------
 net/sched/sch_hfsc.c      |    2 +-
 net/sched/sch_htb.c       |    4 ++--
 net/sched/sch_mq.c        |    4 ++--
 net/sched/sch_mqprio.c    |    4 ++--
 net/sched/sch_multiq.c    |    6 +++---
 net/sched/sch_netem.c     |    2 +-
 net/sched/sch_prio.c      |    6 +++---
 net/sched/sch_qfq.c       |    4 ++--
 net/sched/sch_red.c       |    4 ++--
 net/sched/sch_sfb.c       |    4 ++--
 net/sched/sch_tbf.c       |    4 ++--
 20 files changed, 47 insertions(+), 42 deletions(-)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -559,7 +559,7 @@ void dev_deactivate_many(struct list_hea
 struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 			      struct Qdisc *qdisc);
 void qdisc_reset(struct Qdisc *qdisc);
-void qdisc_destroy(struct Qdisc *qdisc);
+void qdisc_put(struct Qdisc *qdisc);
 void qdisc_tree_reduce_backlog(struct Qdisc *qdisc, unsigned int n,
 			       unsigned int len);
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -928,7 +928,7 @@ static void notify_and_destroy(struct ne
 		qdisc_notify(net, skb, n, clid, old, new);
 
 	if (old)
-		qdisc_destroy(old);
+		qdisc_put(old);
 }
 
 /* Graft qdisc "new" to class "classid" of qdisc "parent" or
@@ -981,7 +981,7 @@ static int qdisc_graft(struct net_device
 				qdisc_refcount_inc(new);
 
 			if (!ingress)
-				qdisc_destroy(old);
+				qdisc_put(old);
 		}
 
 skip:
@@ -1589,7 +1589,7 @@ graft:
 	err = qdisc_graft(dev, p, skb, n, clid, q, NULL, extack);
 	if (err) {
 		if (q)
-			qdisc_destroy(q);
+			qdisc_put(q);
 		return err;
 	}
 
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -150,7 +150,7 @@ static void atm_tc_put(struct Qdisc *sch
 	pr_debug("atm_tc_put: destroying\n");
 	list_del_init(&flow->list);
 	pr_debug("atm_tc_put: qdisc %p\n", flow->q);
-	qdisc_destroy(flow->q);
+	qdisc_put(flow->q);
 	tcf_block_put(flow->block);
 	if (flow->sock) {
 		pr_debug("atm_tc_put: f_count %ld\n",
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1439,7 +1439,7 @@ static void cbq_destroy_class(struct Qdi
 	WARN_ON(cl->filters);
 
 	tcf_block_put(cl->block);
-	qdisc_destroy(cl->q);
+	qdisc_put(cl->q);
 	qdisc_put_rtab(cl->R_tab);
 	gen_kill_estimator(&cl->rate_est);
 	if (cl != &q->link)
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -452,7 +452,7 @@ static void cbs_destroy(struct Qdisc *sc
 	cbs_disable_offload(dev, q);
 
 	if (q->qdisc)
-		qdisc_destroy(q->qdisc);
+		qdisc_put(q->qdisc);
 }
 
 static int cbs_dump(struct Qdisc *sch, struct sk_buff *skb)
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -134,7 +134,7 @@ static int drr_change_class(struct Qdisc
 					    tca[TCA_RATE]);
 		if (err) {
 			NL_SET_ERR_MSG(extack, "Failed to replace estimator");
-			qdisc_destroy(cl->qdisc);
+			qdisc_put(cl->qdisc);
 			kfree(cl);
 			return err;
 		}
@@ -153,7 +153,7 @@ static int drr_change_class(struct Qdisc
 static void drr_destroy_class(struct Qdisc *sch, struct drr_class *cl)
 {
 	gen_kill_estimator(&cl->rate_est);
-	qdisc_destroy(cl->qdisc);
+	qdisc_put(cl->qdisc);
 	kfree(cl);
 }
 
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -415,7 +415,7 @@ static void dsmark_destroy(struct Qdisc
 	pr_debug("%s(sch %p,[qdisc %p])\n", __func__, sch, p);
 
 	tcf_block_put(p->block);
-	qdisc_destroy(p->q);
+	qdisc_put(p->q);
 	if (p->mv != p->embedded)
 		kfree(p->mv);
 }
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -180,7 +180,7 @@ struct Qdisc *fifo_create_dflt(struct Qd
 	if (q) {
 		err = fifo_set_limit(q, limit);
 		if (err < 0) {
-			qdisc_destroy(q);
+			qdisc_put(q);
 			q = NULL;
 		}
 	}
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -918,7 +918,7 @@ struct Qdisc *qdisc_create_dflt(struct n
 	if (!ops->init || ops->init(sch, NULL, extack) == 0)
 		return sch;
 
-	qdisc_destroy(sch);
+	qdisc_put(sch);
 	return NULL;
 }
 EXPORT_SYMBOL(qdisc_create_dflt);
@@ -958,7 +958,7 @@ void qdisc_free(struct Qdisc *qdisc)
 	kfree((char *) qdisc - qdisc->padded);
 }
 
-void qdisc_destroy(struct Qdisc *qdisc)
+static void qdisc_destroy(struct Qdisc *qdisc)
 {
 	const struct Qdisc_ops *ops;
 	struct sk_buff *skb, *tmp;
@@ -967,10 +967,6 @@ void qdisc_destroy(struct Qdisc *qdisc)
 		return;
 	ops = qdisc->ops;
 
-	if (qdisc->flags & TCQ_F_BUILTIN ||
-	    !refcount_dec_and_test(&qdisc->refcnt))
-		return;
-
 #ifdef CONFIG_NET_SCHED
 	qdisc_hash_del(qdisc);
 
@@ -997,7 +993,16 @@ void qdisc_destroy(struct Qdisc *qdisc)
 
 	qdisc_free(qdisc);
 }
-EXPORT_SYMBOL(qdisc_destroy);
+
+void qdisc_put(struct Qdisc *qdisc)
+{
+	if (qdisc->flags & TCQ_F_BUILTIN ||
+	    !refcount_dec_and_test(&qdisc->refcnt))
+		return;
+
+	qdisc_destroy(qdisc);
+}
+EXPORT_SYMBOL(qdisc_put);
 
 /* Attach toplevel qdisc to device queue. */
 struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
@@ -1318,7 +1323,7 @@ static void shutdown_scheduler_queue(str
 		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
 		dev_queue->qdisc_sleeping = qdisc_default;
 
-		qdisc_destroy(qdisc);
+		qdisc_put(qdisc);
 	}
 }
 
@@ -1327,7 +1332,7 @@ void dev_shutdown(struct net_device *dev
 	netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
 	if (dev_ingress_queue(dev))
 		shutdown_scheduler_queue(dev, dev_ingress_queue(dev), &noop_qdisc);
-	qdisc_destroy(dev->qdisc);
+	qdisc_put(dev->qdisc);
 	dev->qdisc = &noop_qdisc;
 
 	WARN_ON(timer_pending(&dev->watchdog_timer));
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1092,7 +1092,7 @@ hfsc_destroy_class(struct Qdisc *sch, st
 	struct hfsc_sched *q = qdisc_priv(sch);
 
 	tcf_block_put(cl->block);
-	qdisc_destroy(cl->qdisc);
+	qdisc_put(cl->qdisc);
 	gen_kill_estimator(&cl->rate_est);
 	if (cl != &q->root)
 		kfree(cl);
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1224,7 +1224,7 @@ static void htb_destroy_class(struct Qdi
 {
 	if (!cl->level) {
 		WARN_ON(!cl->un.leaf.q);
-		qdisc_destroy(cl->un.leaf.q);
+		qdisc_put(cl->un.leaf.q);
 	}
 	gen_kill_estimator(&cl->rate_est);
 	tcf_block_put(cl->block);
@@ -1425,7 +1425,7 @@ static int htb_change_class(struct Qdisc
 			/* turn parent into inner node */
 			qdisc_reset(parent->un.leaf.q);
 			qdisc_tree_reduce_backlog(parent->un.leaf.q, qlen, backlog);
-			qdisc_destroy(parent->un.leaf.q);
+			qdisc_put(parent->un.leaf.q);
 			if (parent->prio_activity)
 				htb_deactivate(q, parent);
 
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -65,7 +65,7 @@ static void mq_destroy(struct Qdisc *sch
 	if (!priv->qdiscs)
 		return;
 	for (ntx = 0; ntx < dev->num_tx_queues && priv->qdiscs[ntx]; ntx++)
-		qdisc_destroy(priv->qdiscs[ntx]);
+		qdisc_put(priv->qdiscs[ntx]);
 	kfree(priv->qdiscs);
 }
 
@@ -119,7 +119,7 @@ static void mq_attach(struct Qdisc *sch)
 		qdisc = priv->qdiscs[ntx];
 		old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
 		if (old)
-			qdisc_destroy(old);
+			qdisc_put(old);
 #ifdef CONFIG_NET_SCHED
 		if (ntx < dev->real_num_tx_queues)
 			qdisc_hash_add(qdisc, false);
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -40,7 +40,7 @@ static void mqprio_destroy(struct Qdisc
 		for (ntx = 0;
 		     ntx < dev->num_tx_queues && priv->qdiscs[ntx];
 		     ntx++)
-			qdisc_destroy(priv->qdiscs[ntx]);
+			qdisc_put(priv->qdiscs[ntx]);
 		kfree(priv->qdiscs);
 	}
 
@@ -300,7 +300,7 @@ static void mqprio_attach(struct Qdisc *
 		qdisc = priv->qdiscs[ntx];
 		old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
 		if (old)
-			qdisc_destroy(old);
+			qdisc_put(old);
 		if (ntx < dev->real_num_tx_queues)
 			qdisc_hash_add(qdisc, false);
 	}
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -175,7 +175,7 @@ multiq_destroy(struct Qdisc *sch)
 
 	tcf_block_put(q->block);
 	for (band = 0; band < q->bands; band++)
-		qdisc_destroy(q->queues[band]);
+		qdisc_put(q->queues[band]);
 
 	kfree(q->queues);
 }
@@ -204,7 +204,7 @@ static int multiq_tune(struct Qdisc *sch
 			q->queues[i] = &noop_qdisc;
 			qdisc_tree_reduce_backlog(child, child->q.qlen,
 						  child->qstats.backlog);
-			qdisc_destroy(child);
+			qdisc_put(child);
 		}
 	}
 
@@ -228,7 +228,7 @@ static int multiq_tune(struct Qdisc *sch
 					qdisc_tree_reduce_backlog(old,
 								  old->q.qlen,
 								  old->qstats.backlog);
-					qdisc_destroy(old);
+					qdisc_put(old);
 				}
 				sch_tree_unlock(sch);
 			}
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1054,7 +1054,7 @@ static void netem_destroy(struct Qdisc *
 
 	qdisc_watchdog_cancel(&q->watchdog);
 	if (q->qdisc)
-		qdisc_destroy(q->qdisc);
+		qdisc_put(q->qdisc);
 	dist_free(q->delay_dist);
 	dist_free(q->slot_dist);
 }
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -175,7 +175,7 @@ prio_destroy(struct Qdisc *sch)
 	tcf_block_put(q->block);
 	prio_offload(sch, NULL);
 	for (prio = 0; prio < q->bands; prio++)
-		qdisc_destroy(q->queues[prio]);
+		qdisc_put(q->queues[prio]);
 }
 
 static int prio_tune(struct Qdisc *sch, struct nlattr *opt,
@@ -205,7 +205,7 @@ static int prio_tune(struct Qdisc *sch,
 					      extack);
 		if (!queues[i]) {
 			while (i > oldbands)
-				qdisc_destroy(queues[--i]);
+				qdisc_put(queues[--i]);
 			return -ENOMEM;
 		}
 	}
@@ -220,7 +220,7 @@ static int prio_tune(struct Qdisc *sch,
 
 		qdisc_tree_reduce_backlog(child, child->q.qlen,
 					  child->qstats.backlog);
-		qdisc_destroy(child);
+		qdisc_put(child);
 	}
 
 	for (i = oldbands; i < q->bands; i++) {
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -524,7 +524,7 @@ set_change_agg:
 	return 0;
 
 destroy_class:
-	qdisc_destroy(cl->qdisc);
+	qdisc_put(cl->qdisc);
 	kfree(cl);
 	return err;
 }
@@ -535,7 +535,7 @@ static void qfq_destroy_class(struct Qdi
 
 	qfq_rm_from_agg(q, cl);
 	gen_kill_estimator(&cl->rate_est);
-	qdisc_destroy(cl->qdisc);
+	qdisc_put(cl->qdisc);
 	kfree(cl);
 }
 
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -181,7 +181,7 @@ static void red_destroy(struct Qdisc *sc
 
 	del_timer_sync(&q->adapt_timer);
 	red_offload(sch, false);
-	qdisc_destroy(q->qdisc);
+	qdisc_put(q->qdisc);
 }
 
 static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
@@ -236,7 +236,7 @@ static int red_change(struct Qdisc *sch,
 	if (child) {
 		qdisc_tree_reduce_backlog(q->qdisc, q->qdisc->q.qlen,
 					  q->qdisc->qstats.backlog);
-		qdisc_destroy(q->qdisc);
+		qdisc_put(q->qdisc);
 		q->qdisc = child;
 	}
 
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -470,7 +470,7 @@ static void sfb_destroy(struct Qdisc *sc
 	struct sfb_sched_data *q = qdisc_priv(sch);
 
 	tcf_block_put(q->block);
-	qdisc_destroy(q->qdisc);
+	qdisc_put(q->qdisc);
 }
 
 static const struct nla_policy sfb_policy[TCA_SFB_MAX + 1] = {
@@ -524,7 +524,7 @@ static int sfb_change(struct Qdisc *sch,
 
 	qdisc_tree_reduce_backlog(q->qdisc, q->qdisc->q.qlen,
 				  q->qdisc->qstats.backlog);
-	qdisc_destroy(q->qdisc);
+	qdisc_put(q->qdisc);
 	q->qdisc = child;
 
 	q->rehash_interval = msecs_to_jiffies(ctl->rehash_interval);
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -392,7 +392,7 @@ static int tbf_change(struct Qdisc *sch,
 	if (child) {
 		qdisc_tree_reduce_backlog(q->qdisc, q->qdisc->q.qlen,
 					  q->qdisc->qstats.backlog);
-		qdisc_destroy(q->qdisc);
+		qdisc_put(q->qdisc);
 		q->qdisc = child;
 	}
 	q->limit = qopt->limit;
@@ -438,7 +438,7 @@ static void tbf_destroy(struct Qdisc *sc
 	struct tbf_sched_data *q = qdisc_priv(sch);
 
 	qdisc_watchdog_cancel(&q->watchdog);
-	qdisc_destroy(q->qdisc);
+	qdisc_put(q->qdisc);
 }
 
 static int tbf_dump(struct Qdisc *sch, struct sk_buff *skb)


