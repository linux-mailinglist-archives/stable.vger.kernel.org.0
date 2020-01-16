Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD4E14001C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390614AbgAPXUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388224AbgAPXUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8FFE20684;
        Thu, 16 Jan 2020 23:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216819;
        bh=qtfZhhH+sbJ6GkfeUQL+nE7qQgjsF8AdwRJb17InM/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8nvwUbJnp0Or7WS6+iaguGioAQ4zUyfETaPRW8Iu5Th0nsO8IsHKZTBvficC4sD6
         xMnlR+oJKxT61P85wpdnnjTfANQxn0iAhe0pOdU8a2gx9eeS3W1u5ztHGeu47jtGIf
         xUxOnt4fFrH9eM0IvTvADUwUkv1vENAbCRJYBOgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 015/203] netfilter: nft_flow_offload: fix underflow in flowtable reference counter
Date:   Fri, 17 Jan 2020 00:15:32 +0100
Message-Id: <20200116231746.109928716@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

commit 8ca79606cdfde2e37ee4f0707b9d1874a6f0eb38 upstream.

The .deactivate and .activate interfaces already deal with the reference
counter. Otherwise, this results in spurious "Device is busy" errors.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_flow_offload.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -197,9 +197,6 @@ static void nft_flow_offload_activate(co
 static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
 				     const struct nft_expr *expr)
 {
-	struct nft_flow_offload *priv = nft_expr_priv(expr);
-
-	priv->flowtable->use--;
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 


