Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFF61EACE3
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbgFASlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731285AbgFASMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C592065C;
        Mon,  1 Jun 2020 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035172;
        bh=pw2Wug4AHtwV4Ddu6HDpLZC76ZaYgk6hgsBtBlctMtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8bwzsSIU3FryfDvdoF7pyKJxSwDTOg8fhQ6xprmVbKiTzoGzMtCxtnAOXUuiXXSa
         URLg4k0885t09aFshVCKkuehFLlApSHKK2Z5uB45XJb8RiJx3tsxoro63jokvE54cU
         umir7cTlwofBA3yiXgKRYXvj3kN4EkJe8QFRN/QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 005/177] net: dont return invalid table id error when we fall back to PF_UNSPEC
Date:   Mon,  1 Jun 2020 19:52:23 +0200
Message-Id: <20200601174049.008480943@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 41b4bd986f86331efc599b9a3f5fb86ad92e9af9 ]

In case we can't find a ->dumpit callback for the requested
(family,type) pair, we fall back to (PF_UNSPEC,type). In effect, we're
in the same situation as if userspace had requested a PF_UNSPEC
dump. For RTM_GETROUTE, that handler is rtnl_dump_all, which calls all
the registered RTM_GETROUTE handlers.

The requested table id may or may not exist for all of those
families. commit ae677bbb4441 ("net: Don't return invalid table id
error when dumping all families") fixed the problem when userspace
explicitly requests a PF_UNSPEC dump, but missed the fallback case.

For example, when we pass ipv6.disable=1 to a kernel with
CONFIG_IP_MROUTE=y and CONFIG_IP_MROUTE_MULTIPLE_TABLES=y,
the (PF_INET6, RTM_GETROUTE) handler isn't registered, so we end up in
rtnl_dump_all, and listing IPv6 routes will unexpectedly print:

  # ip -6 r
  Error: ipv4: MR table does not exist.
  Dump terminated

commit ae677bbb4441 introduced the dump_all_families variable, which
gets set when userspace requests a PF_UNSPEC dump. However, we can't
simply set the family to PF_UNSPEC in rtnetlink_rcv_msg in the
fallback case to get dump_all_families == true, because some messages
types (for example RTM_GETRULE and RTM_GETNEIGH) only register the
PF_UNSPEC handler and use the family to filter in the kernel what is
dumped to userspace. We would then export more entries, that userspace
would have to filter. iproute does that, but other programs may not.

Instead, this patch removes dump_all_families and updates the
RTM_GETROUTE handlers to check if the family that is being dumped is
their own. When it's not, which covers both the intentional PF_UNSPEC
dumps (as dump_all_families did) and the fallback case, ignore the
missing table id error.

Fixes: cb167893f41e ("net: Plumb support for filtering ipv4 and ipv6 multicast route dumps")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_fib.h    |    1 -
 net/ipv4/fib_frontend.c |    3 +--
 net/ipv4/ipmr.c         |    2 +-
 net/ipv6/ip6_fib.c      |    2 +-
 net/ipv6/ip6mr.c        |    2 +-
 5 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -257,7 +257,6 @@ struct fib_dump_filter {
 	u32			table_id;
 	/* filter_set is an optimization that an entry is set */
 	bool			filter_set;
-	bool			dump_all_families;
 	bool			dump_routes;
 	bool			dump_exceptions;
 	unsigned char		protocol;
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -918,7 +918,6 @@ int ip_valid_fib_dump_req(struct net *ne
 	else
 		filter->dump_exceptions = false;
 
-	filter->dump_all_families = (rtm->rtm_family == AF_UNSPEC);
 	filter->flags    = rtm->rtm_flags;
 	filter->protocol = rtm->rtm_protocol;
 	filter->rt_type  = rtm->rtm_type;
@@ -990,7 +989,7 @@ static int inet_dump_fib(struct sk_buff
 	if (filter.table_id) {
 		tb = fib_get_table(net, filter.table_id);
 		if (!tb) {
-			if (filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != PF_INET)
 				return skb->len;
 
 			NL_SET_ERR_MSG(cb->extack, "ipv4: FIB table does not exist");
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2611,7 +2611,7 @@ static int ipmr_rtm_dumproute(struct sk_
 
 		mrt = ipmr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
-			if (filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IPMR)
 				return skb->len;
 
 			NL_SET_ERR_MSG(cb->extack, "ipv4: MR table does not exist");
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -664,7 +664,7 @@ static int inet6_dump_fib(struct sk_buff
 	if (arg.filter.table_id) {
 		tb = fib6_get_table(net, arg.filter.table_id);
 		if (!tb) {
-			if (arg.filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != PF_INET6)
 				goto out;
 
 			NL_SET_ERR_MSG_MOD(cb->extack, "FIB table does not exist");
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2501,7 +2501,7 @@ static int ip6mr_rtm_dumproute(struct sk
 
 		mrt = ip6mr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
-			if (filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IP6MR)
 				return skb->len;
 
 			NL_SET_ERR_MSG_MOD(cb->extack, "MR table does not exist");


