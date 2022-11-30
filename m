Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB97863DD7B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiK3S15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiK3S1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:27:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C2D12774
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:27:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8539561D05
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9780AC433D6;
        Wed, 30 Nov 2022 18:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832859;
        bh=tMO2ukIdQKd8g5sLqwWOhXc0sM/NNOS+j+NOQfqp9Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/ZZFrKPSVJyrc/Ko+n5PUkJIwC8WpfmNP9+bh4CDw7pgR0/4G11x1y8O/QzeG6TQ
         qWlM7rOaLrmSCx1UKIhuUUIJM1kITLYuvVSrAjDnq1/vliF88lXxvmEX20EXjDZUu7
         nW4ujV5H486y7cCOp9sfKBddJj+FIq2nB7UGFjK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brad Spengler <spender@grsecurity.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/162] netfilter: ipset: Limit the maximal range of consecutive elements to add/delete
Date:   Wed, 30 Nov 2022 19:22:26 +0100
Message-Id: <20221130180530.267439907@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 5f7b51bf09baca8e4f80cbe879536842bafb5f31 ]

The range size of consecutive elements were not limited. Thus one could
define a huge range which may result soft lockup errors due to the long
execution time. Now the range size is limited to 2^20 entries.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: c7aa1a76d4a0 ("netfilter: ipset: regression in ip_set_hash_ip.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/ipset/ip_set.h       |  3 +++
 net/netfilter/ipset/ip_set_hash_ip.c         |  9 ++++++++-
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  3 +++
 net/netfilter/ipset/ip_set_hash_net.c        | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c   | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_netnet.c     | 16 +++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netport.c    | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netportnet.c | 16 +++++++++++++++-
 11 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index ab192720e2d6..53c9a17ecb3e 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -198,6 +198,9 @@ struct ip_set_region {
 	u32 elements;		/* Number of elements vs timeout */
 };
 
+/* Max range where every element is added/deleted in one step */
+#define IPSET_MAX_RANGE		(1<<20)
+
 /* The core set type structure */
 struct ip_set_type {
 	struct list_head list;
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 5d6d68eaf6a9..361f4fd69bf4 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -131,8 +131,11 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (ip_to == 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -143,6 +146,10 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
 
+	/* 64bit division is not allowed on 32bit */
+	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried) {
 		ip = ntohl(h->next.ip);
 		e.ip = htonl(ip);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index aba1df617d6e..eefce34a34f0 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -120,6 +120,8 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	e.mark = ntohl(nla_get_be32(tb[IPSET_ATTR_MARK]));
 	e.mark &= h->markmask;
+	if (e.mark == 0 && e.ip == 0)
+		return -IPSET_ERR_HASH_ELEM;
 
 	if (adt == IPSET_TEST ||
 	    !(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_CIDR])) {
@@ -132,8 +134,11 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (e.mark == 0 && ip_to == 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -142,6 +147,9 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
+	if (((u64)ip_to - ip + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 1ff228717e29..4a54e9e8ae59 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -172,6 +172,9 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index fa88afd812fa..09737de5ecc3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -179,6 +179,9 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index eef6ecfcb409..02685371a682 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -252,6 +252,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 136cf0781d3a..9d1beaacb973 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -139,7 +139,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = { .cidr = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0;
+	u32 ip = 0, ip_to = 0, ipn, n = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -187,6 +187,15 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index be5e95a0d876..c3ada9c63fa3 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -201,7 +201,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0;
+	u32 ip = 0, ip_to = 0, ipn, n = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -255,6 +255,14 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index da4ef910b12d..b1411bc91a40 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -167,7 +167,8 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0;
-	u32 ip2 = 0, ip2_from = 0, ip2_to = 0;
+	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, ipn;
+	u64 n = 0, m = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -243,6 +244,19 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn = ip2_from;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 34448df80fb9..d26d13528fe8 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -157,7 +157,8 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 port, port_to, p = 0, ip = 0, ip_to = 0;
+	u32 port, port_to, p = 0, ip = 0, ip_to = 0, ipn;
+	u64 n = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -234,6 +235,14 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 934c1712cba8..6446f4fccc72 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -181,7 +181,8 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2;
+	u32 ip2_from = 0, ip2_to = 0, ip2, ipn;
+	u64 n = 0, m = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -283,6 +284,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn = ip2_from;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
-- 
2.35.1



