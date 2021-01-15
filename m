Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7ABF2F7B2B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733061AbhAOMdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbhAOMdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B3823370;
        Fri, 15 Jan 2021 12:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713971;
        bh=NjIcjsNUDRZit9ds32hhnoD0fdbR8WXH7Dg2O1I7FH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ze/g+niQX20lQ6j8Cx3Cv791XPrCT2Og3T2nJsxZjEZkfSMpSyI4FThY8bOx+5578
         sXoMFZb1h7zHM8Lv3rYYWjJnTaebL1NeEHX0fjatItVAtvbDQJp8VUl9OtwBENdjly
         /QejUfzeTH0v9izKuNOnZbRmqOlxzx6+iPpkt6ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 09/43] net: ipv6: fib: flush exceptions when purging route
Date:   Fri, 15 Jan 2021 13:27:39 +0100
Message-Id: <20210115121957.491877723@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
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
@@ -906,6 +906,8 @@ static void fib6_purge_rt(struct fib6_in
 {
 	struct fib6_table *table = rt->fib6_table;
 
+	/* Flush all cached dst in exception table */
+	rt6_flush_exceptions(rt);
 	if (rt->rt6i_pcpu)
 		fib6_drop_pcpu_from(rt, table);
 
@@ -1756,9 +1758,6 @@ static void fib6_del_route(struct fib6_t
 	net->ipv6.rt6_stats->fib_rt_entries--;
 	net->ipv6.rt6_stats->fib_discarded_routes++;
 
-	/* Flush all cached dst in exception table */
-	rt6_flush_exceptions(rt);
-
 	/* Reset round-robin state, if necessary */
 	if (rcu_access_pointer(fn->rr_ptr) == rt)
 		fn->rr_ptr = NULL;


