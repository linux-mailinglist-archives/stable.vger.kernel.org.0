Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB8124762B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392163AbgHQTeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730169AbgHQPaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:30:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AACE323B23;
        Mon, 17 Aug 2020 15:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678216;
        bh=vDTdG65bwJ1bXEfa0hP27pjDcaJ7475zf3lmwVP2w4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wFGyDPMR5ZguWQ2o6TsGB4v4YNP9TSZ/G1EocQ4AN3q8mJRdOq8rylkNailw/oI5
         cDuj0WpEhYnDmI8DAE//IWiRvjAIWvf0rqpo997ZE64CpZJGzS07NKMBtU9g3KvQTv
         kFFH4Yk3TzJviXJPXugcHFBQ3OGJWv976te804fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 217/464] samples: bpf: Fix bpf programs with kprobe/sys_connect event
Date:   Mon, 17 Aug 2020 17:12:50 +0200
Message-Id: <20200817143844.203699338@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit af9bd3e3331b8af42b6606c75797d041ab39380c ]

Currently, BPF programs with kprobe/sys_connect does not work properly.

Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
This commit modifies the bpf_load behavior of kprobe events in the x64
architecture. If the current kprobe event target starts with "sys_*",
add the prefix "__x64_" to the front of the event.

Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
solution to most of the problems caused by the commit below.

    commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
    pt_regs-based sys_*() to __x64_sys_*()")

However, there is a problem with the sys_connect kprobe event that does
not work properly. For __sys_connect event, parameters can be fetched
normally, but for __x64_sys_connect, parameters cannot be fetched.

    ffffffff818d3520 <__x64_sys_connect>:
    ffffffff818d3520: e8 fb df 32 00        callq   0xffffffff81c01520
    <__fentry__>
    ffffffff818d3525: 48 8b 57 60           movq    96(%rdi), %rdx
    ffffffff818d3529: 48 8b 77 68           movq    104(%rdi), %rsi
    ffffffff818d352d: 48 8b 7f 70           movq    112(%rdi), %rdi
    ffffffff818d3531: e8 1a ff ff ff        callq   0xffffffff818d3450
    <__sys_connect>
    ffffffff818d3536: 48 98                 cltq
    ffffffff818d3538: c3                    retq
    ffffffff818d3539: 0f 1f 80 00 00 00 00  nopl    (%rax)

As the assembly code for __x64_sys_connect shows, parameters should be
fetched and set into rdi, rsi, rdx registers prior to calling
__sys_connect.

Because of this problem, this commit fixes the sys_connect event by
first getting the value of the rdi register and then the value of the
rdi, rsi, and rdx register through an offset based on that value.

Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200707184855.30968-2-danieltimlee@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/map_perf_test_kern.c         | 9 ++++++---
 samples/bpf/test_map_in_map_kern.c       | 9 ++++++---
 samples/bpf/test_probe_write_user_kern.c | 9 ++++++---
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index 12e91ae64d4d9..c9b31193ca128 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -11,6 +11,8 @@
 #include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
 #include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include "trace_common.h"
 
 #define MAX_ENTRIES 1000
 #define MAX_NR_CPUS 1024
@@ -154,9 +156,10 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_connect")
+SEC("kprobe/" SYSCALL(sys_connect))
 int stress_lru_hmap_alloc(struct pt_regs *ctx)
 {
+	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
 	char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
 	union {
 		u16 dst6[8];
@@ -175,8 +178,8 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 	long val = 1;
 	u32 key = 0;
 
-	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2(ctx);
-	addrlen = (int)PT_REGS_PARM3(ctx);
+	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2_CORE(real_regs);
+	addrlen = (int)PT_REGS_PARM3_CORE(real_regs);
 
 	if (addrlen != sizeof(*in6))
 		return 0;
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index 6cee61e8ce9b6..36a203e690645 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -13,6 +13,8 @@
 #include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
 #include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include "trace_common.h"
 
 #define MAX_NR_PORTS 65536
 
@@ -102,9 +104,10 @@ static __always_inline int do_inline_hash_lookup(void *inner_map, u32 port)
 	return result ? *result : -ENOENT;
 }
 
-SEC("kprobe/sys_connect")
+SEC("kprobe/" SYSCALL(sys_connect))
 int trace_sys_connect(struct pt_regs *ctx)
 {
+	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
 	struct sockaddr_in6 *in6;
 	u16 test_case, port, dst6[8];
 	int addrlen, ret, inline_ret, ret_key = 0;
@@ -112,8 +115,8 @@ int trace_sys_connect(struct pt_regs *ctx)
 	void *outer_map, *inner_map;
 	bool inline_hash = false;
 
-	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2(ctx);
-	addrlen = (int)PT_REGS_PARM3(ctx);
+	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2_CORE(real_regs);
+	addrlen = (int)PT_REGS_PARM3_CORE(real_regs);
 
 	if (addrlen != sizeof(*in6))
 		return 0;
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index f033f36a13a38..fd651a65281eb 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -10,6 +10,8 @@
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include "trace_common.h"
 
 struct bpf_map_def SEC("maps") dnat_map = {
 	.type = BPF_MAP_TYPE_HASH,
@@ -26,13 +28,14 @@ struct bpf_map_def SEC("maps") dnat_map = {
  * This example sits on a syscall, and the syscall ABI is relatively stable
  * of course, across platforms, and over time, the ABI may change.
  */
-SEC("kprobe/sys_connect")
+SEC("kprobe/" SYSCALL(sys_connect))
 int bpf_prog1(struct pt_regs *ctx)
 {
+	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
+	void *sockaddr_arg = (void *)PT_REGS_PARM2_CORE(real_regs);
+	int sockaddr_len = (int)PT_REGS_PARM3_CORE(real_regs);
 	struct sockaddr_in new_addr, orig_addr = {};
 	struct sockaddr_in *mapped_addr;
-	void *sockaddr_arg = (void *)PT_REGS_PARM2(ctx);
-	int sockaddr_len = (int)PT_REGS_PARM3(ctx);
 
 	if (sockaddr_len > sizeof(orig_addr))
 		return 0;
-- 
2.25.1



