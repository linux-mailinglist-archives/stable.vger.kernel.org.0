Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9602C0B63
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732950AbgKWNX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731406AbgKWMek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B7F2065E;
        Mon, 23 Nov 2020 12:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134878;
        bh=PNofzJqDA0dtMHEGKWWJ9dyTQzFrM7e/h705iNEd7P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+bw+caiK+AnuqCQwfDhz38mYdN1wr3DElJbraDUo3Wu4ofOHvRDhfogjAcjr6++n
         APuDr/Z9V7CdVLeNeSU8iNZzIYoOLdl1O+X1RZSzTLMH4wsELV67P+fyxffmQeD71B
         1C6r4uUf+6yGEEdd16cl0XwPopXvr4pbFdlOmKQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Dike <jdike@akamai.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 005/158] Exempt multicast addresses from five-second neighbor lifetime
Date:   Mon, 23 Nov 2020 13:20:33 +0100
Message-Id: <20201123121820.202813756@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Dike <jdike@akamai.com>

[ Upstream commit 8cf8821e15cd553339a5b48ee555a0439c2b2742 ]

Commit 58956317c8de ("neighbor: Improve garbage collection")
guarantees neighbour table entries a five-second lifetime.  Processes
which make heavy use of multicast can fill the neighour table with
multicast addresses in five seconds.  At that point, neighbour entries
can't be GC-ed because they aren't five seconds old yet, the kernel
log starts to fill up with "neighbor table overflow!" messages, and
sends start to fail.

This patch allows multicast addresses to be thrown out before they've
lived out their five seconds.  This makes room for non-multicast
addresses and makes messages to all addresses more reliable in these
circumstances.

Fixes: 58956317c8de ("neighbor: Improve garbage collection")
Signed-off-by: Jeff Dike <jdike@akamai.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20201113015815.31397-1-jdike@akamai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/neighbour.h |    1 +
 net/core/neighbour.c    |    2 ++
 net/ipv4/arp.c          |    6 ++++++
 net/ipv6/ndisc.c        |    7 +++++++
 4 files changed, 16 insertions(+)

--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -204,6 +204,7 @@ struct neigh_table {
 	int			(*pconstructor)(struct pneigh_entry *);
 	void			(*pdestructor)(struct pneigh_entry *);
 	void			(*proxy_redo)(struct sk_buff *skb);
+	int			(*is_multicast)(const void *pkey);
 	bool			(*allow_add)(const struct net_device *dev,
 					     struct netlink_ext_ack *extack);
 	char			*id;
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -235,6 +235,8 @@ static int neigh_forced_gc(struct neigh_
 
 			write_lock(&n->lock);
 			if ((n->nud_state == NUD_FAILED) ||
+			    (tbl->is_multicast &&
+			     tbl->is_multicast(n->primary_key)) ||
 			    time_after(tref, n->updated))
 				remove = true;
 			write_unlock(&n->lock);
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -125,6 +125,7 @@ static int arp_constructor(struct neighb
 static void arp_solicit(struct neighbour *neigh, struct sk_buff *skb);
 static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb);
 static void parp_redo(struct sk_buff *skb);
+static int arp_is_multicast(const void *pkey);
 
 static const struct neigh_ops arp_generic_ops = {
 	.family =		AF_INET,
@@ -156,6 +157,7 @@ struct neigh_table arp_tbl = {
 	.key_eq		= arp_key_eq,
 	.constructor	= arp_constructor,
 	.proxy_redo	= parp_redo,
+	.is_multicast	= arp_is_multicast,
 	.id		= "arp_cache",
 	.parms		= {
 		.tbl			= &arp_tbl,
@@ -928,6 +930,10 @@ static void parp_redo(struct sk_buff *sk
 	arp_process(dev_net(skb->dev), NULL, skb);
 }
 
+static int arp_is_multicast(const void *pkey)
+{
+	return ipv4_is_multicast(*((__be32 *)pkey));
+}
 
 /*
  *	Receive an arp request from the device layer.
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -81,6 +81,7 @@ static void ndisc_error_report(struct ne
 static int pndisc_constructor(struct pneigh_entry *n);
 static void pndisc_destructor(struct pneigh_entry *n);
 static void pndisc_redo(struct sk_buff *skb);
+static int ndisc_is_multicast(const void *pkey);
 
 static const struct neigh_ops ndisc_generic_ops = {
 	.family =		AF_INET6,
@@ -115,6 +116,7 @@ struct neigh_table nd_tbl = {
 	.pconstructor =	pndisc_constructor,
 	.pdestructor =	pndisc_destructor,
 	.proxy_redo =	pndisc_redo,
+	.is_multicast =	ndisc_is_multicast,
 	.allow_add  =   ndisc_allow_add,
 	.id =		"ndisc_cache",
 	.parms = {
@@ -1705,6 +1707,11 @@ static void pndisc_redo(struct sk_buff *
 	kfree_skb(skb);
 }
 
+static int ndisc_is_multicast(const void *pkey)
+{
+	return ipv6_addr_is_multicast((struct in6_addr *)pkey);
+}
+
 static bool ndisc_suppress_frag_ndisc(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);


