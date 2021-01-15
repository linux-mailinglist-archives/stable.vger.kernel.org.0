Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFFF2F7A53
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733160AbhAOMsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:48:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732641AbhAOMhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5239123888;
        Fri, 15 Jan 2021 12:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714195;
        bh=CFNkIsy/v5UzLoJ1N+T++ubaD1zBfkfllzFWbmFIplA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNZ4lvTYiRCYPVYKHOFVSWYEuFrzvsJ0DN5qCL1LNND4wma73qXwIIeuADJbGVFE5
         cULGGyLOqzxIuLed5/suaShzCsXPMHevueuvtP6tEF2E7q6HAS/JKZ9BXhgl7IUvpu
         QNLm4IKXRpWp1CgT3Kg8GOYRVh77p42sYbnpNlSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 026/103] tools: selftests: add test for changing routes with PTMU exceptions
Date:   Fri, 15 Jan 2021 13:27:19 +0100
Message-Id: <20210115122007.319547521@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>

[ Upstream commit 5316a7c0130acf09bfc8bb0092407006010fcccc ]

Adds new 2 new tests to the PTMU script: pmtu_ipv4/6_route_change.

These tests explicitly test for a recently discovered problem in the
IPv6 routing framework where PMTU exceptions were not properly released
when replacing a route via "ip route change ...".

After creating PMTU exceptions, the route from the device A to R1 will be
replaced with a new route, then device A will be deleted. If the PMTU
exceptions were properly cleaned up by the kernel, this device deletion
will succeed. Otherwise, the unregistration of the device will stall, and
messages such as the following will be logged in dmesg:

unregister_netdevice: waiting for veth_A-R1 to become free. Usage count = 4

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/1609892546-11389-2-git-send-email-stranche@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/pmtu.sh |   71 ++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -162,7 +162,15 @@
 # - list_flush_ipv6_exception
 #	Using the same topology as in pmtu_ipv6, create exceptions, and check
 #	they are shown when listing exception caches, gone after flushing them
-
+#
+# - pmtu_ipv4_route_change
+#	Use the same topology as in pmtu_ipv4, but issue a route replacement
+#	command and delete the corresponding device afterward. This tests for
+#	proper cleanup of the PMTU exceptions by the route replacement path.
+#	Device unregistration should complete successfully
+#
+# - pmtu_ipv6_route_change
+#	Same as above but with IPv6
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
@@ -224,7 +232,9 @@ tests="
 	cleanup_ipv4_exception		ipv4: cleanup of cached exceptions	1
 	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions	1
 	list_flush_ipv4_exception	ipv4: list and flush cached exceptions	1
-	list_flush_ipv6_exception	ipv6: list and flush cached exceptions	1"
+	list_flush_ipv6_exception	ipv6: list and flush cached exceptions	1
+	pmtu_ipv4_route_change		ipv4: PMTU exception w/route replace	1
+	pmtu_ipv6_route_change		ipv6: PMTU exception w/route replace	1"
 
 NS_A="ns-A"
 NS_B="ns-B"
@@ -1770,6 +1780,63 @@ test_list_flush_ipv6_exception() {
 	return ${fail}
 }
 
+test_pmtu_ipvX_route_change() {
+	family=${1}
+
+	setup namespaces routing || return 2
+	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
+	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
+	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
+	      "${ns_r2}" veth_R2-B    "${ns_b}"  veth_B-R2
+
+	if [ ${family} -eq 4 ]; then
+		ping=ping
+		dst1="${prefix4}.${b_r1}.1"
+		dst2="${prefix4}.${b_r2}.1"
+		gw="${prefix4}.${a_r1}.2"
+	else
+		ping=${ping6}
+		dst1="${prefix6}:${b_r1}::1"
+		dst2="${prefix6}:${b_r2}::1"
+		gw="${prefix6}:${a_r1}::2"
+	fi
+
+	# Set up initial MTU values
+	mtu "${ns_a}"  veth_A-R1 2000
+	mtu "${ns_r1}" veth_R1-A 2000
+	mtu "${ns_r1}" veth_R1-B 1400
+	mtu "${ns_b}"  veth_B-R1 1400
+
+	mtu "${ns_a}"  veth_A-R2 2000
+	mtu "${ns_r2}" veth_R2-A 2000
+	mtu "${ns_r2}" veth_R2-B 1500
+	mtu "${ns_b}"  veth_B-R2 1500
+
+	# Create route exceptions
+	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -w 1 -s 1800 ${dst1}
+	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -w 1 -s 1800 ${dst2}
+
+	# Check that exceptions have been created with the correct PMTU
+	pmtu_1="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst1})"
+	check_pmtu_value "1400" "${pmtu_1}" "exceeding MTU" || return 1
+	pmtu_2="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst2})"
+	check_pmtu_value "1500" "${pmtu_2}" "exceeding MTU" || return 1
+
+	# Replace the route from A to R1
+	run_cmd ${ns_a} ip route change default via ${gw}
+
+	# Delete the device in A
+	run_cmd ${ns_a} ip link del "veth_A-R1"
+}
+
+test_pmtu_ipv4_route_change() {
+	test_pmtu_ipvX_route_change 4
+}
+
+test_pmtu_ipv6_route_change() {
+	test_pmtu_ipvX_route_change 6
+}
+
 usage() {
 	echo
 	echo "$0 [OPTIONS] [TEST]..."


