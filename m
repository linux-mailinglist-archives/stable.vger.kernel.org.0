Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9727B27C95C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbgI2Lhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730104AbgI2Lh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D1723B1C;
        Tue, 29 Sep 2020 11:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379224;
        bh=A6iVWKRWFky6V91r7CvpkOKV8Ult2j1FeDLCBRix+y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3j0q/q3Zt1EeH9YGJla1eSw+AkRF4BjzFzCXg3YHjqXLQJL+cMsfEQBTmMxknSxa
         5i8KDBjXt9TmN5z9UFzU3xJ/4bE9Ib1rnyTElDHZeKM7YIY8QxKP0UBVjrmLQqfXnO
         3lzhPKJwCfbSyUxoajxQ7mIMu37WQBnRYjITj3H4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Lawrence Brakmo <brakmo@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/388] selftests/bpf: De-flake test_tcpbpf
Date:   Tue, 29 Sep 2020 12:56:39 +0200
Message-Id: <20200929110013.786963498@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



