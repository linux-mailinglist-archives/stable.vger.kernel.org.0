Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792DF664B0F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbjAJSis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239524AbjAJShv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:37:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638979151E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:33:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2CAA6183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5505C433EF;
        Tue, 10 Jan 2023 18:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375585;
        bh=6XToY696f95I1KIqnF6w+zCCv7OMMVj+lumQir/hgn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cd7uKYZY2FE4AxIJCJNItB2fN3y2Mfysth243Pjcuvph3rTVcLT4mpT4q5+i5ON7K
         1KF3H9mxpXuaZFJOP9Ek/ZBkEPK+wmbhd9H5P6zj8JWJYFjG7vKEYjDlZu9Wd+duSH
         0zBcMELPzlBaf1jgOkY2pObBSMP9+a57u3VjYAEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/290] netfilter: nf_tables: honor set timeout and garbage collection updates
Date:   Tue, 10 Jan 2023 19:04:57 +0100
Message-Id: <20230110180039.060289480@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 123b99619cca94bdca0bf7bde9abe28f0a0dfe06 ]

Set timeout and garbage collection interval updates are ignored on
updates. Add transaction to update global set element timeout and
garbage collection interval.

Fixes: 96518518cc41 ("netfilter: add nftables")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 13 ++++++-
 net/netfilter/nf_tables_api.c     | 63 ++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5377dbfba120..80df8ff5e675 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -562,7 +562,9 @@ void *nft_set_catchall_gc(const struct nft_set *set);
 
 static inline unsigned long nft_set_gc_interval(const struct nft_set *set)
 {
-	return set->gc_int ? msecs_to_jiffies(set->gc_int) : HZ;
+	u32 gc_int = READ_ONCE(set->gc_int);
+
+	return gc_int ? msecs_to_jiffies(gc_int) : HZ;
 }
 
 /**
@@ -1511,6 +1513,9 @@ struct nft_trans_rule {
 struct nft_trans_set {
 	struct nft_set			*set;
 	u32				set_id;
+	u32				gc_int;
+	u64				timeout;
+	bool				update;
 	bool				bound;
 };
 
@@ -1520,6 +1525,12 @@ struct nft_trans_set {
 	(((struct nft_trans_set *)trans->data)->set_id)
 #define nft_trans_set_bound(trans)	\
 	(((struct nft_trans_set *)trans->data)->bound)
+#define nft_trans_set_update(trans)	\
+	(((struct nft_trans_set *)trans->data)->update)
+#define nft_trans_set_timeout(trans)	\
+	(((struct nft_trans_set *)trans->data)->timeout)
+#define nft_trans_set_gc_int(trans)	\
+	(((struct nft_trans_set *)trans->data)->gc_int)
 
 struct nft_trans_chain {
 	bool				update;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 82fe54b64714..81bd13b3d8fd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -465,8 +465,9 @@ static int nft_delrule_by_chain(struct nft_ctx *ctx)
 	return 0;
 }
 
-static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
-			     struct nft_set *set)
+static int __nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
+			       struct nft_set *set,
+			       const struct nft_set_desc *desc)
 {
 	struct nft_trans *trans;
 
@@ -474,17 +475,28 @@ static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 	if (trans == NULL)
 		return -ENOMEM;
 
-	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] != NULL) {
+	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] && !desc) {
 		nft_trans_set_id(trans) =
 			ntohl(nla_get_be32(ctx->nla[NFTA_SET_ID]));
 		nft_activate_next(ctx->net, set);
 	}
 	nft_trans_set(trans) = set;
+	if (desc) {
+		nft_trans_set_update(trans) = true;
+		nft_trans_set_gc_int(trans) = desc->gc_int;
+		nft_trans_set_timeout(trans) = desc->timeout;
+	}
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 }
 
+static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
+			     struct nft_set *set)
+{
+	return __nft_trans_set_add(ctx, msg_type, set, NULL);
+}
+
 static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int err;
@@ -3899,8 +3911,10 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
-	struct nlmsghdr *nlh;
+	u64 timeout = READ_ONCE(set->timeout);
+	u32 gc_int = READ_ONCE(set->gc_int);
 	u32 portid = ctx->portid;
+	struct nlmsghdr *nlh;
 	struct nlattr *nest;
 	u32 seq = ctx->seq;
 	int i;
@@ -3936,13 +3950,13 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	    nla_put_be32(skb, NFTA_SET_OBJ_TYPE, htonl(set->objtype)))
 		goto nla_put_failure;
 
-	if (set->timeout &&
+	if (timeout &&
 	    nla_put_be64(skb, NFTA_SET_TIMEOUT,
-			 nf_jiffies64_to_msecs(set->timeout),
+			 nf_jiffies64_to_msecs(timeout),
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
-	if (set->gc_int &&
-	    nla_put_be32(skb, NFTA_SET_GC_INTERVAL, htonl(set->gc_int)))
+	if (gc_int &&
+	    nla_put_be32(skb, NFTA_SET_GC_INTERVAL, htonl(gc_int)))
 		goto nla_put_failure;
 
 	if (set->policy != NFT_SET_POL_PERFORMANCE) {
@@ -4487,7 +4501,10 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		for (i = 0; i < num_exprs; i++)
 			nft_expr_destroy(&ctx, exprs[i]);
 
-		return err;
+		if (err < 0)
+			return err;
+
+		return __nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set, &desc);
 	}
 
 	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
@@ -5877,7 +5894,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = set->timeout;
+		timeout = READ_ONCE(set->timeout);
 	}
 
 	expiration = 0;
@@ -5978,7 +5995,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != set->timeout) {
+		if (timeout != READ_ONCE(set->timeout)) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
@@ -8833,14 +8850,20 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
-			nft_clear(net, nft_trans_set(trans));
-			/* This avoids hitting -EBUSY when deleting the table
-			 * from the transaction.
-			 */
-			if (nft_set_is_anonymous(nft_trans_set(trans)) &&
-			    !list_empty(&nft_trans_set(trans)->bindings))
-				trans->ctx.table->use--;
+			if (nft_trans_set_update(trans)) {
+				struct nft_set *set = nft_trans_set(trans);
 
+				WRITE_ONCE(set->timeout, nft_trans_set_timeout(trans));
+				WRITE_ONCE(set->gc_int, nft_trans_set_gc_int(trans));
+			} else {
+				nft_clear(net, nft_trans_set(trans));
+				/* This avoids hitting -EBUSY when deleting the table
+				 * from the transaction.
+				 */
+				if (nft_set_is_anonymous(nft_trans_set(trans)) &&
+				    !list_empty(&nft_trans_set(trans)->bindings))
+					trans->ctx.table->use--;
+			}
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_NEWSET, GFP_KERNEL);
 			nft_trans_destroy(trans);
@@ -9062,6 +9085,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSET:
+			if (nft_trans_set_update(trans)) {
+				nft_trans_destroy(trans);
+				break;
+			}
 			trans->ctx.table->use--;
 			if (nft_trans_set_bound(trans)) {
 				nft_trans_destroy(trans);
-- 
2.35.1



