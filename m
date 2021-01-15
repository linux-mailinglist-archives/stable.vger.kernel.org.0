Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8472F7A4F
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387890AbhAOMgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387877AbhAOMgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BE8823403;
        Fri, 15 Jan 2021 12:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714193;
        bh=Av6AZ5sqMNdznd5hwV5NiBEAkfFz3EQx3O3+DAJjfvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCwwUB9CdqKohqvFMAj38meaAdwztrf08VDQNUfumoF5MzkdKbdN51jFeuKJaMPGe
         0KjIzL3rqsGeh1a+G4TWfV6vR+RjfeivAm+EpdQeZOwfIrM9BxY3Rmtej7WS95XQMW
         1Vm0xmP5EMzcozxLqEH/CyPKGFdlIjODD+QDMuxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 025/103] net: ipv6: fib: flush exceptions when purging route
Date:   Fri, 15 Jan 2021 13:27:18 +0100
Message-Id: <20210115122007.269657489@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>

[ Upstream commit d8f5c29653c3f6995e8979be5623d263e92f6b86 ]

Route removal is handled by two code paths. The main removal path is via
fib6_del_route() which will handle purging any PMTU exceptions from the
cache, removing all per-cpu copies of the DST entry used by the route, and
releasing the fib6_info struct.

The second removal location is during fib6_add_rt2node() during a route
replacement operation. This path also calls fib6_purge_rt() to handle
cleaning up the per-cpu copies of the DST entries and releasing the
fib6_info associated with the older route, but it does not flush any PMTU
exceptions that the older route had. Since the older route is removed from
the tree during the replacement, we lose any way of accessing it again.

As these lingering DSTs and the fib6_info struct are holding references to
the underlying netdevice struct as well, unregistering that device from the
kernel can never complete.

Fixes: 2b760fcf5cfb3 ("ipv6: hook up exception table to store dst cache")
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/1609892546-11389-1-git-send-email-stranche@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1025,6 +1025,8 @@ static void fib6_purge_rt(struct fib6_in
 {
 	struct fib6_table *table = rt->fib6_table;
 
+	/* Flush all cached dst in exception table */
+	rt6_flush_exceptions(rt);
 	fib6_drop_pcpu_from(rt, table);
 
 	if (rt->nh && !list_empty(&rt->nh_list))
@@ -1927,9 +1929,6 @@ static void fib6_del_route(struct fib6_t
 	net->ipv6.rt6_stats->fib_rt_entries--;
 	net->ipv6.rt6_stats->fib_discarded_routes++;
 
-	/* Flush all cached dst in exception table */
-	rt6_flush_exceptions(rt);
-
 	/* Reset round-robin state, if necessary */
 	if (rcu_access_pointer(fn->rr_ptr) == rt)
 		fn->rr_ptr = NULL;


