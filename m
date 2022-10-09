Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F625F910F
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiJIWaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiJIW1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:27:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2232A31366;
        Sun,  9 Oct 2022 15:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8402B80D36;
        Sun,  9 Oct 2022 22:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6134CC433C1;
        Sun,  9 Oct 2022 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353898;
        bh=sExncP2vEI4lKfEjoGTg9PlosArh89bqCxfpK8p7bwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyoXti6/SB03WGlWNe5/Ucn49k0HXui268Et6tUoU5QXf3gUk0LsPLv/it1BKz6s5
         2RAs8hZVpMkjFrc9kbmsENU9KjQ2UCdPGyNYUwAu7cqQeU59kAJwqDVgaUH3eXOQ5z
         Uy5P9JwBqEZUeSygc/HccZ7Gce2JUUzV7gKuATpcu8Q336FfJGqnIxx13f3VsITVO3
         UEaB5rtrJ0N2yL4R9y1NmA9PUiwoO17Ak7yL1OKL2AFQSv4RDaQ5fMBsBOJjvgIcg0
         PO4vPeLvMwE2M2pIU1Rumz21VK1v7gcODHkAmA1Ox/YsMy7hsFTrzg0mGau3uBMMey
         J0nhh07Z8ry1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Tao <houtao1@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, shuah@kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 56/73] selftests/bpf: Free the allocated resources after test case succeeds
Date:   Sun,  9 Oct 2022 18:14:34 -0400
Message-Id: <20221009221453.1216158-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 103d002fb7d548fb1187e350f2b73788558128b9 ]

Free the created fd or allocated bpf_object after test case succeeds,
else there will be resource leaks.

Spotted by using address sanitizer and checking the content of
/proc/$pid/fd directory.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20220921070035.2016413-3-houtao@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/map_tests/array_map_batch_ops.c       |  2 ++
 .../bpf/map_tests/htab_map_batch_ops.c        |  2 ++
 .../bpf/map_tests/lpm_trie_map_batch_ops.c    |  2 ++
 tools/testing/selftests/bpf/test_maps.c       | 24 ++++++++++++-------
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
index 78c76496b14a..b595556315bc 100644
--- a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
+++ b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
@@ -3,6 +3,7 @@
 #include <stdio.h>
 #include <errno.h>
 #include <string.h>
+#include <unistd.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -137,6 +138,7 @@ static void __test_map_lookup_and_update_batch(bool is_pcpu)
 	free(keys);
 	free(values);
 	free(visited);
+	close(map_fd);
 }
 
 static void array_map_batch_ops(void)
diff --git a/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
index f807d53fd8dd..1230ccf90128 100644
--- a/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
+++ b/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
@@ -3,6 +3,7 @@
 #include <stdio.h>
 #include <errno.h>
 #include <string.h>
+#include <unistd.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -255,6 +256,7 @@ void __test_map_lookup_and_delete_batch(bool is_pcpu)
 	free(visited);
 	if (!is_pcpu)
 		free(values);
+	close(map_fd);
 }
 
 void htab_map_batch_ops(void)
diff --git a/tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c
index 87d07b596e17..b66d56ddb7ef 100644
--- a/tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c
+++ b/tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c
@@ -7,6 +7,7 @@
 #include <errno.h>
 #include <string.h>
 #include <stdlib.h>
+#include <unistd.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -150,4 +151,5 @@ void test_lpm_trie_map_batch_ops(void)
 	free(keys);
 	free(values);
 	free(visited);
+	close(map_fd);
 }
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index cbebfaa7c1e8..4d42ffea0038 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -658,13 +658,13 @@ static void test_sockmap(unsigned int tasks, void *data)
 {
 	struct bpf_map *bpf_map_rx, *bpf_map_tx, *bpf_map_msg, *bpf_map_break;
 	int map_fd_msg = 0, map_fd_rx = 0, map_fd_tx = 0, map_fd_break;
+	struct bpf_object *parse_obj, *verdict_obj, *msg_obj;
 	int ports[] = {50200, 50201, 50202, 50204};
 	int err, i, fd, udp, sfd[6] = {0xdeadbeef};
 	u8 buf[20] = {0x0, 0x5, 0x3, 0x2, 0x1, 0x0};
 	int parse_prog, verdict_prog, msg_prog;
 	struct sockaddr_in addr;
 	int one = 1, s, sc, rc;
-	struct bpf_object *obj;
 	struct timeval to;
 	__u32 key, value;
 	pid_t pid[tasks];
@@ -760,6 +760,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 		       i, udp);
 		goto out_sockmap;
 	}
