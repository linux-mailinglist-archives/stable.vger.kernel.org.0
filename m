Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5854C23A411
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgHCMWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgHCMWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E1D20738;
        Mon,  3 Aug 2020 12:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457349;
        bh=shXoIIFE+mFSKXT36InT5+QteA25m8Le11cbh/N8l24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RB7KuKVWyDTd+LaCnQbYfQltWO1Svj4a1bhbk5Mm4GLb3L63tDy5/fkQpft/2MOp+
         +6FjVpoUzyG7LfioDILTE1nkIeQLb401krONa7t8VWC7o8nmlpahPASAolq40cvqZG
         2Jr73EmI90ycKl4SPsZKOJDg97yOlaptd5U9uD/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Brunner <tobias@strongswan.org>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 036/120] xfrm: policy: match with both mark and mask on user interfaces
Date:   Mon,  3 Aug 2020 14:18:14 +0200
Message-Id: <20200803121904.587988896@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 4f47e8ab6ab796b5380f74866fa5287aca4dcc58 ]

In commit ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list"),
it would take 'priority' to make a policy unique, and allow duplicated
policies with different 'priority' to be added, which is not expected
by userland, as Tobias reported in strongswan.

To fix this duplicated policies issue, and also fix the issue in
commit ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list"),
when doing add/del/get/update on user interfaces, this patch is to change
to look up a policy with both mark and mask by doing:

  mark.v == pol->mark.v && mark.m == pol->mark.m

and leave the check:

  (mark & pol->mark.m) == pol->mark.v

for tx/rx path only.

As the userland expects an exact mark and mask match to manage policies.

v1->v2:
  - make xfrm_policy_mark_match inline and fix the changelog as
    Tobias suggested.

Fixes: 295fae568885 ("xfrm: Allow user space manipulation of SPD mark")
Fixes: ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list")
Reported-by: Tobias Brunner <tobias@strongswan.org>
Tested-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     | 11 +++++++----
 net/key/af_key.c       |  4 ++--
 net/xfrm/xfrm_policy.c | 39 ++++++++++++++++-----------------------
 net/xfrm/xfrm_user.c   | 18 +++++++++++-------
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 03024701c79f7..31ff059b42904 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1633,13 +1633,16 @@ int xfrm_policy_walk(struct net *net, struct xfrm_policy_walk *walk,
 		     void *);
 void xfrm_policy_walk_done(struct xfrm_policy_walk *walk, struct net *net);
 int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl);
-struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u32 if_id,
-					  u8 type, int dir,
+struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net,
+					  const struct xfrm_mark *mark,
+					  u32 if_id, u8 type, int dir,
 					  struct xfrm_selector *sel,
 					  struct xfrm_sec_ctx *ctx, int delete,
 					  int *err);
-struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u32 if_id, u8,
-				     int dir, u32 id, int delete, int *err);
+struct xfrm_policy *xfrm_policy_byid(struct net *net,
+				     const struct xfrm_mark *mark, u32 if_id,
+				     u8 type, int dir, u32 id, int delete,
+				     int *err);
 int xfrm_policy_flush(struct net *net, u8 type, bool task_valid);
 void xfrm_policy_hash_rebuild(struct net *net);
 u32 xfrm_get_acqseq(void);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index b67ed3a8486c2..979c579afc63b 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2400,7 +2400,7 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, const struct sa
 			return err;
 	}
 
