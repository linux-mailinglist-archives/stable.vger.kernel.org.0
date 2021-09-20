Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1B6411FC3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348934AbhITRpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353032AbhITRnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:43:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 870C261B73;
        Mon, 20 Sep 2021 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157755;
        bh=Ya1hswu0XwHbdQRGD+GudeTZTgcg2a4tO2uO/9KUCTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abPDJNPduytaR9YvWG4/U4xqVhpAS8z/3lrDeP1Fu0r2iZDBBOQpHyriF/4BBjDs7
         DpfPKZaN2UeuHR3z+DrTJFOlIb/uPVmE99JJXcbjhwsU5y2sFeSm6N+SmJ1z0/mb5O
         URkrHU49bFj43arfdRiX+/D7NpWk3//rRBW/y1PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 135/293] selftests/bpf: fix tests due to const spill/fill
Date:   Mon, 20 Sep 2021 18:41:37 +0200
Message-Id: <20210920163937.901309320@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit fc559a70d57c6ee5443f7a750858503e94cdc941 upstream.

fix tests that incorrectly assumed that the verifier
cannot track constants through stack.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   31 +++++++++++++++-------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -3888,7 +3888,8 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, data)),
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct __sk_buff, data_end)),
-			BPF_MOV64_IMM(BPF_REG_0, 0xffffffff),
+			BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct __sk_buff, mark)),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_10, -8),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_0, 0xffff),
@@ -6560,9 +6561,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, bitwise AND, zero included",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 64),
@@ -6577,9 +6578,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, bitwise AND + JMP, wrong max",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 65),
@@ -6653,9 +6654,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP, bounds + offset",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_JMP_IMM(BPF_JGT, BPF_REG_2, 64, 5),
@@ -6674,9 +6675,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP, wrong max",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_JMP_IMM(BPF_JGT, BPF_REG_2, 65, 4),
@@ -6694,9 +6695,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP, no max check",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_MOV64_IMM(BPF_REG_4, 0),
@@ -6714,9 +6715,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP, no min check",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_JMP_IMM(BPF_JGT, BPF_REG_2, 64, 3),
@@ -6732,9 +6733,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP (signed), no min check",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_JMP_IMM(BPF_JSGT, BPF_REG_2, 64, 3),
@@ -6776,6 +6777,7 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: map, JMP, wrong max",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
 			BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
@@ -6783,7 +6785,7 @@ static struct bpf_test tests[] = {
 			BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
 			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 10),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
-			BPF_MOV64_IMM(BPF_REG_2, sizeof(struct test_val)),
+			BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
 			BPF_JMP_IMM(BPF_JSGT, BPF_REG_2,
@@ -6795,7 +6797,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		.fixup_map2 = { 3 },
+		.fixup_map2 = { 4 },
 		.errstr = "invalid access to map value, value_size=48 off=0 size=49",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_TRACEPOINT,
@@ -6830,6 +6832,7 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: map adjusted, JMP, wrong max",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
 			BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
@@ -6838,7 +6841,7 @@ static struct bpf_test tests[] = {
 			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 11),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 20),
-			BPF_MOV64_IMM(BPF_REG_2, sizeof(struct test_val)),
+			BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
 			BPF_JMP_IMM(BPF_JSGT, BPF_REG_2,
@@ -6850,7 +6853,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		.fixup_map2 = { 3 },
+		.fixup_map2 = { 4 },
 		.errstr = "R1 min value is outside of the array range",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_TRACEPOINT,
@@ -6872,8 +6875,8 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: size > 0 not allowed on NULL (ARG_PTR_TO_MEM_OR_NULL)",
 		.insns = {
+			BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
 			BPF_MOV64_IMM(BPF_REG_1, 0),
-			BPF_MOV64_IMM(BPF_REG_2, 1),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 64),
@@ -7100,6 +7103,7 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: 8 bytes leak",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
@@ -7110,7 +7114,6 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -24),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
-			BPF_MOV64_IMM(BPF_REG_2, 1),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 63),


