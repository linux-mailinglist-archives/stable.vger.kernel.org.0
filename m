Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80F3147A74
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbgAXJdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:33:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730676AbgAXJdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:33:47 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 159C22070A;
        Fri, 24 Jan 2020 09:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858426;
        bh=3Jzw21dNbAU4rA7XdTnvOcPn1PewqBfeGPCaF1zDnzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF7DMjhbV62LofAjmApn52hkoI0BlBileDr2vNVAoPX+Ol7m+D9aWeZYoKOQ+nCVT
         9nzF4jkvyJGitjsZPZBv85gWJyfupbAUQFupAyO2a5kirZoQd+9WQ5z+ZVE2Dp82W5
         HKMKdlhHF6pfE+sroMDAO8JW1a/L5ZCq6DSTqO68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH 5.4 007/102] libbpf: Fix call relocation offset calculation bug
Date:   Fri, 24 Jan 2020 10:30:08 +0100
Message-Id: <20200124092807.172946256@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit a0d7da26ce86a25e97ae191cb90574ada6daea98 upstream.

When relocating subprogram call, libbpf doesn't take into account
relo->text_off, which comes from symbol's value. This generally works fine for
subprograms implemented as static functions, but breaks for global functions.

Taking a simplified test_pkt_access.c as an example:

__attribute__ ((noinline))
static int test_pkt_access_subprog1(volatile struct __sk_buff *skb)
{
        return skb->len * 2;
}

__attribute__ ((noinline))
static int test_pkt_access_subprog2(int val, volatile struct __sk_buff *skb)
{
        return skb->len + val;
}

SEC("classifier/test_pkt_access")
int test_pkt_access(struct __sk_buff *skb)
{
        if (test_pkt_access_subprog1(skb) != skb->len * 2)
                return TC_ACT_SHOT;
        if (test_pkt_access_subprog2(2, skb) != skb->len + 2)
                return TC_ACT_SHOT;
        return TC_ACT_UNSPEC;
}

When compiled, we get two relocations, pointing to '.text' symbol. .text has
st_value set to 0 (it points to the beginning of .text section):

0000000000000008  000000050000000a R_BPF_64_32            0000000000000000 .text
0000000000000040  000000050000000a R_BPF_64_32            0000000000000000 .text

test_pkt_access_subprog1 and test_pkt_access_subprog2 offsets (targets of two
calls) are encoded within call instruction's imm32 part as -1 and 2,
respectively:

0000000000000000 test_pkt_access_subprog1:
       0:       61 10 00 00 00 00 00 00 r0 = *(u32 *)(r1 + 0)
       1:       64 00 00 00 01 00 00 00 w0 <<= 1
       2:       95 00 00 00 00 00 00 00 exit

0000000000000018 test_pkt_access_subprog2:
       3:       61 10 00 00 00 00 00 00 r0 = *(u32 *)(r1 + 0)
       4:       04 00 00 00 02 00 00 00 w0 += 2
       5:       95 00 00 00 00 00 00 00 exit

0000000000000000 test_pkt_access:
       0:       bf 16 00 00 00 00 00 00 r6 = r1
===>   1:       85 10 00 00 ff ff ff ff call -1
       2:       bc 01 00 00 00 00 00 00 w1 = w0
       3:       b4 00 00 00 02 00 00 00 w0 = 2
       4:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
       5:       64 02 00 00 01 00 00 00 w2 <<= 1
       6:       5e 21 08 00 00 00 00 00 if w1 != w2 goto +8 <LBB0_3>
       7:       bf 61 00 00 00 00 00 00 r1 = r6
===>   8:       85 10 00 00 02 00 00 00 call 2
       9:       bc 01 00 00 00 00 00 00 w1 = w0
      10:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
      11:       04 02 00 00 02 00 00 00 w2 += 2
      12:       b4 00 00 00 ff ff ff ff w0 = -1
      13:       1e 21 01 00 00 00 00 00 if w1 == w2 goto +1 <LBB0_3>
      14:       b4 00 00 00 02 00 00 00 w0 = 2
0000000000000078 LBB0_3:
      15:       95 00 00 00 00 00 00 00 exit

Now, if we compile example with global functions, the setup changes.
Relocations are now against specifically test_pkt_access_subprog1 and
test_pkt_access_subprog2 symbols, with test_pkt_access_subprog2 pointing 24
bytes into its respective section (.text), i.e., 3 instructions in:

0000000000000008  000000070000000a R_BPF_64_32            0000000000000000 test_pkt_access_subprog1
0000000000000048  000000080000000a R_BPF_64_32            0000000000000018 test_pkt_access_subprog2

Calls instructions now encode offsets relative to function symbols and are both
set ot -1:

0000000000000000 test_pkt_access_subprog1:
       0:       61 10 00 00 00 00 00 00 r0 = *(u32 *)(r1 + 0)
       1:       64 00 00 00 01 00 00 00 w0 <<= 1
       2:       95 00 00 00 00 00 00 00 exit

0000000000000018 test_pkt_access_subprog2:
       3:       61 20 00 00 00 00 00 00 r0 = *(u32 *)(r2 + 0)
       4:       0c 10 00 00 00 00 00 00 w0 += w1
       5:       95 00 00 00 00 00 00 00 exit