-	xp = xfrm_policy_bysel_ctx(net, DUMMY_MARK, 0, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_bysel_ctx(net, &dummy_mark, 0, XFRM_POLICY_TYPE_MAIN,
 				   pol->sadb_x_policy_dir - 1, &sel, pol_ctx,
 				   1, &err);
 	security_xfrm_policy_free(pol_ctx);
@@ -2651,7 +2651,7 @@ static int pfkey_spdget(struct sock *sk, struct sk_buff *skb, const struct sadb_
 		return -EINVAL;
 
 	delete = (hdr->sadb_msg_type == SADB_X_SPDDELETE2);
-	xp = xfrm_policy_byid(net, DUMMY_MARK, 0, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_byid(net, &dummy_mark, 0, XFRM_POLICY_TYPE_MAIN,
 			      dir, pol->sadb_x_policy_id, delete, &err);
 	if (xp == NULL)
 		return -ENOENT;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 564aa6492e7c3..6847b3579f541 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1433,14 +1433,10 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
 	spin_unlock_bh(&pq->hold_queue.lock);
 }
 
-static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
-				   struct xfrm_policy *pol)
+static inline bool xfrm_policy_mark_match(const struct xfrm_mark *mark,
+					  struct xfrm_policy *pol)
 {
-	if (policy->mark.v == pol->mark.v &&
-	    policy->priority == pol->priority)
-		return true;
-
-	return false;
+	return mark->v == pol->mark.v && mark->m == pol->mark.m;
 }
 
 static u32 xfrm_pol_bin_key(const void *data, u32 len, u32 seed)
@@ -1503,7 +1499,7 @@ static void xfrm_policy_insert_inexact_list(struct hlist_head *chain,
 		if (pol->type == policy->type &&
 		    pol->if_id == policy->if_id &&
 		    !selector_cmp(&pol->selector, &policy->selector) &&
-		    xfrm_policy_mark_match(policy, pol) &&
+		    xfrm_policy_mark_match(&policy->mark, pol) &&
 		    xfrm_sec_ctx_match(pol->security, policy->security) &&
 		    !WARN_ON(delpol)) {
 			delpol = pol;
@@ -1538,7 +1534,7 @@ static struct xfrm_policy *xfrm_policy_insert_list(struct hlist_head *chain,
 		if (pol->type == policy->type &&
 		    pol->if_id == policy->if_id &&
 		    !selector_cmp(&pol->selector, &policy->selector) &&
-		    xfrm_policy_mark_match(policy, pol) &&
+		    xfrm_policy_mark_match(&policy->mark, pol) &&
 		    xfrm_sec_ctx_match(pol->security, policy->security) &&
 		    !WARN_ON(delpol)) {
 			if (excl)
@@ -1610,9 +1606,8 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 EXPORT_SYMBOL(xfrm_policy_insert);
 
 static struct xfrm_policy *
-__xfrm_policy_bysel_ctx(struct hlist_head *chain, u32 mark, u32 if_id,
-			u8 type, int dir,
-			struct xfrm_selector *sel,
+__xfrm_policy_bysel_ctx(struct hlist_head *chain, const struct xfrm_mark *mark,
+			u32 if_id, u8 type, int dir, struct xfrm_selector *sel,
 			struct xfrm_sec_ctx *ctx)
 {
 	struct xfrm_policy *pol;
@@ -1623,7 +1618,7 @@ __xfrm_policy_bysel_ctx(struct hlist_head *chain, u32 mark, u32 if_id,
 	hlist_for_each_entry(pol, chain, bydst) {
 		if (pol->type == type &&
 		    pol->if_id == if_id &&
-		    (mark & pol->mark.m) == pol->mark.v &&
+		    xfrm_policy_mark_match(mark, pol) &&
 		    !selector_cmp(sel, &pol->selector) &&
 		    xfrm_sec_ctx_match(ctx, pol->security))
 			return pol;
@@ -1632,11 +1627,10 @@ __xfrm_policy_bysel_ctx(struct hlist_head *chain, u32 mark, u32 if_id,
 	return NULL;
 }
 
-struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u32 if_id,
-					  u8 type, int dir,
-					  struct xfrm_selector *sel,
-					  struct xfrm_sec_ctx *ctx, int delete,
-					  int *err)
+struct xfrm_policy *
+xfrm_policy_bysel_ctx(struct net *net, const struct xfrm_mark *mark, u32 if_id,
+		      u8 type, int dir, struct xfrm_selector *sel,
+		      struct xfrm_sec_ctx *ctx, int delete, int *err)
 {
 	struct xfrm_pol_inexact_bin *bin = NULL;
 	struct xfrm_policy *pol, *ret = NULL;
@@ -1703,9 +1697,9 @@ struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u32 if_id,
 }
 EXPORT_SYMBOL(xfrm_policy_bysel_ctx);
 
-struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u32 if_id,
-				     u8 type, int dir, u32 id, int delete,
-				     int *err)
+struct xfrm_policy *
+xfrm_policy_byid(struct net *net, const struct xfrm_mark *mark, u32 if_id,
+		 u8 type, int dir, u32 id, int delete, int *err)
 {
 	struct xfrm_policy *pol, *ret;
 	struct hlist_head *chain;
@@ -1720,8 +1714,7 @@ struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u32 if_id,
 	ret = NULL;
 	hlist_for_each_entry(pol, chain, byidx) {
 		if (pol->type == type && pol->index == id &&
-		    pol->if_id == if_id &&
-		    (mark & pol->mark.m) == pol->mark.v) {
+		    pol->if_id == if_id && xfrm_policy_mark_match(mark, pol)) {
 			xfrm_pol_hold(pol);
 			if (delete) {
 				*err = security_xfrm_policy_delete(
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e6cfaa680ef3d..fbb7d9d064787 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1863,7 +1863,6 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct km_event c;
 	int delete;
 	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
 	u32 if_id = 0;
 
 	p = nlmsg_data(nlh);
@@ -1880,8 +1879,11 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (attrs[XFRMA_IF_ID])
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
+	xfrm_mark_get(attrs, &m);
+
 	if (p->index)
-		xp = xfrm_policy_byid(net, mark, if_id, type, p->dir, p->index, delete, &err);
+		xp = xfrm_policy_byid(net, &m, if_id, type, p->dir,
+				      p->index, delete, &err);
 	else {
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
@@ -1898,8 +1900,8 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 			if (err)
 				return err;
 		}
-		xp = xfrm_policy_bysel_ctx(net, mark, if_id, type, p->dir, &p->sel,
-					   ctx, delete, &err);
+		xp = xfrm_policy_bysel_ctx(net, &m, if_id, type, p->dir,
+					   &p->sel, ctx, delete, &err);
 		security_xfrm_policy_free(ctx);
 	}
 	if (xp == NULL)
@@ -2166,7 +2168,6 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u8 type = XFRM_POLICY_TYPE_MAIN;
 	int err = -ENOENT;
 	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
 	u32 if_id = 0;
 
 	err = copy_from_user_policy_type(&type, attrs);
@@ -2180,8 +2181,11 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (attrs[XFRMA_IF_ID])
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
+	xfrm_mark_get(attrs, &m);
+
 	if (p->index)
-		xp = xfrm_policy_byid(net, mark, if_id, type, p->dir, p->index, 0, &err);
+		xp = xfrm_policy_byid(net, &m, if_id, type, p->dir, p->index,
+				      0, &err);
 	else {
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
@@ -2198,7 +2202,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 			if (err)
 				return err;
 		}
-		xp = xfrm_policy_bysel_ctx(net, mark, if_id, type, p->dir,
+		xp = xfrm_policy_bysel_ctx(net, &m, if_id, type, p->dir,
 					   &p->sel, ctx, 0, &err);
 		security_xfrm_policy_free(ctx);
 	}
-- 
2.25.1



