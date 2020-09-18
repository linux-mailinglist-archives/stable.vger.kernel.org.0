Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B7C26EB06
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgIRCCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgIRCCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F35221EC;
        Fri, 18 Sep 2020 02:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394555;
        bh=A6iVWKRWFky6V91r7CvpkOKV8Ult2j1FeDLCBRix+y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQPeJmPVdK57xBrSP1E/mHxNZ5vZMWD50xPgqcn34CPJiNFIjD5M4Qqh2LQSx4fRg
         mf9QNVW/fi3VaR1D4yHMj9IhFnVx5JGRqBAJP9sBUqpfFJXyzXbbO99Khi9mJLk4iz
         wEyfIVWgOKMbE7fpa1IakLEB9gg7uiu4812J15og=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Lawrence Brakmo <brakmo@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 071/330] selftests/bpf: De-flake test_tcpbpf
Date:   Thu, 17 Sep 2020 21:56:51 -0400
Message-Id: <20200918020110.2063155-71-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit ef8c84effce3c7a0b8196fcda8f430c815ab511c ]

It looks like BPF program that handles BPF_SOCK_OPS_STATE_CB state
can race with the bpf_map_lookup_elem("global_map"); I sometimes
see the failures in this test and re-running helps.

Since we know that we expect the callback to be called 3 times (one
time for listener socket, two times for both ends of the connection),
let's export this number and add simple retry logic around that.

Also, let's make EXPECT_EQ() not return on failure, but continue
evaluating all conditions; that should make potential debugging
easier.

With this fix in place I don't observe the flakiness anymore.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Lawrence Brakmo <brakmo@fb.com>
Link: https://lore.kernel.org/bpf/20191204190955.170934-1-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/test_tcpbpf_kern.c    |  1 +
 tools/testing/selftests/bpf/test_tcpbpf.h     |  1 +
 .../testing/selftests/bpf/test_tcpbpf_user.c  | 25 +++++++++++++------
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index 2e233613d1fc0..7fa4595d2b66b 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -131,6 +131,7 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 				g.bytes_received = skops->bytes_received;
 				g.bytes_acked = skops->bytes_acked;
 			}
+			g.num_close_events++;
 			bpf_map_update_elem(&global_map, &key, &g,
 					    BPF_ANY);
 		}
diff --git a/tools/testing/selftests/bpf/test_tcpbpf.h b/tools/testing/selftests/bpf/test_tcpbpf.h
index 7bcfa62070056..6220b95cbd02c 100644
--- a/tools/testing/selftests/bpf/test_tcpbpf.h
+++ b/tools/testing/selftests/bpf/test_tcpbpf.h
@@ -13,5 +13,6 @@ struct tcpbpf_globals {
 	__u64 bytes_received;
 	__u64 bytes_acked;
 	__u32 num_listen;
+	__u32 num_close_events;
 };
 #endif
diff --git a/tools/testing/selftests/bpf/test_tcpbpf_user.c b/tools/testing/selftests/bpf/test_tcpbpf_user.c
index 716b4e3be5813..3ae127620463d 100644
--- a/tools/testing/selftests/bpf/test_tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/test_tcpbpf_user.c
@@ -16,6 +16,9 @@
 
 #include "test_tcpbpf.h"
 
+/* 3 comes from one listening socket + both ends of the connection */
+#define EXPECTED_CLOSE_EVENTS		3
+
 #define EXPECT_EQ(expected, actual, fmt)			\
 	do {							\
 		if ((expected) != (actual)) {			\
@@ -23,13 +26,14 @@
 			       "    Actual: %" fmt "\n"		\
 			       "  Expected: %" fmt "\n",	\
 			       (actual), (expected));		\
-			goto err;				\
+			ret--;					\
 		}						\
 	} while (0)
 
 int verify_result(const struct tcpbpf_globals *result)
 {
 	__u32 expected_events;
+	int ret = 0;
 
 	expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
 			   (1 << BPF_SOCK_OPS_RWND_INIT) |
@@ -48,15 +52,15 @@ int verify_result(const struct tcpbpf_globals *result)
 	EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
 	EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
 	EXPECT_EQ(1, result->num_listen, PRIu32);
+	EXPECT_EQ(EXPECTED_CLOSE_EVENTS, result->num_close_events, PRIu32);
 
-	return 0;
-err:
-	return -1;
+	return ret;
 }
 
 int verify_sockopt_result(int sock_map_fd)
 {
 	__u32 key = 0;
+	int ret = 0;
 	int res;
 	int rv;
 
@@ -69,9 +73,7 @@ int verify_sockopt_result(int sock_map_fd)
 	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
 	EXPECT_EQ(0, rv, "d");
 	EXPECT_EQ(1, res, "d");
-	return 0;
-err:
-	return -1;
+	return ret;
 }
 
 static int bpf_find_map(const char *test, struct bpf_object *obj,
@@ -96,6 +98,7 @@ int main(int argc, char **argv)
 	int error = EXIT_FAILURE;
 	struct bpf_object *obj;
 	int cg_fd = -1;
+	int retry = 10;
 	__u32 key = 0;
 	int rv;
 
@@ -134,12 +137,20 @@ int main(int argc, char **argv)
 	if (sock_map_fd < 0)
 		goto err;
 
+retry_lookup:
 	rv = bpf_map_lookup_elem(map_fd, &key, &g);
 	if (rv != 0) {
 		printf("FAILED: bpf_map_lookup_elem returns %d\n", rv);
 		goto err;
 	}
 
+	if (g.num_close_events != EXPECTED_CLOSE_EVENTS && retry--) {
+		printf("Unexpected number of close events (%d), retrying!\n",
+		       g.num_close_events);
+		usleep(100);
+		goto retry_lookup;
+	}
+
 	if (verify_result(&g)) {
 		printf("FAILED: Wrong stats\n");
 		goto err;
-- 
2.25.1

