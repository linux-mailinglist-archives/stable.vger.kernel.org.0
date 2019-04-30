Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006E1F7BA
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfD3Lo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729266AbfD3Lo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:44:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 149C521783;
        Tue, 30 Apr 2019 11:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624666;
        bh=YEOO92+O+3+p3qSzNn72tyfz8WhLv3cbBk0aEgiY0ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpAIZE2FmyHQFRl4FnIoIsoyj8Hn0El4eotLraV4MpKknYYJ8d+KLYcZufQaMyJQ1
         fhOy5cShw/3ievAl6tsz3FdfuUspKagejzr8s9oLXtLu6SZR8CFJ5LVxnA86Kpt1eO
         bdDqd4Q6jd5ATm8wRjsRPFqyikQvefMU8duRkyB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/100] netfilter: nf_tables: fix set double-free in abort path
Date:   Tue, 30 Apr 2019 13:37:38 +0200
Message-Id: <20190430113609.064927621@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 40ba1d9b4d19796afc9b7ece872f5f3e8f5e2c13 ]

The abort path can cause a double-free of an anonymous set.
Added-and-to-be-aborted rule looks like this:

udp dport { 137, 138 } drop

The to-be-aborted transaction list looks like this:

newset
newsetelem
newsetelem
rule

This gets walked in reverse order, so first pass disables the rule, the
set elements, then the set.

After synchronize_rcu(), we then destroy those in same order: rule, set
element, set element, newset.

Problem is that the anonymous set has already been bound to the rule, so
the rule (lookup expression destructor) already frees the set, when then
cause use-after-free when trying to delete the elements from this set,
then try to free the set again when handling the newset expression.

Rule releases the bound set in first place from the abort path, this
causes the use-after-free on set element removal when undoing the new
element transactions. To handle this, skip new element transaction if
set is bound from the abort path.

This is still causes the use-after-free on set element removal.  To
handle this, remove transaction from the list when the set is already
bound.

Joint work with Florian Westphal.

Fixes: f6ac85858976 ("netfilter: nf_tables: unbind set in rule from commit path")
Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1325
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  6 ++----
 net/netfilter/nf_tables_api.c     | 17 +++++++++++------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f66bb406004b..e5f879efcc92 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -416,7 +416,8 @@ struct nft_set {
 	unsigned char			*udata;
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
-	u16				flags:14,
+	u16				flags:13,
+					bound:1,
 					genmask:2;
 	u8				klen;
 	u8				dlen;
@@ -1330,15 +1331,12 @@ struct nft_trans_rule {
 struct nft_trans_set {
 	struct nft_set			*set;
 	u32				set_id;
-	bool				bound;
 };
 
 #define nft_trans_set(trans)	\
 	(((struct nft_trans_set *)trans->data)->set)
 #define nft_trans_set_id(trans)	\
 	(((struct nft_trans_set *)trans->data)->set_id)
-#define nft_trans_set_bound(trans)	\
-	(((struct nft_trans_set *)trans->data)->bound)
 
 struct nft_trans_chain {
 	bool				update;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index de5908d51758..959f123c1cf7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -123,7 +123,7 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
 	list_for_each_entry_reverse(trans, &net->nft.commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWSET &&
 		    nft_trans_set(trans) == set) {
-			nft_trans_set_bound(trans) = true;
+			set->bound = true;
 			break;
 		}
 	}
@@ -6547,8 +6547,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_NEWSET:
-		if (!nft_trans_set_bound(trans))
-			nft_set_destroy(nft_trans_set(trans));
+		nft_set_destroy(nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
@@ -6621,8 +6620,11 @@ static int __nf_tables_abort(struct net *net)
 			break;
 		case NFT_MSG_NEWSET:
 			trans->ctx.table->use--;
-			if (!nft_trans_set_bound(trans))
-				list_del_rcu(&nft_trans_set(trans)->list);
+			if (nft_trans_set(trans)->bound) {
+				nft_trans_destroy(trans);
+				break;
+			}
+			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
 			trans->ctx.table->use++;
@@ -6630,8 +6632,11 @@ static int __nf_tables_abort(struct net *net)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
+			if (nft_trans_elem_set(trans)->bound) {
+				nft_trans_destroy(trans);
+				break;
+			}
 			te = (struct nft_trans_elem *)trans->data;
-
 			te->set->ops->remove(net, te->set, &te->elem);
 			atomic_dec(&te->set->nelems);
 			break;
-- 
2.19.1



