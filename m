Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5DF1EEA5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731709AbfEOLXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731694AbfEOLXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A27920881;
        Wed, 15 May 2019 11:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919427;
        bh=JYkujlxxw32yNS0nlfdlOjicILURIxzUFUSHXFtYckM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8McB0ICo8WY4Vqj/V4K0h2XaeVw6MDv4MVwXL/Qo7zxkR7cS9rlxU3JuJfRB0Fn+
         3WyQ1KhaIUG2/8RmeUKQX5OyTxcF+tu6gpurxiabAHRoSMfUR0st5thXPvBCwN5QNt
         0tn+U6yIM6F2ngvn3CGI9qR82KtJLLHWu0rq3gKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.19 070/113] netfilter: nf_tables: use-after-free in dynamic operations
Date:   Wed, 15 May 2019 12:56:01 +0200
Message-Id: <20190515090658.842149354@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3f3a390dbd59d236f62cff8e8b20355ef7069e3d ]

Smatch reports:

       net/netfilter/nf_tables_api.c:2167 nf_tables_expr_destroy()
        error: dereferencing freed memory 'expr->ops'

net/netfilter/nf_tables_api.c
    2162 static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
    2163                                   struct nft_expr *expr)
    2164 {
    2165        if (expr->ops->destroy)
    2166                expr->ops->destroy(ctx, expr);
                                                ^^^^
--> 2167        module_put(expr->ops->type->owner);
                           ^^^^^^^^^
    2168 }

Smatch says there are three functions which free expr->ops.

Fixes: b8e204006340 ("netfilter: nft_compat: use .release_ops and remove list of extension")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f272f9538c44a..ef7ff13a7b992 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2113,9 +2113,11 @@ static int nf_tables_newexpr(const struct nft_ctx *ctx,
 static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
 				   struct nft_expr *expr)
 {
+	const struct nft_expr_type *type = expr->ops->type;
+
 	if (expr->ops->destroy)
 		expr->ops->destroy(ctx, expr);
-	module_put(expr->ops->type->owner);
+	module_put(type->owner);
 }
 
 struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
-- 
2.20.1



