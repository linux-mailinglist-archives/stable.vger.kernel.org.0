Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1561D8517
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730897AbgERR6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731907AbgERR6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:58:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F9D9207C4;
        Mon, 18 May 2020 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824709;
        bh=0NmjDoUM5gYgsEDS4Q8qgD6YSor5H2823HhLNhDpAmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZu9ebdZQpye+b1ESJkqkVSTSls9WBkfs1WgC85kAC9lJaa5vpYFpsYX3GFtkn4FD
         ooZ5xSXdYl6xfWLjz6updiwLEzmP0+V1G72d/vY/f+5l7xtQ1uOLwscK6StZ7O5Jc0
         fXIXQqCRadkWU9ODTwbvAz+hVd1abJ3oBMnqsn70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/147] netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
Date:   Mon, 18 May 2020 19:36:45 +0200
Message-Id: <20200518173523.883069486@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 6f7c9caf017be8ab0fe3b99509580d0793bf0833 ]

Replace negations of nft_rbtree_interval_end() with a new helper,
nft_rbtree_interval_start(), wherever this helps to visualise the
problem at hand, that is, for all the occurrences except for the
comparison against given flags in __nft_rbtree_get().

This gets especially useful in the next patch.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index a9f804f7a04ac..95fcba34bfd35 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -33,6 +33,11 @@ static bool nft_rbtree_interval_end(const struct nft_rbtree_elem *rbe)
 	       (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END);
 }
 
+static bool nft_rbtree_interval_start(const struct nft_rbtree_elem *rbe)
+{
+	return !nft_rbtree_interval_end(rbe);
+}
+
 static bool nft_rbtree_equal(const struct nft_set *set, const void *this,
 			     const struct nft_rbtree_elem *interval)
 {
@@ -64,7 +69,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 			if (interval &&
 			    nft_rbtree_equal(set, this, interval) &&
 			    nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(interval))
+			    nft_rbtree_interval_start(interval))
 				continue;
 			interval = rbe;
 		} else if (d > 0)
@@ -89,7 +94,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_rbtree_interval_end(interval)) {
+	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
 	}
@@ -224,9 +229,9 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			p = &parent->rb_right;
 		else {
 			if (nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(new)) {
+			    nft_rbtree_interval_start(new)) {
 				p = &parent->rb_left;
-			} else if (!nft_rbtree_interval_end(rbe) &&
+			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p = &parent->rb_right;
 			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
@@ -317,10 +322,10 @@ static void *nft_rbtree_deactivate(const struct net *net,
 			parent = parent->rb_right;
 		else {
 			if (nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(this)) {
+			    nft_rbtree_interval_start(this)) {
 				parent = parent->rb_left;
 				continue;
-			} else if (!nft_rbtree_interval_end(rbe) &&
+			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
-- 
2.20.1



