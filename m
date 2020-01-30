Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F420C14E27D
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgA3Swc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:52:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbgA3SnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B22720702;
        Thu, 30 Jan 2020 18:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409799;
        bh=yXty+WdNxvokyl00YDkgkyg6aV/FbdwQkYYjPbpWsdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COr7q9xZShRK/ZbdoYQD5eQS4jLE/kPIaqs/qBUUHtnxTPOrrnU1lTy3YpmfEsDwu
         iDfqdPvES8LIwdSq5LvCyMxGmvUsnXtfWYVu0IA6373NyD6V9YOxkWlLY/7xwS3PIH
         U0mRHUkqDwLdWF/2gMjv0c460zRmk3W805YQg0/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com,
        syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com
Subject: [PATCH 5.4 036/110] net_sched: fix ops->bind_class() implementations
Date:   Thu, 30 Jan 2020 19:38:12 +0100
Message-Id: <20200130183619.629975750@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 2e24cd755552350b94a7617617c6877b8cbcb701 ]

The current implementations of ops->bind_class() are merely
searching for classid and updating class in the struct tcf_result,
without invoking either of cl_ops->bind_tcf() or
cl_ops->unbind_tcf(). This breaks the design of them as qdisc's
like cbq use them to count filters too. This is why syzbot triggered
the warning in cbq_destroy_class().

In order to fix this, we have to call cl_ops->bind_tcf() and
cl_ops->unbind_tcf() like the filter binding path. This patch does
so by refactoring out two helper functions __tcf_bind_filter()
and __tcf_unbind_filter(), which are lockless and accept a Qdisc
pointer, then teaching each implementation to call them correctly.

Note, we merely pass the Qdisc pointer as an opaque pointer to
each filter, they only need to pass it down to the helper
functions without understanding it at all.

Fixes: 07d79fc7d94e ("net_sched: add reverse binding for tc class")
Reported-and-tested-by: syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/pkt_cls.h     |   33 +++++++++++++++++++--------------
 include/net/sch_generic.h |    3 ++-
 net/sched/cls_basic.c     |   11 ++++++++---
 net/sched/cls_bpf.c       |   11 ++++++++---
 net/sched/cls_flower.c    |   11 ++++++++---
 net/sched/cls_fw.c        |   11 ++++++++---
 net/sched/cls_matchall.c  |   11 ++++++++---
 net/sched/cls_route.c     |   11 ++++++++---
 net/sched/cls_rsvp.h      |   11 ++++++++---
 net/sched/cls_tcindex.c   |   11 ++++++++---
 net/sched/cls_u32.c       |   11 ++++++++---
 net/sched/sch_api.c       |    6 ++++--
 12 files changed, 97 insertions(+), 44 deletions(-)

--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -141,31 +141,38 @@ __cls_set_class(unsigned long *clp, unsi
 	return xchg(clp, cl);
 }
 
-static inline unsigned long
-cls_set_class(struct Qdisc *q, unsigned long *clp, unsigned long cl)
+static inline void
+__tcf_bind_filter(struct Qdisc *q, struct tcf_result *r, unsigned long base)
 {
-	unsigned long old_cl;
+	unsigned long cl;
 
-	sch_tree_lock(q);
-	old_cl = __cls_set_class(clp, cl);
-	sch_tree_unlock(q);
-	return old_cl;
+	cl = q->ops->cl_ops->bind_tcf(q, base, r->classid);
+	cl = __cls_set_class(&r->class, cl);
+	if (cl)
+		q->ops->cl_ops->unbind_tcf(q, cl);
 }
 
 static inline void
 tcf_bind_filter(struct tcf_proto *tp, struct tcf_result *r, unsigned long base)
 {
 	struct Qdisc *q = tp->chain->block->q;
-	unsigned long cl;
 
 	/* Check q as it is not set for shared blocks. In that case,
 	 * setting class is not supported.
 	 */
 	if (!q)
 		return;
-	cl = q->ops->cl_ops->bind_tcf(q, base, r->classid);
-	cl = cls_set_class(q, &r->class, cl);
-	if (cl)
+	sch_tree_lock(q);
+	__tcf_bind_filter(q, r, base);
+	sch_tree_unlock(q);
+}
+
+static inline void
+__tcf_unbind_filter(struct Qdisc *q, struct tcf_result *r)
+{
+	unsigned long cl;
+
+	if ((cl = __cls_set_class(&r->class, 0)) != 0)
 		q->ops->cl_ops->unbind_tcf(q, cl);
 }
 
@@ -173,12 +180,10 @@ static inline void
 tcf_unbind_filter(struct tcf_proto *tp, struct tcf_result *r)
 {
 	struct Qdisc *q = tp->chain->block->q;
-	unsigned long cl;
 
 	if (!q)
 		return;
-	if ((cl = __cls_set_class(&r->class, 0)) != 0)
-		q->ops->cl_ops->unbind_tcf(q, cl);
+	__tcf_unbind_filter(q, r);
 }
 
 struct tcf_exts {
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -318,7 +318,8 @@ struct tcf_proto_ops {
 					  void *type_data);
 	void			(*hw_del)(struct tcf_proto *tp,
 					  void *type_data);
-	void			(*bind_class)(void *, u32, unsigned long);
+	void			(*bind_class)(void *, u32, unsigned long,
+					      void *, unsigned long);
 	void *			(*tmplt_create)(struct net *net,
 						struct tcf_chain *chain,
 						struct nlattr **tca,
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -263,12 +263,17 @@ skip:
 	}
 }
 
