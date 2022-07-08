Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B92B56B85E
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 13:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiGHLXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 07:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbiGHLXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 07:23:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A94ABC93
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 04:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F328624B0
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA73C341CA;
        Fri,  8 Jul 2022 11:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657279413;
        bh=Dqg3RpJ1JUyLm+N9dFWi2PGTvXtL1aKPbUb4NjmyTcE=;
        h=Subject:To:Cc:From:Date:From;
        b=NhTa3QsDApw58tjgdxKIrdGvUbDhlCVv//P/dSRsHPM0Dx3BA4m5RgC3H/htykQj5
         Mo7RpebsxfvUfOB1FzFXCciG35+XZ5tJ8T0ESXM7gJMWtmkJX7m0VlqEaKLKeg9kVr
         eUjk8IE+BC03/8lFR2NDaNDQnyGqsKkvDkCib5Fs=
Subject: FAILED: patch "[PATCH] bpf: Fix insufficient bounds propagation from" failed to apply to 4.14-stable tree
To:     daniel@iogearbox.net, andrii@kernel.org, john.fastabend@gmail.com,
        liulin063@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 08 Jul 2022 13:23:30 +0200
Message-ID: <1657279410158228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3844d153a41adea718202c10ae91dc96b37453b5 Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Fri, 1 Jul 2022 14:47:25 +0200
Subject: [PATCH] bpf: Fix insufficient bounds propagation from
 adjust_scalar_min_max_vals

Kuee reported a corner case where the tnum becomes constant after the call
to __reg_bound_offset(), but the register's bounds are not, that is, its
min bounds are still not equal to the register's max bounds.

This in turn allows to leak pointers through turning a pointer register as
is into an unknown scalar via adjust_ptr_min_max_vals().

Before:

  func#0 @0
  0: R1=ctx(off=0,imm=0,umax=0,var_off=(0x0; 0x0)) R10=fp(off=0,imm=0,umax=0,var_off=(0x0; 0x0))
  0: (b7) r0 = 1                        ; R0_w=scalar(imm=1,umin=1,umax=1,var_off=(0x1; 0x0))
  1: (b7) r3 = 0                        ; R3_w=scalar(imm=0,umax=0,var_off=(0x0; 0x0))
  2: (87) r3 = -r3                      ; R3_w=scalar()
  3: (87) r3 = -r3                      ; R3_w=scalar()
  4: (47) r3 |= 32767                   ; R3_w=scalar(smin=-9223372036854743041,umin=32767,var_off=(0x7fff; 0xffffffffffff8000),s32_min=-2147450881)
  5: (75) if r3 s>= 0x0 goto pc+1       ; R3_w=scalar(umin=9223372036854808575,var_off=(0x8000000000007fff; 0x7fffffffffff8000),s32_min=-2147450881,u32_min=32767)
  6: (95) exit

  from 5 to 7: R0=scalar(imm=1,umin=1,umax=1,var_off=(0x1; 0x0)) R1=ctx(off=0,imm=0,umax=0,var_off=(0x0; 0x0)) R3=scalar(umin=32767,umax=9223372036854775807,var_off=(0x7fff; 0x7fffffffffff8000),s32_min=-2147450881) R10=fp(off=0,imm=0,umax=0,var_off=(0x0; 0x0))
  7: (d5) if r3 s<= 0x8000 goto pc+1    ; R3=scalar(umin=32769,umax=9223372036854775807,var_off=(0x7fff; 0x7fffffffffff8000),s32_min=-2147450881,u32_min=32767)
  8: (95) exit

  from 7 to 9: R0=scalar(imm=1,umin=1,umax=1,var_off=(0x1; 0x0)) R1=ctx(off=0,imm=0,umax=0,var_off=(0x0; 0x0)) R3=scalar(umin=32767,umax=32768,var_off=(0x7fff; 0x8000)) R10=fp(off=0,imm=0,umax=0,var_off=(0x0; 0x0))
  9: (07) r3 += -32767                  ; R3_w=scalar(imm=0,umax=1,var_off=(0x0; 0x0))  <--- [*]
  10: (95) exit

