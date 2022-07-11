Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADD356FC16
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiGKJiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiGKJiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:38:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5345868A6;
        Mon, 11 Jul 2022 02:19:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A6CDB80E7E;
        Mon, 11 Jul 2022 09:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF07C34115;
        Mon, 11 Jul 2022 09:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531185;
        bh=BTdRQGUwh8mubNbXUJ+N9pwfwkRy8WzOkeXYeEula2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMLbFqXt14RV3LzzdNC9XE5FJDk/S1/R1UPvhAFTTsLw6GHRTQWtFS0xFDF0JqrCn
         iYt3pUdULKCEpd8VbZDBS86hNMEuHsHToJIWo/uFZtnwqU/IhCPwVJyCjQ3hlC+q2s
         +EeXjf+xzdMHEyvBi1j7cVWZqlafX5Qp14GAwJFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuee K1r0a <liulin063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.15 015/230] bpf: Fix insufficient bounds propagation from adjust_scalar_min_max_vals
Date:   Mon, 11 Jul 2022 11:04:31 +0200
Message-Id: <20220711090604.505443679@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 3844d153a41adea718202c10ae91dc96b37453b5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   72 +++++++++++++++-----------------------------------
 1 file changed, 23 insertions(+), 49 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1333,6 +1333,21 @@ static void __reg_bound_offset(struct bp
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
@@ -1374,16 +1389,8 @@ static void __reg_combine_32_into_64(str
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
@@ -1399,7 +1406,6 @@ static bool __reg64_bound_u32(u64 a)
 static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
 {
 	__mark_reg32_unbounded(reg);
-
 	if (__reg64_bound_s32(reg->smin_value) && __reg64_bound_s32(reg->smax_value)) {
 		reg->s32_min_value = (s32)reg->smin_value;
 		reg->s32_max_value = (s32)reg->smax_value;
@@ -1408,14 +1414,7 @@ static void __reg_combine_64_into_32(str
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
@@ -6054,9 +6053,7 @@ static void do_refine_retval_range(struc
 	ret_reg->s32_max_value = meta->msize_max_value;
 	ret_reg->smin_value = -MAX_ERRNO;
 	ret_reg->s32_min_value = -MAX_ERRNO;
-	__reg_deduce_bounds(ret_reg);
-	__reg_bound_offset(ret_reg);
-	__update_reg_bounds(ret_reg);
+	reg_bounds_sync(ret_reg);
 }
 
 static int
@@ -7216,11 +7213,7 @@ reject:
 
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
@@ -7958,10 +7951,7 @@ static int adjust_scalar_min_max_vals(st
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
 
@@ -8150,10 +8140,7 @@ static int check_alu_op(struct bpf_verif
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
@@ -8756,21 +8743,8 @@ static void __reg_combine_min_max(struct
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


