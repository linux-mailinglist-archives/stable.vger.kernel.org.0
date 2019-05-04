Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF0713932
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfEDKav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbfEDKZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:25:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E0C420862;
        Sat,  4 May 2019 10:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965545;
        bh=bdyM8oxbQkd8wXQ6tcNLjvAslpgVHezybpZhC3gVPT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEFZD8xpIx02Hqo7NPIKl5bCre2X9oWRZeAbGoBa9DrbmVFkA0AseAlsAPhmXVM3/
         CiP5i745U2Mif7OgvCsEIo/6L3SllEzCA4C31C+9MpFy0iJZrQZoJKtoEqGBxzatPj
         XcCqEYtloUBcYZG19Wdc4uTeQJXmB5HzFViyHU/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 13/32] selftests: fib_rule_tests: print the result and return 1 if any tests failed
Date:   Sat,  4 May 2019 12:24:58 +0200
Message-Id: <20190504102452.937110928@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
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


