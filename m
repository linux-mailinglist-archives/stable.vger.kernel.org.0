Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7741D82B1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731907AbgERR6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731919AbgERR6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:58:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B3FE20835;
        Mon, 18 May 2020 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824712;
        bh=7MdQddoJEFfGf81S5tG2f0tnk49guqQ1rC60ry4HOBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6o+dlZmWxcn/xbvbgkcZljorkmYJMXaVYjQ/s+mcft5GRsF37j1Zd8lCeaBb9Szj
         iscLL9ZXl6JtXm8w4dFC5e5d9L+3ibQdPIaF60Y94Y0Az881h3l8X3VediU5VI/1JF
         cC8B+UsCeK6HpIrThO/uCCMmg8ws4ps6iYhDHOAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/147] netfilter: nft_set_rbtree: Add missing expired checks
Date:   Mon, 18 May 2020 19:36:46 +0200
Message-Id: <20200518173523.990186693@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 340eaff651160234bdbce07ef34b92a8e45cd540 ]

Expired intervals would still match and be dumped to user space until
garbage collection wiped them out. Make sure they stop matching and
disappear (from users' perspective) as soon as they expire.

Fixes: 8d8540c4f5e03 ("netfilter: nft_set_rbtree: add timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 95fcba34bfd35..ee7c29e0a9d7b 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -79,6 +79,10 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
+
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (nft_rbtree_interval_end(rbe)) {
 				if (nft_set_is_anonymous(set))
 					return false;
@@ -94,6 +98,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
@@ -154,6 +159,9 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 				continue;
 			}
 
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
 			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
 			    (flags & NFT_SET_ELEM_INTERVAL_END)) {
@@ -170,6 +178,7 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    ((!nft_rbtree_interval_end(interval) &&
 	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
 	     (nft_rbtree_interval_end(interval) &&
@@ -355,6 +364,8 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
+		if (nft_set_elem_expired(&rbe->ext))
+			goto cont;
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-- 
2.20.1



