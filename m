Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BA463DE54
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiK3SgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiK3Sft (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:35:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C609702A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:35:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1609BB81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555B9C433C1;
        Wed, 30 Nov 2022 18:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833344;
        bh=lIXqrKLisWwPiDrXfBShLVeCztZm5Of1XLr4RJ0VfN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tc2gIs1nBKIGI/7DmB2yv2mmmpAbeuOrVSrRIhnSuC99AMHTIVwbl40m50DYZDzYX
         5BzhpRxVTzYl/8RlVG/4EutcSMZByOvHqc4xJ0VjBe9bge0tr5woszaKuKLQ+i67Wc
         jBaKLkkrJoI8Nyh95RqXGSrs60amC8qzOXDZBpl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/206] selftests: mptcp: more stable simult_flows tests
Date:   Wed, 30 Nov 2022 19:22:04 +0100
Message-Id: <20221130180534.828115169@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit b6ab64b074f29b42ff272793806efc913f7cc742 ]

Currently the simult_flows.sh self-tests are not very stable,
especially when running on slow VMs.

The tests measure runtime for transfers on multiple subflows
and check that the time is near the theoretical maximum.

The current test infra introduces a bit of jitter in test
runtime, due to multiple explicit delays. Additionally the
runtime is measured by the shell script wrapper. On a slow
VM, the script overhead is measurable and subject to relevant
jitter.

One solution to make the test more stable would be adding more
slack to the expected time; that could possibly hide real
regressions. Instead move the measurement inside the command
doing the transfer, and drop most unneeded sleeps.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3de88b95c4d4 ("selftests: mptcp: fix mibit vs mbit mix up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 72 +++++++++++++++----
 .../selftests/net/mptcp/simult_flows.sh       | 36 ++++------
 2 files changed, 72 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 89c4753c2760..95e81d557b08 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -14,6 +14,7 @@
 #include <strings.h>
 #include <signal.h>
 #include <unistd.h>
+#include <time.h>
 
 #include <sys/poll.h>
 #include <sys/sendfile.h>
@@ -64,6 +65,7 @@ static int cfg_sndbuf;
 static int cfg_rcvbuf;
 static bool cfg_join;
 static bool cfg_remove;
+static unsigned int cfg_time;
 static unsigned int cfg_do_w;
 static int cfg_wait;
 static uint32_t cfg_mark;
@@ -78,9 +80,10 @@ static struct cfg_cmsg_types cfg_cmsg_types;
 static void die_usage(void)
 {
 	fprintf(stderr, "Usage: mptcp_connect [-6] [-u] [-s MPTCP|TCP] [-p port] [-m mode]"
-		"[-l] [-w sec] connect_address\n");
+		"[-l] [-w sec] [-t num] [-T num] connect_address\n");
 	fprintf(stderr, "\t-6 use ipv6\n");
 	fprintf(stderr, "\t-t num -- set poll timeout to num\n");
+	fprintf(stderr, "\t-T num -- set expected runtime to num ms\n");
 	fprintf(stderr, "\t-S num -- set SO_SNDBUF to num\n");
 	fprintf(stderr, "\t-R num -- set SO_RCVBUF to num\n");
 	fprintf(stderr, "\t-p num -- use port num\n");
@@ -448,7 +451,7 @@ static void set_nonblock(int fd)
 	fcntl(fd, F_SETFL, flags | O_NONBLOCK);
 }
 
