Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E664547260C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbhLMJsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:48:51 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38922 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbhLMJqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:46:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52535CE0E93;
        Mon, 13 Dec 2021 09:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C5EC00446;
        Mon, 13 Dec 2021 09:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388781;
        bh=wVjwqELeO4GSWdRg1zD8OEFEc3ea2jB8SpW09lMJW74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kiXVH3xqA5VuaNiE2/jBzbOFHs07hD5T9CmYKA9UeEJKwpMziY4CFR8nt3+cDPmBz
         I2UM43j/f22WNLDr/E8ujvFw1F4Kg4ey/GoCQBm9pL8XJ8M3qAKR3x7F3siwiqwb5X
         1Tn1Esy+G6EyvXeOFF4gkP4YnbvS4BYVmM+Tz0TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 88/88] bpf: Add selftests to cover packet access corner cases
Date:   Mon, 13 Dec 2021 10:30:58 +0100
Message-Id: <20211213092936.236660507@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

commit b560b21f71eb4ef9dfc7c8ec1d0e4d7f9aa54b51 upstream.

This commit adds BPF verifier selftests that cover all corner cases by
packet boundary checks. Specifically, 8-byte packet reads are tested at
the beginning of data and at the beginning of data_meta, using all kinds
of boundary checks (all comparison operators: <, >, <=, >=; both
permutations of operands: data + length compared to end, end compared to
data + length). For each case there are three tests:

1. Length is just enough for an 8-byte read. Length is either 7 or 8,
   depending on the comparison.

2. Length is increased by 1 - should still pass the verifier. These
   cases are useful, because they failed before commit 2fa7d94afc1a
   ("bpf: Fix the off-by-two error in range markings").

3. Length is decreased by 1 - should be rejected by the verifier.

Some existing tests are just renamed to avoid duplication.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211207081521.41923-1-maximmi@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c |  600 +++++++++-
 1 file changed, 584 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
+++ b/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
@@ -35,7 +35,7 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 },
 {
-	"XDP pkt read, pkt_data' > pkt_end, good access",
+	"XDP pkt read, pkt_data' > pkt_end, corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -88,6 +88,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
+	"XDP pkt read, pkt_data' > pkt_end, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' > pkt_end, corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
 	"XDP pkt read, pkt_end > pkt_data', good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
@@ -106,7 +141,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_end > pkt_data', bad access 1",
+	"XDP pkt read, pkt_end > pkt_data', corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -143,6 +178,42 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
+	"XDP pkt read, pkt_end > pkt_data', corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end > pkt_data', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
 	"XDP pkt read, pkt_data' < pkt_end, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
@@ -161,7 +232,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data' < pkt_end, bad access 1",
+	"XDP pkt read, pkt_data' < pkt_end, corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -198,7 +269,43 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_end < pkt_data', good access",
+	"XDP pkt read, pkt_data' < pkt_end, corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' < pkt_end, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end < pkt_data', corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -251,6 +358,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
+	"XDP pkt read, pkt_end < pkt_data', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end < pkt_data', corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
 	"XDP pkt read, pkt_data' >= pkt_end, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
@@ -268,7 +410,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data' >= pkt_end, bad access 1",
+	"XDP pkt read, pkt_data' >= pkt_end, corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -304,7 +446,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_end >= pkt_data', good access",
+	"XDP pkt read, pkt_data' >= pkt_end, corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' >= pkt_end, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end >= pkt_data', corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -359,7 +535,44 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data' <= pkt_end, good access",
+	"XDP pkt read, pkt_end >= pkt_data', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end >= pkt_data', corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' <= pkt_end, corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -414,6 +627,43 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
+	"XDP pkt read, pkt_data' <= pkt_end, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' <= pkt_end, corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
 	"XDP pkt read, pkt_end <= pkt_data', good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
@@ -431,7 +681,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_end <= pkt_data', bad access 1",
+	"XDP pkt read, pkt_end <= pkt_data', corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -467,7 +717,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_meta' > pkt_data, good access",
+	"XDP pkt read, pkt_end <= pkt_data', corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end <= pkt_data', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' > pkt_data, corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -520,6 +804,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
+	"XDP pkt read, pkt_meta' > pkt_data, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' > pkt_data, corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
 	"XDP pkt read, pkt_data > pkt_meta', good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
@@ -538,7 +857,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data > pkt_meta', bad access 1",
+	"XDP pkt read, pkt_data > pkt_meta', corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -575,6 +894,42 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
+	"XDP pkt read, pkt_data > pkt_meta', corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data > pkt_meta', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
 	"XDP pkt read, pkt_meta' < pkt_data, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
@@ -593,7 +948,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_meta' < pkt_data, bad access 1",
+	"XDP pkt read, pkt_meta' < pkt_data, corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -630,7 +985,43 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data < pkt_meta', good access",
+	"XDP pkt read, pkt_meta' < pkt_data, corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' < pkt_data, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data < pkt_meta', corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -683,6 +1074,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
+	"XDP pkt read, pkt_data < pkt_meta', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data < pkt_meta', corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
 	"XDP pkt read, pkt_meta' >= pkt_data, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
@@ -700,7 +1126,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_meta' >= pkt_data, bad access 1",
+	"XDP pkt read, pkt_meta' >= pkt_data, corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -736,7 +1162,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data >= pkt_meta', good access",
+	"XDP pkt read, pkt_meta' >= pkt_data, corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' >= pkt_data, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data >= pkt_meta', corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -791,7 +1251,44 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_meta' <= pkt_data, good access",
+	"XDP pkt read, pkt_data >= pkt_meta', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data >= pkt_meta', corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' <= pkt_data, corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -846,6 +1343,43 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
+	"XDP pkt read, pkt_meta' <= pkt_data, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' <= pkt_data, corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
 	"XDP pkt read, pkt_data <= pkt_meta', good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
@@ -863,7 +1397,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data <= pkt_meta', bad access 1",
+	"XDP pkt read, pkt_data <= pkt_meta', corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -898,3 +1432,37 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_data <= pkt_meta', corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data <= pkt_meta', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},


