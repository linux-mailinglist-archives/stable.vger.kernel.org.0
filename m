Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F96468D914
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjBGNPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbjBGNPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:15:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0133BD8F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:15:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69F15611AA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734CEC433D2;
        Tue,  7 Feb 2023 13:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775682;
        bh=7babElETrdkgrPFTxFSououFNKzkmO7nRtQrIEGi7Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvIPIFjpRji8YhWFLaRdey3cwdlParjapMu9opV+J6xxhIFgEBIe/30evdYz51NOX
         2GzyleeB2Gksko5ATxIoCSmEZktTQnG0Wd2rw7JLwYERFxKxzpNLaKhrQq4NIYcRPq
         +AID/AGPjkASf+aQkWMMiDGnK3qUpRitFyuJUdXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Chaignon <paul@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 109/120] bpf: Fix incorrect state pruning for <8B spill/fill
Date:   Tue,  7 Feb 2023 13:58:00 +0100
Message-Id: <20230207125623.405260901@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Chaignon <paul@isovalent.com>

commit 345e004d023343d38088fdfea39688aa11e06ccf upstream.

Commit 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
introduced support in the verifier to track <8B spill/fills of scalars.
The backtracking logic for the precision bit was however skipping
spill/fills of less than 8B. That could cause state pruning to consider
two states equivalent when they shouldn't be.

As an example, consider the following bytecode snippet:

  0:  r7 = r1
  1:  call bpf_get_prandom_u32
  2:  r6 = 2
  3:  if r0 == 0 goto pc+1
  4:  r6 = 3
  ...
  8: [state pruning point]
  ...
  /* u32 spill/fill */
  10: *(u32 *)(r10 - 8) = r6
  11: r8 = *(u32 *)(r10 - 8)
  12: r0 = 0
  13: if r8 == 3 goto pc+1
  14: r0 = 1
  15: exit

The verifier first walks the path with R6=3. Given the support for <8B
spill/fills, at instruction 13, it knows the condition is true and skips
instruction 14. At that point, the backtracking logic kicks in but stops
at the fill instruction since it only propagates the precision bit for
8B spill/fill. When the verifier then walks the path with R6=2, it will
consider it safe at instruction 8 because R6 is not marked as needing
precision. Instruction 14 is thus never walked and is then incorrectly
removed as 'dead code'.

It's also possible to lead the verifier to accept e.g. an out-of-bound
memory access instead of causing an incorrect dead code elimination.

This regression was found via Cilium's bpf-next CI where it was causing
a conntrack map update to be silently skipped because the code had been
removed by the verifier.

This commit fixes it by enabling support for <8B spill/fills in the
bactracking logic. In case of a <8B spill/fill, the full 8B stack slot
will be marked as needing precision. Then, in __mark_chain_precision,
any tracked register spilled in a marked slot will itself be marked as
needing precision, regardless of the spill size. This logic makes two
assumptions: (1) only 8B-aligned spill/fill are tracked and (2) spilled
registers are only tracked if the spill and fill sizes are equal. Commit
ef979017b837 ("bpf: selftest: Add verifier tests for <8-byte scalar
spill and refill") covers the first assumption and the next commit in
this patchset covers the second.

Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
Signed-off-by: Paul Chaignon <paul@isovalent.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2224,8 +2224,6 @@ static int backtrack_insn(struct bpf_ver
 		 */
 		if (insn->src_reg != BPF_REG_FP)
 			return 0;
-		if (BPF_SIZE(insn->code) != BPF_DW)
-			return 0;
 
 		/* dreg = *(u64 *)[fp - off] was a fill from the stack.
 		 * that [fp - off] slot contains scalar that needs to be
@@ -2248,8 +2246,6 @@ static int backtrack_insn(struct bpf_ver
 		/* scalars can only be spilled into stack */
 		if (insn->dst_reg != BPF_REG_FP)
 			return 0;
-		if (BPF_SIZE(insn->code) != BPF_DW)
-			return 0;
 		spi = (-insn->off - 1) / BPF_REG_SIZE;
 		if (spi >= 64) {
 			verbose(env, "BUG spi %d\n", spi);


