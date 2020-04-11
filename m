Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704DC1A5074
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgDKMSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728514AbgDKMSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:18:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B222084D;
        Sat, 11 Apr 2020 12:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607481;
        bh=SLxe7vui/sy4bL9CxI8nH4037eviKppUqHtZ57BTB3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAPfariusqJBjfzCcBS87Zg2XnJr90ffKCM7+0thPSOvMfyhhfSkgtUhi9Kz8WaPV
         bXHbibAue1U/k+TnMrX8GcW75Ck89MUTDoCNpO9B9yKvLai1i87oOr/FCLml2djFDj
         3enwUiRt67YYTqd2wBa1VFcDqw0stS2TjXkhuAjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 08/41] net_sched: add a temporary refcnt for struct tcindex_data
Date:   Sat, 11 Apr 2020 14:09:17 +0200
Message-Id: <20200411115504.704586285@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 304e024216a802a7dc8ba75d36de82fa136bbf3e ]

Although we intentionally use an ordered workqueue for all tc
filter works, the ordering is not guaranteed by RCU work,
given that tcf_queue_work() is esstenially a call_rcu().

This problem is demostrated by Thomas:

  CPU 0:
    tcf_queue_work()
      tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);

  -> Migration to CPU 1

  CPU 1:
     tcf_queue_work(&p->rwork, tcindex_destroy_work);

so the 2nd work could be queued before the 1st one, which leads
to a free-after-free.

Enforcing this order in RCU work is hard as it requires to change
RCU code too. Fortunately we can workaround this problem in tcindex
filter by taking a temporary refcnt, we only refcnt it right before
we begin to destroy it. This simplifies the code a lot as a full
refcnt requires much more changes in tcindex_set_parms().

Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_tcindex.c |   44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -11,6 +11,7 @@
 #include <linux/skbuff.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
@@ -26,9 +27,12 @@
 #define DEFAULT_HASH_SIZE	64	/* optimized for diffserv */
 
 
+struct tcindex_data;
+
 struct tcindex_filter_result {
 	struct tcf_exts		exts;
 	struct tcf_result	res;
+	struct tcindex_data	*p;
 	struct rcu_work		rwork;
 };
 
@@ -49,6 +53,7 @@ struct tcindex_data {
 	u32 hash;		/* hash table size; 0 if undefined */
 	u32 alloc_hash;		/* allocated size */
 	u32 fall_through;	/* 0: only classify if explicit match */
+	refcount_t refcnt;	/* a temporary refcnt for perfect hash */
 	struct rcu_work rwork;
 };
 
@@ -57,6 +62,20 @@ static inline int tcindex_filter_is_set(
 	return tcf_exts_has_actions(&r->exts) || r->res.classid;
 }
 
+static void tcindex_data_get(struct tcindex_data *p)
+{
+	refcount_inc(&p->refcnt);
+}
+
+static void tcindex_data_put(struct tcindex_data *p)
+{
+	if (refcount_dec_and_test(&p->refcnt)) {
+		kfree(p->perfect);
+		kfree(p->h);
+		kfree(p);
+	}
+}
+
 static struct tcindex_filter_result *tcindex_lookup(struct tcindex_data *p,
 						    u16 key)
 {
@@ -141,6 +160,7 @@ static void __tcindex_destroy_rexts(stru
 {
 	tcf_exts_destroy(&r->exts);
 	tcf_exts_put_net(&r->exts);
+	tcindex_data_put(r->p);
 }
 
 static void tcindex_destroy_rexts_work(struct work_struct *work)
@@ -212,6 +232,8 @@ found:
 		else
 			__tcindex_destroy_fexts(f);
 	} else {
+		tcindex_data_get(p);
+
 		if (tcf_exts_get_net(&r->exts))
 			tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
 		else
@@ -228,9 +250,7 @@ static void tcindex_destroy_work(struct
 					      struct tcindex_data,
 					      rwork);
 
-	kfree(p->perfect);
-	kfree(p->h);
-	kfree(p);
+	tcindex_data_put(p);
 }
 
 static inline int
@@ -248,9 +268,11 @@ static const struct nla_policy tcindex_p
 };
 
 static int tcindex_filter_result_init(struct tcindex_filter_result *r,
+				      struct tcindex_data *p,
 				      struct net *net)
 {
 	memset(r, 0, sizeof(*r));
+	r->p = p;
 	return tcf_exts_init(&r->exts, net, TCA_TCINDEX_ACT,
 			     TCA_TCINDEX_POLICE);
 }
@@ -290,6 +312,7 @@ static int tcindex_alloc_perfect_hash(st
 				    TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
 		if (err < 0)
 			goto errout;
+		cp->perfect[i].p = cp;
 	}
 
 	return 0;
@@ -334,6 +357,7 @@ tcindex_set_parms(struct net *net, struc
 	cp->alloc_hash = p->alloc_hash;
 	cp->fall_through = p->fall_through;
 	cp->tp = tp;
+	refcount_set(&cp->refcnt, 1); /* Paired with tcindex_destroy_work() */
 
 	if (tb[TCA_TCINDEX_HASH])
 		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
@@ -366,7 +390,7 @@ tcindex_set_parms(struct net *net, struc
 	}
 	cp->h = p->h;
 
-	err = tcindex_filter_result_init(&new_filter_result, net);
+	err = tcindex_filter_result_init(&new_filter_result, cp, net);
 	if (err < 0)
 		goto errout_alloc;
 	if (old_r)
@@ -434,7 +458,7 @@ tcindex_set_parms(struct net *net, struc
 			goto errout_alloc;
 		f->key = handle;
 		f->next = NULL;
-		err = tcindex_filter_result_init(&f->result, net);
+		err = tcindex_filter_result_init(&f->result, cp, net);
 		if (err < 0) {
 			kfree(f);
 			goto errout_alloc;
@@ -447,7 +471,7 @@ tcindex_set_parms(struct net *net, struc
 	}
 
 	if (old_r && old_r != r) {
-		err = tcindex_filter_result_init(old_r, net);
+		err = tcindex_filter_result_init(old_r, cp, net);
 		if (err < 0) {
 			kfree(f);
 			goto errout_alloc;
@@ -571,6 +595,14 @@ static void tcindex_destroy(struct tcf_p
 		for (i = 0; i < p->hash; i++) {
 			struct tcindex_filter_result *r = p->perfect + i;
 
+			/* tcf_queue_work() does not guarantee the ordering we
+			 * want, so we have to take this refcnt temporarily to
+			 * ensure 'p' is freed after all tcindex_filter_result
+			 * here. Imperfect hash does not need this, because it
+			 * uses linked lists rather than an array.
+			 */
+			tcindex_data_get(p);
+
 			tcf_unbind_filter(tp, &r->res);
 			if (tcf_exts_get_net(&r->exts))
 				tcf_queue_work(&r->rwork,


