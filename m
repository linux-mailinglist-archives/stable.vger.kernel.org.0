Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718121E2CA3
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404577AbgEZTPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404470AbgEZTPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:15:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D691D20776;
        Tue, 26 May 2020 19:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520546;
        bh=SCfhZTIaHqAp/kDN9R0eV/qpGB7J/zlJUu4kD5LbpR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fV9Wki0ROEZVoDxOUiqdUHkUJ9mLuzpinmfeDpIrOLQ4LLSAUxrHAdQFYaykRe85j
         Lh/8vJreYHrBt7PjpPzN3Q47mx98OqFy+Wkgqzb3Bj0XhBHA1r7wWOvoBf3dhbd3us
         Yf5XD0kAtxpje325Jen8IV3zdvfS3E0vQ+vHkX8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 123/126] bpf: Prevent mmap()ing read-only maps as writable
Date:   Tue, 26 May 2020 20:54:20 +0200
Message-Id: <20200526183947.664403627@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit dfeb376dd4cb2c5004aeb625e2475f58a5ff2ea7 ]

As discussed in [0], it's dangerous to allow mapping BPF map, that's meant to
be frozen and is read-only on BPF program side, because that allows user-space
to actually store a writable view to the page even after it is frozen. This is
exacerbated by BPF verifier making a strong assumption that contents of such
frozen map will remain unchanged. To prevent this, disallow mapping
BPF_F_RDONLY_PROG mmap()'able BPF maps as writable, ever.

  [0] https://lore.kernel.org/bpf/CAEf4BzYGWYhXdp6BJ7_=9OQPJxQpgug080MMjdSB72i9R+5c6g@mail.gmail.com/

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/bpf/20200519053824.1089415-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c                          | 17 ++++++++++++++---
 tools/testing/selftests/bpf/prog_tests/mmap.c | 13 ++++++++++++-
 tools/testing/selftests/bpf/progs/test_mmap.c |  8 ++++++++
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e04ea4c8f935..c0ab9bfdf28a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -629,9 +629,20 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	mutex_lock(&map->freeze_mutex);
 
-	if ((vma->vm_flags & VM_WRITE) && map->frozen) {
-		err = -EPERM;
-		goto out;
+	if (vma->vm_flags & VM_WRITE) {
+		if (map->frozen) {
+			err = -EPERM;
+			goto out;
+		}
+		/* map is meant to be read-only, so do not allow mapping as
+		 * writable, because it's possible to leak a writable page
+		 * reference and allows user-space to still modify it after
+		 * freezing, while verifier will assume contents do not change
+		 */
+		if (map->map_flags & BPF_F_RDONLY_PROG) {
+			err = -EACCES;
+			goto out;
+		}
 	}
 
 	/* set default open/close callbacks */
diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index b0e789678aa4..5495b669fccc 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -19,7 +19,7 @@ void test_mmap(void)
 	const size_t map_sz = roundup_page(sizeof(struct map_data));
 	const int zero = 0, one = 1, two = 2, far = 1500;
 	const long page_size = sysconf(_SC_PAGE_SIZE);
-	int err, duration = 0, i, data_map_fd;
+	int err, duration = 0, i, data_map_fd, rdmap_fd;
 	struct bpf_map *data_map, *bss_map;
 	void *bss_mmaped = NULL, *map_mmaped = NULL, *tmp1, *tmp2;
 	struct test_mmap__bss *bss_data;
@@ -36,6 +36,17 @@ void test_mmap(void)
 	data_map = skel->maps.data_map;
 	data_map_fd = bpf_map__fd(data_map);
 
+	rdmap_fd = bpf_map__fd(skel->maps.rdonly_map);
+	tmp1 = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, rdmap_fd, 0);
+	if (CHECK(tmp1 != MAP_FAILED, "rdonly_write_mmap", "unexpected success\n")) {
+		munmap(tmp1, 4096);
+		goto cleanup;
+	}
+	/* now double-check if it's mmap()'able at all */
+	tmp1 = mmap(NULL, 4096, PROT_READ, MAP_SHARED, rdmap_fd, 0);
+	if (CHECK(tmp1 == MAP_FAILED, "rdonly_read_mmap", "failed: %d\n", errno))
+		goto cleanup;
+
 	bss_mmaped = mmap(NULL, bss_sz, PROT_READ | PROT_WRITE, MAP_SHARED,
 			  bpf_map__fd(bss_map), 0);
 	if (CHECK(bss_mmaped == MAP_FAILED, "bss_mmap",
diff --git a/tools/testing/selftests/bpf/progs/test_mmap.c b/tools/testing/selftests/bpf/progs/test_mmap.c
index 6239596cd14e..4eb42cff5fe9 100644
--- a/tools/testing/selftests/bpf/progs/test_mmap.c
+++ b/tools/testing/selftests/bpf/progs/test_mmap.c
@@ -7,6 +7,14 @@
 
 char _license[] SEC("license") = "GPL";
 
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 4096);
+	__uint(map_flags, BPF_F_MMAPABLE | BPF_F_RDONLY_PROG);
+	__type(key, __u32);
+	__type(value, char);
+} rdonly_map SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, 512 * 4); /* at least 4 pages of data */
-- 
2.25.1



