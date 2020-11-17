Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00A92B626E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731870AbgKQN2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731464AbgKQN0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DEFF20781;
        Tue, 17 Nov 2020 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619601;
        bh=lzlPIPiFVgtxRWJece5MTPypKexIcJYGWoklRc9edk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNo9K2zEegNZFa/aY1XyZ4cUq1E4zIKLSmrPTJDeioB0j81rR9cfkjMjzCyGaDPeh
         Woe293lGZD+qqpg3aSOy7Eum/u9xt1aYyiNi6b5CxInQODo8BEPo4FQ8wG/QqLlrmu
         +w6mjKz9ykwTw5vKGT+sR6cFP4Mnyy00GjAVASaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Verbeiren <david.verbeiren@tessares.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/151] bpf: Zero-fill re-used per-cpu map element
Date:   Tue, 17 Nov 2020 14:05:23 +0100
Message-Id: <20201117122125.930740704@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Verbeiren <david.verbeiren@tessares.net>

[ Upstream commit d3bec0138bfbe58606fc1d6f57a4cdc1a20218db ]

Zero-fill element values for all other cpus than current, just as
when not using prealloc. This is the only way the bpf program can
ensure known initial values for all cpus ('onallcpus' cannot be
set when coming from the bpf program).

The scenario is: bpf program inserts some elements in a per-cpu
map, then deletes some (or userspace does). When later adding
new elements using bpf_map_update_elem(), the bpf program can
only set the value of the new elements for the current cpu.
When prealloc is enabled, previously deleted elements are re-used.
Without the fix, values for other cpus remain whatever they were
when the re-used entry was previously freed.

A selftest is added to validate correct operation in above
scenario as well as in case of LRU per-cpu map element re-use.

Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
Signed-off-by: David Verbeiren <david.verbeiren@tessares.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20201104112332.15191-1-david.verbeiren@tessares.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c                          |  30 ++-
 .../selftests/bpf/prog_tests/map_init.c       | 214 ++++++++++++++++++
 .../selftests/bpf/progs/test_map_init.c       |  33 +++
 3 files changed, 275 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_init.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_init.c

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 728ffec52cf36..03a67583f6fb9 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -709,6 +709,32 @@ static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
 	}
 }
 
+static void pcpu_init_value(struct bpf_htab *htab, void __percpu *pptr,
+			    void *value, bool onallcpus)
+{
+	/* When using prealloc and not setting the initial value on all cpus,
+	 * zero-fill element values for other cpus (just as what happens when
+	 * not using prealloc). Otherwise, bpf program has no way to ensure
+	 * known initial values for cpus other than current one
+	 * (onallcpus=false always when coming from bpf prog).
+	 */
+	if (htab_is_prealloc(htab) && !onallcpus) {
+		u32 size = round_up(htab->map.value_size, 8);
+		int current_cpu = raw_smp_processor_id();
+		int cpu;
+
+		for_each_possible_cpu(cpu) {
+			if (cpu == current_cpu)
+				bpf_long_memcpy(per_cpu_ptr(pptr, cpu), value,
+						size);
+			else
+				memset(per_cpu_ptr(pptr, cpu), 0, size);
+		}
+	} else {
+		pcpu_copy_value(htab, pptr, value, onallcpus);
+	}
+}
+
 static bool fd_htab_map_needs_adjust(const struct bpf_htab *htab)
 {
 	return htab->map.map_type == BPF_MAP_TYPE_HASH_OF_MAPS &&
@@ -779,7 +805,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			}
 		}
 
-		pcpu_copy_value(htab, pptr, value, onallcpus);
+		pcpu_init_value(htab, pptr, value, onallcpus);
 
 		if (!prealloc)
 			htab_elem_set_ptr(l_new, key_size, pptr);
