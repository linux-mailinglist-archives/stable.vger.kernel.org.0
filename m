Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E497111F90
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfLCXKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbfLCWms (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65AF020684;
        Tue,  3 Dec 2019 22:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412967;
        bh=5gOlZR1tvFzT779USqpuu7JWs+nEHLrWwYc3pmbp98Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEXhV8s4Q/Vk6wNeaPFvy6zbKnuXtgp7Mk0cWiSyqNaiUkFd/fq8pFogWbB7iM661
         WeJ6YHA+pf0Y9cqr2dScgROtpwhXTiJkGv8JJRYta6b2HdsIGGx+HjjhermQdQ+dlz
         O/N+Qlqm+oYM2Ct1XV2Rd2+SBvaCn8wZSJ+/V5hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 046/135] netfilter: ipset: Fix nla_policies to fully support NL_VALIDATE_STRICT
Date:   Tue,  3 Dec 2019 23:34:46 +0100
Message-Id: <20191203213018.708261928@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

[ Upstream commit 1289975643f4cdecb071dc641059a47679fd170f ]

Since v5.2 (commit "netlink: re-add parse/validate functions in strict
mode") NL_VALIDATE_STRICT is enabled. Fix the ipset nla_policies which did
not support strict mode and convert from deprecated parsings to verified ones.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c        | 41 ++++++++++++++++--------
 net/netfilter/ipset/ip_set_hash_net.c    |  1 +
 net/netfilter/ipset/ip_set_hash_netnet.c |  1 +
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e7288eab75126..d73d1828216a6 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -296,7 +296,8 @@ ip_set_get_ipaddr4(struct nlattr *nla,  __be32 *ipaddr)
 
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
-	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_IPADDR_MAX, nla, ipaddr_policy, NULL))
+	if (nla_parse_nested(tb, IPSET_ATTR_IPADDR_MAX, nla,
+			     ipaddr_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_IPADDR_IPV4)))
 		return -IPSET_ERR_PROTOCOL;
@@ -314,7 +315,8 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_IPADDR_MAX, nla, ipaddr_policy, NULL))
+	if (nla_parse_nested(tb, IPSET_ATTR_IPADDR_MAX, nla,
+			     ipaddr_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_IPADDR_IPV6)))
 		return -IPSET_ERR_PROTOCOL;
@@ -934,7 +936,8 @@ static int ip_set_create(struct net *net, struct sock *ctnl,
 
 	/* Without holding any locks, create private part. */
 	if (attr[IPSET_ATTR_DATA] &&
-	    nla_parse_nested_deprecated(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_ATTR_DATA], set->type->create_policy, NULL)) {
+	    nla_parse_nested(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_ATTR_DATA],
+			     set->type->create_policy, NULL)) {
 		ret = -IPSET_ERR_PROTOCOL;
 		goto put_out;
 	}
@@ -1281,6 +1284,14 @@ dump_attrs(struct nlmsghdr *nlh)
 	}
 }
 
+static const struct nla_policy
+ip_set_dump_policy[IPSET_ATTR_CMD_MAX + 1] = {
+	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
+	[IPSET_ATTR_SETNAME]	= { .type = NLA_NUL_STRING,
+				    .len = IPSET_MAXNAMELEN - 1 },
+	[IPSET_ATTR_FLAGS]	= { .type = NLA_U32 },
+};
+
 static int
 dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 {
@@ -1292,9 +1303,9 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 	ip_set_id_t index;
 	int ret;
 
-	ret = nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, attr,
-				   nlh->nlmsg_len - min_len,
-				   ip_set_setname_policy, NULL);
+	ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, attr,
+			nlh->nlmsg_len - min_len,
+			ip_set_dump_policy, NULL);
 	if (ret)
 		return ret;
 
@@ -1543,9 +1554,9 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
-		ret = nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
-					   nlh->nlmsg_len - min_len,
-					   ip_set_adt_policy, NULL);
+		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
+				nlh->nlmsg_len - min_len, ip_set_adt_policy,
+				NULL);
 
 		if (ret) {
 			nlmsg_free(skb2);
@@ -1596,7 +1607,9 @@ static int ip_set_ad(struct net *net, struct sock *ctnl,
 
 	use_lineno = !!attr[IPSET_ATTR_LINENO];
 	if (attr[IPSET_ATTR_DATA]) {
-		if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA], set->type->adt_policy, NULL))
+		if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX,
+				     attr[IPSET_ATTR_DATA],
+				     set->type->adt_policy, NULL))
 			return -IPSET_ERR_PROTOCOL;
 		ret = call_ad(ctnl, skb, set, tb, adt, flags,
 			      use_lineno);
@@ -1606,7 +1619,8 @@ static int ip_set_ad(struct net *net, struct sock *ctnl,
 		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
 			if (nla_type(nla) != IPSET_ATTR_DATA ||
 			    !flag_nested(nla) ||
-			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->type->adt_policy, NULL))
+			    nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, nla,
+					     set->type->adt_policy, NULL))
 				return -IPSET_ERR_PROTOCOL;
 			ret = call_ad(ctnl, skb, set, tb, adt,
 				      flags, use_lineno);
@@ -1655,7 +1669,8 @@ static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	if (!set)
 		return -ENOENT;
 
-	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA], set->type->adt_policy, NULL))
+	if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA],
+			     set->type->adt_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 
 	rcu_read_lock_bh();
@@ -1961,7 +1976,7 @@ static const struct nfnl_callback ip_set_netlink_subsys_cb[IPSET_MSG_MAX] = {
 	[IPSET_CMD_LIST]	= {
 		.call		= ip_set_dump,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
-		.policy		= ip_set_setname_policy,
+		.policy		= ip_set_dump_policy,
 	},
 	[IPSET_CMD_SAVE]	= {
 		.call		= ip_set_dump,
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index c259cbc3ef453..3d932de0ad295 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -368,6 +368,7 @@ static struct ip_set_type hash_net_type __read_mostly = {
 		[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
+		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index a3ae69bfee668..4398322fad592 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -476,6 +476,7 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
 		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
 		[IPSET_ATTR_CIDR2]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
+		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-- 
2.20.1



