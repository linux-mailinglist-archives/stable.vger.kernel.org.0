Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D39CA481
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbfJCQZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390494AbfJCQZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:25:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F020A215EA;
        Thu,  3 Oct 2019 16:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119920;
        bh=3Ns8z5rPL19etrEXv+UVIEZ1HUYcfTPW144ZHogKkn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndSzGgPKTyea8GE1tDyU1TEhV35Og5aLIK/wWXJ+LJKNGUDkz85Q8+4lGp9rcY4Tp
         rQQ67FnP625PueVzb/xfuc94KF1xklmrMigunm+3VAtIywsCd7dbmK70aTt6s48Q6U
         kyW7r3e0NEeQNtrVv6u3YQNV/43ewA8gY9MIkjD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 003/313] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule
Date:   Thu,  3 Oct 2019 17:49:41 +0200
Message-Id: <20191003154533.875309419@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit ca7a03c4175366a92cee0ccc4fec0038c3266e26 ]

Commit 7d9e5f422150 removed references from certain dsts, but accounting
for this never translated down into the fib6 suppression code. This bug
was triggered by WireGuard users who use wg-quick(8), which uses the
"suppress-prefix" directive to ip-rule(8) for routing all of their
internet traffic without routing loops. The test case added here
causes the reference underflow by causing packets to evaluate a suppress
rule.

Fixes: 7d9e5f422150 ("ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/fib6_rules.c                    |    3 ++-
 tools/testing/selftests/net/fib_tests.sh |   17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -285,7 +285,8 @@ static bool fib6_rule_suppress(struct fi
 	return false;
 
 suppress_route:
-	ip6_rt_put(rt);
+	if (!(arg->flags & FIB_LOOKUP_NOREF))
+		ip6_rt_put(rt);
 	return true;
 }
 
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -9,7 +9,7 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-TESTS="unregister down carrier nexthop ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw"
+TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw"
 
 VERBOSE=0
 PAUSE_ON_FAIL=no
@@ -582,6 +582,20 @@ fib_nexthop_test()
 	cleanup
 }
 
+fib_suppress_test()
+{
+	$IP link add dummy1 type dummy
+	$IP link set dummy1 up
+	$IP -6 route add default dev dummy1
+	$IP -6 rule add table main suppress_prefixlength 0
+	ping -f -c 1000 -W 1 1234::1 || true
+	$IP -6 rule del table main suppress_prefixlength 0
+	$IP link del dummy1
+
+	# If we got here without crashing, we're good.
+	return 0
+}
+
 ################################################################################
 # Tests on route add and replace
 
@@ -1558,6 +1572,7 @@ do
 	fib_down_test|down)		fib_down_test;;
 	fib_carrier_test|carrier)	fib_carrier_test;;
 	fib_nexthop_test|nexthop)	fib_nexthop_test;;
+	fib_suppress_test|suppress)	fib_suppress_test;;
 	ipv6_route_test|ipv6_rt)	ipv6_route_test;;
 	ipv4_route_test|ipv4_rt)	ipv4_route_test;;
 	ipv6_addr_metric)		ipv6_addr_metric_test;;


