Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA343AEFB2
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhFUQlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233128AbhFUQjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:39:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1876128A;
        Mon, 21 Jun 2021 16:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292992;
        bh=Z11Q4DssXH8ugaQvRdzoT9JXaLGaFdqSa2cnzox+gpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cepN/vrFohDXQYIihsxOr4k5KvaLkqVTWjCB7iFSnQvfCvQB8wIlMC8yfo4DZDNb9
         8ycUjb68H73d5aRLd2ppD7excTa6bJApzqtq23RNudIUU9QosByzkBFGJzvLSbTkcG
         rXem9J+eN5qw91ZNITqfrmMsm3fJlxvIPMf7bFWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 025/178] netfilter: nf_tables: initialize set before expression setup
Date:   Mon, 21 Jun 2021 18:13:59 +0200
Message-Id: <20210621154922.694123225@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit ad9f151e560b016b6ad3280b48e42fa11e1a5440 ]

nft_set_elem_expr_alloc() needs an initialized set if expression sets on
the NFT_EXPR_GC flag. Move set fields initialization before expression
setup.

[4512935.019450] ==================================================================
[4512935.019456] BUG: KASAN: null-ptr-deref in nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019487] Read of size 8 at addr 0000000000000070 by task nft/23532
[4512935.019494] CPU: 1 PID: 23532 Comm: nft Not tainted 5.12.0-rc4+ #48
[...]
[4512935.019502] Call Trace:
[4512935.019505]  dump_stack+0x89/0xb4
[4512935.019512]  ? nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019536]  ? nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019560]  kasan_report.cold.12+0x5f/0xd8
[4512935.019566]  ? nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019590]  nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019615]  nf_tables_newset+0xc7f/0x1460 [nf_tables]

Reported-by: syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com
Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 83 ++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 31016c144c48..9d5ea2352965 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4317,13 +4317,44 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	err = nf_tables_set_alloc_name(&ctx, set, name);
 	kfree(name);
 	if (err < 0)
-		goto err_set_alloc_name;
+		goto err_set_name;
+
+	udata = NULL;
+	if (udlen) {
+		udata = set->data + size;
+		nla_memcpy(udata, nla[NFTA_SET_USERDATA], udlen);
+	}
+
+	INIT_LIST_HEAD(&set->bindings);
+	set->table = table;
+	write_pnet(&set->net, net);
+	set->ops = ops;
+	set->ktype = ktype;
+	set->klen = desc.klen;
+	set->dtype = dtype;
+	set->objtype = objtype;
+	set->dlen = desc.dlen;
+	set->flags = flags;
+	set->size = desc.size;
+	set->policy = policy;
+	set->udlen = udlen;
+	set->udata = udata;
+	set->timeout = timeout;
+	set->gc_int = gc_int;
+
+	set->field_count = desc.field_count;
+	for (i = 0; i < desc.field_count; i++)
+		set->field_len[i] = desc.field_len[i];
+
+	err = ops->init(set, &desc, nla);
+	if (err < 0)
+		goto err_set_init;
 
 	if (nla[NFTA_SET_EXPR]) {
 		expr = nft_set_elem_expr_alloc(&ctx, set, nla[NFTA_SET_EXPR]);
 		if (IS_ERR(expr)) {
 			err = PTR_ERR(expr);
-			goto err_set_alloc_name;
+			goto err_set_expr_alloc;
 		}
 		set->exprs[0] = expr;
 		set->num_exprs++;
@@ -4334,74 +4365,44 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 
 		if (!(flags & NFT_SET_EXPR)) {
 			err = -EINVAL;
-			goto err_set_alloc_name;
+			goto err_set_expr_alloc;
 		}
 		i = 0;
 		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
 			if (i == NFT_SET_EXPR_MAX) {
 				err = -E2BIG;
-				goto err_set_init;
+				goto err_set_expr_alloc;
 			}
 			if (nla_type(tmp) != NFTA_LIST_ELEM) {
 				err = -EINVAL;
-				goto err_set_init;
+				goto err_set_expr_alloc;
 			}
 			expr = nft_set_elem_expr_alloc(&ctx, set, tmp);
 			if (IS_ERR(expr)) {
 				err = PTR_ERR(expr);
-				goto err_set_init;
+				goto err_set_expr_alloc;
 			}
 			set->exprs[i++] = expr;
 			set->num_exprs++;
 		}
 	}
 
-	udata = NULL;
-	if (udlen) {
-		udata = set->data + size;
-		nla_memcpy(udata, nla[NFTA_SET_USERDATA], udlen);
-	}
-
-	INIT_LIST_HEAD(&set->bindings);
-	set->table = table;
-	write_pnet(&set->net, net);
-	set->ops   = ops;
-	set->ktype = ktype;
-	set->klen  = desc.klen;
-	set->dtype = dtype;
-	set->objtype = objtype;
-	set->dlen  = desc.dlen;
-	set->flags = flags;
-	set->size  = desc.size;
-	set->policy = policy;
-	set->udlen  = udlen;
-	set->udata  = udata;
-	set->timeout = timeout;
-	set->gc_int = gc_int;
 	set->handle = nf_tables_alloc_handle(table);
 
-	set->field_count = desc.field_count;
-	for (i = 0; i < desc.field_count; i++)
-		set->field_len[i] = desc.field_len[i];
-
-	err = ops->init(set, &desc, nla);
-	if (err < 0)
-		goto err_set_init;
-
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
 	if (err < 0)
-		goto err_set_trans;
+		goto err_set_expr_alloc;
 
 	list_add_tail_rcu(&set->list, &table->sets);
 	table->use++;
 	return 0;
 
-err_set_trans:
-	ops->destroy(set);
-err_set_init:
+err_set_expr_alloc:
 	for (i = 0; i < set->num_exprs; i++)
 		nft_expr_destroy(&ctx, set->exprs[i]);
-err_set_alloc_name:
+
+	ops->destroy(set);
+err_set_init:
 	kfree(set->name);
 err_set_name:
 	kvfree(set);
-- 
2.30.2



