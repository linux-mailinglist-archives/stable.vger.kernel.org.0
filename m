Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAB1226884
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgGTQFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729592AbgGTQFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:05:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B65F82065E;
        Mon, 20 Jul 2020 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261151;
        bh=t1as8jjmM9/CjP432IFcq9zmVDBLor6vyibQW3FZRo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc29GCTLkZ8dbzeBqrNJzLUEKA9u6GxZXaFc7k0klgsUagYuHsFjtO658B9eX2lGI
         OlwN1s5ibsw5aHT7FChBNCdxAF5hKTbkMIZoaJ32eaVOFdyl4qxanDi5Eh1RfhY8Vq
         0jNoeuiITxIPH0XJdlOx98l4jR+96ENidv+NN/qM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Rak <brak@choopa.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 004/244] ipv6: fib6_select_path can not use out path for nexthop objects
Date:   Mon, 20 Jul 2020 17:34:35 +0200
Message-Id: <20200720152826.077223321@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
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


