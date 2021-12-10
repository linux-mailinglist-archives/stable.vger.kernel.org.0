Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EC446FEF4
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 11:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhLJKvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 05:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbhLJKvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 05:51:21 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6170C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 02:47:46 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q3so14199747wru.5
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 02:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SZO5uOjZ5xqpp816soSUw3oRyqnenfDaW2h3kNB6rvQ=;
        b=lbuLqJVgkLBLsMq1MtiQF25osTsOJKQQT1Nph7DAo1nB1PbjbeQ5Em7PhlHk2Jdfgk
         uX1H1uUBWCIPzHIqkFgdFAGqoI9X7sLLIyw8gpjX1+iusAowg3X/8Dp5ObNLCDYM2+1X
         VeQwh86GmBJoAwNanWm+h374aiLvdBm+3XDzkHbOgZfl1lYzCruF6AkdNvPvmm6VU8jK
         uioDzUVaSuDliiPiNNz+DZdVYZPebgXWM8Eg7zp+p2Hp3UTLwtZZ1S/SmGV+xnvC6a2k
         sFrHz7Cm6b89F3wN83CqzQzcVTwQVwLWJrdUHVmTN2ucdFL+S0ro+dhbJWPT0NaQ19zc
         n6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SZO5uOjZ5xqpp816soSUw3oRyqnenfDaW2h3kNB6rvQ=;
        b=bNo9iFo8xhOmPaUa0U6pMyIqN0dxkHBCpnIzRTnYasxtXExihFkyF7Fvkx0UkysOYM
         nHrygLkh68zX3/Mu9G62gUqHuwKfiz01tzgEft1Tf0wNoNl4UGR8rhG7zHTwc9KUEXin
         dBeaFeeRXCUMxocz7OHpNBPkx4pWVFzsOA72Ltoy38gfKmRqRI8dPECgzKLXFGDC7/64
         GUmP5i95O/sjQLwyvo1iBUVMOyej5FAGjWEGV30BByMAkHMIHlUKekzszILCOyak311H
         2lgKJ1xEOoy83QieXbCynlKrSNEoVRqGrzglbvttjn2acq+4Zppk9v9h9AIwnovFasKH
         mMyw==
X-Gm-Message-State: AOAM530PP7jNIdD31U+zEXk4929ZQm6y8fJD5x/Ls/np7Lj75CRjBwAZ
        H4yrlhy1/wHFa4ZAjFGW0mSprGjK153uZg==
X-Google-Smtp-Source: ABdhPJzZGDW3GK/Zht/y8Q+DKxZgUipUl4FQwFo/VW/rAzPi47vQVNC7sTZ8+IdxXYWMGFasDtQVKw==
X-Received: by 2002:adf:f9d2:: with SMTP id w18mr12863712wrr.501.1639133265378;
        Fri, 10 Dec 2021 02:47:45 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id m3sm2159507wrv.95.2021.12.10.02.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:47:44 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Subject: [PATCH 4.19.y 3/5] net: sched: extend Qdisc with rcu
Date:   Fri, 10 Dec 2021 10:47:27 +0000
Message-Id: <20211210104729.582403-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211210104729.582403-1-lee.jones@linaro.org>
References: <20211210104729.582403-1-lee.jones@linaro.org>
MIME-Version: 1.0
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
---
 include/linux/rtnetlink.h |  5 +++++
 include/net/pkt_sched.h   |  1 +
 include/net/sch_generic.h |  2 ++
 net/sched/sch_api.c       | 18 ++++++++++++++++++
 net/sched/sch_generic.c   | 25 ++++++++++++++++++++++++-
 5 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 9cdd76348d9ab..bb9cb84114c15 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -85,6 +85,11 @@ static inline struct netdev_queue *dev_ingress_queue(struct net_device *dev)
 	return rtnl_dereference(dev->ingress_queue);
 }
 
+static inline struct netdev_queue *dev_ingress_queue_rcu(struct net_device *dev)
+{
+	return rcu_dereference(dev->ingress_queue);
+}
+
 struct netdev_queue *dev_ingress_queue_create(struct net_device *dev);
 
 #ifdef CONFIG_NET_INGRESS
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index edca90ef3bdc4..1a6ac924266db 100644
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
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 70dfbd0437530..04a5133d875e8 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -108,6 +108,7 @@ struct Qdisc {
 
 	spinlock_t		busylock ____cacheline_aligned_in_smp;
 	spinlock_t		seqlock;
+	struct rcu_head		rcu;
 };
 
 static inline void qdisc_refcount_inc(struct Qdisc *qdisc)
@@ -560,6 +561,7 @@ struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 			      struct Qdisc *qdisc);
 void qdisc_reset(struct Qdisc *qdisc);
 void qdisc_put(struct Qdisc *qdisc);
+void qdisc_put_unlocked(struct Qdisc *qdisc);
 void qdisc_tree_reduce_backlog(struct Qdisc *qdisc, unsigned int n,
 			       unsigned int len);
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 60f40a396a039..af035431bec60 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -315,6 +315,24 @@ struct Qdisc *qdisc_lookup(struct net_device *dev, u32 handle)
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
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6fee2731b4c22..80498c22d001b 100644
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
@@ -991,7 +998,7 @@ static void qdisc_destroy(struct Qdisc *qdisc)
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
-- 
2.34.1.173.g76aa8bc2d0-goog

