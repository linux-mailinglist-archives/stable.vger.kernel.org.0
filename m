Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E66B86A4D
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404426AbfHHTIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404831AbfHHTII (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0EAC21874;
        Thu,  8 Aug 2019 19:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291287;
        bh=TwtygEeANJyww3dG6WqFMUcjgTZm7wPoqtvFZc+v78M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jd6Ohm3fL2BsEE0E4SK0zDIyIrxuYPn4i0Cea316AULpAgROsgHcyhtoHkt9xS84L
         8bmIwuriz8Wm6TRqqUf/R5QA7vgNLOIpURRHkLEoqJLWaHoxLyrM1XpKsYUXHZGXCQ
         iDCXI+mfjq8gf/CGiaEnPLn48IstWiDWem4JihE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 42/56] bpf: fix XDP vlan selftests test_xdp_vlan.sh
Date:   Thu,  8 Aug 2019 21:05:08 +0200
Message-Id: <20190808190454.797303745@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 4de9c89a4982431c4a02739743fd360dc5581f22 ]

Change BPF selftest test_xdp_vlan.sh to (default) use generic XDP.

This selftest was created together with a fix for generic XDP, in commit
297249569932 ("net: fix generic XDP to handle if eth header was
mangled"). And was suppose to catch if generic XDP was broken again.

The tests are using veth and assumed that veth driver didn't support
native driver XDP, thus it used the (ip link set) 'xdp' attach that fell
back to generic-XDP. But veth gained native-XDP support in 948d4f214fde
("veth: Add driver XDP"), which caused this test script to use
native-XDP.

Fixes: 948d4f214fde ("veth: Add driver XDP")
Fixes: 97396ff0bc2d ("selftests/bpf: add XDP selftests for modifying and popping VLAN headers")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_xdp_vlan.sh |   42 +++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -1,7 +1,12 @@
 #!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Author: Jesper Dangaard Brouer <hawk@kernel.org>
 
 TESTNAME=xdp_vlan
 
+# Default XDP mode
+XDP_MODE=xdpgeneric
+
 usage() {
   echo "Testing XDP + TC eBPF VLAN manipulations: $TESTNAME"
   echo ""
@@ -9,9 +14,23 @@ usage() {
   echo "  -v | --verbose : Verbose"
   echo "  --flush        : Flush before starting (e.g. after --interactive)"
   echo "  --interactive  : Keep netns setup running after test-run"
+  echo "  --mode=XXX     : Choose XDP mode (xdp | xdpgeneric | xdpdrv)"
   echo ""
 }
 
+valid_xdp_mode()
+{
+	local mode=$1
+
+	case "$mode" in
+		xdpgeneric | xdpdrv | xdp)
+			return 0
+			;;
+		*)
+			return 1
+	esac
+}
+
 cleanup()
 {
 	local status=$?
@@ -37,7 +56,7 @@ cleanup()
 
 # Using external program "getopt" to get --long-options
 OPTIONS=$(getopt -o hvfi: \
-    --long verbose,flush,help,interactive,debug -- "$@")
+    --long verbose,flush,help,interactive,debug,mode: -- "$@")
 if (( $? != 0 )); then
     usage
     echo "selftests: $TESTNAME [FAILED] Error calling getopt, unknown option?"
@@ -60,6 +79,11 @@ while true; do
 		cleanup
 		shift
 		;;
+	    --mode )
+		shift
+		XDP_MODE=$1
+		shift
+		;;
 	    -- )
 		shift
 		break
@@ -81,8 +105,14 @@ if [ "$EUID" -ne 0 ]; then
 	exit 1
 fi
 
-ip link set dev lo xdp off 2>/dev/null > /dev/null
-if [ $? -ne 0 ];then
+valid_xdp_mode $XDP_MODE
+if [ $? -ne 0 ]; then
+	echo "selftests: $TESTNAME [FAILED] unknown XDP mode ($XDP_MODE)"
+	exit 1
+fi
+
+ip link set dev lo xdpgeneric off 2>/dev/null > /dev/null
+if [ $? -ne 0 ]; then
 	echo "selftests: $TESTNAME [SKIP] need ip xdp support"
 	exit 0
 fi
@@ -166,7 +196,7 @@ export FILE=test_xdp_vlan.o
 
 # First test: Remove VLAN by setting VLAN ID 0, using "xdp_vlan_change"
 export XDP_PROG=xdp_vlan_change
-ip netns exec ns1 ip link set $DEVNS1 xdp object $FILE section $XDP_PROG
+ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # In ns1: egress use TC to add back VLAN tag 4011
 #  (del cmd)
@@ -187,8 +217,8 @@ ip netns exec ns1 ping -W 2 -c 3 $IPADDR
 # ETH_P_8021Q indication, and this cause overwriting of our changes.
 #
 export XDP_PROG=xdp_vlan_remove_outer2
-ip netns exec ns1 ip link set $DEVNS1 xdp off
-ip netns exec ns1 ip link set $DEVNS1 xdp object $FILE section $XDP_PROG
+ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE off
+ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # Now the namespaces should still be able reach each-other, test with ping:
 ip netns exec ns2 ping -W 2 -c 3 $IPADDR1


