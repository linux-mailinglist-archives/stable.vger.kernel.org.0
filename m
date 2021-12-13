Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D4547273E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237708AbhLMJ7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239215AbhLMJ5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:57:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9451BC0698C5;
        Mon, 13 Dec 2021 01:47:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D6AAB80E20;
        Mon, 13 Dec 2021 09:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8889FC00446;
        Mon, 13 Dec 2021 09:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388854;
        bh=RiEzAXB4xKAnpMJWR6osceKi4tVF+SfgpVR1rf1u4rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynP/BgeCVnyalt0gXQneWyMELLIPqgQBg33bYhi2cZ4ulkJnkfHvtjJfnWz1TkeD0
         yf37sLMxueY0k7vspQrCTRQzPyAxSE/hxgXb78XxEhy7f5tBXa22i3s0AUK4nb5bxK
         KxfWq3tlnMsF2K93hS5Ll0w7j4GPp3AEXHJ3t1vI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 031/132] bpf: Fix the off-by-two error in range markings
Date:   Mon, 13 Dec 2021 10:29:32 +0100
Message-Id: <20211213092940.181627577@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

commit 2fa7d94afc1afbb4d702760c058dc2d7ed30f226 upstream.

The first commit cited below attempts to fix the off-by-one error that
appeared in some comparisons with an open range. Due to this error,
arithmetically equivalent pieces of code could get different verdicts
from the verifier, for example (pseudocode):

  // 1. Passes the verifier:
  if (data + 8 > data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

  // 2. Rejected by the verifier (should still pass):
  if (data + 7 >= data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

The attempted fix, however, shifts the range by one in a wrong
direction, so the bug not only remains, but also such piece of code
starts failing in the verifier:

  // 3. Rejected by the verifier, but the check is stricter than in #1.
  if (data + 8 >= data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

The change performed by that fix converted an off-by-one bug into
off-by-two. The second commit cited below added the BPF selftests
written to ensure than code chunks like #3 are rejected, however,
they should be accepted.

This commit fixes the off-by-two error by adjusting new_range in the
right direction and fixes the tests by changing the range into the
one that should actually fail.

Fixes: fb2a311a31d3 ("bpf: fix off by one for range markings with L{T, E} patterns")
Fixes: b37242c773b2 ("bpf: add test cases to bpf selftests to cover all access tests")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211130181607.593149-1-maximmi@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c                                           |    2 
 tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c |   32 +++++-----
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7240,7 +7240,7 @@ static void find_good_pkt_pointers(struc
 
 	new_range = dst_reg->off;
 	if (range_right_open)
-		new_range--;
+		new_range++;
 
 	/* Examples for register markings:
 	 *
--- a/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
+++ b/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
@@ -112,10 +112,10 @@
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 		    offsetof(struct xdp_md, data_end)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
 	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -167,10 +167,10 @@
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 		    offsetof(struct xdp_md, data_end)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
 	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -274,9 +274,9 @@
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 		    offsetof(struct xdp_md, data_end)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -437,9 +437,9 @@
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 		    offsetof(struct xdp_md, data_end)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -544,10 +544,10 @@
 		    offsetof(struct xdp_md, data_meta)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
 	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -599,10 +599,10 @@
 		    offsetof(struct xdp_md, data_meta)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
 	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -706,9 +706,9 @@
 		    offsetof(struct xdp_md, data_meta)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -869,9 +869,9 @@
 		    offsetof(struct xdp_md, data_meta)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},