@@ -1075,7 +1101,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 		pcpu_copy_value(htab, htab_elem_get_ptr(l_old, key_size),
 				value, onallcpus);
 	} else {
-		pcpu_copy_value(htab, htab_elem_get_ptr(l_new, key_size),
+		pcpu_init_value(htab, htab_elem_get_ptr(l_new, key_size),
 				value, onallcpus);
 		hlist_nulls_add_head_rcu(&l_new->hash_node, head);
 		l_new = NULL;
diff --git a/tools/testing/selftests/bpf/prog_tests/map_init.c b/tools/testing/selftests/bpf/prog_tests/map_init.c
new file mode 100644
index 0000000000000..14a31109dd0e0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/map_init.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Tessares SA <http://www.tessares.net> */
+
+#include <test_progs.h>
+#include "test_map_init.skel.h"
+
+#define TEST_VALUE 0x1234
+#define FILL_VALUE 0xdeadbeef
+
+static int nr_cpus;
+static int duration;
+
+typedef unsigned long long map_key_t;
+typedef unsigned long long map_value_t;
+typedef struct {
+	map_value_t v; /* padding */
+} __bpf_percpu_val_align pcpu_map_value_t;
+
+
+static int map_populate(int map_fd, int num)
+{
+	pcpu_map_value_t value[nr_cpus];
+	int i, err;
+	map_key_t key;
+
+	for (i = 0; i < nr_cpus; i++)
+		bpf_percpu(value, i) = FILL_VALUE;
+
+	for (key = 1; key <= num; key++) {
+		err = bpf_map_update_elem(map_fd, &key, value, BPF_NOEXIST);
+		if (!ASSERT_OK(err, "bpf_map_update_elem"))
+			return -1;
+	}
+
+	return 0;
+}
+
+static struct test_map_init *setup(enum bpf_map_type map_type, int map_sz,
+			    int *map_fd, int populate)
+{
+	struct test_map_init *skel;
+	int err;
+
+	skel = test_map_init__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return NULL;
+
+	err = bpf_map__set_type(skel->maps.hashmap1, map_type);
+	if (!ASSERT_OK(err, "bpf_map__set_type"))
+		goto error;
+
+	err = bpf_map__set_max_entries(skel->maps.hashmap1, map_sz);
+	if (!ASSERT_OK(err, "bpf_map__set_max_entries"))
+		goto error;
+
+	err = test_map_init__load(skel);
+	if (!ASSERT_OK(err, "skel_load"))
+		goto error;
+
+	*map_fd = bpf_map__fd(skel->maps.hashmap1);
+	if (CHECK(*map_fd < 0, "bpf_map__fd", "failed\n"))
+		goto error;
+
+	err = map_populate(*map_fd, populate);
+	if (!ASSERT_OK(err, "map_populate"))
+		goto error_map;
+
+	return skel;
+
+error_map:
+	close(*map_fd);
+error:
+	test_map_init__destroy(skel);
+	return NULL;
+}
+
+/* executes bpf program that updates map with key, value */
+static int prog_run_insert_elem(struct test_map_init *skel, map_key_t key,
+				map_value_t value)
+{
+	struct test_map_init__bss *bss;
+
+	bss = skel->bss;
+
+	bss->inKey = key;
+	bss->inValue = value;
+	bss->inPid = getpid();
+
+	if (!ASSERT_OK(test_map_init__attach(skel), "skel_attach"))
+		return -1;
+
+	/* Let tracepoint trigger */
+	syscall(__NR_getpgid);
+
+	test_map_init__detach(skel);
+
+	return 0;
+}
+
+static int check_values_one_cpu(pcpu_map_value_t *value, map_value_t expected)
+{
+	int i, nzCnt = 0;
+	map_value_t val;
+
+	for (i = 0; i < nr_cpus; i++) {
+		val = bpf_percpu(value, i);
+		if (val) {
+			if (CHECK(val != expected, "map value",
+				  "unexpected for cpu %d: 0x%llx\n", i, val))
+				return -1;
+			nzCnt++;
+		}
+	}
+
+	if (CHECK(nzCnt != 1, "map value", "set for %d CPUs instead of 1!\n",
+		  nzCnt))
+		return -1;
+
+	return 0;
+}
+
+/* Add key=1 elem with values set for all CPUs
+ * Delete elem key=1
+ * Run bpf prog that inserts new key=1 elem with value=0x1234
+ *   (bpf prog can only set value for current CPU)
+ * Lookup Key=1 and check value is as expected for all CPUs:
+ *   value set by bpf prog for one CPU, 0 for all others
+ */
+static void test_pcpu_map_init(void)
+{
+	pcpu_map_value_t value[nr_cpus];
+	struct test_map_init *skel;
+	int map_fd, err;
+	map_key_t key;
+
+	/* max 1 elem in map so insertion is forced to reuse freed entry */
+	skel = setup(BPF_MAP_TYPE_PERCPU_HASH, 1, &map_fd, 1);
+	if (!ASSERT_OK_PTR(skel, "prog_setup"))
+		return;
+
+	/* delete element so the entry can be re-used*/
+	key = 1;
+	err = bpf_map_delete_elem(map_fd, &key);
+	if (!ASSERT_OK(err, "bpf_map_delete_elem"))
+		goto cleanup;
+
+	/* run bpf prog that inserts new elem, re-using the slot just freed */
+	err = prog_run_insert_elem(skel, key, TEST_VALUE);
+	if (!ASSERT_OK(err, "prog_run_insert_elem"))
+		goto cleanup;
+
+	/* check that key=1 was re-created by bpf prog */
+	err = bpf_map_lookup_elem(map_fd, &key, value);
+	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
+		goto cleanup;
+
+	/* and has expected values */
+	check_values_one_cpu(value, TEST_VALUE);
+
+cleanup:
+	test_map_init__destroy(skel);
+}
+
+/* Add key=1 and key=2 elems with values set for all CPUs
+ * Run bpf prog that inserts new key=3 elem
+ *   (only for current cpu; other cpus should have initial value = 0)
+ * Lookup Key=1 and check value is as expected for all CPUs
+ */
+static void test_pcpu_lru_map_init(void)
+{
+	pcpu_map_value_t value[nr_cpus];
+	struct test_map_init *skel;
+	int map_fd, err;
+	map_key_t key;
+
+	/* Set up LRU map with 2 elements, values filled for all CPUs.
+	 * With these 2 elements, the LRU map is full
+	 */
+	skel = setup(BPF_MAP_TYPE_LRU_PERCPU_HASH, 2, &map_fd, 2);
+	if (!ASSERT_OK_PTR(skel, "prog_setup"))
+		return;
+
+	/* run bpf prog that inserts new key=3 element, re-using LRU slot */
+	key = 3;
+	err = prog_run_insert_elem(skel, key, TEST_VALUE);
+	if (!ASSERT_OK(err, "prog_run_insert_elem"))
+		goto cleanup;
+
+	/* check that key=3 replaced one of earlier elements */
+	err = bpf_map_lookup_elem(map_fd, &key, value);
+	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
+		goto cleanup;
+
+	/* and has expected values */
+	check_values_one_cpu(value, TEST_VALUE);
+
+cleanup:
+	test_map_init__destroy(skel);
+}
+
+void test_map_init(void)
+{
+	nr_cpus = bpf_num_possible_cpus();
+	if (nr_cpus <= 1) {
+		printf("%s:SKIP: >1 cpu needed for this test\n", __func__);
+		test__skip();
+		return;
+	}
+
+	if (test__start_subtest("pcpu_map_init"))
+		test_pcpu_map_init();
+	if (test__start_subtest("pcpu_lru_map_init"))
+		test_pcpu_lru_map_init();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_map_init.c b/tools/testing/selftests/bpf/progs/test_map_init.c
new file mode 100644
index 0000000000000..c89d28ead6737
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_map_init.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Tessares SA <http://www.tessares.net> */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+__u64 inKey = 0;
+__u64 inValue = 0;
+__u32 inPid = 0;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 2);
+	__type(key, __u64);
+	__type(value, __u64);
+} hashmap1 SEC(".maps");
+
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int sysenter_getpgid(const void *ctx)
+{
+	/* Just do it for once, when called from our own test prog. This
+	 * ensures the map value is only updated for a single CPU.
+	 */
+	int cur_pid = bpf_get_current_pid_tgid() >> 32;
+
+	if (cur_pid == inPid)
+		bpf_map_update_elem(&hashmap1, &inKey, &inValue, BPF_NOEXIST);
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.27.0



