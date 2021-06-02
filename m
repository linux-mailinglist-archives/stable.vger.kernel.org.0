Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5DA397F7D
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 05:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhFBD3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 23:29:53 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45760 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231210AbhFBD3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 23:29:52 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH0O6+rZgh7MIAA--.9496S5;
        Wed, 02 Jun 2021 11:28:06 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Joe Stringer <joe@wand.net.nz>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 3/9] selftests/bpf: Generalize dummy program types
Date:   Wed,  2 Jun 2021 11:27:47 +0800
Message-Id: <1622604473-781-4-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxH0O6+rZgh7MIAA--.9496S5
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4kXr4fXw1fAryfJFW5Jrb_yoWrWF4UpF
        WrtF9FkF1kJFnrXay5Aa45Zr95tF1DXrWUGrWUZ3yUZa1UZw1rWFyfGFZ0yrn3uFWrWr1S
        v3W29r93uw1fKrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBYb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv
        6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK67AK6r48MxAIw28IcxkI7V
        AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0XyCJUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Stringer <joe@wand.net.nz>

commit 0c586079f852187d19fea60c9a4981ad29e22ba8 upstream

Don't hardcode the dummy program types to SOCKET_FILTER type, as this
prevents testing bpf_tail_call in conjunction with other program types.
Instead, use the program type specified in the test case.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 tools/testing/selftests/bpf/test_verifier.c | 31 ++++++++++++++++-------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 38dd129..809d8e9 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -12631,18 +12631,18 @@ static int create_map(uint32_t type, uint32_t size_key,
 	return fd;
 }
 
-static int create_prog_dummy1(void)
+static int create_prog_dummy1(enum bpf_map_type prog_type)
 {
 	struct bpf_insn prog[] = {
 		BPF_MOV64_IMM(BPF_REG_0, 42),
 		BPF_EXIT_INSN(),
 	};
 
-	return bpf_load_program(BPF_PROG_TYPE_SOCKET_FILTER, prog,
+	return bpf_load_program(prog_type, prog,
 				ARRAY_SIZE(prog), "GPL", 0, NULL, 0);
 }
 
-static int create_prog_dummy2(int mfd, int idx)
+static int create_prog_dummy2(enum bpf_map_type prog_type, int mfd, int idx)
 {
 	struct bpf_insn prog[] = {
 		BPF_MOV64_IMM(BPF_REG_3, idx),
@@ -12653,11 +12653,12 @@ static int create_prog_dummy2(int mfd, int idx)
 		BPF_EXIT_INSN(),
 	};
 
-	return bpf_load_program(BPF_PROG_TYPE_SOCKET_FILTER, prog,
+	return bpf_load_program(prog_type, prog,
 				ARRAY_SIZE(prog), "GPL", 0, NULL, 0);
 }
 
-static int create_prog_array(uint32_t max_elem, int p1key)
+static int create_prog_array(enum bpf_map_type prog_type, uint32_t max_elem,
+			     int p1key)
 {
 	int p2key = 1;
 	int mfd, p1fd, p2fd;
@@ -12669,8 +12670,8 @@ static int create_prog_array(uint32_t max_elem, int p1key)
 		return -1;
 	}
 
-	p1fd = create_prog_dummy1();
-	p2fd = create_prog_dummy2(mfd, p2key);
+	p1fd = create_prog_dummy1(prog_type);
+	p2fd = create_prog_dummy2(prog_type, mfd, p2key);
 	if (p1fd < 0 || p2fd < 0)
 		goto out;
 	if (bpf_map_update_elem(mfd, &p1key, &p1fd, BPF_ANY) < 0)
@@ -12725,8 +12726,8 @@ static int create_cgroup_storage(void)
 
 static char bpf_vlog[UINT_MAX >> 8];
 
-static void do_test_fixup(struct bpf_test *test, struct bpf_insn *prog,
-			  int *map_fds)
+static void do_test_fixup(struct bpf_test *test, enum bpf_map_type prog_type,
+			  struct bpf_insn *prog, int *map_fds)
 {
 	int *fixup_map1 = test->fixup_map1;
 	int *fixup_map2 = test->fixup_map2;
@@ -12781,7 +12782,7 @@ static void do_test_fixup(struct bpf_test *test, struct bpf_insn *prog,
 	}
 
 	if (*fixup_prog1) {
-		map_fds[4] = create_prog_array(4, 0);
+		map_fds[4] = create_prog_array(prog_type, 4, 0);
 		do {
 			prog[*fixup_prog1].imm = map_fds[4];
 			fixup_prog1++;
@@ -12789,7 +12790,7 @@ static void do_test_fixup(struct bpf_test *test, struct bpf_insn *prog,
 	}
 
 	if (*fixup_prog2) {
-		map_fds[5] = create_prog_array(8, 7);
+		map_fds[5] = create_prog_array(prog_type, 8, 7);
 		do {
 			prog[*fixup_prog2].imm = map_fds[5];
 			fixup_prog2++;
@@ -12855,11 +12856,13 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	for (i = 0; i < MAX_NR_MAPS; i++)
 		map_fds[i] = -1;
 
-	do_test_fixup(test, prog, map_fds);
+	if (!prog_type)
+		prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
+	do_test_fixup(test, prog_type, prog, map_fds);
 	prog_len = probe_filter_length(prog);
 
-	fd_prog = bpf_verify_program(prog_type ? : BPF_PROG_TYPE_SOCKET_FILTER,
-				     prog, prog_len, test->flags & F_LOAD_WITH_STRICT_ALIGNMENT,
+	fd_prog = bpf_verify_program(prog_type, prog, prog_len,
+				     test->flags & F_LOAD_WITH_STRICT_ALIGNMENT,
 				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 1);
 
 	expected_ret = unpriv && test->result_unpriv != UNDEF ?
-- 
2.1.0

