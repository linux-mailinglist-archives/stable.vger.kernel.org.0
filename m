Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50543138DA
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfEDK1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbfEDK1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D88320859;
        Sat,  4 May 2019 10:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965632;
        bh=bdyM8oxbQkd8wXQ6tcNLjvAslpgVHezybpZhC3gVPT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqvAhDgH/H2TM0SN8sFF2lZ6zLbBc8eCzTD6jZwdrPCakwun7I3rEBRyFgD1GOFm1
         BaA6ndOmr4IBPnDRi0lPPCrHmIvnefPKF+ABAu/z/9Oi4aIQyQmZJRxsOOebBF2S+G
         p87m7AsgorbX12A5ynxyvvjBfiPpDGh5l3gaaIb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 13/23] selftests: fib_rule_tests: print the result and return 1 if any tests failed
Date:   Sat,  4 May 2019 12:25:15 +0200
Message-Id: <20190504102451.973046799@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit f68d7c44e76532e46f292ad941aa3706cb9e6e40 ]

Fixes: 65b2b4939a64 ("selftests: net: initial fib rule tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fib_rule_tests.sh |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -27,6 +27,7 @@ log_test()
 		nsuccess=$((nsuccess+1))
 		printf "\n    TEST: %-50s  [ OK ]\n" "${msg}"
 	else
+		ret=1
 		nfail=$((nfail+1))
 		printf "\n    TEST: %-50s  [FAIL]\n" "${msg}"
 		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
@@ -245,4 +246,9 @@ setup
 run_fibrule_tests
 cleanup
 
+if [ "$TESTS" != "none" ]; then
+	printf "\nTests passed: %3d\n" ${nsuccess}
+	printf "Tests failed: %3d\n"   ${nfail}
+fi
+
 exit $ret


