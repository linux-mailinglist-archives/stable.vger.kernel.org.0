Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD62505764
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244501AbiDRNvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244801AbiDRNvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:51:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B90044762;
        Mon, 18 Apr 2022 06:02:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A31E2B80D9C;
        Mon, 18 Apr 2022 13:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD8FC385A1;
        Mon, 18 Apr 2022 13:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286923;
        bh=JHX+u6lY9EHfEH4aLHrplvtn94n7PjEXcl31WuzP428=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XctGIf55yTNSFyHFEp0zIL1vhKC/aYfnAwHb0OnGK9KmDkKVboBYokpwfsde2uV9W
         nOAHWpb1fJzgxTrQYT8JcE8waXbEedXXl2IVTrpzbMfN1dNgFPbCI+zJhmc6ww7mmq
         19ezbRqgKSEzXk9/u7ZSvvdmFwGYNKvP/1hSANcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Brunner <tobias@strongswan.org>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.14 260/284] xfrm: policy: match with both mark and mask on user interfaces
Date:   Mon, 18 Apr 2022 14:14:01 +0200
Message-Id: <20220418121219.925012759@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

Fixes: 295fae568885 ("xfrm: Allow user space manipulation of SPD mark")
Fixes: ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list")
Reported-by: Tobias Brunner <tobias@strongswan.org>
Tested-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/xfrm.h     |    9 ++++++---
 net/key/af_key.c       |    4 ++--
 net/xfrm/xfrm_policy.c |   24 ++++++++++--------------
 net/xfrm/xfrm_user.c   |   14 ++++++++------
 4 files changed, 26 insertions(+), 25 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1674,13 +1674,16 @@ int xfrm_policy_walk(struct net *net, st
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
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2411,7 +2411,7 @@ static int pfkey_spddelete(struct sock *
 			return err;
 	}
 
-	xp = xfrm_policy_bysel_ctx(net, DUMMY_MARK, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_bysel_ctx(net, &dummy_mark, XFRM_POLICY_TYPE_MAIN,
 				   pol->sadb_x_policy_dir - 1, &sel, pol_ctx,
 				   1, &err);
 	security_xfrm_policy_free(pol_ctx);
@@ -2662,7 +2662,7 @@ static int pfkey_spdget(struct sock *sk,
 		return -EINVAL;
 
 	delete = (hdr->sadb_msg_type == SADB_X_SPDDELETE2);
-	xp = xfrm_policy_byid(net, DUMMY_MARK, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_byid(net, &dummy_mark, XFRM_POLICY_TYPE_MAIN,
 			      dir, pol->sadb_x_policy_id, delete, &err);
 	if (xp == NULL)
 		return -ENOENT;
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -719,14 +719,10 @@ static void xfrm_policy_requeue(struct x
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
@@ -744,7 +740,7 @@ int xfrm_policy_insert(int dir, struct x
 	hlist_for_each_entry(pol, chain, bydst) {
 		if (pol->type == policy->type &&
 		    !selector_cmp(&pol->selector, &policy->selector) &&
-		    xfrm_policy_mark_match(policy, pol) &&
+		    xfrm_policy_mark_match(&policy->mark, pol) &&
 		    xfrm_sec_ctx_match(pol->security, policy->security) &&
 		    !WARN_ON(delpol)) {
 			if (excl) {
@@ -794,8 +790,8 @@ int xfrm_policy_insert(int dir, struct x
 }
 EXPORT_SYMBOL(xfrm_policy_insert);
 
-struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u8 type,
-					  int dir, struct xfrm_selector *sel,
+struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, const struct xfrm_mark *mark,
+					  u8 type, int dir, struct xfrm_selector *sel,
 					  struct xfrm_sec_ctx *ctx, int delete,
 					  int *err)
 {
@@ -808,7 +804,7 @@ struct xfrm_policy *xfrm_policy_bysel_ct
 	ret = NULL;
 	hlist_for_each_entry(pol, chain, bydst) {
 		if (pol->type == type &&
-		    (mark & pol->mark.m) == pol->mark.v &&
+		    xfrm_policy_mark_match(mark, pol) &&
 		    !selector_cmp(sel, &pol->selector) &&
 		    xfrm_sec_ctx_match(ctx, pol->security)) {
 			xfrm_pol_hold(pol);
@@ -833,8 +829,8 @@ struct xfrm_policy *xfrm_policy_bysel_ct
 }
 EXPORT_SYMBOL(xfrm_policy_bysel_ctx);
 
-struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u8 type,
-				     int dir, u32 id, int delete, int *err)
+struct xfrm_policy *xfrm_policy_byid(struct net *net, const struct xfrm_mark *mark,
+					 u8 type, int dir, u32 id, int delete, int *err)
 {
 	struct xfrm_policy *pol, *ret;
 	struct hlist_head *chain;
@@ -849,7 +845,7 @@ struct xfrm_policy *xfrm_policy_byid(str
 	ret = NULL;
 	hlist_for_each_entry(pol, chain, byidx) {
 		if (pol->type == type && pol->index == id &&
-		    (mark & pol->mark.m) == pol->mark.v) {
+		    xfrm_policy_mark_match(mark, pol)) {
 			xfrm_pol_hold(pol);
 			if (delete) {
 				*err = security_xfrm_policy_delete(
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1814,7 +1814,6 @@ static int xfrm_get_policy(struct sk_buf
 	struct km_event c;
 	int delete;
 	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
 
 	p = nlmsg_data(nlh);
 	delete = nlh->nlmsg_type == XFRM_MSG_DELPOLICY;
@@ -1827,8 +1826,10 @@ static int xfrm_get_policy(struct sk_buf
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
@@ -1845,7 +1846,7 @@ static int xfrm_get_policy(struct sk_buf
 			if (err)
 				return err;
 		}
-		xp = xfrm_policy_bysel_ctx(net, mark, type, p->dir, &p->sel,
+		xp = xfrm_policy_bysel_ctx(net, &m, type, p->dir, &p->sel,
 					   ctx, delete, &err);
 		security_xfrm_policy_free(ctx);
 	}
@@ -2108,7 +2109,6 @@ static int xfrm_add_pol_expire(struct sk
 	u8 type = XFRM_POLICY_TYPE_MAIN;
 	int err = -ENOENT;
 	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
 
 	err = copy_from_user_policy_type(&type, attrs);
 	if (err)
@@ -2118,8 +2118,10 @@ static int xfrm_add_pol_expire(struct sk
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
@@ -2136,7 +2138,7 @@ static int xfrm_add_pol_expire(struct sk
 			if (err)
 				return err;
 		}
-		xp = xfrm_policy_bysel_ctx(net, mark, type, p->dir,
+		xp = xfrm_policy_bysel_ctx(net, &m, type, p->dir,
 					   &p->sel, ctx, 0, &err);
 		security_xfrm_policy_free(ctx);
 	}