-static int copyfd_io_poll(int infd, int peerfd, int outfd)
+static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after_out)
 {
 	struct pollfd fds = {
 		.fd = peerfd,
@@ -487,9 +490,11 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 				 */
 				fds.events &= ~POLLIN;
 
-				if ((fds.events & POLLOUT) == 0)
+				if ((fds.events & POLLOUT) == 0) {
+					*in_closed_after_out = true;
 					/* and nothing more to send */
 					break;
+				}
 
 			/* Else, still have data to transmit */
 			} else if (len < 0) {
@@ -547,7 +552,7 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 	}
 
 	/* leave some time for late join/announce */
-	if (cfg_join || cfg_remove)
+	if (cfg_remove)
 		usleep(cfg_wait);
 
 	close(peerfd);
@@ -646,7 +651,7 @@ static int do_sendfile(int infd, int outfd, unsigned int count)
 }
 
 static int copyfd_io_mmap(int infd, int peerfd, int outfd,
-			  unsigned int size)
+			  unsigned int size, bool *in_closed_after_out)
 {
 	int err;
 
@@ -664,13 +669,14 @@ static int copyfd_io_mmap(int infd, int peerfd, int outfd,
 		shutdown(peerfd, SHUT_WR);
 
 		err = do_recvfile(peerfd, outfd);
+		*in_closed_after_out = true;
 	}
 
 	return err;
 }
 
 static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
-			      unsigned int size)
+			      unsigned int size, bool *in_closed_after_out)
 {
 	int err;
 
@@ -685,6 +691,7 @@ static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
 		if (err)
 			return err;
 		err = do_recvfile(peerfd, outfd);
+		*in_closed_after_out = true;
 	}
 
 	return err;
