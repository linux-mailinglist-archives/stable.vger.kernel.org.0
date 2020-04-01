Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CE719B404
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbgDAQy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732368AbgDAQ01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:26:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B693021556;
        Wed,  1 Apr 2020 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758387;
        bh=nNt8enatMWJnw9ROJBeIzsfYeGO5CjoIBWXwR3psAfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZaXmNcTLnmE7EcVqGU1usxro/n4lIEVgZ3v7mjE30DueFYp+0fm5YcTPs2gonzMJ
         BMuWVoUOBHeb3FCMCUjoGx+tOad67P6Q7ky2kw72vtXCHg1vwk6vWDhHcbBp0R+aQy
         InBPLQuTa0mdP2IJt7nkC3VzlfuGUb2HrHFWTj0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 073/116] netfilter: nft_fwd_netdev: validate family and chain type
Date:   Wed,  1 Apr 2020 18:17:29 +0200
Message-Id: <20200401161552.228574839@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 76a109fac206e158eb3c967af98c178cff738e6a upstream.

Make sure the forward action is only used from ingress.

Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_fwd_netdev.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -186,6 +186,13 @@ nla_put_failure:
 	return -1;
 }
 
+static int nft_fwd_validate(const struct nft_ctx *ctx,
+			    const struct nft_expr *expr,
+			    const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS));
+}
+
 static struct nft_expr_type nft_fwd_netdev_type;
 static const struct nft_expr_ops nft_fwd_neigh_netdev_ops = {
 	.type		= &nft_fwd_netdev_type,
@@ -193,6 +200,7 @@ static const struct nft_expr_ops nft_fwd
 	.eval		= nft_fwd_neigh_eval,
 	.init		= nft_fwd_neigh_init,
 	.dump		= nft_fwd_neigh_dump,
+	.validate	= nft_fwd_validate,
 };
 
 static const struct nft_expr_ops nft_fwd_netdev_ops = {
@@ -201,6 +209,7 @@ static const struct nft_expr_ops nft_fwd
 	.eval		= nft_fwd_netdev_eval,
 	.init		= nft_fwd_netdev_init,
 	.dump		= nft_fwd_netdev_dump,
+	.validate	= nft_fwd_validate,
 };
 
 static const struct nft_expr_ops *


