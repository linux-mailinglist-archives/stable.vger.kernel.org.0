Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E146915778A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgBJMkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbgBJMkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:46 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21E29208C4;
        Mon, 10 Feb 2020 12:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338446;
        bh=MIdrN4eNMf+qGiOgzxhA4qnCELEF867GZBySwRbQpQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFTPYCQoXfU47cS3zm4/n5zCk3SVcTWafz/ENjbJk+Js/ZlhgIyLlj6h7r3YvEw0w
         Lkl3LoP8i+FXoLoBz1QeZGrNm/VblC9J4AQ0X8/P5TZErWUG9bSVC5iKkBISmfQBmB
         VAaSCiFmZ1ing7sUMPbOPzt1Z4rZRoU5qdv2MRqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.5 161/367] selftests/bpf: Fix perf_buffer test on systems w/ offline CPUs
Date:   Mon, 10 Feb 2020 04:31:14 -0800
Message-Id: <20200210122439.685145454@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 91cbdf740a476cf2c744169bf407de2e3ac1f3cf upstream.

Fix up perf_buffer.c selftest to take into account offline/missing CPUs.

Fixes: ee5cf82ce04a ("selftests/bpf: test perf buffer API")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191212013621.1691858-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/prog_tests/perf_buffer.c |   29 +++++++++++++++----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -4,6 +4,7 @@
 #include <sched.h>
 #include <sys/socket.h>
 #include <test_progs.h>
+#include "libbpf_internal.h"
 
 static void on_sample(void *ctx, int cpu, void *data, __u32 size)
 {
@@ -19,7 +20,7 @@ static void on_sample(void *ctx, int cpu
 
 void test_perf_buffer(void)
 {
-	int err, prog_fd, nr_cpus, i, duration = 0;
+	int err, prog_fd, on_len, nr_on_cpus = 0,  nr_cpus, i, duration = 0;
 	const char *prog_name = "kprobe/sys_nanosleep";
 	const char *file = "./test_perf_buffer.o";
 	struct perf_buffer_opts pb_opts = {};
@@ -29,15 +30,27 @@ void test_perf_buffer(void)
 	struct bpf_object *obj;
 	struct perf_buffer *pb;
 	struct bpf_link *link;
+	bool *online;
 
 	nr_cpus = libbpf_num_possible_cpus();
 	if (CHECK(nr_cpus < 0, "nr_cpus", "err %d\n", nr_cpus))
 		return;
 
+	err = parse_cpu_mask_file("/sys/devices/system/cpu/online",
+				  &online, &on_len);
+	if (CHECK(err, "nr_on_cpus", "err %d\n", err))
+		return;
+
+	for (i = 0; i < on_len; i++)
+		if (online[i])
+			nr_on_cpus++;
+
 	/* load program */
 	err = bpf_prog_load(file, BPF_PROG_TYPE_KPROBE, &obj, &prog_fd);
-	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
-		return;
+	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno)) {
+		obj = NULL;
+		goto out_close;
+	}
 
 	prog = bpf_object__find_program_by_title(obj, prog_name);
 	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", prog_name))
@@ -64,6 +77,11 @@ void test_perf_buffer(void)
 	/* trigger kprobe on every CPU */
 	CPU_ZERO(&cpu_seen);
 	for (i = 0; i < nr_cpus; i++) {
+		if (i >= on_len || !online[i]) {
+			printf("skipping offline CPU #%d\n", i);
+			continue;
+		}
+
 		CPU_ZERO(&cpu_set);
 		CPU_SET(i, &cpu_set);
 
@@ -81,8 +99,8 @@ void test_perf_buffer(void)
 	if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
 		goto out_free_pb;
 
-	if (CHECK(CPU_COUNT(&cpu_seen) != nr_cpus, "seen_cpu_cnt",
-		  "expect %d, seen %d\n", nr_cpus, CPU_COUNT(&cpu_seen)))
+	if (CHECK(CPU_COUNT(&cpu_seen) != nr_on_cpus, "seen_cpu_cnt",
+		  "expect %d, seen %d\n", nr_on_cpus, CPU_COUNT(&cpu_seen)))
 		goto out_free_pb;
 
 out_free_pb:
@@ -91,4 +109,5 @@ out_detach:
 	bpf_link__destroy(link);
 out_close:
 	bpf_object__close(obj);
+	free(online);
 }


