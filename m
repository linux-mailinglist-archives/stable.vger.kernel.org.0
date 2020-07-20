Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD21226A2B
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbgGTP5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731859AbgGTP5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:57:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B61A2065E;
        Mon, 20 Jul 2020 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260624;
        bh=t1as8jjmM9/CjP432IFcq9zmVDBLor6vyibQW3FZRo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMDpjTg1ct3y8ijodaD0kkkOXDGRx/P/6YZJi2lNrONX1PBfEngF7+07zdGsH8N7o
         oh73N4OVEvQNWNBdy85P69gJNf6fY+PYz6hB5HxtwUbv/cewXr1O383pShRK58es2h
         skDo5Cj4DEDdvVcnvI27v2uwGGHuu+OVttFGG4+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Rak <brak@choopa.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 008/215] ipv6: fib6_select_path can not use out path for nexthop objects
Date:   Mon, 20 Jul 2020 17:34:50 +0200
Message-Id: <20200720152820.552884553@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 34fe5a1cf95c3f114068fc16d919c9cf4b00e428 ]

Brian reported a crash in IPv6 code when using rpfilter with a setup
running FRR and external nexthop objects. The root cause of the crash
is fib6_select_path setting fib6_nh in the result to NULL because of
an improper check for nexthop objects.

More specifically, rpfilter invokes ip6_route_lookup with flowi6_oif
set causing fib6_select_path to be called with have_oif_match set.
fib6_select_path has early check on have_oif_match and jumps to the
out label which presumes a builtin fib6_nh. This path is invalid for
nexthop objects; for external nexthops fib6_select_path needs to just
return if the fib6_nh has already been set in the result otherwise it
returns after the call to nexthop_path_fib6_result. Update the check
on have_oif_match to not bail on external nexthops.

Update selftests for this problem.

Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
Reported-by: Brian Rak <brak@choopa.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c                            |    5 ++++-
 tools/testing/selftests/net/fib_nexthops.sh |   13 +++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -431,9 +431,12 @@ void fib6_select_path(const struct net *
 	struct fib6_info *sibling, *next_sibling;
 	struct fib6_info *match = res->f6i;
 
-	if ((!match->fib6_nsiblings && !match->nh) || have_oif_match)
+	if (!match->nh && (!match->fib6_nsiblings || have_oif_match))
 		goto out;
 
+	if (match->nh && have_oif_match && res->nh)
+		return;
+
 	/* We might have already computed the hash for ICMPv6 errors. In such
 	 * case it will always be non-zero. Otherwise now is the time to do it.
 	 */
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -512,6 +512,19 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP nexthop add id 86 via 2001:db8:91::2 dev veth1"
 	run_cmd "$IP ro add 2001:db8:101::1/128 nhid 81"
 
+	# rpfilter and default route
+	$IP nexthop flush >/dev/null 2>&1
+	run_cmd "ip netns exec me ip6tables -t mangle -I PREROUTING 1 -m rpfilter --invert -j DROP"
+	run_cmd "$IP nexthop add id 91 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 92 via 2001:db8:92::2 dev veth3"
+	run_cmd "$IP nexthop add id 93 group 91/92"
+	run_cmd "$IP -6 ro add default nhid 91"
+	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	log_test $? 0 "Nexthop with default route and rpfilter"
+	run_cmd "$IP -6 ro replace default nhid 93"
+	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	log_test $? 0 "Nexthop with multipath default route and rpfilter"
+
 	# TO-DO:
 	# existing route with old nexthop; append route with new nexthop
 	# existing route with old nexthop; replace route with new