What can be seen here is that R3=scalar(umin=32767,umax=32768,var_off=(0x7fff;
0x8000)) after the operation R3 += -32767 results in a 'malformed' constant, that
is, R3_w=scalar(imm=0,umax=1,var_off=(0x0; 0x0)). Intersecting with var_off has
not been done at that point via __update_reg_bounds(), which would have improved
the umax to be equal to umin.

Refactor the tnum <> min/max bounds information flow into a reg_bounds_sync()
helper and use it consistently everywhere. After the fix, bounds have been
corrected to R3_w=scalar(imm=0,umax=0,var_off=(0x0; 0x0)) and thus the register
is regarded as a 'proper' constant scalar of 0.

After:

  func#0 @0
  0: R1=ctx(off=0,imm=0,umax=0,var_off=(0x0; 0x0)) R10=fp(off=0,imm=0,umax=0,var_off=(0x0; 0x0))
  0: (b7) r0 = 1                        ; R0_w=scalar(imm=1,umin=1,umax=1,var_off=(0x1; 0x0))
  1: (b7) r3 = 0                        ; R3_w=scalar(imm=0,umax=0,var_off=(0x0; 0x0))
  2: (87) r3 = -r3                      ; R3_w=scalar()
  3: (87) r3 = -r3                      ; R3_w=scalar()
  4: (47) r3 |= 32767                   ; R3_w=scalar(smin=-9223372036854743041,umin=32767,var_off=(0x7fff; 0xffffffffffff8000),s32_min=-2147450881)
  5: (75) if r3 s>= 0x0 goto pc+1       ; R3_w=scalar(umin=9223372036854808575,var_off=(0x8000000000007fff; 0x7fffffffffff8000),s32_min=-2147450881,u32_min=32767)
  6: (95) exit

  from 5 to 7: R0=scalar(imm=1,umin=1,umax=1,var_off=(0x1; 0x0)) R1=ctx(off=0,imm=0,umax=0,var_off=(0x0; 0x0)) R3=scalar(umin=32767,umax=9223372036854775807,var_off=(0x7fff; 0x7fffffffffff8000),s32_min=-2147450881) R10=fp(off=0,imm=0,umax=0,var_off=(0x0; 0x0))
  7: (d5) if r3 s<= 0x8000 goto pc+1    ; R3=scalar(umin=32769,umax=9223372036854775807,var_off=(0x7fff; 0x7fffffffffff8000),s32_min=-2147450881,u32_min=32767)
  8: (95) exit

  from 7 to 9: R0=scalar(imm=1,umin=1,umax=1,var_off=(0x1; 0x0)) R1=ctx(off=0,imm=0,umax=0,var_off=(0x0; 0x0)) R3=scalar(umin=32767,umax=32768,var_off=(0x7fff; 0x8000)) R10=fp(off=0,imm=0,umax=0,var_off=(0x0; 0x0))
  9: (07) r3 += -32767                  ; R3_w=scalar(imm=0,umax=0,var_off=(0x0; 0x0))  <--- [*]
  10: (95) exit

Fixes: b03c9f9fdc37 ("bpf/verifier: track signed and unsigned min/max values")
Reported-by: Kuee K1r0a <liulin063@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220701124727.11153-2-daniel@iogearbox.net

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ec164b3c0fa2..0efbac0fd126 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1562,6 +1562,21 @@ static void __reg_bound_offset(struct bpf_reg_state *reg)
 	reg->var_off = tnum_or(tnum_clear_subreg(var64_off), var32_off);
 }
 
+static void reg_bounds_sync(struct bpf_reg_state *reg)
+{
+	/* We might have learned new bounds from the var_off. */
+	__update_reg_bounds(reg);
+	/* We might have learned something about the sign bit. */
+	__reg_deduce_bounds(reg);
+	/* We might have learned some bits from the bounds. */
+	__reg_bound_offset(reg);
+	/* Intersecting with the old var_off might have improved our bounds
+	 * slightly, e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
+	 * then new var_off is (0; 0x7f...fc) which improves our umax.
+	 */
+	__update_reg_bounds(reg);
+}
+
 static bool __reg32_bound_s64(s32 a)
 {
 	return a >= 0 && a <= S32_MAX;
@@ -1603,16 +1618,8 @@ static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
 		 * so they do not impact tnum bounds calculation.
 		 */
 		__mark_reg64_unbounded(reg);
-		__update_reg_bounds(reg);
 	}
