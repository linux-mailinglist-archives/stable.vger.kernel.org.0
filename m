Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1006ECA607
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404794AbfJCQjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404700AbfJCQjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:39:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A370B20830;
        Thu,  3 Oct 2019 16:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120748;
        bh=1b0mp+G7Vz0aBxcLs6/5p2l/G0/P9kTbNCvwoB5x1ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsmAfqo05PCTVtE+6L4qpFmI+Suf3hxcb89KlNLLS+kRxl/gOWSpHN/a6xNFXPtkW
         vExdSZUKJ1AMmGge0Eq7rw/ueUpZhoQ5VakSOPktS378cpNgVB4Y2gU35cAL5U5oNW
         4jWXCp8zRoR8ihjdy8bcpJgDc9wwkT9Elc3Q/vkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.3 023/344] selftests: Update fib_nexthop_multiprefix to handle missing ping6
Date:   Thu,  3 Oct 2019 17:49:48 +0200
Message-Id: <20191003154542.365911270@linuxfoundation.org>
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

[ Upstream commit e84622ce24482f6e9c1bf29d3bdd556eb587ff41 ]

Some distributions (e.g., debian buster) do not install ping6. Re-use
the hook in pmtu.sh to detect this and fallback to ping.

Fixes: 735ab2f65dce ("selftests: Add test with multiple prefixes using single nexthop")
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fib_nexthop_multiprefix.sh |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
+++ b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
@@ -15,6 +15,8 @@
 PAUSE_ON_FAIL=no
 VERBOSE=0
 
+which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
+
 ################################################################################
 # helpers
 
@@ -200,7 +202,7 @@ validate_v6_exception()
 	local rc
 
 	if [ ${ping_sz} != "0" ]; then
-		run_cmd ip netns exec h0 ping6 -s ${ping_sz} -c5 -w5 ${dst}
+		run_cmd ip netns exec h0 ${ping6} -s ${ping_sz} -c5 -w5 ${dst}
 	fi
 
 	if [ "$VERBOSE" = "1" ]; then
@@ -243,7 +245,7 @@ do
 		run_cmd taskset -c ${c} ip netns exec h0 ping -c1 -w1 172.16.10${i}.1
 		[ $? -ne 0 ] && printf "\nERROR: ping to h${i} failed\n" && ret=1
 
-		run_cmd taskset -c ${c} ip netns exec h0 ping6 -c1 -w1 2001:db8:10${i}::1
+		run_cmd taskset -c ${c} ip netns exec h0 ${ping6} -c1 -w1 2001:db8:10${i}::1
 		[ $? -ne 0 ] && printf "\nERROR: ping6 to h${i} failed\n" && ret=1
 
 		[ $ret -ne 0 ] && break


