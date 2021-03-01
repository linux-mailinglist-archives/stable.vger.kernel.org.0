Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305A1328CE9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240606AbhCATBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:01:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239832AbhCASxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:53:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6BDA64F59;
        Mon,  1 Mar 2021 17:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620414;
        bh=1FSjNEQCzgf8Bm70keOHSQMSKyFdXIV7u3autdwo/p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeYuMrn4n51JJYkGAiKsB6QKVmKeUOT3SFYY+wZFBlRIUBjYcBoawWcUzvXwF8EWl
         0+k7k0WqRSnOva+pukovIP8xsxIVzSFkf0PlMNAzMsAlYqhS3KMp0bUSBGbSTP7jEt
         vY0xktS6Y0xV2e7HAc7bEUrPhpvz2RL0PE/wb5Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 145/775] selftests/bpf: Sync RCU before unloading bpf_testmod
Date:   Mon,  1 Mar 2021 17:05:13 +0100
Message-Id: <20210301161208.815356147@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 635599bace259a2c42741c3ea61bfa7be6f15556 ]

If some of the subtests use module BTFs through ksyms, they will cause
bpf_prog to take a refcount on bpf_testmod module, which will prevent it from
successfully unloading. Module's refcnt is decremented when bpf_prog is freed,
which generally happens in RCU callback. So we need to trigger
syncronize_rcu() in the kernel, which can be achieved nicely with
membarrier(MEMBARRIER_CMD_SHARED) or membarrier(MEMBARRIER_CMD_GLOBAL) syscall.
So do that in kernel_sync_rcu() and make it available to other test inside the
test_progs. This synchronize_rcu() is called before attempting to unload
bpf_testmod.

Fixes: 9f7fa225894c ("selftests/bpf: Add bpf_testmod kernel module for testing")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Hao Luo <haoluo@google.com>
Link: https://lore.kernel.org/bpf/20210112075520.4103414-5-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/btf_map_in_map.c | 33 -------------------
 tools/testing/selftests/bpf/test_progs.c      | 11 +++++++
 tools/testing/selftests/bpf/test_progs.h      |  1 +
 3 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
index 76ebe4c250f11..eb90a6b8850d2 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
@@ -20,39 +20,6 @@ static __u32 bpf_map_id(struct bpf_map *map)
 	return info.id;
 }
 
-/*
- * Trigger synchronize_rcu() in kernel.
- *
- * ARRAY_OF_MAPS/HASH_OF_MAPS lookup/update operations trigger synchronize_rcu()
- * if looking up an existing non-NULL element or updating the map with a valid
- * inner map FD. Use this fact to trigger synchronize_rcu(): create map-in-map,
- * create a trivial ARRAY map, update map-in-map with ARRAY inner map. Then
- * cleanup. At the end, at least one synchronize_rcu() would be called.
- */
-static int kern_sync_rcu(void)
-{
-	int inner_map_fd, outer_map_fd, err, zero = 0;
-
-	inner_map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, 4, 4, 1, 0);
-	if (CHECK(inner_map_fd < 0, "inner_map_create", "failed %d\n", -errno))
-		return -1;
-
-	outer_map_fd = bpf_create_map_in_map(BPF_MAP_TYPE_ARRAY_OF_MAPS, NULL,
-					     sizeof(int), inner_map_fd, 1, 0);
-	if (CHECK(outer_map_fd < 0, "outer_map_create", "failed %d\n", -errno)) {
-		close(inner_map_fd);
-		return -1;
-	}
-
-	err = bpf_map_update_elem(outer_map_fd, &zero, &inner_map_fd, 0);
-	if (err)
-		err = -errno;
-	CHECK(err, "outer_map_update", "failed %d\n", err);
-	close(inner_map_fd);
-	close(outer_map_fd);
-	return err;
-}
-
 static void test_lookup_update(void)
 {
 	int map1_fd, map2_fd, map3_fd, map4_fd, map5_fd, map1_id, map2_id;
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 7d077d48cadd0..213628ee721c1 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -11,6 +11,7 @@
 #include <signal.h>
 #include <string.h>
 #include <execinfo.h> /* backtrace */
+#include <linux/membarrier.h>
 
 #define EXIT_NO_TEST		2
 #define EXIT_ERR_SETUP_INFRA	3
@@ -370,8 +371,18 @@ static int delete_module(const char *name, int flags)
 	return syscall(__NR_delete_module, name, flags);
 }
 
+/*
+ * Trigger synchronize_rcu() in kernel.
+ */
+int kern_sync_rcu(void)
+{
+	return syscall(__NR_membarrier, MEMBARRIER_CMD_SHARED, 0, 0);
+}
+
 static void unload_bpf_testmod(void)
 {
+	if (kern_sync_rcu())
+		fprintf(env.stderr, "Failed to trigger kernel-side RCU sync!\n");
 	if (delete_module("bpf_testmod", 0)) {
 		if (errno == ENOENT) {
 			if (env.verbosity > VERBOSE_NONE)
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 115953243f623..e49e2fdde9425 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -219,6 +219,7 @@ int bpf_find_map(const char *test, struct bpf_object *obj, const char *name);
 int compare_map_keys(int map1_fd, int map2_fd);
 int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len);
 int extract_build_id(char *build_id, size_t size);
+int kern_sync_rcu(void);
 
 #ifdef __x86_64__
 #define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
-- 
2.27.0



