Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01C53A0065
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhFHSnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234945AbhFHSky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B364613BC;
        Tue,  8 Jun 2021 18:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177306;
        bh=ySa+E50hx0t0wf7cdNP4vinnzBrxwEkjZqdIZ2QcoH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2r7lQB04fLa+7/pHqnKVQ+OZHcntnhnXYC7qvYUEHg2zt1dxziSS6Nt+QjEGxkJO
         +Lb7cyZxd7c8PCGCtGWuinb9Ea1QhQMc9rVYM4QQUS7AhJQWNDqc/7GLCtQAFJ2DNY
         Dr3MZD0jC6Lr/pWjtNSELL+xdaXil7+G0rjnhzy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 4.19 46/58] bpf: Apply F_NEEDS_EFFICIENT_UNALIGNED_ACCESS to more ACCEPT test cases.
Date:   Tue,  8 Jun 2021 20:27:27 +0200
Message-Id: <20210608175933.791780772@linuxfoundation.org>
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

commit 0a68632488aa0129ed530af9ae9e8573f5650812 upstream

If a testcase has alignment problems but is expected to be ACCEPT,
verify it using F_NEEDS_EFFICIENT_UNALIGNED_ACCESS too.

Maybe in the future if we add some architecture specific code to elide
the unaligned memory access warnings during the test, we can execute
these as well.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

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


