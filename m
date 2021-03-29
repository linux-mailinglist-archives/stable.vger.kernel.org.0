Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B943B34C7AD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhC2IR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233045AbhC2IPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B63B61959;
        Mon, 29 Mar 2021 08:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005730;
        bh=ATi5ccoVKsqKmD1D8NsF2tx63RLYduU5eu00IddEJcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiNycyD9/S2++sdJhDAfZdkH4KBspknvXKdhDnPhWmCmDLycQjImJzPihiQ3WoYCp
         rrWZDETvo2x5VX34BD9Ce83qcneBHHEWW7pnUm9LAWJwArsi4h1bCTU3m5e9yOd9zF
         b89oznt8YGTYPExpFozGuuRKaj17GpPwN+rQudeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/111] Revert "netfilter: x_tables: Update remaining dereference to RCU"
Date:   Mon, 29 Mar 2021 09:58:44 +0200
Message-Id: <20210329075618.412408710@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit abe7034b9a8d57737e80cc16d60ed3666990bdbf ]

This reverts commit 443d6e86f821a165fae3fc3fc13086d27ac140b1.

This (and the following) patch basically re-implemented the RCU
mechanisms of patch 784544739a25. That patch was replaced because of the
performance problems that it created when replacing tables. Now, we have
the same issue: the call to synchronize_rcu() makes replacing tables
slower by as much as an order of magnitude.

Revert these patches and fix the issue in a different way.

Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arp_tables.c | 2 +-
 net/ipv4/netfilter/ip_tables.c  | 2 +-
 net/ipv6/netfilter/ip6_tables.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 680a1320399d..f1f78a742b36 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1406,7 +1406,7 @@ static int compat_get_entries(struct net *net,
 	xt_compat_lock(NFPROTO_ARP);
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 
 		ret = compat_table_info(private, &info);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 8c320b7a423c..10b91ebdf213 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1616,7 +1616,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 85d8ed970cdc..c973ace208c5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1625,7 +1625,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size)
-- 
2.30.1



