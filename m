Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9FB5F742
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfD3L5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728926AbfD3LsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1B0C2054F;
        Tue, 30 Apr 2019 11:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624886;
        bh=17cVRuU6W8q7VjDf23UMfIcNffAFqd8hJoMrPf6lOa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUOtV+tXxNPfWTaJdWPuhe7xr8vABRP+ix5D2MhZ3heD0WHhZDfoYuWzzTB8Y1lVl
         TDbphLE+vgNihQmBlk2IBnbXN/6sKtMJThrXdAVyftA/wZzI24qQU/tvZ6F9vOP6tY
         YHEVPmynbUiA9KGK8qGS7NoH4hZujciiGPQkgvxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Garcia <nevola@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 02/89] netfilter: nf_tables: bogus EBUSY in helper removal from transaction
Date:   Tue, 30 Apr 2019 13:37:53 +0200
Message-Id: <20190430113609.924618319@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8ffcd32f64633926163cdd07a7d295c500a947d1 ]

Proper use counter updates when activating and deactivating the object,
otherwise, this hits bogus EBUSY error.

Fixes: cd5125d8f518 ("netfilter: nf_tables: split set destruction in deactivate and destroy phase")
Reported-by: Laura Garcia <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_objref.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index d8737c115257..bf92a40dd1b2 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -64,21 +64,34 @@ nla_put_failure:
 	return -1;
 }
 
-static void nft_objref_destroy(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr)
+static void nft_objref_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr,
+				  enum nft_trans_phase phase)
 {
 	struct nft_object *obj = nft_objref_priv(expr);
 
+	if (phase == NFT_TRANS_COMMIT)
+		return;
+
 	obj->use--;
 }
 
+static void nft_objref_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_object *obj = nft_objref_priv(expr);
+
+	obj->use++;
+}
+
 static struct nft_expr_type nft_objref_type;
 static const struct nft_expr_ops nft_objref_ops = {
 	.type		= &nft_objref_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_object *)),
 	.eval		= nft_objref_eval,
 	.init		= nft_objref_init,
-	.destroy	= nft_objref_destroy,
+	.activate	= nft_objref_activate,
+	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
 };
 
-- 
2.19.1