-
-	/* Intersecting with the old var_off might have improved our bounds
-	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
-	 * then new var_off is (0; 0x7f...fc) which improves our umax.
-	 */
-	__reg_deduce_bounds(reg);
-	__reg_bound_offset(reg);
-	__update_reg_bounds(reg);
+	reg_bounds_sync(reg);
 }
 
 static bool __reg64_bound_s32(s64 a)
@@ -1628,7 +1635,6 @@ static bool __reg64_bound_u32(u64 a)
 static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
 {
 	__mark_reg32_unbounded(reg);
-
 	if (__reg64_bound_s32(reg->smin_value) && __reg64_bound_s32(reg->smax_value)) {
 		reg->s32_min_value = (s32)reg->smin_value;
 		reg->s32_max_value = (s32)reg->smax_value;
@@ -1637,14 +1643,7 @@ static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
 		reg->u32_min_value = (u32)reg->umin_value;
 		reg->u32_max_value = (u32)reg->umax_value;
 	}
-
-	/* Intersecting with the old var_off might have improved our bounds
-	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
-	 * then new var_off is (0; 0x7f...fc) which improves our umax.
-	 */
-	__reg_deduce_bounds(reg);
-	__reg_bound_offset(reg);
-	__update_reg_bounds(reg);
+	reg_bounds_sync(reg);
 }
 
 /* Mark a register as having a completely unknown (scalar) value. */
@@ -6943,9 +6942,7 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
 	ret_reg->s32_max_value = meta->msize_max_value;
 	ret_reg->smin_value = -MAX_ERRNO;
 	ret_reg->s32_min_value = -MAX_ERRNO;
-	__reg_deduce_bounds(ret_reg);
-	__reg_bound_offset(ret_reg);
-	__update_reg_bounds(ret_reg);
+	reg_bounds_sync(ret_reg);
 }
 
 static int
@@ -8202,11 +8199,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	if (!check_reg_sane_offset(env, dst_reg, ptr_reg->type))
 		return -EINVAL;
-
-	__update_reg_bounds(dst_reg);
-	__reg_deduce_bounds(dst_reg);
-	__reg_bound_offset(dst_reg);
-
+	reg_bounds_sync(dst_reg);
 	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
 		return -EACCES;
 	if (sanitize_needed(opcode)) {
@@ -8944,10 +8937,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	/* ALU32 ops are zero extended into 64bit register */
 	if (alu32)
 		zext_32_to_64(dst_reg);
-
-	__update_reg_bounds(dst_reg);
-	__reg_deduce_bounds(dst_reg);
-	__reg_bound_offset(dst_reg);
+	reg_bounds_sync(dst_reg);
 	return 0;
 }
 
@@ -9136,10 +9126,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 							 insn->dst_reg);
 				}
 				zext_32_to_64(dst_reg);
-
-				__update_reg_bounds(dst_reg);
-				__reg_deduce_bounds(dst_reg);
-				__reg_bound_offset(dst_reg);
+				reg_bounds_sync(dst_reg);
 			}
 		} else {
 			/* case: R = imm
@@ -9742,21 +9729,8 @@ static void __reg_combine_min_max(struct bpf_reg_state *src_reg,
 							dst_reg->smax_value);
 	src_reg->var_off = dst_reg->var_off = tnum_intersect(src_reg->var_off,
 							     dst_reg->var_off);
-	/* We might have learned new bounds from the var_off. */
-	__update_reg_bounds(src_reg);
-	__update_reg_bounds(dst_reg);
-	/* We might have learned something about the sign bit. */
-	__reg_deduce_bounds(src_reg);
-	__reg_deduce_bounds(dst_reg);
-	/* We might have learned some bits from the bounds. */
-	__reg_bound_offset(src_reg);
-	__reg_bound_offset(dst_reg);
-	/* Intersecting with the old var_off might have improved our bounds
-	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
-	 * then new var_off is (0; 0x7f...fc) which improves our umax.
-	 */
-	__update_reg_bounds(src_reg);
-	__update_reg_bounds(dst_reg);
+	reg_bounds_sync(src_reg);
+	reg_bounds_sync(dst_reg);
 }
 
 static void reg_combine_min_max(struct bpf_reg_state *true_src,

