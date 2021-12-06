Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895FE469DE9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377049AbhLFPeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387173AbhLFPat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:30:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A26C0698E5;
        Mon,  6 Dec 2021 07:18:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E770161322;
        Mon,  6 Dec 2021 15:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6A0C341C1;
        Mon,  6 Dec 2021 15:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803911;
        bh=P8T9G6uehFe2A8S3SaDZ33FIidEeWMHmQDD9C6ITSUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAclEnPH5woIDVYLrA/HSj0nGeXRfQg+EYdpAxkOv0c5YdLTeNFWdSK/IXmY05ARR
         kdejr3l6l13sCbny1wsY7Fo7DsFL3GSey8LTfaP3mT0P5llVXGgDcfIo42mNmIhOHb
         aEMB/lFm6zGKdNVo83Zl+TjdNdFwkGJg9snyleic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 090/130] ipv4: convert fib_num_tclassid_users to atomic_t
Date:   Mon,  6 Dec 2021 15:56:47 +0100
Message-Id: <20211206145602.762865707@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 213f5f8f31f10aa1e83187ae20fb7fa4e626b724 upstream.

Before commit faa041a40b9f ("ipv4: Create cleanup helper for fib_nh")
changes to net->ipv4.fib_num_tclassid_users were protected by RTNL.

After the change, this is no longer the case, as free_fib_info_rcu()
runs after rcu grace period, without rtnl being held.

Fixes: faa041a40b9f ("ipv4: Create cleanup helper for fib_nh")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_fib.h     |    2 +-
 include/net/netns/ipv4.h |    2 +-
 net/ipv4/fib_frontend.c  |    2 +-
 net/ipv4/fib_rules.c     |    4 ++--
 net/ipv4/fib_semantics.c |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -437,7 +437,7 @@ int fib_validate_source(struct sk_buff *
 #ifdef CONFIG_IP_ROUTE_CLASSID
 static inline int fib_num_tclassid_users(struct net *net)
 {
-	return net->ipv4.fib_num_tclassid_users;
+	return atomic_read(&net->ipv4.fib_num_tclassid_users);
 }
 #else
 static inline int fib_num_tclassid_users(struct net *net)
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -61,7 +61,7 @@ struct netns_ipv4 {
 #endif
 	bool			fib_has_custom_local_routes;
 #ifdef CONFIG_IP_ROUTE_CLASSID
-	int			fib_num_tclassid_users;
+	atomic_t		fib_num_tclassid_users;
 #endif
 	struct hlist_head	*fib_table_hash;
 	bool			fib_offload_disabled;
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1578,7 +1578,7 @@ static int __net_init fib_net_init(struc
 	int error;
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
-	net->ipv4.fib_num_tclassid_users = 0;
+	atomic_set(&net->ipv4.fib_num_tclassid_users, 0);
 #endif
 	error = ip_fib_net_init(net);
 	if (error < 0)
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -264,7 +264,7 @@ static int fib4_rule_configure(struct fi
 	if (tb[FRA_FLOW]) {
 		rule4->tclassid = nla_get_u32(tb[FRA_FLOW]);
 		if (rule4->tclassid)
-			net->ipv4.fib_num_tclassid_users++;
+			atomic_inc(&net->ipv4.fib_num_tclassid_users);
 	}
 #endif
 
@@ -296,7 +296,7 @@ static int fib4_rule_delete(struct fib_r
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	if (((struct fib4_rule *)rule)->tclassid)
-		net->ipv4.fib_num_tclassid_users--;
+		atomic_dec(&net->ipv4.fib_num_tclassid_users);
 #endif
 	net->ipv4.fib_has_custom_rules = true;
 
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -222,7 +222,7 @@ void fib_nh_release(struct net *net, str
 {
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	if (fib_nh->nh_tclassid)
-		net->ipv4.fib_num_tclassid_users--;
+		atomic_dec(&net->ipv4.fib_num_tclassid_users);
 #endif
 	fib_nh_common_release(&fib_nh->nh_common);
 }
@@ -633,7 +633,7 @@ int fib_nh_init(struct net *net, struct
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	nh->nh_tclassid = cfg->fc_flow;
 	if (nh->nh_tclassid)
-		net->ipv4.fib_num_tclassid_users++;
+		atomic_inc(&net->ipv4.fib_num_tclassid_users);
 #endif
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 	nh->fib_nh_weight = nh_weight;


