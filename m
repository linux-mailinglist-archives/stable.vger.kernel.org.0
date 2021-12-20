Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3C147AED7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbhLTPEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240300AbhLTPCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:02:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF7BC08EE25;
        Mon, 20 Dec 2021 06:51:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BF52B80EED;
        Mon, 20 Dec 2021 14:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA47BC36AE8;
        Mon, 20 Dec 2021 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011906;
        bh=PDjuPzImbdm+3W1a23MyASLqV+xE0pBSOyY5oiu7Ko0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuM50WsWP6i8prxgh1WVGI85EwOURRvmsE5GNKVMnhOu7uQG3+eYAzR34OUpEwU58
         bfBL04KigJt8J66Ai+wl65dzhFOg2eTk+V+Blj4NUTwEu4rLfmPNwJ6A3FveQ8g3HS
         0wNVjUr6IUsdTcMlOddMCBgTg/trD2yPUY1i4eTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 017/177] bpf, selftests: Add test case trying to taint map value pointer
Date:   Mon, 20 Dec 2021 15:32:47 +0100
Message-Id: <20211220143040.647959041@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit b1a7288dedc6caf9023f2676b4f5ed34cf0d4029 upstream.

Add a test case which tries to taint map value pointer arithmetic into a
unknown scalar with subsequent export through the map.

Before fix:

  # ./test_verifier 1186
  #1186/u map access: trying to leak tained dst reg FAIL
  Unexpected success to load!
  verification time 24 usec
  stack depth 8
  processed 15 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 1
  #1186/p map access: trying to leak tained dst reg FAIL
  Unexpected success to load!
  verification time 8 usec
  stack depth 8
  processed 15 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 1
  Summary: 0 PASSED, 0 SKIPPED, 2 FAILED

After fix:

  # ./test_verifier 1186
  #1186/u map access: trying to leak tained dst reg OK
  #1186/p map access: trying to leak tained dst reg OK
  Summary: 2 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c |   23 +++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -1078,6 +1078,29 @@
 	.errstr_unpriv = "R0 pointer -= pointer prohibited",
 },
 {
+	"map access: trying to leak tained dst reg",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_MOV32_IMM(BPF_REG_1, 0xFFFFFFFF),
+	BPF_MOV32_REG(BPF_REG_1, BPF_REG_1),
+	BPF_ALU64_REG(BPF_SUB, BPF_REG_2, BPF_REG_1),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_array_48b = { 4 },
+	.result = REJECT,
+	.errstr = "math between map_value pointer and 4294967295 is not allowed",
+},
+{
 	"32bit pkt_ptr -= scalar",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_8, BPF_REG_1,


