Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7274FDBCF
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354114AbiDLKH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 06:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358167AbiDLITU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 04:19:20 -0400
Received: from mail.strongswan.org (sitav-80046.hsr.ch [152.96.80.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175D21C12E
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 00:44:27 -0700 (PDT)
Received: from [IPV6:2a01:8b81:5406:4b00:5799:1c1d:f43e:e349] (unknown [IPv6:2a01:8b81:5406:4b00:5799:1c1d:f43e:e349])
        by mail.strongswan.org (Postfix) with ESMTPSA id 92FD5406B9;
        Tue, 12 Apr 2022 09:34:21 +0200 (CEST)
Message-ID: <1c77552c-e793-fd5f-0c73-2f567cce8ee3@strongswan.org>
Date:   Tue, 12 Apr 2022 09:34:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Xin Long <lucien.xin@gmail.com>
From:   Tobias Brunner <tobias@strongswan.org>
Subject: [PATCH 4.14/4.9] xfrm: policy: match with both mark and mask on user
 interfaces
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 4f47e8ab6ab796b5380f74866fa5287aca4dcc58 upstream.

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

Cc: <stable@vger.kernel.org> # 4.14.x
Cc: <stable@vger.kernel.org> # 4.9.x
Fixes: 295fae568885 ("xfrm: Allow user space manipulation of SPD mark")
Fixes: ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list")
Reported-by: Tobias Brunner <tobias@strongswan.org>
Tested-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
This is a backport to 4.14.x and 4.9.x of a fix that has already been
applied to newer stable kernels.  However, due to conflicts it was never
included in the 4.x trees, which all contain backports of the problematic
commit referenced above (ed17b8d377ea).  So they all are prone to
creating duplicate IPsec policies with priority updates.

  include/net/xfrm.h     |  9 ++++++---
  net/key/af_key.c       |  4 ++--
  net/xfrm/xfrm_policy.c | 24 ++++++++++--------------
  net/xfrm/xfrm_user.c   | 14 ++++++++------
  4 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b2a405c93a34..7415a9876987 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1595,13 +1595,16 @@ int xfrm_policy_walk(struct net *net, struct xfrm_policy_walk *walk,
  		     void *);
  void xfrm_policy_walk_done(struct xfrm_policy_walk *walk, struct net *net);
  int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl);
-struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark,
+struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net,
+					  const struct xfrm_mark *mark,
  					  u8 type, int dir,
  					  struct xfrm_selector *sel,
  					  struct xfrm_sec_ctx *ctx, int delete,
  					  int *err);
-struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u8, int dir,
-				     u32 id, int delete, int *err);
+struct xfrm_policy *xfrm_policy_byid(struct net *net,
+				     const struct xfrm_mark *mark,
+				     u8 type, int dir, u32 id, int delete,
+				     int *err);
  int xfrm_policy_flush(struct net *net, u8 type, bool task_valid);
  void xfrm_policy_hash_rebuild(struct net *net);
  u32 xfrm_get_acqseq(void);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index adc93329e6aa..46ab7a23328c 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2434,7 +2434,7 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, const struct sa
  			return err;
  	}
  