0000000000000000 test_pkt_access:
       0:       bf 16 00 00 00 00 00 00 r6 = r1
===>   1:       85 10 00 00 ff ff ff ff call -1
       2:       bc 01 00 00 00 00 00 00 w1 = w0
       3:       b4 00 00 00 02 00 00 00 w0 = 2
       4:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
       5:       64 02 00 00 01 00 00 00 w2 <<= 1
       6:       5e 21 09 00 00 00 00 00 if w1 != w2 goto +9 <LBB2_3>
       7:       b4 01 00 00 02 00 00 00 w1 = 2
       8:       bf 62 00 00 00 00 00 00 r2 = r6
===>   9:       85 10 00 00 ff ff ff ff call -1
      10:       bc 01 00 00 00 00 00 00 w1 = w0
      11:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
      12:       04 02 00 00 02 00 00 00 w2 += 2
      13:       b4 00 00 00 ff ff ff ff w0 = -1
      14:       1e 21 01 00 00 00 00 00 if w1 == w2 goto +1 <LBB2_3>
      15:       b4 00 00 00 02 00 00 00 w0 = 2
0000000000000080 LBB2_3:
      16:       95 00 00 00 00 00 00 00 exit

Thus the right formula to calculate target call offset after relocation should
take into account relocation's target symbol value (offset within section),
call instruction's imm32 offset, and (subtracting, to get relative instruction
offset) instruction index of call instruction itself. All that is shifted by
number of instructions in main program, given all sub-programs are copied over
after main program.

Convert few selftests relying on bpf-to-bpf calls to use global functions
instead of static ones.

Fixes: 48cca7e44f9f ("libbpf: add support for bpf_call")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191119224447.3781271-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/libbpf.c                             |    8 ++++++--
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |    4 ++--
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |    4 ++--
 tools/testing/selftests/bpf/progs/test_btf_nokv.c  |    4 ++--
 4 files changed, 12 insertions(+), 8 deletions(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1791,9 +1791,13 @@ bpf_program__collect_reloc(struct bpf_pr
 				pr_warning("incorrect bpf_call opcode\n");
 				return -LIBBPF_ERRNO__RELOC;
 			}
+			if (sym.st_value % 8) {
+				pr_warn("bad call relo offset: %lu\n", sym.st_value);
+				return -LIBBPF_ERRNO__RELOC;
+			}
 			prog->reloc_desc[i].type = RELO_CALL;
 			prog->reloc_desc[i].insn_idx = insn_idx;
-			prog->reloc_desc[i].text_off = sym.st_value;
+			prog->reloc_desc[i].text_off = sym.st_value / 8;
 			obj->has_pseudo_calls = true;
 			continue;
 		}
@@ -3239,7 +3243,7 @@ bpf_program__reloc_text(struct bpf_progr
 			 prog->section_name);
 	}
 	insn = &prog->insns[relo->insn_idx];
-	insn->imm += prog->main_prog_cnt - relo->insn_idx;
+	insn->imm += relo->text_off + prog->main_prog_cnt - relo->insn_idx;
 	return 0;
 }
 
--- a/tools/testing/selftests/bpf/progs/test_btf_haskv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_haskv.c
@@ -25,7 +25,7 @@ struct dummy_tracepoint_args {
 };
 
 __attribute__((noinline))
-static int test_long_fname_2(struct dummy_tracepoint_args *arg)
+int test_long_fname_2(struct dummy_tracepoint_args *arg)
 {
 	struct ipv_counts *counts;
 	int key = 0;
@@ -43,7 +43,7 @@ static int test_long_fname_2(struct dumm
 }
 
 __attribute__((noinline))
-static int test_long_fname_1(struct dummy_tracepoint_args *arg)
+int test_long_fname_1(struct dummy_tracepoint_args *arg)
 {
 	return test_long_fname_2(arg);
 }
--- a/tools/testing/selftests/bpf/progs/test_btf_newkv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
@@ -33,7 +33,7 @@ struct dummy_tracepoint_args {
 };
 
 __attribute__((noinline))
-static int test_long_fname_2(struct dummy_tracepoint_args *arg)
+int test_long_fname_2(struct dummy_tracepoint_args *arg)
 {
 	struct ipv_counts *counts;
 	int key = 0;
@@ -56,7 +56,7 @@ static int test_long_fname_2(struct dumm
 }
 
 __attribute__((noinline))
-static int test_long_fname_1(struct dummy_tracepoint_args *arg)
+int test_long_fname_1(struct dummy_tracepoint_args *arg)
 {
 	return test_long_fname_2(arg);
 }
--- a/tools/testing/selftests/bpf/progs/test_btf_nokv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_nokv.c
@@ -23,7 +23,7 @@ struct dummy_tracepoint_args {
 };
 
 __attribute__((noinline))
-static int test_long_fname_2(struct dummy_tracepoint_args *arg)
+int test_long_fname_2(struct dummy_tracepoint_args *arg)
 {
 	struct ipv_counts *counts;
 	int key = 0;
@@ -41,7 +41,7 @@ static int test_long_fname_2(struct dumm
 }
 
 __attribute__((noinline))
-static int test_long_fname_1(struct dummy_tracepoint_args *arg)
+int test_long_fname_1(struct dummy_tracepoint_args *arg)
 {
 	return test_long_fname_2(arg);
 }


