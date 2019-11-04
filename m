Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0909FEEC81
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbfKDV5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387909AbfKDV5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:37 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAF31214D8;
        Mon,  4 Nov 2019 21:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904656;
        bh=b/VTm9YJ1NJyWJzB9JlmSk2ByMW0IN3eqaHT/MLyop0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3tRkK1yVV/kpIKoAoGwvCphKQelH8yWqpELwsMca8j4bgBgSfCcLFnWokVUXxwxW
         C+o1mGUEAYcZfc2cnyn0fJIKIVtRZRyqm2l4/a6h+ihr3UvX0PvG6m8zAMjZnvxokT
         EZ8r6qpADFJ44TZKmuXNPVjhDS5HC5EUG0eWYpug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/149] netfilter: ipset: Make invalid MAC address checks consistent
Date:   Mon,  4 Nov 2019 22:43:36 +0100
Message-Id: <20191104212137.327372294@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 29edbc3ebdb0faa934114f14bf12fc0b784d4f1b ]

Set types bitmap:ipmac and hash:ipmac check that MAC addresses
are not all zeroes.

Introduce one missing check, and make the remaining ones
consistent, using is_zero_ether_addr() instead of comparing
against an array containing zeroes.

This was already done for hash:mac sets in commit 26c97c5d8dac
("netfilter: ipset: Use is_zero_ether_addr instead of static and
memcmp").

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c |  3 +++
 net/netfilter/ipset/ip_set_hash_ipmac.c   | 11 ++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 4f01321e793ce..794e0335a8648 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -235,6 +235,9 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
 
+	if (is_zero_ether_addr(e.ether))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index 16ec822e40447..25560ea742d66 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -36,9 +36,6 @@ MODULE_ALIAS("ip_set_hash:ip,mac");
 /* Type specific function prefix */
 #define HTYPE		hash_ipmac
 
-/* Zero valued element is not supported */
-static const unsigned char invalid_ether[ETH_ALEN] = { 0 };
-
 /* IPv4 variant */
 
 /* Member elements */
@@ -104,7 +101,7 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
 
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -EINVAL;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
@@ -140,7 +137,7 @@ hash_ipmac4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 	memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -IPSET_ERR_HASH_ELEM;
 
 	return adtfn(set, &e, &ext, &ext, flags);
@@ -220,7 +217,7 @@ hash_ipmac6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
 
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -EINVAL;
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
@@ -260,7 +257,7 @@ hash_ipmac6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -IPSET_ERR_HASH_ELEM;
 
 	return adtfn(set, &e, &ext, &ext, flags);
-- 
2.20.1



