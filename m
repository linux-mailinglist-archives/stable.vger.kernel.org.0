Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086F866488C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238803AbjAJSM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239027AbjAJSLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:11:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BABD15733
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A3C2B818FB
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE65C433D2;
        Tue, 10 Jan 2023 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374204;
        bh=lNXWFMuL/ocracAQo3c3OA9n8dfodmXWQ8pw6Ub5HiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYq5zdtiokW06ZAb1E9f9lHrbO/0WkYmIRrPGCA0SGQ54/NRFNBvcF3JGzF/6bvab
         Qc38RHYQcQArI/UqPR0EgZ9in6ts+sym9UKo8TSoGoLQvr2H4MML8dcVkD0JeRAfFD
         sTp3oAoVuB3K2+2a2dcEwi8ZUGAYrhholCtZpN7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9204e7399656300bf271@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 085/148] netfilter: ipset: Rework long task execution when adding/deleting entries
Date:   Tue, 10 Jan 2023 19:03:09 +0100
Message-Id: <20230110180019.896265972@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

[ Upstream commit 5e29dc36bd5e2166b834ceb19990d9e68a734d7d ]

When adding/deleting large number of elements in one step in ipset, it can
take a reasonable amount of time and can result in soft lockup errors. The
patch 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of
consecutive elements to add/delete") tried to fix it by limiting the max
elements to process at all. However it was not enough, it is still possible
that we get hung tasks. Lowering the limit is not reasonable, so the
approach in this patch is as follows: rely on the method used at resizing
sets and save the state when we reach a smaller internal batch limit,
unlock/lock and proceed from the saved state. Thus we can avoid long
continuous tasks and at the same time removed the limit to add/delete large
number of elements in one step.

The nfnl mutex is held during the whole operation which prevents one to
issue other ipset commands in parallel.

Fixes: 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")
Reported-by: syzbot+9204e7399656300bf271@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/ipset/ip_set.h      |  2 +-
 net/netfilter/ipset/ip_set_core.c           |  7 ++++---
 net/netfilter/ipset/ip_set_hash_ip.c        | 14 ++++++-------
 net/netfilter/ipset/ip_set_hash_ipmark.c    | 13 ++++++------
 net/netfilter/ipset/ip_set_hash_ipport.c    | 13 ++++++------
 net/netfilter/ipset/ip_set_hash_ipportip.c  | 13 ++++++------
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 13 +++++++-----
 net/netfilter/ipset/ip_set_hash_net.c       | 17 +++++++--------
 net/netfilter/ipset/ip_set_hash_netiface.c  | 15 ++++++--------
 net/netfilter/ipset/ip_set_hash_netnet.c    | 23 +++++++--------------
 net/netfilter/ipset/ip_set_hash_netport.c   | 19 +++++++----------
 11 files changed, 68 insertions(+), 81 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index ada1296c87d5..72f5ebc5c97a 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -197,7 +197,7 @@ struct ip_set_region {
 };
 
 /* Max range where every element is added/deleted in one step */
-#define IPSET_MAX_RANGE		(1<<20)
+#define IPSET_MAX_RANGE		(1<<14)
 
 /* The max revision number supported by any set type + 1 */
 #define IPSET_REVISION_MAX	9
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 6b31746f9be3..751ac89b07a5 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1698,9 +1698,10 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
 		ip_set_unlock(set);
 		retried = true;
-	} while (ret == -EAGAIN &&
-		 set->variant->resize &&
-		 (ret = set->variant->resize(set, retried)) == 0);
+	} while (ret == -ERANGE ||
+		 (ret == -EAGAIN &&
+		  set->variant->resize &&
+		  (ret = set->variant->resize(set, retried)) == 0));
 
 	if (!ret || (ret == -IPSET_ERR_EXIST && eexist))
 		return 0;
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 75d556d71652..24adcdd7a0b1 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -98,11 +98,11 @@ static int
 hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ip4 *h = set->data;