-	xp = xfrm_policy_bysel_ctx(net, DUMMY_MARK, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_bysel_ctx(net, &dummy_mark, XFRM_POLICY_TYPE_MAIN,
  				   pol->sadb_x_policy_dir - 1, &sel, pol_ctx,
  				   1, &err);
  	security_xfrm_policy_free(pol_ctx);
@@ -2687,7 +2687,7 @@ static int pfkey_spdget(struct sock *sk, struct sk_buff *skb, const struct sadb_
  		return -EINVAL;
  
  	delete = (hdr->sadb_msg_type == SADB_X_SPDDELETE2);
-	xp = xfrm_policy_byid(net, DUMMY_MARK, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_byid(net, &dummy_mark, XFRM_POLICY_TYPE_MAIN,
  			      dir, pol->sadb_x_policy_id, delete, &err);
  	if (xp == NULL)
  		return -ENOENT;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b00ed36b9aac..9179b47e8b61 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -754,14 +754,10 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
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
  
  int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
@@ -779,7 +775,7 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
  	hlist_for_each_entry(pol, chain, bydst) {
  		if (pol->type == policy->type &&
  		    !selector_cmp(&pol->selector, &policy->selector) &&
-		    xfrm_policy_mark_match(policy, pol) &&
+		    xfrm_policy_mark_match(&policy->mark, pol) &&
  		    xfrm_sec_ctx_match(pol->security, policy->security) &&
  		    !WARN_ON(delpol)) {
  			if (excl) {
@@ -830,8 +826,8 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
  }
  EXPORT_SYMBOL(xfrm_policy_insert);
  
-struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u8 type,
-					  int dir, struct xfrm_selector *sel,
+struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, const struct xfrm_mark *mark,
+					  u8 type, int dir, struct xfrm_selector *sel,
  					  struct xfrm_sec_ctx *ctx, int delete,
  					  int *err)
  {
@@ -844,7 +840,7 @@ struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u8 type,
  	ret = NULL;
  	hlist_for_each_entry(pol, chain, bydst) {
  		if (pol->type == type &&
-		    (mark & pol->mark.m) == pol->mark.v &&
+		    xfrm_policy_mark_match(mark, pol) &&
  		    !selector_cmp(sel, &pol->selector) &&
  		    xfrm_sec_ctx_match(ctx, pol->security)) {
  			xfrm_pol_hold(pol);
@@ -869,8 +865,8 @@ struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u8 type,
  }
  EXPORT_SYMBOL(xfrm_policy_bysel_ctx);
  
-struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u8 type,
-				     int dir, u32 id, int delete, int *err)
+struct xfrm_policy *xfrm_policy_byid(struct net *net, const struct xfrm_mark *mark,
+					 u8 type, int dir, u32 id, int delete, int *err)
  {
  	struct xfrm_policy *pol, *ret;
  	struct hlist_head *chain;
@@ -885,7 +881,7 @@ struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u8 type,
  	ret = NULL;
  	hlist_for_each_entry(pol, chain, byidx) {
  		if (pol->type == type && pol->index == id &&
-		    (mark & pol->mark.m) == pol->mark.v) {
+		    xfrm_policy_mark_match(mark, pol)) {
  			xfrm_pol_hold(pol);
  			if (delete) {
  				*err = security_xfrm_policy_delete(
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 48139e1a0ac9..eaed74522197 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1777,7 +1777,6 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
  	struct km_event c;
  	int delete;
  	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
  
  	p = nlmsg_data(nlh);
  	delete = nlh->nlmsg_type == XFRM_MSG_DELPOLICY;
@@ -1790,8 +1789,10 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
  	if (err)
  		return err;
  
+	xfrm_mark_get(attrs, &m);
+
  	if (p->index)
-		xp = xfrm_policy_byid(net, mark, type, p->dir, p->index, delete, &err);
+		xp = xfrm_policy_byid(net, &m, type, p->dir, p->index, delete, &err);
  	else {
  		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
  		struct xfrm_sec_ctx *ctx;
@@ -1808,7 +1809,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
  			if (err)
  				return err;
  		}
-		xp = xfrm_policy_bysel_ctx(net, mark, type, p->dir, &p->sel,
+		xp = xfrm_policy_bysel_ctx(net, &m, type, p->dir, &p->sel,
  					   ctx, delete, &err);
  		security_xfrm_policy_free(ctx);
  	}
@@ -2072,7 +2073,6 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
  	u8 type = XFRM_POLICY_TYPE_MAIN;
  	int err = -ENOENT;
  	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
  
  	err = copy_from_user_policy_type(&type, attrs);
  	if (err)
@@ -2082,8 +2082,10 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
  	if (err)
  		return err;
  
+	xfrm_mark_get(attrs, &m);
+
  	if (p->index)
-		xp = xfrm_policy_byid(net, mark, type, p->dir, p->index, 0, &err);
+		xp = xfrm_policy_byid(net, &m, type, p->dir, p->index, 0, &err);
  	else {
  		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
  		struct xfrm_sec_ctx *ctx;
@@ -2100,7 +2102,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
  			if (err)
  				return err;
  		}
-		xp = xfrm_policy_bysel_ctx(net, mark, type, p->dir,
+		xp = xfrm_policy_bysel_ctx(net, &m, type, p->dir,
  					   &p->sel, ctx, 0, &err);
  		security_xfrm_policy_free(ctx);
  	}
-- 
2.25.1
