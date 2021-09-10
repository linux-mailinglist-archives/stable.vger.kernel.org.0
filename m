Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE98B406BDF
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhIJMfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233802AbhIJMe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:34:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 803D1611F0;
        Fri, 10 Sep 2021 12:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277196;
        bh=VC2FlREVMZd6jCfikPXlVEMdaq3EJePffyLdeXYEM/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXJ6KgCqqgZLNeW9oE03595IFda66O+Iq3o9ca1Jakugt8rd9psbXeheBBwfqJdww
         UazLISBZeKJhtRIZYS8J7re9BctLICSFKqRwJPug9MHQDjAjvXytMZhI0Wn4qFAxlo
         /DZnmrl26ZfwFSXMwSkvG5Nvw0pZ5PovHxI4LpBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laura Garcia Liebana <nevola@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 15/26] netfilter: nftables: clone set element expression template
Date:   Fri, 10 Sep 2021 14:30:19 +0200
Message-Id: <20210910122916.743370957@linuxfoundation.org>
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

commit 4d8f9065830e526c83199186c5f56a6514f457d2 upstream.

memcpy() breaks when using connlimit in set elements. Use
nft_expr_clone() to initialize the connlimit expression list, otherwise
connlimit garbage collector crashes when walking on the list head copy.

[  493.064656] Workqueue: events_power_efficient nft_rhash_gc [nf_tables]
[  493.064685] RIP: 0010:find_or_evict+0x5a/0x90 [nf_conncount]
[  493.064694] Code: 2b 43 40 83 f8 01 77 0d 48 c7 c0 f5 ff ff ff 44 39 63 3c 75 df 83 6d 18 01 48 8b 43 08 48 89 de 48 8b 13 48 8b 3d ee 2f 00 00 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 48 89 03 48 83
[  493.064699] RSP: 0018:ffffc90000417dc0 EFLAGS: 00010297
[  493.064704] RAX: 0000000000000000 RBX: ffff888134f38410 RCX: 0000000000000000
[  493.064708] RDX: 0000000000000000 RSI: ffff888134f38410 RDI: ffff888100060cc0
[  493.064711] RBP: ffff88812ce594a8 R08: ffff888134f38438 R09: 00000000ebb9025c
[  493.064714] R10: ffffffff8219f838 R11: 0000000000000017 R12: 0000000000000001
[  493.064718] R13: ffffffff82146740 R14: ffff888134f38410 R15: 0000000000000000
[  493.064721] FS:  0000000000000000(0000) GS:ffff88840e440000(0000) knlGS:0000000000000000
[  493.064725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  493.064729] CR2: 0000000000000008 CR3: 00000001330aa002 CR4: 00000000001706e0
[  493.064733] Call Trace:
[  493.064737]  nf_conncount_gc_list+0x8f/0x150 [nf_conncount]
[  493.064746]  nft_rhash_gc+0x106/0x390 [nf_tables]

Reported-by: Laura Garcia Liebana <nevola@gmail.com>
Fixes: 409444522976 ("netfilter: nf_tables: add elements with stateful expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5150,6 +5150,24 @@ static void nf_tables_set_elem_destroy(c
 	kfree(elem);
 }
 
+static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
+				   const struct nft_set_ext *ext,
+				   struct nft_expr *expr)
+{
+	struct nft_expr *elem_expr = nft_set_ext_expr(ext);
+	int err;
+
+	if (expr == NULL)
+		return 0;
+
+	err = nft_expr_clone(elem_expr, expr);
+	if (err < 0)
+		return -ENOMEM;
+
+	nft_expr_destroy(ctx, expr);
+	return 0;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -5352,15 +5370,17 @@ static int nft_add_set_elem(struct nft_c
 		*nft_set_ext_obj(ext) = obj;
 		obj->use++;
 	}
-	if (expr) {
-		memcpy(nft_set_ext_expr(ext), expr, expr->ops->size);
-		kfree(expr);
-		expr = NULL;
-	}
+
+	err = nft_set_elem_expr_setup(ctx, ext, expr);
+	if (err < 0)
+		goto err_elem_expr;
+	expr = NULL;
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
-	if (trans == NULL)
-		goto err_trans;
+	if (trans == NULL) {
+		err = -ENOMEM;
+		goto err_elem_expr;
+	}
 
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
@@ -5404,7 +5424,7 @@ err_set_full:
 	set->ops->remove(ctx->net, set, &elem);
 err_element_clash:
 	kfree(trans);
-err_trans:
+err_elem_expr:
 	if (obj)
 		obj->use--;
 


