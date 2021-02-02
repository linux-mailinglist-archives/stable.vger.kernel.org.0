Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0B730C87A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbhBBRvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:51:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233981AbhBBOJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:09:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E02165031;
        Tue,  2 Feb 2021 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273844;
        bh=Y5BFwjLVG8kcJgA01NSeCoCKb9oeogaK/Z9HJ4DEvuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baxt3etJFiv6esRBX05sWeNGAkWQrryzPl/zsbvKZOgbuCvzCd4HYLM1bicr0bnzJ
         L9p5IvCU1uu/BgwqqLSLm9leyyZNCccYGDaF+p1HujuQrb1JZrOl7kyoT5/JfWYcOS
         xkEKYISNrahp3MMhkBE1+I8JAMniI3+SAuog3NYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.9 22/32] netfilter: nft_dynset: add timeout extension to template
Date:   Tue,  2 Feb 2021 14:38:45 +0100
Message-Id: <20210202132942.903858869@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 0c5b7a501e7400869ee905b4f7af3d6717802bcb upstream.

Otherwise, the newly create element shows no timeout when listing the
ruleset. If the set definition does not specify a default timeout, then
the set element only shows the expiration time, but not the timeout.
This is a problem when restoring a stateful ruleset listing since it
skips the timeout policy entirely.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_dynset.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -210,8 +210,10 @@ static int nft_dynset_init(const struct
 		nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_EXPR,
 				       priv->expr->ops->size);
 	if (set->flags & NFT_SET_TIMEOUT) {
-		if (timeout || set->timeout)
+		if (timeout || set->timeout) {
+			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
 			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_EXPIRATION);
+		}
 	}
 
 	priv->timeout = timeout;


