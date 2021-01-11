Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A562F153C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbhAKNhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:37:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbhAKNN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:13:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B901621534;
        Mon, 11 Jan 2021 13:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370765;
        bh=3yp5qsA3SEx3Gj+bzyrpvCgVBvhwQdMDTMprdwZU3Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9ZzCy0LrzaBZa+cZQVY0ht+OukTgUOqnjrtCw1L6+fF/4SsxZxDKFln9wNmq8djQ
         DvemY0WDwSnFtpLENxD7/eCLeMr3XVghoNOFfaaPxfHgfgmVI/kem+xNjtHzHlE8y7
         jnd5hZuYBNTrv73u7nElcxYz8eFmRPFszQ3kZow0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 87/92] netfilter: x_tables: Update remaining dereference to RCU
Date:   Mon, 11 Jan 2021 14:02:31 +0100
Message-Id: <20210111130043.351425234@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

commit 443d6e86f821a165fae3fc3fc13086d27ac140b1 upstream.

This fixes the dereference to fetch the RCU pointer when holding
the appropriate xtables lock.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: cc00bcaa5899 ("netfilter: x_tables: Switch synchronization to RCU")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/netfilter/arp_tables.c |    2 +-
 net/ipv4/netfilter/ip_tables.c  |    2 +-
 net/ipv6/netfilter/ip6_tables.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1406,7 +1406,7 @@ static int compat_get_entries(struct net
 	xt_compat_lock(NFPROTO_ARP);
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 		struct xt_table_info info;
 
 		ret = compat_table_info(private, &info);
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1616,7 +1616,7 @@ compat_get_entries(struct net *net, stru
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size)
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1625,7 +1625,7 @@ compat_get_entries(struct net *net, stru
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size)