@@ -692,27 +699,62 @@ static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
 
 static int copyfd_io(int infd, int peerfd, int outfd)
 {
+	bool in_closed_after_out = false;
+	struct timespec start, end;
 	int file_size;
+	int ret;
+
+	if (cfg_time && (clock_gettime(CLOCK_MONOTONIC, &start) < 0))
+		xerror("can not fetch start time %d", errno);
 
 	switch (cfg_mode) {
 	case CFG_MODE_POLL:
-		return copyfd_io_poll(infd, peerfd, outfd);
+		ret = copyfd_io_poll(infd, peerfd, outfd, &in_closed_after_out);
+		break;
+
 	case CFG_MODE_MMAP:
 		file_size = get_infd_size(infd);
 		if (file_size < 0)
 			return file_size;
-		return copyfd_io_mmap(infd, peerfd, outfd, file_size);
+		ret = copyfd_io_mmap(infd, peerfd, outfd, file_size, &in_closed_after_out);
+		break;
+
 	case CFG_MODE_SENDFILE:
 		file_size = get_infd_size(infd);
 		if (file_size < 0)
 			return file_size;
-		return copyfd_io_sendfile(infd, peerfd, outfd, file_size);
+		ret = copyfd_io_sendfile(infd, peerfd, outfd, file_size, &in_closed_after_out);
+		break;
+
+	default:
+		fprintf(stderr, "Invalid mode %d\n", cfg_mode);
+
+		die_usage();
+		return 1;
 	}
 
-	fprintf(stderr, "Invalid mode %d\n", cfg_mode);
+	if (ret)
+		return ret;
 
-	die_usage();
-	return 1;
+	if (cfg_time) {
+		unsigned int delta_ms;
+
+		if (clock_gettime(CLOCK_MONOTONIC, &end) < 0)
+			xerror("can not fetch end time %d", errno);
+		delta_ms = (end.tv_sec - start.tv_sec) * 1000 + (end.tv_nsec - start.tv_nsec) / 1000000;
+		if (delta_ms > cfg_time) {
+			xerror("transfer slower than expected! runtime %d ms, expected %d ms",
+			       delta_ms, cfg_time);
+		}
+
+		/* show the runtime only if this end shutdown(wr) before receiving the EOF,
+		 * (that is, if this end got the longer runtime)
+		 */
+		if (in_closed_after_out)
+			fprintf(stderr, "%d", delta_ms);
+	}
+
+	return 0;
 }
 
 static void check_sockaddr(int pf, struct sockaddr_storage *ss,
@@ -1005,12 +1047,11 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6jr:lp:s:hut:m:S:R:w:M:P:c:")) != -1) {
+	while ((c = getopt(argc, argv, "6jr:lp:s:hut:T:m:S:R:w:M:P:c:")) != -1) {
 		switch (c) {
 		case 'j':
 			cfg_join = true;
 			cfg_mode = CFG_MODE_POLL;
-			cfg_wait = 400000;
 			break;
 		case 'r':
 			cfg_remove = true;
@@ -1043,6 +1084,9 @@ static void parse_opts(int argc, char **argv)
 			if (poll_timeout <= 0)
 				poll_timeout = -1;
 			break;
+		case 'T':
+			cfg_time = atoi(optarg);
+			break;
 		case 'm':
 			cfg_mode = parse_mode(optarg);
 			break;
diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 910d8126af8f..f441ff7904fc 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -51,7 +51,7 @@ setup()
 	sout=$(mktemp)
 	cout=$(mktemp)
 	capout=$(mktemp)
-	size=$((2048 * 4096))
+	size=$((2 * 2048 * 4096))
 	dd if=/dev/zero of=$small bs=4096 count=20 >/dev/null 2>&1
 	dd if=/dev/zero of=$large bs=4096 count=$((size / 4096)) >/dev/null 2>&1
 
@@ -161,17 +161,15 @@ do_transfer()
 
 	timeout ${timeout_test} \
 		ip netns exec ${ns3} \
-			./mptcp_connect -jt ${timeout_poll} -l -p $port \
+			./mptcp_connect -jt ${timeout_poll} -l -p $port -T $time \
 				0.0.0.0 < "$sin" > "$sout" &
 	local spid=$!
 
 	wait_local_port_listen "${ns3}" "${port}"
 
-	local start
-	start=$(date +%s%3N)
 	timeout ${timeout_test} \
 		ip netns exec ${ns1} \
-			./mptcp_connect -jt ${timeout_poll} -p $port \
+			./mptcp_connect -jt ${timeout_poll} -p $port -T $time \
 				10.0.3.3 < "$cin" > "$cout" &
 	local cpid=$!
 
@@ -180,27 +178,20 @@ do_transfer()
 	wait $spid
 	local rets=$?
 
-	local stop
-	stop=$(date +%s%3N)
-
 	if $capture; then
 		sleep 1
 		kill ${cappid_listener}
 		kill ${cappid_connector}
 	fi
 
-	local duration
-	duration=$((stop-start))
-
 	cmp $sin $cout > /dev/null 2>&1
 	local cmps=$?
 	cmp $cin $sout > /dev/null 2>&1
 	local cmpc=$?
 
-	printf "%16s" "$duration max $max_time "
+	printf "%-16s" " max $max_time "
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ] && \
-	   [ $cmpc -eq 0 ] && [ $cmps -eq 0 ] && \
-	   [ $duration -lt $max_time ]; then
+	   [ $cmpc -eq 0 ] && [ $cmps -eq 0 ]; then
 		echo "[ OK ]"
 		cat "$capout"
 		return 0
@@ -244,23 +235,24 @@ run_test()
 	tc -n $ns2 qdisc add dev ns2eth1 root netem rate ${rate1}mbit $delay1
 	tc -n $ns2 qdisc add dev ns2eth2 root netem rate ${rate2}mbit $delay2
 
-	# time is measure in ms
-	local time=$((size * 8 * 1000 / (( $rate1 + $rate2) * 1024 *1024) ))
+	# time is measured in ms, account for transfer size, affegated link speed
+	# and header overhead (10%)
+	local time=$((size * 8 * 1000 * 10 / (( $rate1 + $rate2) * 1024 *1024 * 9) ))
 
 	# mptcp_connect will do some sleeps to allow the mp_join handshake
-	# completion
-	time=$((time + 1350))
+	# completion (see mptcp_connect): 200ms on each side, add some slack
+	time=$((time + 450))
 
-	printf "%-50s" "$msg"
-	do_transfer $small $large $((time * 11 / 10))
+	printf "%-60s" "$msg"
+	do_transfer $small $large $time
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
 		[ $bail -eq 0 ] || exit $ret
 	fi
 
-	printf "%-50s" "$msg - reverse direction"
-	do_transfer $large $small $((time * 11 / 10))
+	printf "%-60s" "$msg - reverse direction"
+	do_transfer $large $small $time
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
-- 
2.35.1



