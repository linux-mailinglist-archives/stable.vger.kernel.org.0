Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8682B469BF8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357735AbhLFPTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:19:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35952 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358426AbhLFPQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1066261310;
        Mon,  6 Dec 2021 15:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9008C341C2;
        Mon,  6 Dec 2021 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803588;
        bh=ZYaMDF2+hl1TIq9QXVtsLdiBoSPAj7KMFe0MRRfbsH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9/HKMzYprJ7L+OG/J4FcPthT5jF4w5AGEAYJwpoMh3h6fEpbx9IA1O3KQgVNAwgS
         5dGQiiDPKHl1phYxfSPbWcNdwuFkknQdIkJHLrh66c3TnZkdInBbd470HeClbOcQ3V
         bcfbjY/Ymtmi1ZJc3VfF7GjN9SRwYlz9z1yxJnI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 46/70] ipv4: convert fib_num_tclassid_users to atomic_t
Date:   Mon,  6 Dec 2021 15:56:50 +0100
Message-Id: <20211206145553.515740967@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
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
@@ -412,7 +412,7 @@ int fib_validate_source(struct sk_buff *
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
@@ -1588,7 +1588,7 @@ static int __net_init fib_net_init(struc
 	int error;
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
-	net->ipv4.fib_num_tclassid_users = 0;
+	atomic_set(&net->ipv4.fib_num_tclassid_users, 0);
 #endif
 	error = ip_fib_net_init(net);
 	if (error < 0)
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -258,7 +258,7 @@ static int fib4_rule_configure(struct fi
 	if (tb[FRA_FLOW]) {
 		rule4->tclassid = nla_get_u32(tb[FRA_FLOW]);
 		if (rule4->tclassid)
-			net->ipv4.fib_num_tclassid_users++;
+			atomic_inc(&net->ipv4.fib_num_tclassid_users);
 	}
 #endif
 
@@ -290,7 +290,7 @@ static int fib4_rule_delete(struct fib_r
 
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
@@ -624,7 +624,7 @@ int fib_nh_init(struct net *net, struct
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	nh->nh_tclassid = cfg->fc_flow;
 	if (nh->nh_tclassid)
-		net->ipv4.fib_num_tclassid_users++;
+		atomic_inc(&net->ipv4.fib_num_tclassid_users);
 #endif
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 	nh->fib_nh_weight = nh_weight;


