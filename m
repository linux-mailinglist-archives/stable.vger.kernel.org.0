Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E0B4DC6DD
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiCQM4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiCQMzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:55:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0688A94E2;
        Thu, 17 Mar 2022 05:54:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB375B81DA1;
        Thu, 17 Mar 2022 12:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8FCC340E9;
        Thu, 17 Mar 2022 12:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521637;
        bh=oGJyW9VB8SVJrrMO0vttarNjtv3xd82FZtlB3Ii/tZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=189SxMmauxQ+8b69e8lIeX6XGcRH5O794dG7YNao1X9JmbHtf36SQyKvcnCvu0F05
         pe9Y5G1XUvf5AFLbRzN4TSU7iuhelc/R5H8IBQqU9j4WnQf/n2dKD2DwrCG4qV7iIA
         IZaQ7gUZiOk9VcRR59dD87XMQh0DJ+K1zDwELGOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Yan <evitayan@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 04/28] xfrm: Check if_id in xfrm_migrate
Date:   Thu, 17 Mar 2022 13:45:55 +0100
Message-Id: <20220317124526.896673291@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
References: <20220317124526.768423926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Yan <evitayan@google.com>

[ Upstream commit c1aca3080e382886e2e58e809787441984a2f89b ]

This patch enables distinguishing SAs and SPs based on if_id during
the xfrm_migrate flow. This ensures support for xfrm interfaces
throughout the SA/SP lifecycle.

When there are multiple existing SPs with the same direction,
the same xfrm_selector and different endpoint addresses,
xfrm_migrate might fail with ENODATA.

Specifically, the code path for performing xfrm_migrate is:
  Stage 1: find policy to migrate with
    xfrm_migrate_policy_find(sel, dir, type, net)
  Stage 2: find and update state(s) with
    xfrm_migrate_state_find(mp, net)
  Stage 3: update endpoint address(es) of template(s) with
    xfrm_policy_migrate(pol, m, num_migrate)

Currently "Stage 1" always returns the first xfrm_policy that
matches, and "Stage 3" looks for the xfrm_tmpl that matches the
old endpoint address. Thus if there are multiple xfrm_policy
with same selector, direction, type and net, "Stage 1" might
rertun a wrong xfrm_policy and "Stage 3" will fail with ENODATA
because it cannot find a xfrm_tmpl with the matching endpoint
address.

The fix is to allow userspace to pass an if_id and add if_id
to the matching rule in Stage 1 and Stage 2 since if_id is a
unique ID for xfrm_policy and xfrm_state. For compatibility,
if_id will only be checked if the attribute is set.

Tested with additions to Android's kernel unit test suite:
https://android-review.googlesource.com/c/kernel/tests/+/1668886

Signed-off-by: Yan Yan <evitayan@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     |  5 +++--
 net/key/af_key.c       |  2 +-
 net/xfrm/xfrm_policy.c | 14 ++++++++------
 net/xfrm/xfrm_state.c  |  7 ++++++-
 net/xfrm/xfrm_user.c   |  6 +++++-
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 301a164f17e9..358dfe6fefef 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1679,14 +1679,15 @@ int km_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	       const struct xfrm_migrate *m, int num_bundles,
 	       const struct xfrm_kmaddress *k,
 	       const struct xfrm_encap_tmpl *encap);
-struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net);
+struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
+						u32 if_id);
 struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 				      struct xfrm_migrate *m,
 				      struct xfrm_encap_tmpl *encap);
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_bundles,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap);
+		 struct xfrm_encap_tmpl *encap, u32 if_id);
 #endif
 
 int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index de24a7d474df..9bf52a09b5ff 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2623,7 +2623,7 @@ static int pfkey_migrate(struct sock *sk, struct sk_buff *skb,
 	}
 
 	return xfrm_migrate(&sel, dir, XFRM_POLICY_TYPE_MAIN, m, i,
-			    kma ? &k : NULL, net, NULL);
+			    kma ? &k : NULL, net, NULL, 0);
 
  out:
 	return err;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4924b9135c6e..fbc0b2798184 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4257,7 +4257,7 @@ static bool xfrm_migrate_selector_match(const struct xfrm_selector *sel_cmp,
 }
 
 static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *sel,
-						    u8 dir, u8 type, struct net *net)
+						    u8 dir, u8 type, struct net *net, u32 if_id)
 {
 	struct xfrm_policy *pol, *ret = NULL;
 	struct hlist_head *chain;
@@ -4266,7 +4266,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	chain = policy_hash_direct(net, &sel->daddr, &sel->saddr, sel->family, dir);
 	hlist_for_each_entry(pol, chain, bydst) {
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			priority = ret->priority;
@@ -4278,7 +4279,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 		if ((pol->priority >= priority) && ret)
 			break;
 
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			break;
@@ -4394,7 +4396,7 @@ static int xfrm_migrate_check(const struct xfrm_migrate *m, int num_migrate)
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_migrate,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap)
+		 struct xfrm_encap_tmpl *encap, u32 if_id)
 {
 	int i, err, nx_cur = 0, nx_new = 0;
 	struct xfrm_policy *pol = NULL;
@@ -4413,14 +4415,14 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	}
 
 	/* Stage 1 - find policy */
-	if ((pol = xfrm_migrate_policy_find(sel, dir, type, net)) == NULL) {
+	if ((pol = xfrm_migrate_policy_find(sel, dir, type, net, if_id)) == NULL) {
 		err = -ENOENT;
 		goto out;
 	}
 
 	/* Stage 2 - find and update state(s) */
 	for (i = 0, mp = m; i < num_migrate; i++, mp++) {
-		if ((x = xfrm_migrate_state_find(mp, net))) {
+		if ((x = xfrm_migrate_state_find(mp, net, if_id))) {
 			x_cur[nx_cur] = x;
 			nx_cur++;
 			xc = xfrm_state_migrate(x, mp, encap);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 100b4b3723e7..291236d7676f 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1605,7 +1605,8 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	return NULL;
 }
 
-struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net)
+struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
+						u32 if_id)
 {
 	unsigned int h;
 	struct xfrm_state *x = NULL;
@@ -1621,6 +1622,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 				continue;
 			if (m->reqid && x->props.reqid != m->reqid)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
@@ -1636,6 +1639,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 			if (x->props.mode != m->mode ||
 			    x->id.proto != m->proto)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 17f0623c4508..a8c142bd1263 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2592,6 +2592,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int n = 0;
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_encap_tmpl  *encap = NULL;
+	u32 if_id = 0;
 
 	if (attrs[XFRMA_MIGRATE] == NULL)
 		return -EINVAL;
@@ -2616,7 +2617,10 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return -ENOMEM;
 	}
 
-	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap);
+	if (attrs[XFRMA_IF_ID])
+		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+
+	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap, if_id);
 
 	kfree(encap);
 
-- 
2.34.1



