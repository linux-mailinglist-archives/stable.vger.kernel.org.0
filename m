Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47679B2118
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390059AbfIMNdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388969AbfIMNLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:32 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 727ED214AE;
        Fri, 13 Sep 2019 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380292;
        bh=cf4/Pn3VPpv71AShPSQTZtULPy31ou4jN9H2NFSvnO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgLkM3fECiasueB8zYMzM3hp0xHQeS3e/BAd7g6u9C+Jp7wckmHiIO0EOlEiIxv+W
         y/l2/78kWFXwJoPFqZqHnkmCJO20zjFVVTkwZWBqWvt+kmP67I/c+0rBpUltR00W+w
         TUJ9tN5dJPsUDxD4mOKBaM8c6pZdXcOqO4AFrKgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/190] selftests: fib_rule_tests: use pre-defined DEV_ADDR
Date:   Fri, 13 Sep 2019 14:04:33 +0100
Message-Id: <20190913130601.015815111@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 34632975cafdd07ce80e85c2eda4e9c16b5f2faa ]

DEV_ADDR is defined but not used. Use it in address setting.
Do the same with IPv6 for consistency.

Reported-by: David Ahern <dsahern@gmail.com>
Fixes: fc82d93e57e3 ("selftests: fib_rule_tests: fix local IPv4 address typo")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index 1ba069967fa2b..ba2d9fab28d0f 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -15,6 +15,7 @@ GW_IP6=2001:db8:1::2
 SRC_IP6=2001:db8:1::3
 
 DEV_ADDR=192.51.100.1
+DEV_ADDR6=2001:db8:1::1
 DEV=dummy0
 
 log_test()
@@ -55,8 +56,8 @@ setup()
 
 	$IP link add dummy0 type dummy
 	$IP link set dev dummy0 up
-	$IP address add 192.51.100.1/24 dev dummy0
-	$IP -6 address add 2001:db8:1::1/64 dev dummy0
+	$IP address add $DEV_ADDR/24 dev dummy0
+	$IP -6 address add $DEV_ADDR6/64 dev dummy0
 
 	set +e
 }
-- 
2.20.1



