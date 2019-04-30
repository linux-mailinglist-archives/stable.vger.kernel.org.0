Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2DBF7DA
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfD3MCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730016AbfD3Lnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C1E21707;
        Tue, 30 Apr 2019 11:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624630;
        bh=YGRx5VxwEXCkogZbYt4NHvidQoiAzq1HlPlq2VdV9Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keIzluzZH1LxGHpQIttzGIxOAXDMb+5itWXgqDL0gKSFPLtYzL/Ddxj5DTXQ3C8+6
         u7SkATDq6VhpAMb7lrOTWfYTgqZZ2yufByjKN2UMJm9bugLDyJ4lOT0Tf0nLaa7boy
         9qbjsUn0j5yifEsqKOR1HBwhl2+VMZiH5Qrew+eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 005/100] netfilter: nf_tables: warn when expr implements only one of activate/deactivate
Date:   Tue, 30 Apr 2019 13:37:34 +0200
Message-Id: <20190430113608.892225940@linuxfoundation.org>
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

->destroy is only allowed to free data, or do other cleanups that do not
have side effects on other state, such as visibility to other netlink
requests.

Such things need to be done in ->deactivate.
As a transaction can fail, we need to make sure we can undo such
operations, therefore ->activate() has to be provided too.

So print a warning and refuse registration if expr->ops provides
only one of the two operations.

v2: fix nft_expr_check_ops to not repeat same check twice (Jones Desougi)

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 667f6eccbec7..dd2b28a09bd4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -207,6 +207,18 @@ static int nft_delchain(struct nft_ctx *ctx)
 	return err;
 }
 
+/* either expr ops provide both activate/deactivate, or neither */
+static bool nft_expr_check_ops(const struct nft_expr_ops *ops)
+{
+	if (!ops)
+		return true;
+
+	if (WARN_ON_ONCE((!ops->activate ^ !ops->deactivate)))
+		return false;
+
+	return true;
+}
+
 static void nft_rule_expr_activate(const struct nft_ctx *ctx,
 				   struct nft_rule *rule)
 {
@@ -1914,6 +1926,9 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
+	if (!nft_expr_check_ops(type->ops))
+		return -EINVAL;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
 		list_add_tail_rcu(&type->list, &nf_tables_expressions);
@@ -2061,6 +2076,10 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 			err = PTR_ERR(ops);
 			goto err1;
 		}
+		if (!nft_expr_check_ops(ops)) {
+			err = -EINVAL;
+			goto err1;
+		}
 	} else
 		ops = type->ops;
 
-- 
2.19.1



