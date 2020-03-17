Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C2D188063
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgCQLJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgCQLJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:09:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E39D206EC;
        Tue, 17 Mar 2020 11:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443383;
        bh=Ggz1sRhTzQZoTuPck6ZrQkVJyEgMExwVHKHueR0GWSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKL+tDGYXjb3rGE5S1B1Pr+AoZ22oJudxUIaSCLkVkirHSn2FD6TNAXt0jNztNBWm
         /tvP1Zu3CxfrWCZG1F1+JNjbjSuJ3hJdHZuxaKMAn7OJy02m91GR79LzZV/fc8zIUJ
         sw3lCZe/7/MNVCDccoRYfre3X5PJkVMnbCCnsOB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 066/151] selftests/net/fib_tests: update addr_metric_test for peer route testing
Date:   Tue, 17 Mar 2020 11:54:36 +0100
Message-Id: <20200317103331.202257468@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 0d29169a708bf730ede287248e429d579f432d1d ]

This patch update {ipv4, ipv6}_addr_metric_test with
1. Set metric of address with peer route and see if the route added
correctly.
2. Modify metric and peer address for peer route and see if the route
changed correctly.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fib_tests.sh |   34 ++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1041,6 +1041,27 @@ ipv6_addr_metric_test()
 	fi
 	log_test $rc 0 "Prefix route with metric on link up"
 
+	# verify peer metric added correctly
+	set -e
+	run_cmd "$IP -6 addr flush dev dummy2"
+	run_cmd "$IP -6 addr add dev dummy2 2001:db8:104::1 peer 2001:db8:104::2 metric 260"
+	set +e
+
+	check_route6 "2001:db8:104::1 dev dummy2 proto kernel metric 260"
+	log_test $? 0 "Set metric with peer route on local side"
+	log_test $? 0 "User specified metric on local address"
+	check_route6 "2001:db8:104::2 dev dummy2 proto kernel metric 260"
+	log_test $? 0 "Set metric with peer route on peer side"
+
+	set -e
+	run_cmd "$IP -6 addr change dev dummy2 2001:db8:104::1 peer 2001:db8:104::3 metric 261"
+	set +e
+
+	check_route6 "2001:db8:104::1 dev dummy2 proto kernel metric 261"
+	log_test $? 0 "Modify metric and peer address on local side"
+	check_route6 "2001:db8:104::3 dev dummy2 proto kernel metric 261"
+	log_test $? 0 "Modify metric and peer address on peer side"
+
 	$IP li del dummy1
 	$IP li del dummy2
 	cleanup
@@ -1457,13 +1478,20 @@ ipv4_addr_metric_test()
 
 	run_cmd "$IP addr flush dev dummy2"
 	run_cmd "$IP addr add dev dummy2 172.16.104.1/32 peer 172.16.104.2 metric 260"
-	run_cmd "$IP addr change dev dummy2 172.16.104.1/32 peer 172.16.104.2 metric 261"
 	rc=$?
 	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.2 dev dummy2 proto kernel scope link src 172.16.104.1 metric 261"
+		check_route "172.16.104.2 dev dummy2 proto kernel scope link src 172.16.104.1 metric 260"
+		rc=$?
+	fi
+	log_test $rc 0 "Set metric of address with peer route"
+
+	run_cmd "$IP addr change dev dummy2 172.16.104.1/32 peer 172.16.104.3 metric 261"
+	rc=$?
+	if [ $rc -eq 0 ]; then
+		check_route "172.16.104.3 dev dummy2 proto kernel scope link src 172.16.104.1 metric 261"
 		rc=$?
 	fi
-	log_test $rc 0 "Modify metric of address with peer route"
+	log_test $rc 0 "Modify metric and peer address for peer route"
 
 	$IP li del dummy1
 	$IP li del dummy2


