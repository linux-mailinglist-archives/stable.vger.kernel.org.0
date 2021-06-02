Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2D5397F87
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 05:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhFBDaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 23:30:10 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45896 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231213AbhFBDaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 23:30:10 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH0O6+rZgh7MIAA--.9496S9;
        Wed, 02 Jun 2021 11:28:19 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 7/9] bpf: Apply F_NEEDS_EFFICIENT_UNALIGNED_ACCESS to more ACCEPT test cases.
Date:   Wed,  2 Jun 2021 11:27:51 +0800
Message-Id: <1622604473-781-8-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxH0O6+rZgh7MIAA--.9496S9
X-Coremail-Antispam: 1UD129KBjvJXoWxCFykGw43ZFWDKF1ktry3CFg_yoWrtrW3pa
        17Aa90vF48Ka17JFWfAa129F4rWrZYqrW7CanFk34jvas3W3yUGF4IgFWkArn5KFZYyrWx
        Ar15trs29a43XF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

commit 0a68632488aa0129ed530af9ae9e8573f5650812 upstream

If a testcase has alignment problems but is expected to be ACCEPT,
verify it using F_NEEDS_EFFICIENT_UNALIGNED_ACCESS too.

Maybe in the future if we add some architecture specific code to elide
the unaligned memory access warnings during the test, we can execute
these as well.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 tools/testing/selftests/bpf/test_verifier.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index a402121..2241e4ee 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -3787,6 +3787,7 @@ static struct bpf_test tests[] = {
 		},
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.result = ACCEPT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"direct packet access: test21 (x += pkt_ptr, 2)",
@@ -3812,6 +3813,7 @@ static struct bpf_test tests[] = {
 		},
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.result = ACCEPT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"direct packet access: test22 (x += pkt_ptr, 3)",
@@ -3842,6 +3844,7 @@ static struct bpf_test tests[] = {
 		},
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.result = ACCEPT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"direct packet access: test23 (x += pkt_ptr, 4)",
@@ -3894,6 +3897,7 @@ static struct bpf_test tests[] = {
 		},
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.result = ACCEPT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"direct packet access: test25 (marking on <, good access)",
@@ -6957,6 +6961,7 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.retval = 0 /* csum_diff of 64-byte packet */,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"helper access to variable memory: size = 0 not allowed on NULL (!ARG_PTR_TO_MEM_OR_NULL)",
@@ -8923,6 +8928,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data' > pkt_end, bad access 1",
@@ -9094,6 +9100,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_end < pkt_data', bad access 1",
@@ -9206,6 +9213,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_end >= pkt_data', bad access 1",
@@ -9263,6 +9271,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data' <= pkt_end, bad access 1",
@@ -9375,6 +9384,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_meta' > pkt_data, bad access 1",
@@ -9546,6 +9556,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data < pkt_meta', bad access 1",
@@ -9658,6 +9669,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_data >= pkt_meta', bad access 1",
@@ -9715,6 +9727,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_XDP,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"XDP pkt read, pkt_meta' <= pkt_data, bad access 1",
@@ -11646,6 +11659,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.result = ACCEPT,
 		.retval = 1,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: pkt_ptr spill into caller stack 4",
@@ -11680,6 +11694,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.result = ACCEPT,
 		.retval = 1,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: pkt_ptr spill into caller stack 5",
@@ -11825,6 +11840,7 @@ static struct bpf_test tests[] = {
 		},
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.result = ACCEPT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"calls: pkt_ptr spill into caller stack 9",
-- 
2.1.0

