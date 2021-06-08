Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD08F3A006E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhFHSnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235040AbhFHSlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:41:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32FF5613BF;
        Tue,  8 Jun 2021 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177303;
        bh=FhD0RDeS7zx9ToFH24j+dUp1eNULH0FcQLKRd8sWVIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+jfIwifv9B+0u1gWsOy1QxGV7spBvE6k/rBa/I/hoWVFXdZ5hrAdh2Y/ztI3NJJh
         IEMRfm2Mko0ou5uvLpMuzfZncb1UpYHxkTyTN82XgbhDs9zTbdQSQuSVPofc7r/EPe
         dSFbZoV4OL/Y4jUeMNxShoepP5Q/RzLjXi5RI7L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 4.19 45/58] bpf: Make more use of any alignment in test_verifier.c
Date:   Tue,  8 Jun 2021 20:27:26 +0200
Message-Id: <20210608175933.759319841@linuxfoundation.org>
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

From: "David S. Miller" <davem@davemloft.net>

commit 2acc5fd5b8c25df0de7f3c8b8e385f5c6f8202ec upstream

Use F_NEEDS_EFFICIENT_UNALIGNED_ACCESS in more tests where the
expected result is REJECT.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   41 ++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1799,6 +1799,7 @@ static struct bpf_test tests[] = {
 		.errstr = "invalid bpf_context access",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_SK_MSG,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"direct packet read for SK_MSG",
@@ -2191,6 +2192,7 @@ static struct bpf_test tests[] = {
 		},
 		.errstr = "invalid bpf_context access",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"check cb access: half, wrong type",
@@ -3151,6 +3153,7 @@ static struct bpf_test tests[] = {
 		.result = REJECT,
 		.errstr = "R0 invalid mem access 'inv'",
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"raw_stack: skb_load_bytes, spilled regs corruption 2",
@@ -3181,6 +3184,7 @@ static struct bpf_test tests[] = {
 		.result = REJECT,
 		.errstr = "R3 invalid mem access 'inv'",
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"raw_stack: skb_load_bytes, spilled regs + data",
@@ -3680,6 +3684,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R2 invalid mem access 'inv'",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"direct packet access: test16 (arith on data_end)",
@@ -3863,6 +3868,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.result = REJECT,
 		.errstr = "invalid access to packet, off=0 size=8, R5(id=1,off=0,r=0)",
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"direct packet access: test24 (x += pkt_ptr, 5)",
@@ -4767,6 +4773,7 @@ static struct bpf_test tests[] = {
 		.result = REJECT,
 		.errstr = "invalid access to map value, value_size=64 off=-2 size=4",
 		.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"invalid cgroup storage access 5",
@@ -6433,6 +6440,7 @@ static struct bpf_test tests[] = {
 		.errstr = "invalid mem access 'inv'",
 		.result = REJECT,
 		.result_unpriv = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"map element value illegal alu op, 5",
@@ -6455,6 +6463,7 @@ static struct bpf_test tests[] = {
 		.fixup_map2 = { 3 },
 		.errstr = "R0 invalid mem access 'inv'",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"map element value is preserved across register spilling",
@@ -8951,6 +8960,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_end > pkt_data', good access",
@@ -8989,6 +8999,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_end > pkt_data', bad access 2",
@@ -9007,6 +9018,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data' < pkt_end, good access",
@@ -9045,6 +9057,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data' < pkt_end, bad access 2",
@@ -9063,6 +9076,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_end < pkt_data', good access",
@@ -9117,6 +9131,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data' >= pkt_end, good access",
@@ -9153,6 +9168,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data' >= pkt_end, bad access 2",
@@ -9228,6 +9244,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data' <= pkt_end, good access",
@@ -9284,6 +9301,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_end <= pkt_data', good access",
@@ -9320,6 +9338,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_end <= pkt_data', bad access 2",
@@ -9393,6 +9412,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data > pkt_meta', good access",
@@ -9431,6 +9451,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data > pkt_meta', bad access 2",
@@ -9449,6 +9470,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_meta' < pkt_data, good access",
@@ -9487,6 +9509,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_meta' < pkt_data, bad access 2",
@@ -9505,6 +9528,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data < pkt_meta', good access",
@@ -9559,6 +9583,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_meta' >= pkt_data, good access",
@@ -9595,6 +9620,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_meta' >= pkt_data, bad access 2",
@@ -9670,6 +9696,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_meta' <= pkt_data, good access",
@@ -9726,6 +9753,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data <= pkt_meta', good access",
@@ -9762,6 +9790,7 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 offset is outside of the packet",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data <= pkt_meta', bad access 2",
@@ -9876,6 +9905,7 @@ static struct bpf_test tests[] = {
 		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "dereference of modified ctx ptr",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"check deducing bounds from const, 8",
@@ -9890,6 +9920,7 @@ static struct bpf_test tests[] = {
 		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "dereference of modified ctx ptr",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"check deducing bounds from const, 9",
@@ -10365,6 +10396,7 @@ static struct bpf_test tests[] = {
 		.result = REJECT,
 		.errstr = "R6 invalid mem access 'inv'",
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: two calls with args",
@@ -11230,6 +11262,7 @@ static struct bpf_test tests[] = {
 		.fixup_map1 = { 12, 22 },
 		.result = REJECT,
 		.errstr = "invalid access to map value, value_size=8 off=2 size=8",
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: two calls that receive map_value via arg=ptr_stack_of_caller. test2",
@@ -11373,6 +11406,7 @@ static struct bpf_test tests[] = {
 		.fixup_map1 = { 12, 22 },
 		.result = REJECT,
 		.errstr = "invalid access to map value, value_size=8 off=2 size=8",
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: two calls that receive map_value_ptr_or_null via arg. test1",
@@ -11544,6 +11578,7 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.retval = POINTER_VALUE,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: pkt_ptr spill into caller stack 2",
@@ -11575,6 +11610,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.errstr = "invalid access to packet",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: pkt_ptr spill into caller stack 3",
@@ -11677,6 +11713,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.errstr = "same insn cannot be used with different",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: pkt_ptr spill into caller stack 6",
@@ -11712,6 +11749,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.errstr = "R4 invalid mem access",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: pkt_ptr spill into caller stack 7",
@@ -11746,6 +11784,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.errstr = "R4 invalid mem access",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: pkt_ptr spill into caller stack 8",
@@ -11827,6 +11866,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.errstr = "invalid access to packet",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: caller stack init to zero or map_value_or_null",
@@ -12192,6 +12232,7 @@ static struct bpf_test tests[] = {
 		.result = REJECT,
 		.errstr = "BPF_XADD stores into R2 packet",
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"xadd/w check whether src/dst got mangled, 1",


