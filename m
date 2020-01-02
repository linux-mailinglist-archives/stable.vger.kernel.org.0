Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED8612F104
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgABWQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:16:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbgABWQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9928A22314;
        Thu,  2 Jan 2020 22:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003416;
        bh=ILr2F9ip7yp2gDwdnnyebGeo5o25gwVP7tX0p4pr8Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jygHwWe2N8153czd3lMQAEnknPpaHHx/QZzis93VOSJjpT1NTCl1RmvFMUShwtRTd
         JDxwdv70ZaIWR/gdfEVZx+1oQK33tPGun9eFgVUCl9NSrm5dgl6Q+ANvKhxBvfONET
         rovguTHbNhanqAIpin00Xw9YTVBLQ9uYnxo7itsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 152/191] net/sched: add delete_empty() to filters and use it in cls_flower
Date:   Thu,  2 Jan 2020 23:07:14 +0100
Message-Id: <20200102215845.743336018@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit a5b72a083da197b493c7ed1e5730d62d3199f7d6 ]

Revert "net/sched: cls_u32: fix refcount leak in the error path of
u32_change()", and fix the u32 refcount leak in a more generic way that
preserves the semantic of rule dumping.
On tc filters that don't support lockless insertion/removal, there is no
need to guard against concurrent insertion when a removal is in progress.
Therefore, for most of them we can avoid a full walk() when deleting, and
just decrease the refcount, like it was done on older Linux kernels.
This fixes situations where walk() was wrongly detecting a non-empty
filter, like it happened with cls_u32 in the error path of change(), thus
leading to failures in the following tdc selftests:

 6aa7: (filter, u32) Add/Replace u32 with source match and invalid indev
 6658: (filter, u32) Add/Replace u32 with custom hash table and invalid handle
 74c2: (filter, u32) Add/Replace u32 filter with invalid hash table id

On cls_flower, and on (future) lockless filters, this check is necessary:
move all the check_empty() logic in a callback so that each filter
can have its own implementation. For cls_flower, it's sufficient to check
if no IDRs have been allocated.

This reverts commit 275c44aa194b7159d1191817b20e076f55f0e620.

Changes since v1:
 - document the need for delete_empty() when TCF_PROTO_OPS_DOIT_UNLOCKED
   is used, thanks to Vlad Buslov
 - implement delete_empty() without doing fl_walk(), thanks to Vlad Buslov
 - squash revert and new fix in a single patch, to be nice with bisect
   tests that run tdc on u32 filter, thanks to Dave Miller

Fixes: 275c44aa194b ("net/sched: cls_u32: fix refcount leak in the error path of u32_change()")
Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp is empty")
Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Suggested-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |    5 +++++
 net/sched/cls_api.c       |   31 +++++--------------------------
 net/sched/cls_flower.c    |   12 ++++++++++++
 3 files changed, 22 insertions(+), 26 deletions(-)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -308,6 +308,7 @@ struct tcf_proto_ops {
 	int			(*delete)(struct tcf_proto *tp, void *arg,
 					  bool *last, bool rtnl_held,
 					  struct netlink_ext_ack *);
+	bool			(*delete_empty)(struct tcf_proto *tp);
 	void			(*walk)(struct tcf_proto *tp,
 					struct tcf_walker *arg, bool rtnl_held);
 	int			(*reoffload)(struct tcf_proto *tp, bool add,
@@ -336,6 +337,10 @@ struct tcf_proto_ops {
 	int			flags;
 };
 
+/* Classifiers setting TCF_PROTO_OPS_DOIT_UNLOCKED in tcf_proto_ops->flags
+ * are expected to implement tcf_proto_ops->delete_empty(), otherwise race
+ * conditions can occur when filters are inserted/deleted simultaneously.
+ */
 enum tcf_proto_ops_flags {
 	TCF_PROTO_OPS_DOIT_UNLOCKED = 1,
 };
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -308,33 +308,12 @@ static void tcf_proto_put(struct tcf_pro
 		tcf_proto_destroy(tp, rtnl_held, true, extack);
 }
 
-static int walker_check_empty(struct tcf_proto *tp, void *fh,
-			      struct tcf_walker *arg)
+static bool tcf_proto_check_delete(struct tcf_proto *tp)
 {
-	if (fh) {
-		arg->nonempty = true;
-		return -1;
-	}
-	return 0;
-}
-
-static bool tcf_proto_is_empty(struct tcf_proto *tp, bool rtnl_held)
-{
-	struct tcf_walker walker = { .fn = walker_check_empty, };
-
-	if (tp->ops->walk) {
-		tp->ops->walk(tp, &walker, rtnl_held);
-		return !walker.nonempty;
-	}
-	return true;
-}
+	if (tp->ops->delete_empty)
+		return tp->ops->delete_empty(tp);
 
-static bool tcf_proto_check_delete(struct tcf_proto *tp, bool rtnl_held)
-{
-	spin_lock(&tp->lock);
-	if (tcf_proto_is_empty(tp, rtnl_held))
-		tp->deleting = true;
-	spin_unlock(&tp->lock);
+	tp->deleting = true;
 	return tp->deleting;
 }
 
@@ -1751,7 +1730,7 @@ static void tcf_chain_tp_delete_empty(st
 	 * concurrently.
 	 * Mark tp for deletion if it is empty.
 	 */
-	if (!tp_iter || !tcf_proto_check_delete(tp, rtnl_held)) {
+	if (!tp_iter || !tcf_proto_check_delete(tp)) {
 		mutex_unlock(&chain->filter_chain_lock);
 		return;
 	}
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2519,6 +2519,17 @@ static void fl_bind_class(void *fh, u32
 		f->res.class = cl;
 }
 
+static bool fl_delete_empty(struct tcf_proto *tp)
+{
+	struct cls_fl_head *head = fl_head_dereference(tp);
+
+	spin_lock(&tp->lock);
+	tp->deleting = idr_is_empty(&head->handle_idr);
+	spin_unlock(&tp->lock);
+
+	return tp->deleting;
+}
+
 static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.kind		= "flower",
 	.classify	= fl_classify,
@@ -2528,6 +2539,7 @@ static struct tcf_proto_ops cls_fl_ops _
 	.put		= fl_put,
 	.change		= fl_change,
 	.delete		= fl_delete,
+	.delete_empty	= fl_delete_empty,
 	.walk		= fl_walk,
 	.reoffload	= fl_reoffload,
 	.hw_add		= fl_hw_add,


