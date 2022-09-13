Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CE75B78D8
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbiIMRwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiIMRvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:51:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0613E89CDD;
        Tue, 13 Sep 2022 09:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BD92B80F88;
        Tue, 13 Sep 2022 14:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CD0C433D6;
        Tue, 13 Sep 2022 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079651;
        bh=K70JH39tiKRwFDLY7T6ypiwg3RtOS38zHWLLT8EoT0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRMk/zv8DJ8dSXveia2ySIfjkSoY22vUuX0TWc439Pr8g5fWD3TWWiiB40sz4Qd82
         0BipyLcVH6I8idvTpZPEUdSH/O3DRiwnQexbisSCRU23veQRMllhKW+haRtC73uQKS
         nhQP+zRg0AxDuEJyVtyK/6eovQ6/eY3zW1oPPwe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 03/61] bpf: Fix the off-by-two error in range markings
Date:   Tue, 13 Sep 2022 16:07:05 +0200
Message-Id: <20220913140346.623139487@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
[OP: only cherry-pick selftest changes applicable to 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -7438,10 +7438,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -7494,10 +7494,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -7603,9 +7603,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -7770,9 +7770,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},


