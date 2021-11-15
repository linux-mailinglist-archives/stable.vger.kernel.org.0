Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB812451E59
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349350AbhKPAfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344838AbhKOTZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C982636D7;
        Mon, 15 Nov 2021 19:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003110;
        bh=A2RFcS0QxXijrT/BZRHLwEfc1AgUeJmPmJ04TVZauPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0LB8SffJy2eRudpAO8QqOzk/2Ae61ndPVYumcI/kBi5uiOu/PFFuJ6G6BRHfZeAT
         Vhywjq1JsI0OQrS2jbZH3uEu0ChtdqRrrw7EKmnJzDOhOD8m8noKeArp0jhIGHKJbf
         0KYwdIHVYLR5IMEglDPL4wmlcJSkmPPNbc2Jq+0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 807/917] selftests/bpf/xdp_redirect_multi: Limit the tests in netns
Date:   Mon, 15 Nov 2021 18:05:02 +0100
Message-Id: <20211115165456.351773382@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 8955c1a329873385775081e029d9a7c6aa9037e1 ]

As I want to test both DEVMAP and DEVMAP_HASH in XDP multicast redirect, I
limited DEVMAP max entries to a small value for performace. When the test
runs after amount of interface creating/deleting tests. The interface index
will exceed the map max entries and xdp_redirect_multi will error out with
"Get interfacesInterface index to large".

Fix this issue by limit the tests in netns and specify the ifindex when
creating interfaces.

Fixes: d23292476297 ("selftests/bpf: Add xdp_redirect_multi test")
Reported-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211027033553.962413-5-liuhangbin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 23 ++++++++++++-------
 .../selftests/bpf/xdp_redirect_multi.c        |  4 ++--
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
index 37e347159ab44..bedff7aa7023f 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -2,11 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # Test topology:
-#     - - - - - - - - - - - - - - - - - - - - - - - - -
-#    | veth1         veth2         veth3 |  ... init net
+#    - - - - - - - - - - - - - - - - - - -
+#    | veth1         veth2         veth3 |  ns0
 #     - -| - - - - - - | - - - - - - | - -
 #    ---------     ---------     ---------
-#    | veth0 |     | veth0 |     | veth0 |  ...
+#    | veth0 |     | veth0 |     | veth0 |
 #    ---------     ---------     ---------
 #       ns1           ns2           ns3
 #
@@ -51,6 +51,7 @@ clean_up()
 		ip link del veth$i 2> /dev/null
 		ip netns del ns$i 2> /dev/null
 	done
+	ip netns del ns0 2> /dev/null
 }
 
 # Kselftest framework requirement - SKIP code is 4.
@@ -78,10 +79,12 @@ setup_ns()
 		mode="xdpdrv"
 	fi
 
+	ip netns add ns0
 	for i in $(seq $NUM); do
 	        ip netns add ns$i
-	        ip link add veth$i type veth peer name veth0 netns ns$i
-		ip link set veth$i up
+		ip -n ns$i link add veth0 index 2 type veth \
+			peer name veth$i netns ns0 index $((1 + $i))
+		ip -n ns0 link set veth$i up
 		ip -n ns$i link set veth0 up
 
 		ip -n ns$i addr add 192.0.2.$i/24 dev veth0
@@ -92,7 +95,7 @@ setup_ns()
 			xdp_dummy.o sec xdp_dummy &> /dev/null || \
 			{ test_fail "Unable to load dummy xdp" && exit 1; }
 		IFACES="$IFACES veth$i"
-		veth_mac[$i]=$(ip link show veth$i | awk '/link\/ether/ {print $2}')
+		veth_mac[$i]=$(ip -n ns0 link show veth$i | awk '/link\/ether/ {print $2}')
 	done
 }
 
@@ -177,9 +180,13 @@ do_tests()
 		xdpgeneric) drv_p="-S";;
 	esac
 
-	./xdp_redirect_multi $drv_p $IFACES &> ${LOG_DIR}/xdp_redirect_${mode}.log &
+	ip netns exec ns0 ./xdp_redirect_multi $drv_p $IFACES &> ${LOG_DIR}/xdp_redirect_${mode}.log &
 	xdp_pid=$!
 	sleep 1
+	if ! ps -p $xdp_pid > /dev/null; then
+		test_fail "$mode xdp_redirect_multi start failed"
+		return 1
+	fi
 
 	if [ "$mode" = "xdpegress" ]; then
 		do_egress_tests $mode
@@ -190,7 +197,7 @@ do_tests()
 	kill $xdp_pid
 }
 
-trap clean_up 0 2 3 6 9
+trap clean_up EXIT
 
 check_env
 
diff --git a/tools/testing/selftests/bpf/xdp_redirect_multi.c b/tools/testing/selftests/bpf/xdp_redirect_multi.c
index 3696a8f32c235..f5ffba341c174 100644
--- a/tools/testing/selftests/bpf/xdp_redirect_multi.c
+++ b/tools/testing/selftests/bpf/xdp_redirect_multi.c
@@ -129,7 +129,7 @@ int main(int argc, char **argv)
 		goto err_out;
 	}
 
-	printf("Get interfaces");
+	printf("Get interfaces:");
 	for (i = 0; i < MAX_IFACE_NUM && argv[optind + i]; i++) {
 		ifaces[i] = if_nametoindex(argv[optind + i]);
 		if (!ifaces[i])
@@ -139,7 +139,7 @@ int main(int argc, char **argv)
 			goto err_out;
 		}
 		if (ifaces[i] > MAX_INDEX_NUM) {
-			printf("Interface index to large\n");
+			printf(" interface index too large\n");
 			goto err_out;
 		}
 		printf(" %d", ifaces[i]);
-- 
2.33.0



