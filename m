Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEF83A0064
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbhFHSnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234929AbhFHSky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF32461380;
        Tue,  8 Jun 2021 18:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177295;
        bh=O0cl0lxuYZ5l+gxEdmIAnBAygUIuuoJk39rbcnKeQHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2SX3FdVYCDgbNNaY7L/GJX6JemnjtoGwUeVNcwbRei9bBYQ7IbsefxgpjnxWM4YbC
         grtj3HoVFAEDXkA4RJ1xk/W+kgW/3gF0Yy/quGgS9TqhXmFLm/S7brAoe928yBJo04
         Vjc+3AFQwMrxBGC8VrCDReYXEMVcykXOcg0rLKsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Stringer <joe@wand.net.nz>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 4.19 42/58] selftests/bpf: Generalize dummy program types
Date:   Tue,  8 Jun 2021 20:27:23 +0200
Message-Id: <20210608175933.657207777@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   31 +++++++++++++++-------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -12631,18 +12631,18 @@ static int create_map(uint32_t type, uin
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
@@ -12653,11 +12653,12 @@ static int create_prog_dummy2(int mfd, i
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
@@ -12669,8 +12670,8 @@ static int create_prog_array(uint32_t ma
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
@@ -12781,7 +12782,7 @@ static void do_test_fixup(struct bpf_tes
 	}
 
 	if (*fixup_prog1) {
-		map_fds[4] = create_prog_array(4, 0);
+		map_fds[4] = create_prog_array(prog_type, 4, 0);
 		do {
 			prog[*fixup_prog1].imm = map_fds[4];
 			fixup_prog1++;
@@ -12789,7 +12790,7 @@ static void do_test_fixup(struct bpf_tes
 	}
 
 	if (*fixup_prog2) {
-		map_fds[5] = create_prog_array(8, 7);
+		map_fds[5] = create_prog_array(prog_type, 8, 7);
 		do {
 			prog[*fixup_prog2].imm = map_fds[5];
 			fixup_prog2++;
@@ -12855,11 +12856,13 @@ static void do_test_single(struct bpf_te
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


