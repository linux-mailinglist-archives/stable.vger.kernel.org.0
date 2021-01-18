Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803B82FA9B9
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407899AbhARTI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390517AbhARLjG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:39:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F80422571;
        Mon, 18 Jan 2021 11:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969926;
        bh=95LXqHmt/884FgYQTDIjCFnE0wpPj8HcF/6tCVxGgkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpdiIt7ft4ZM/nttM2BOblOoov6gXacgNOIidqr7zNqpIJ8QZSpQlAsidufIOdWFb
         lrGmAi4bMe7Uaqq2PPxw6xCU3OWwdx9iUpj5XyQnESa4xLO9ZaZi3N2lAjbLm5T92p
         aDHJjnzq+JbxL+on7dMxfAQOT72MWlpwZnoYRadE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/76] selftests: fix the return value for UDP GRO test
Date:   Mon, 18 Jan 2021 12:34:41 +0100
Message-Id: <20210118113342.955781088@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 3503ee6c0bec5f173d606359e6384a5ef85492fb ]

The udpgro.sh will always return 0 (unless the bpf selftest was not
build first) even if there are some failed sub test-cases.

Therefore the kselftest framework will report this case is OK.

Check and return the exit status of each test to make it easier to
spot real failures.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro.sh | 34 +++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index ac2a30be9b325..f8a19f548ae9d 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -5,6 +5,14 @@
 
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
+# set global exit status, but never reset nonzero one.
+check_err()
+{
+	if [ $ret -eq 0 ]; then
+		ret=$1
+	fi
+}
+
 cleanup() {
 	local -r jobs="$(jobs -p)"
 	local -r ns="$(ip netns list|grep $PEER_NS)"
@@ -44,7 +52,9 @@ run_one() {
 	# Hack: let bg programs complete the startup
 	sleep 0.1
 	./udpgso_bench_tx ${tx_args}
+	ret=$?
 	wait $(jobs -p)
+	return $ret
 }
 
 run_test() {
@@ -87,8 +97,10 @@ run_one_nat() {
 
 	sleep 0.1
 	./udpgso_bench_tx ${tx_args}
+	ret=$?
 	kill -INT $pid
 	wait $(jobs -p)
+	return $ret
 }
 
 run_one_2sock() {
@@ -110,7 +122,9 @@ run_one_2sock() {
 	sleep 0.1
 	# first UDP GSO socket should be closed at this point
 	./udpgso_bench_tx ${tx_args}
+	ret=$?
 	wait $(jobs -p)
+	return $ret
 }
 
 run_nat_test() {
@@ -131,36 +145,54 @@ run_all() {
 	local -r core_args="-l 4"
 	local -r ipv4_args="${core_args} -4 -D 192.168.1.1"
 	local -r ipv6_args="${core_args} -6 -D 2001:db8::1"
+	ret=0
 
 	echo "ipv4"
 	run_test "no GRO" "${ipv4_args} -M 10 -s 1400" "-4 -n 10 -l 1400"
+	check_err $?
 
 	# explicitly check we are not receiving UDP_SEGMENT cmsg (-S -1)
 	# when GRO does not take place
 	run_test "no GRO chk cmsg" "${ipv4_args} -M 10 -s 1400" "-4 -n 10 -l 1400 -S -1"
+	check_err $?
 
 	# the GSO packets are aggregated because:
 	# * veth schedule napi after each xmit
 	# * segmentation happens in BH context, veth napi poll is delayed after
 	#   the transmission of the last segment
 	run_test "GRO" "${ipv4_args} -M 1 -s 14720 -S 0 " "-4 -n 1 -l 14720"
+	check_err $?
 	run_test "GRO chk cmsg" "${ipv4_args} -M 1 -s 14720 -S 0 " "-4 -n 1 -l 14720 -S 1472"
+	check_err $?
 	run_test "GRO with custom segment size" "${ipv4_args} -M 1 -s 14720 -S 500 " "-4 -n 1 -l 14720"
+	check_err $?
 	run_test "GRO with custom segment size cmsg" "${ipv4_args} -M 1 -s 14720 -S 500 " "-4 -n 1 -l 14720 -S 500"
+	check_err $?
 
 	run_nat_test "bad GRO lookup" "${ipv4_args} -M 1 -s 14720 -S 0" "-n 10 -l 1472"
+	check_err $?
 	run_2sock_test "multiple GRO socks" "${ipv4_args} -M 1 -s 14720 -S 0 " "-4 -n 1 -l 14720 -S 1472"
+	check_err $?
 
 	echo "ipv6"
 	run_test "no GRO" "${ipv6_args} -M 10 -s 1400" "-n 10 -l 1400"
+	check_err $?
 	run_test "no GRO chk cmsg" "${ipv6_args} -M 10 -s 1400" "-n 10 -l 1400 -S -1"
+	check_err $?
 	run_test "GRO" "${ipv6_args} -M 1 -s 14520 -S 0" "-n 1 -l 14520"
+	check_err $?
 	run_test "GRO chk cmsg" "${ipv6_args} -M 1 -s 14520 -S 0" "-n 1 -l 14520 -S 1452"
+	check_err $?
 	run_test "GRO with custom segment size" "${ipv6_args} -M 1 -s 14520 -S 500" "-n 1 -l 14520"
+	check_err $?
 	run_test "GRO with custom segment size cmsg" "${ipv6_args} -M 1 -s 14520 -S 500" "-n 1 -l 14520 -S 500"
+	check_err $?
 
 	run_nat_test "bad GRO lookup" "${ipv6_args} -M 1 -s 14520 -S 0" "-n 10 -l 1452"
+	check_err $?
 	run_2sock_test "multiple GRO socks" "${ipv6_args} -M 1 -s 14520 -S 0 " "-n 1 -l 14520 -S 1452"
+	check_err $?
+	return $ret
 }
 
 if [ ! -f ../bpf/xdp_dummy.o ]; then
@@ -180,3 +212,5 @@ elif [[ $1 == "__subprocess_2sock" ]]; then
 	shift
 	run_one_2sock $@
 fi
+
+exit $?
-- 
2.27.0