+	struct hash_ip4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ip4_elem e = { 0 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0, hosts;
+	u32 ip = 0, ip_to = 0, hosts, i = 0;
 	int ret = 0;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -147,14 +147,14 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
 
-	/* 64bit division is not allowed on 32bit */
-	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to;) {
+	for (; ip <= ip_to; i++) {
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_ip4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 153de3457423..a22ec1a6f6ec 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -97,11 +97,11 @@ static int
 hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipmark4 *h = set->data;
+	struct hash_ipmark4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipmark4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to = 0;
+	u32 ip, ip_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -148,13 +148,14 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
-	if (((u64)ip_to - ip + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to; ip++, i++) {
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_ipmark4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ret = adtfn(set, &e, &ext, &ext, flags);
 
 		if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 7303138e46be..10481760a9b2 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -105,11 +105,11 @@ static int
 hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipport4 *h = set->data;
+	struct hash_ipport4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem e = { .ip = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to = 0, p = 0, port, port_to;
+	u32 ip, ip_to = 0, p = 0, port, port_to, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -173,17 +173,18 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
-		for (; p <= port_to; p++) {
+		for (; p <= port_to; p++, i++) {
 			e.ip = htonl(ip);
 			e.port = htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_ipport4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret = adtfn(set, &e, &ext, &ext, flags);
 
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 334fb1ad0e86..39a01934b153 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -108,11 +108,11 @@ static int
 hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		    enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipportip4 *h = set->data;
+	struct hash_ipportip4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip4_elem e = { .ip = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to = 0, p = 0, port, port_to;
+	u32 ip, ip_to = 0, p = 0, port, port_to, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -180,17 +180,18 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
-		for (; p <= port_to; p++) {
+		for (; p <= port_to; p++, i++) {
 			e.ip = htonl(ip);
 			e.port = htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_ipportip4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret = adtfn(set, &e, &ext, &ext, flags);
 
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 7df94f437f60..5c6de605a9fb 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -160,12 +160,12 @@ static int
 hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		     enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipportnet4 *h = set->data;
+	struct hash_ipportnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2;
+	u32 ip2_from = 0, ip2_to = 0, ip2, i = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -253,9 +253,6 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
@@ -282,9 +279,15 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
 			do {
+				i++;
 				e.ip2 = htonl(ip2);
 				ip2 = ip_set_range_to_cidr(ip2, ip2_to, &cidr);
 				e.cidr = cidr - 1;
+				if (i > IPSET_MAX_RANGE) {
+					hash_ipportnet4_data_next(&h->next,
+								  &e);
+					return -ERANGE;
+				}
 				ret = adtfn(set, &e, &ext, &ext, flags);
 
 				if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 1422739d9aa2..ce0a9ce5a91f 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -136,11 +136,11 @@ static int
 hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_net4 *h = set->data;
+	struct hash_net4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = { .cidr = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0, ipn, n = 0;
+	u32 ip = 0, ip_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -188,19 +188,16 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
+		i++;
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_net4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 9810f5bf63f5..031073286236 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -202,7 +202,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0, ipn, n = 0;
+	u32 ip = 0, ip_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -256,19 +256,16 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
+		i++;
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_netiface4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 3d09eefe998a..c07b70bf32db 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -163,13 +163,12 @@ static int
 hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netnet4 *h = set->data;
+	struct hash_netnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0;
-	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, ipn;
-	u64 n = 0, m = 0;
+	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -245,19 +244,6 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
-		n++;
-	} while (ipn++ < ip_to);
-	ipn = ip2_from;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
-		m++;
-	} while (ipn++ < ip2_to);
-
-	if (n*m > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
@@ -270,7 +256,12 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		e.ip[0] = htonl(ip);
 		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		do {
+			i++;
 			e.ip[1] = htonl(ip2);
+			if (i > IPSET_MAX_RANGE) {
+				hash_netnet4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ip2 = ip_set_range_to_cidr(ip2, ip2_to, &e.cidr[1]);
 			ret = adtfn(set, &e, &ext, &ext, flags);
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 09cf72eb37f8..d1a0628df4ef 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -154,12 +154,11 @@ static int
 hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		   enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netport4 *h = set->data;
+	struct hash_netport4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 port, port_to, p = 0, ip = 0, ip_to = 0, ipn;
-	u64 n = 0;
+	u32 port, port_to, p = 0, ip = 0, ip_to = 0, i = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -236,14 +235,6 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip);
@@ -255,8 +246,12 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		e.ip = htonl(ip);
 		ip = ip_set_range_to_cidr(ip, ip_to, &cidr);
 		e.cidr = cidr - 1;
-		for (; p <= port_to; p++) {
+		for (; p <= port_to; p++, i++) {
 			e.port = htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_netport4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret = adtfn(set, &e, &ext, &ext, flags);
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
-- 
2.35.1



