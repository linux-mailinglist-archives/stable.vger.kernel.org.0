Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8C3549748
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352676AbiFMMlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355357AbiFMMjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:39:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6945DD11;
        Mon, 13 Jun 2022 04:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E9D7B80EA7;
        Mon, 13 Jun 2022 11:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FED1C34114;
        Mon, 13 Jun 2022 11:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118529;
        bh=ZBJYkgPNFRM3u3ol/sDY2wlx3RX7Ieto/6GbF+E1F6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOGx/fCKy6vPJJZs/RTG0enjDvQ6ZQhPu9LqFMowDXlRSg5l8mD6jDMf2W20o/kCq
         NBaEtmokcV7em0/S9ZKGANCI/Dxhg+PB6oYKj3uE9sggCKEXazGZAguTy4jHjOtD91
         gSc49f4hfhUTjTeJh82EeyMTAZPxAfUYyh5eRffc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/172] netfilter: nf_tables: delete flowtable hooks via transaction list
Date:   Mon, 13 Jun 2022 12:10:52 +0200
Message-Id: <20220613094912.536908626@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b6d9014a3335194590abdd2a2471ef5147a67645 ]

Remove inactive bool field in nft_hook object that was introduced in
abadb2f865d7 ("netfilter: nf_tables: delete devices from flowtable").
Move stale flowtable hooks to transaction list instead.

Deleting twice the same device does not result in ENOENT.

Fixes: abadb2f865d7 ("netfilter: nf_tables: delete devices from flowtable")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c     | 31 ++++++-------------------------
 2 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 76bfb6cd5815..b7907385a02f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1013,7 +1013,6 @@ struct nft_stats {
 
 struct nft_hook {
 	struct list_head	list;
-	bool			inactive;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ea162e36e0e4..a5779790e337 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1733,7 +1733,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		goto err_hook_dev;
 	}
 	hook->ops.dev = dev;
-	hook->inactive = false;
 
 	return hook;
 
@@ -6880,6 +6879,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	LIST_HEAD(flowtable_del_list);
 	struct nft_hook *this, *hook;
 	struct nft_trans *trans;
 	int err;
@@ -6895,7 +6895,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
 		}
-		hook->inactive = true;
+		list_move(&hook->list, &flowtable_del_list);
 	}
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
@@ -6908,6 +6908,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
+	list_splice(&flowtable_del_list, &nft_trans_flowtable_hooks(trans));
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
@@ -6915,13 +6916,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_flowtable_del_hook:
-	list_for_each_entry(this, &flowtable_hook.list, list) {
-		hook = nft_hook_list_find(&flowtable->hook_list, this);
-		if (!hook)
-			break;
-
-		hook->inactive = false;
-	}
+	list_splice(&flowtable_del_list, &flowtable->hook_list);
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
@@ -7771,17 +7766,6 @@ void nft_chain_del(struct nft_chain *chain)
 	list_del_rcu(&chain->list);
 }
 
-static void nft_flowtable_hooks_del(struct nft_flowtable *flowtable,
-				    struct list_head *hook_list)
-{
-	struct nft_hook *hook, *next;
-
-	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		if (hook->inactive)
-			list_move(&hook->list, hook_list);
-	}
-}
-
 static void nf_tables_module_autoload_cleanup(struct net *net)
 {
 	struct nft_module_request *req, *next;
@@ -8045,8 +8029,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				nft_flowtable_hooks_del(nft_trans_flowtable(trans),
-							&nft_trans_flowtable_hooks(trans));
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
@@ -8124,7 +8106,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
-	struct nft_hook *hook;
 
 	if (action == NFNL_ABORT_VALIDATE &&
 	    nf_tables_validate(net) < 0)
@@ -8242,8 +8223,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				list_for_each_entry(hook, &nft_trans_flowtable(trans)->hook_list, list)
-					hook->inactive = false;
+				list_splice(&nft_trans_flowtable_hooks(trans),
+					    &nft_trans_flowtable(trans)->hook_list);
 			} else {
 				trans->ctx.table->use++;
 				nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
-- 
2.35.1



