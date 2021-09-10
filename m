Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78578406BDC
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhIJMfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233627AbhIJMeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:34:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A17D1611EE;
        Fri, 10 Sep 2021 12:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277193;
        bh=4vQ/ZzFECcekYZ2Hcm4y3pu+ZCD9NQxmMVpVlE5aSeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8dAE1Ki8oha3rRhXkwN/6jzsno1axHTQH8qVd1xD/6IvWZT6kKCjaBqcoRf8IvMS
         qL7o73RNpejU9OSND0mZJHkC8/pVSytWUHXLEX2dk0fjC3367jKoHKb1b1KGCui4jr
         Y/G5V0uBlGmf7DUv/A+jC1khySXx3Y0DQRRg9ln4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 14/26] netfilter: nf_tables: initialize set before expression setup
Date:   Fri, 10 Sep 2021 14:30:18 +0200
Message-Id: <20210910122916.712856812@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit ad9f151e560b016b6ad3280b48e42fa11e1a5440 upstream.

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
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   46 +++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4280,15 +4280,7 @@ static int nf_tables_newset(struct net *
 	err = nf_tables_set_alloc_name(&ctx, set, name);
 	kfree(name);
 	if (err < 0)
-		goto err_set_alloc_name;
-
-	if (nla[NFTA_SET_EXPR]) {
-		expr = nft_set_elem_expr_alloc(&ctx, set, nla[NFTA_SET_EXPR]);
-		if (IS_ERR(expr)) {
-			err = PTR_ERR(expr);
-			goto err_set_alloc_name;
-		}
-	}
+		goto err_set_name;
 
 	udata = NULL;
 	if (udlen) {
@@ -4299,21 +4291,19 @@ static int nf_tables_newset(struct net *
 	INIT_LIST_HEAD(&set->bindings);
 	set->table = table;
 	write_pnet(&set->net, net);
-	set->ops   = ops;
+	set->ops = ops;
 	set->ktype = ktype;
-	set->klen  = desc.klen;
+	set->klen = desc.klen;
 	set->dtype = dtype;
 	set->objtype = objtype;
-	set->dlen  = desc.dlen;
-	set->expr = expr;
+	set->dlen = desc.dlen;
 	set->flags = flags;
-	set->size  = desc.size;
+	set->size = desc.size;
 	set->policy = policy;
-	set->udlen  = udlen;
-	set->udata  = udata;
+	set->udlen = udlen;
+	set->udata = udata;
 	set->timeout = timeout;
 	set->gc_int = gc_int;
-	set->handle = nf_tables_alloc_handle(table);
 
 	set->field_count = desc.field_count;
 	for (i = 0; i < desc.field_count; i++)
@@ -4323,20 +4313,32 @@ static int nf_tables_newset(struct net *
 	if (err < 0)
 		goto err_set_init;
 
+	if (nla[NFTA_SET_EXPR]) {
+		expr = nft_set_elem_expr_alloc(&ctx, set, nla[NFTA_SET_EXPR]);
+		if (IS_ERR(expr)) {
+			err = PTR_ERR(expr);
+			goto err_set_expr_alloc;
+		}
+
+		set->expr = expr;
+	}
+
+	set->handle = nf_tables_alloc_handle(table);
+
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
 	if (err < 0)
-		goto err_set_trans;
+		goto err_set_expr_alloc;
 
 	list_add_tail_rcu(&set->list, &table->sets);
 	table->use++;
 	return 0;
 
-err_set_trans:
+err_set_expr_alloc:
+	if (set->expr)
+		nft_expr_destroy(&ctx, set->expr);
+
 	ops->destroy(set);
 err_set_init:
-	if (expr)
-		nft_expr_destroy(&ctx, expr);
-err_set_alloc_name:
 	kfree(set->name);
 err_set_name:
 	kvfree(set);


