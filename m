Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F070397F84
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 05:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFBDaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 23:30:08 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45868 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231213AbhFBDaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 23:30:06 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH0O6+rZgh7MIAA--.9496S8;
        Wed, 02 Jun 2021 11:28:16 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 6/9] bpf: Make more use of 'any' alignment in test_verifier.c
Date:   Wed,  2 Jun 2021 11:27:50 +0800
Message-Id: <1622604473-781-7-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxH0O6+rZgh7MIAA--.9496S8
X-Coremail-Antispam: 1UD129KBjvJXoW3Cry7KrWkWF13GF18tw15twb_yoWkZF4Upw
        47Aa9IvF4kta1fAryxA3WDCFs5WrWYgry7CanrK340yasa9rWUJF1jgFWkArn0gFWFyw4I
        yr15trs7ua13Xw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBab7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
        jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI
        8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2
        z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
        AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1l
        Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8GwCF04k20x
        vY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I
        3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIx
        AIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAI
        cVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07brtxDUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
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
---
 tools/testing/selftests/bpf/test_verifier.c | 41 +++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 686f5d1..a402121 100644
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
-- 
2.1.0

