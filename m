Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A141BC7F3
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgD1S2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729139AbgD1S2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74C0920730;
        Tue, 28 Apr 2020 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098487;
        bh=bfMmx3fYjly39Pex01XfPoaA0tBtUA1c8xYcYUBstT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUNZqvPU3nrcrPTuqX+eo7byfNGjOSbIHqWBWL3ByuevYjLDXsM9fm0XXN0muHjNA
         C1gA7xJ884Jn+L4VPFWLOq4OHq/Tee49t5IodbSxtJlSzAi/E1KTfky3zm7c4zrdTb
         lk5bR4hSEhgLtasPc3VsFgoNkREWyhJSlxoZ+db4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 059/167] selftests: Fix suppress test in fib_tests.sh
Date:   Tue, 28 Apr 2020 20:23:55 +0200
Message-Id: <20200428182232.435862777@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 2c1dd4c110627c2a4f006643f074119205cfcff4 ]

fib_tests is spewing errors:
    ...
    Cannot open network namespace "ns1": No such file or directory
    Cannot open network namespace "ns1": No such file or directory
    Cannot open network namespace "ns1": No such file or directory
    Cannot open network namespace "ns1": No such file or directory
    ping: connect: Network is unreachable
    Cannot open network namespace "ns1": No such file or directory
    Cannot open network namespace "ns1": No such file or directory
    ...

Each test entry in fib_tests is supposed to do its own setup and
cleanup. Right now the $IP commands in fib_suppress_test are
failing because there is no ns1. Add the setup/cleanup and logging
expected for each test.

Fixes: ca7a03c41753 ("ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fib_tests.sh |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -618,16 +618,22 @@ fib_nexthop_test()
 
 fib_suppress_test()
 {
+	echo
+	echo "FIB rule with suppress_prefixlength"
+	setup
+
 	$IP link add dummy1 type dummy
 	$IP link set dummy1 up
 	$IP -6 route add default dev dummy1
 	$IP -6 rule add table main suppress_prefixlength 0
-	ping -f -c 1000 -W 1 1234::1 || true
+	ping -f -c 1000 -W 1 1234::1 >/dev/null 2>&1
 	$IP -6 rule del table main suppress_prefixlength 0
 	$IP link del dummy1
 
 	# If we got here without crashing, we're good.
-	return 0
+	log_test 0 0 "FIB rule suppress test"
+
+	cleanup
 }
 
 ################################################################################


