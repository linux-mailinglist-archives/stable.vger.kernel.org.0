Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3382DCA849
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbfJCQYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388447AbfJCQYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:24:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F5720867;
        Thu,  3 Oct 2019 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119874;
        bh=2QH/EUfS4lQgR+I/4gaccFGz2O8T7l5naiON+mxXKuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAzxO0u+36i0QHU/VIIwiY7fc+zhbPXJuQDHk+sTBEVyPCgsGcC6RWg4meR6iRRAP
         I/85wmgNVOIdNOYcFnSHefQ78H3VihuAHhRY4jQO53DIsU7+ue1o8km9zTl4GQCbTS
         /YOSKzNL9OjmlKLDdNqLi8qeXkEJvOTpVOc0OUnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.2 014/313] selftests: Update fib_tests to handle missing ping6
Date:   Thu,  3 Oct 2019 17:49:52 +0200
Message-Id: <20191003154534.825243660@linuxfoundation.org>
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

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 0360894a05ed52be268e3c4d40b2df9d94975fa6 ]

Some distributions (e.g., debian buster) do not install ping6. Re-use
the hook in pmtu.sh to detect this and fallback to ping.

Fixes: a0e11da78f48 ("fib_tests: Add tests for metrics on routes")
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fib_tests.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -16,6 +16,8 @@ PAUSE_ON_FAIL=no
 PAUSE=no
 IP="ip -netns ns1"
 
+which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
+
 log_test()
 {
 	local rc=$1
@@ -1068,7 +1070,7 @@ ipv6_route_metrics_test()
 	log_test $rc 0 "Multipath route with mtu metric"
 
 	$IP -6 ro add 2001:db8:104::/64 via 2001:db8:101::2 mtu 1300
-	run_cmd "ip netns exec ns1 ping6 -w1 -c1 -s 1500 2001:db8:104::1"
+	run_cmd "ip netns exec ns1 ${ping6} -w1 -c1 -s 1500 2001:db8:104::1"
 	log_test $? 0 "Using route with mtu metric"
 
 	run_cmd "$IP -6 ro add 2001:db8:114::/64 via  2001:db8:101::2  congctl lock foo"


