Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAD5CA930
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392200AbfJCQip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392360AbfJCQio (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD5820830;
        Thu,  3 Oct 2019 16:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120723;
        bh=RZ0r+49xVQffCkzokeOCJEC2HowsVBwZlOcoarKVGkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJhMkA2yGseTAjByqYNMWfWfTllQTGSVjHRJyNy4ibgdWMJApsF02SW/nW86EOBDt
         H8y5H0KsJtaVdsrFURwNbhFw4tsa1r7uqxHKLE4qe0cI6LcX1DcWXLROD+5iAQxb3t
         yLnQeEXEoIXp2POBo0VITsPU0nSQW4pYYCgR+bUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.3 015/344] selftests: Update fib_tests to handle missing ping6
Date:   Thu,  3 Oct 2019 17:49:40 +0200
Message-Id: <20191003154541.593957517@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
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
@@ -17,6 +17,8 @@ PAUSE=no
 IP="ip -netns ns1"
 NS_EXEC="ip netns exec ns1"
 
+which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
+
 log_test()
 {
 	local rc=$1
@@ -1100,7 +1102,7 @@ ipv6_route_metrics_test()
 	log_test $rc 0 "Multipath route with mtu metric"
 
 	$IP -6 ro add 2001:db8:104::/64 via 2001:db8:101::2 mtu 1300
-	run_cmd "ip netns exec ns1 ping6 -w1 -c1 -s 1500 2001:db8:104::1"
+	run_cmd "ip netns exec ns1 ${ping6} -w1 -c1 -s 1500 2001:db8:104::1"
 	log_test $? 0 "Using route with mtu metric"
 
 	run_cmd "$IP -6 ro add 2001:db8:114::/64 via  2001:db8:101::2  congctl lock foo"


