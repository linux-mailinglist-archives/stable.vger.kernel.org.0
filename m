Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6B1780FC
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387696AbgCCSAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387692AbgCCSAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:00:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B187F20870;
        Tue,  3 Mar 2020 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258399;
        bh=pljk31STGftjsikbQyVVPOMEA1lAzFCuTWZW/U/y4Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSN3Uwkc4eJDgYKlXl+lPnMDpgjmG6dyq8o+19JI3nKNYHW35krsp832okg/4K8Wz
         M61NGTcy5R0u/UGlY3wKM6lexh92vKG6No3vbCMke9EU0W4+pc7VjNY2ZFhkbNeV/r
         NLBPXdqJFDU46q2+7pdnjt2/gVr6BXwhbne2w9aA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 35/87] ipv6: Fix route replacement with dev-only route
Date:   Tue,  3 Mar 2020 18:43:26 +0100
Message-Id: <20200303174353.733624916@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Poirier <bpoirier@cumulusnetworks.com>

[ Upstream commit e404b8c7cfb31654c9024d497cec58a501501692 ]

After commit 27596472473a ("ipv6: fix ECMP route replacement") it is no
longer possible to replace an ECMP-able route by a non ECMP-able route.
For example,
	ip route add 2001:db8::1/128 via fe80::1 dev dummy0
	ip route replace 2001:db8::1/128 dev dummy0
does not work as expected.

Tweak the replacement logic so that point 3 in the log of the above commit
becomes:
3. If the new route is not ECMP-able, and no matching non-ECMP-able route
exists, replace matching ECMP-able route (if any) or add the new route.

We can now summarize the entire replace semantics to:
When doing a replace, prefer replacing a matching route of the same
"ECMP-able-ness" as the replace argument. If there is no such candidate,
fallback to the first route found.

Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c                       |    7 ++++---
 tools/testing/selftests/net/fib_tests.sh |    6 ++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -981,8 +981,7 @@ static int fib6_add_rt2node(struct fib6_
 					found++;
 					break;
 				}
-				if (rt_can_ecmp)
-					fallback_ins = fallback_ins ?: ins;
+				fallback_ins = fallback_ins ?: ins;
 				goto next_iter;
 			}
 
@@ -1025,7 +1024,9 @@ next_iter:
 	}
 
 	if (fallback_ins && !found) {
-		/* No ECMP-able route found, replace first non-ECMP one */
+		/* No matching route with same ecmp-able-ness found, replace
+		 * first matching route
+		 */
 		ins = fallback_ins;
 		iter = rcu_dereference_protected(*ins,
 				    lockdep_is_held(&rt->fib6_table->tb6_lock));
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -848,6 +848,12 @@ ipv6_rt_replace_mpath()
 	check_route6 "2001:db8:104::/64 via 2001:db8:101::3 dev veth1 metric 1024"
 	log_test $? 0 "Multipath with single path via multipath attribute"
 
+	# multipath with dev-only
+	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
+	run_cmd "$IP -6 ro replace 2001:db8:104::/64 dev veth1"
+	check_route6 "2001:db8:104::/64 dev veth1 metric 1024"
+	log_test $? 0 "Multipath with dev-only"
+
 	# route replace fails - invalid nexthop 1
 	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
 	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:111::3 nexthop via 2001:db8:103::3"


