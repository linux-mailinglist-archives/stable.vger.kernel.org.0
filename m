Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402D0C150B
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbfI2OAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729871AbfI2OAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:00:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A724721835;
        Sun, 29 Sep 2019 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765610;
        bh=vB8PEykiLTpJVoylB+3/isI7qp+NEDMc4CvjjxdfpbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Znd12XbFRjPjyEtophp9UappMkmtOqXTAFK26tfVblSDgP2CUkxuJxce7xZX3pPMt
         S0ryJkrOGqEiN6qPvXKi1U3jn0QRxy07ga3xjMbV5NsDDL21KXOuFJ7EIQGxkJqf5W
         d82KXGh7x73giEds0EKJ/rjN1qltP1DbsdUPXxfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/63] netfilter: nft_socket: fix erroneous socket assignment
Date:   Sun, 29 Sep 2019 15:54:33 +0200
Message-Id: <20190929135041.228856362@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit 039b1f4f24ecc8493b6bb9d70b4b78750d1b35c2 ]

The socket assignment is wrong, see skb_orphan():
When skb->destructor callback is not set, but skb->sk is set, this hits BUG().

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1651813
Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_socket.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index d7f3776dfd719..637ce3e8c575c 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -47,9 +47,6 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		return;
 	}
 
-	/* So that subsequent socket matching not to require other lookups. */
-	skb->sk = sk;
-
 	switch(priv->key) {
 	case NFT_SOCKET_TRANSPARENT:
 		nft_reg_store8(dest, inet_sk_transparent(sk));
@@ -66,6 +63,9 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
 	}
+
+	if (sk != skb->sk)
+		sock_gen_put(sk);
 }
 
 static const struct nla_policy nft_socket_policy[NFTA_SOCKET_MAX + 1] = {
-- 
2.20.1



