Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF53714B77A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgA1OOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729944AbgA1OOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D56A324688;
        Tue, 28 Jan 2020 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220883;
        bh=8gSogPXNh+Qua/Z7YIKP4oqNfyKKRzwF83tKnY3Hask=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szGJavda8irn88H5qGjPQO8Jm86oG6uyKnRwEma6dBK3/E0qDdfCyem1qtxffwer5
         iPwJqC7uZlhQUpLl9WpeX08xULBFj9cDC63E4qhrR9AXSruz3uYJ9Z7iIFlNcmDqvY
         qZupGiZT/js9uAn6djVwMA1CwfLOBEwLA4hIf8kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 154/183] net: neigh: use long type to store jiffies delta
Date:   Tue, 28 Jan 2020 15:06:13 +0100
Message-Id: <20200128135845.142045551@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9d027e3a83f39b819e908e4e09084277a2e45e95 ]

A difference of two unsigned long needs long storage.

Fixes: c7fb64db001f ("[NETLINK]: Neighbour table configuration and statistics via rtnetlink")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index af1ecd0e7b070..9849f1f4cf4f7 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1837,8 +1837,8 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
 		goto nla_put_failure;
 	{
 		unsigned long now = jiffies;
-		unsigned int flush_delta = now - tbl->last_flush;
-		unsigned int rand_delta = now - tbl->last_rand;
+		long flush_delta = now - tbl->last_flush;
+		long rand_delta = now - tbl->last_rand;
 		struct neigh_hash_table *nht;
 		struct ndt_config ndc = {
 			.ndtc_key_len		= tbl->key_len,
-- 
2.20.1



