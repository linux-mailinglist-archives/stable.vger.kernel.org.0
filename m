Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9325168D58D
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 12:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjBGLdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 06:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjBGLdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 06:33:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5A8A24B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 03:31:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3566ECE1D79
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45366C433D2;
        Tue,  7 Feb 2023 11:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675769506;
        bh=5yDcFvDNrk4NgtaVnutjHZAXhpjcrox0i4q/ztiuD5s=;
        h=Subject:To:Cc:From:Date:From;
        b=xQ3Wx8QB1rZQNAjjEEqZKUyxq98Ihl6cvdPZsy3UumIUmdQBYjPkPIGYwNX33utBQ
         9YsECLFC4oC3nuHDsBbQL7vK8BJcRbmTsdcgC6Gts2BChBDGM/eHoetnms3x/QucQo
         kxVna7bqG0pmwLVP6mjeWCmIuniUjH1epBhtjn9I=
Subject: FAILED: patch "[PATCH] bpf: Do not reject when the stack read size is different from" failed to apply to 5.10-stable tree
To:     kafai@fb.com, daniel@iogearbox.net, hengqi.chen@gmail.com,
        yhs@fb.com, yhs@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 12:31:43 +0100
Message-ID: <1675769503122160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f30d4968e9ae ("bpf: Do not reject when the stack read size is different from the tracked scalar size")
354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
27113c59b6d0 ("bpf: Check the other end of slot_type for STACK_SPILL")
2039f26f3aca ("bpf: Fix leakage due to insufficient speculative store bypass mitigation")
01f810ace9ed ("bpf: Allow variable-offset stack access")
cd17d38f8b28 ("bpf: Permits pointers on stack for helper calls")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f30d4968e9aee737e174fc97942af46cfb49b484 Mon Sep 17 00:00:00 2001
From: Martin KaFai Lau <kafai@fb.com>
Date: Mon, 1 Nov 2021 23:45:35 -0700
Subject: [PATCH] bpf: Do not reject when the stack read size is different from
 the tracked scalar size

Below is a simplified case from a report in bcc [0]:

  r4 = 20
  *(u32 *)(r10 -4) = r4
  *(u32 *)(r10 -8) = r4  /* r4 state is tracked */
  r4 = *(u64 *)(r10 -8)  /* Read more than the tracked 32bit scalar.
			  * verifier rejects as 'corrupted spill memory'.
			  */

After commit 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill"),
the 8-byte aligned 32bit spill is also tracked by the verifier and the
register state is stored.

However, if 8 bytes are read from the stack instead of the tracked 4 byte
scalar, then verifier currently rejects the program as "corrupted spill
memory". This patch fixes this case by allowing it to read but marks the
register as unknown.

Also note that, if the prog is trying to corrupt/leak an earlier spilled
pointer by spilling another <8 bytes register on top, this has already
been rejected in the check_stack_write_fixed_off().

  [0] https://github.com/iovisor/bcc/pull/3683

Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
Reported-by: Hengqi Chen <hengqi.chen@gmail.com>
Reported-by: Yonghong Song <yhs@gmail.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211102064535.316018-1-kafai@fb.com

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f0dca726ebfd..5f8d9128860a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3088,9 +3088,12 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 	reg = &reg_state->stack[spi].spilled_ptr;
 
 	if (is_spilled_reg(&reg_state->stack[spi])) {
-		if (size != BPF_REG_SIZE) {
-			u8 scalar_size = 0;
+		u8 spill_size = 1;
+
+		for (i = BPF_REG_SIZE - 1; i > 0 && stype[i - 1] == STACK_SPILL; i--)
+			spill_size++;
 
+		if (size != BPF_REG_SIZE || spill_size != BPF_REG_SIZE) {
 			if (reg->type != SCALAR_VALUE) {
 				verbose_linfo(env, env->insn_idx, "; ");
 				verbose(env, "invalid size of register fill\n");
@@ -3101,10 +3104,7 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 			if (dst_regno < 0)
 				return 0;
 
-			for (i = BPF_REG_SIZE; i > 0 && stype[i - 1] == STACK_SPILL; i--)
-				scalar_size++;
-
-			if (!(off % BPF_REG_SIZE) && size == scalar_size) {
+			if (!(off % BPF_REG_SIZE) && size == spill_size) {
 				/* The earlier check_reg_arg() has decided the
 				 * subreg_def for this insn.  Save it first.
 				 */
@@ -3128,12 +3128,6 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 			state->regs[dst_regno].live |= REG_LIVE_WRITTEN;
 			return 0;
 		}
-		for (i = 1; i < BPF_REG_SIZE; i++) {
-			if (stype[(slot - i) % BPF_REG_SIZE] != STACK_SPILL) {
-				verbose(env, "corrupted spill memory\n");
-				return -EACCES;
-			}
-		}
 
 		if (dst_regno >= 0) {
 			/* restore register state from stack */

