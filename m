Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85A8F558A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388124AbfKHTDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729833AbfKHTDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:03:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F81215EA;
        Fri,  8 Nov 2019 19:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239784;
        bh=caerxxbWsm1Pp5Wd/RgLWcj1/JZ4KMfdap7er8g7ap0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1vFOhFJ0yqjhwMrUn94AGOpZ2cCOjWYWKOCrudUK+cGgdHYh27Z/V/Nt+k5LO6mw
         oPMwOLyBXpMk3QuK9WTH+fN71llP63UpFDeMGC+ysseZa/jjiJeMNhrU10DPC4s3m9
         BQyx8SWBI6c+1k7jf9ey5cEVrzI64X8rwBqvjBe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 60/79] selftests: fib_tests: add more tests for metric update
Date:   Fri,  8 Nov 2019 19:50:40 +0100
Message-Id: <20191108174820.075150796@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 37de3b354150450ba12275397155e68113e99901 ]

This patch adds two more tests to ipv4_addr_metric_test() to
explicitly cover the scenarios fixed by the previous patch.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fib_tests.sh |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1301,6 +1301,27 @@ ipv4_addr_metric_test()
 	fi
 	log_test $rc 0 "Prefix route with metric on link up"
 
+	# explicitly check for metric changes on edge scenarios
+	run_cmd "$IP addr flush dev dummy2"
+	run_cmd "$IP addr add dev dummy2 172.16.104.0/24 metric 259"
+	run_cmd "$IP addr change dev dummy2 172.16.104.0/24 metric 260"
+	rc=$?
+	if [ $rc -eq 0 ]; then
+		check_route "172.16.104.0/24 dev dummy2 proto kernel scope link src 172.16.104.0 metric 260"
+		rc=$?
+	fi
+	log_test $rc 0 "Modify metric of .0/24 address"
+
+	run_cmd "$IP addr flush dev dummy2"
+	run_cmd "$IP addr add dev dummy2 172.16.104.1/32 peer 172.16.104.2 metric 260"
+	run_cmd "$IP addr change dev dummy2 172.16.104.1/32 peer 172.16.104.2 metric 261"
+	rc=$?
+	if [ $rc -eq 0 ]; then
+		check_route "172.16.104.2 dev dummy2 proto kernel scope link src 172.16.104.1 metric 261"
+		rc=$?
+	fi
+	log_test $rc 0 "Modify metric of address with peer route"
+
 	$IP li del dummy1
 	$IP li del dummy2
 	cleanup