+	close(udp);
 
 	/* Test update without programs */
 	for (i = 0; i < 6; i++) {
@@ -822,27 +823,27 @@ static void test_sockmap(unsigned int tasks, void *data)
 
 	/* Load SK_SKB program and Attach */
 	err = bpf_prog_test_load(SOCKMAP_PARSE_PROG,
-			    BPF_PROG_TYPE_SK_SKB, &obj, &parse_prog);
+			    BPF_PROG_TYPE_SK_SKB, &parse_obj, &parse_prog);
 	if (err) {
 		printf("Failed to load SK_SKB parse prog\n");
 		goto out_sockmap;
 	}
 
 	err = bpf_prog_test_load(SOCKMAP_TCP_MSG_PROG,
-			    BPF_PROG_TYPE_SK_MSG, &obj, &msg_prog);
+			    BPF_PROG_TYPE_SK_MSG, &msg_obj, &msg_prog);
 	if (err) {
 		printf("Failed to load SK_SKB msg prog\n");
 		goto out_sockmap;
 	}
 
 	err = bpf_prog_test_load(SOCKMAP_VERDICT_PROG,
-			    BPF_PROG_TYPE_SK_SKB, &obj, &verdict_prog);
+			    BPF_PROG_TYPE_SK_SKB, &verdict_obj, &verdict_prog);
 	if (err) {
 		printf("Failed to load SK_SKB verdict prog\n");
 		goto out_sockmap;
 	}
 
-	bpf_map_rx = bpf_object__find_map_by_name(obj, "sock_map_rx");
+	bpf_map_rx = bpf_object__find_map_by_name(verdict_obj, "sock_map_rx");
 	if (!bpf_map_rx) {
 		printf("Failed to load map rx from verdict prog\n");
 		goto out_sockmap;
@@ -854,7 +855,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 		goto out_sockmap;
 	}
 
-	bpf_map_tx = bpf_object__find_map_by_name(obj, "sock_map_tx");
+	bpf_map_tx = bpf_object__find_map_by_name(verdict_obj, "sock_map_tx");
 	if (!bpf_map_tx) {
 		printf("Failed to load map tx from verdict prog\n");
 		goto out_sockmap;
@@ -866,7 +867,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 		goto out_sockmap;
 	}
 
-	bpf_map_msg = bpf_object__find_map_by_name(obj, "sock_map_msg");
+	bpf_map_msg = bpf_object__find_map_by_name(verdict_obj, "sock_map_msg");
 	if (!bpf_map_msg) {
 		printf("Failed to load map msg from msg_verdict prog\n");
 		goto out_sockmap;
@@ -878,7 +879,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 		goto out_sockmap;
 	}
 
-	bpf_map_break = bpf_object__find_map_by_name(obj, "sock_map_break");
+	bpf_map_break = bpf_object__find_map_by_name(verdict_obj, "sock_map_break");
 	if (!bpf_map_break) {
 		printf("Failed to load map tx from verdict prog\n");
 		goto out_sockmap;
@@ -1124,7 +1125,9 @@ static void test_sockmap(unsigned int tasks, void *data)
 	}
 	close(fd);
 	close(map_fd_rx);
-	bpf_object__close(obj);
+	bpf_object__close(parse_obj);
+	bpf_object__close(msg_obj);
+	bpf_object__close(verdict_obj);
 	return;
 out:
 	for (i = 0; i < 6; i++)
@@ -1282,8 +1285,11 @@ static void test_map_in_map(void)
 			printf("Inner map mim.inner was not destroyed\n");
 			goto out_map_in_map;
 		}
+
+		close(fd);
 	}
 
+	bpf_object__close(obj);
 	return;
 
 out_map_in_map:
-- 
2.35.1