-static void basic_bind_class(void *fh, u32 classid, unsigned long cl)
+static void basic_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			     unsigned long base)
 {
 	struct basic_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static int basic_dump(struct net *net, struct tcf_proto *tp, void *fh,
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -631,12 +631,17 @@ nla_put_failure:
 	return -1;
 }
 
-static void cls_bpf_bind_class(void *fh, u32 classid, unsigned long cl)
+static void cls_bpf_bind_class(void *fh, u32 classid, unsigned long cl,
+			       void *q, unsigned long base)
 {
 	struct cls_bpf_prog *prog = fh;
 
-	if (prog && prog->res.classid == classid)
-		prog->res.class = cl;
+	if (prog && prog->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &prog->res, base);
+		else
+			__tcf_unbind_filter(q, &prog->res);
+	}
 }
 
 static void cls_bpf_walk(struct tcf_proto *tp, struct tcf_walker *arg,
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2511,12 +2511,17 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
-static void fl_bind_class(void *fh, u32 classid, unsigned long cl)
+static void fl_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			  unsigned long base)
 {
 	struct cls_fl_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static bool fl_delete_empty(struct tcf_proto *tp)
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -419,12 +419,17 @@ nla_put_failure:
 	return -1;
 }
 
-static void fw_bind_class(void *fh, u32 classid, unsigned long cl)
+static void fw_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			  unsigned long base)
 {
 	struct fw_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static struct tcf_proto_ops cls_fw_ops __read_mostly = {
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -393,12 +393,17 @@ nla_put_failure:
 	return -1;
 }
 
-static void mall_bind_class(void *fh, u32 classid, unsigned long cl)
+static void mall_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			    unsigned long base)
 {
 	struct cls_mall_head *head = fh;
 
-	if (head && head->res.classid == classid)
-		head->res.class = cl;
+	if (head && head->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &head->res, base);
+		else
+			__tcf_unbind_filter(q, &head->res);
+	}
 }
 
 static struct tcf_proto_ops cls_mall_ops __read_mostly = {
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -641,12 +641,17 @@ nla_put_failure:
 	return -1;
 }
 
-static void route4_bind_class(void *fh, u32 classid, unsigned long cl)
+static void route4_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			      unsigned long base)
 {
 	struct route4_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static struct tcf_proto_ops cls_route4_ops __read_mostly = {
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -738,12 +738,17 @@ nla_put_failure:
 	return -1;
 }
 
-static void rsvp_bind_class(void *fh, u32 classid, unsigned long cl)
+static void rsvp_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			    unsigned long base)
 {
 	struct rsvp_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static struct tcf_proto_ops RSVP_OPS __read_mostly = {
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -654,12 +654,17 @@ nla_put_failure:
 	return -1;
 }
 
-static void tcindex_bind_class(void *fh, u32 classid, unsigned long cl)
+static void tcindex_bind_class(void *fh, u32 classid, unsigned long cl,
+			       void *q, unsigned long base)
 {
 	struct tcindex_filter_result *r = fh;
 
-	if (r && r->res.classid == classid)
-		r->res.class = cl;
+	if (r && r->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &r->res, base);
+		else
+			__tcf_unbind_filter(q, &r->res);
+	}
 }
 
 static struct tcf_proto_ops cls_tcindex_ops __read_mostly = {
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1255,12 +1255,17 @@ static int u32_reoffload(struct tcf_prot
 	return 0;
 }
 
-static void u32_bind_class(void *fh, u32 classid, unsigned long cl)
+static void u32_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			   unsigned long base)
 {
 	struct tc_u_knode *n = fh;
 
-	if (n && n->res.classid == classid)
-		n->res.class = cl;
+	if (n && n->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &n->res, base);
+		else
+			__tcf_unbind_filter(q, &n->res);
+	}
 }
 
 static int u32_dump(struct net *net, struct tcf_proto *tp, void *fh,
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1891,8 +1891,9 @@ static int tclass_del_notify(struct net
 
 struct tcf_bind_args {
 	struct tcf_walker w;
-	u32 classid;
+	unsigned long base;
 	unsigned long cl;
+	u32 classid;
 };
 
 static int tcf_node_bind(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
@@ -1903,7 +1904,7 @@ static int tcf_node_bind(struct tcf_prot
 		struct Qdisc *q = tcf_block_q(tp->chain->block);
 
 		sch_tree_lock(q);
-		tp->ops->bind_class(n, a->classid, a->cl);
+		tp->ops->bind_class(n, a->classid, a->cl, q, a->base);
 		sch_tree_unlock(q);
 	}
 	return 0;
@@ -1936,6 +1937,7 @@ static void tc_bind_tclass(struct Qdisc
 
 			arg.w.fn = tcf_node_bind;
 			arg.classid = clid;
+			arg.base = cl;
 			arg.cl = new_cl;
 			tp->ops->walk(tp, &arg.w, true);
 		}


