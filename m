Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6027637C69F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhELPwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237077AbhELPsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:48:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A30EF619B2;
        Wed, 12 May 2021 15:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833071;
        bh=uYh41/BNEoCs/7OtrJYUAvJJ+6ufErYZBYJOOX9kdSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RipATnEn6mnPkApiaQ13nNUbWafQyTYK94OTbp1ybC51ssDa8tpK5Wdd3UOzesLkL
         Jb2qgyB5uhTQwCiDopUFfP1mDH0FaCFhLYsckqUTXisIg5SA6l0L4m2UiSodS2QVEO
         FccZfoBEQLz6Azn57NjgyaNjj49V4AV1CMBhwGpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 523/530] bpf: Fix alu32 const subreg bound tracking on bitwise operations
Date:   Wed, 12 May 2021 16:50:33 +0200
Message-Id: <20210512144836.937792816@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 049c4e13714ecbca567b4d5f6d563f05d431c80e upstream.

Fix a bug in the verifier's scalar32_min_max_*() functions which leads to
incorrect tracking of 32 bit bounds for the simulation of and/or/xor bitops.
When both the src & dst subreg is a known constant, then the assumption is
that scalar_min_max_*() will take care to update bounds correctly. However,
this is not the case, for example, consider a register R2 which has a tnum
of 0xffffffff00000000, meaning, lower 32 bits are known constant and in this
case of value 0x00000001. R2 is then and'ed with a register R3 which is a
64 bit known constant, here, 0x100000002.

What can be seen in line '10:' is that 32 bit bounds reach an invalid state
where {u,s}32_min_value > {u,s}32_max_value. The reason is scalar32_min_max_*()
delegates 32 bit bounds updates to scalar_min_max_*(), however, that really
only takes place when both the 64 bit src & dst register is a known constant.
Given scalar32_min_max_*() is intended to be designed as closely as possible
to scalar_min_max_*(), update the 32 bit bounds in this situation through
__mark_reg32_known() which will set all {u,s}32_{min,max}_value to the correct
constant, which is 0x00000000 after the fix (given 0x00000001 & 0x00000002 in
32 bit space). This is possible given var32_off already holds the final value
as dst_reg->var_off is updated before calling scalar32_min_max_*().

Before fix, invalid tracking of R2:

  [...]
  9: R0_w=inv1337 R1=ctx(id=0,off=0,imm=0) R2_w=inv(id=0,smin_value=-9223372036854775807 (0x8000000000000001),smax_value=9223372032559808513 (0x7fffffff00000001),umin_value=1,umax_value=0xffffffff00000001,var_off=(0x1; 0xffffffff00000000),s32_min_value=1,s32_max_value=1,u32_min_value=1,u32_max_value=1) R3_w=inv4294967298 R10=fp0
  9: (5f) r2 &= r3
  10: R0_w=inv1337 R1=ctx(id=0,off=0,imm=0) R2_w=inv(id=0,smin_value=0,smax_value=4294967296 (0x100000000),umin_value=0,umax_value=0x100000000,var_off=(0x0; 0x100000000),s32_min_value=1,s32_max_value=0,u32_min_value=1,u32_max_value=0) R3_w=inv4294967298 R10=fp0
  [...]

After fix, correct tracking of R2:

  [...]
  9: R0_w=inv1337 R1=ctx(id=0,off=0,imm=0) R2_w=inv(id=0,smin_value=-9223372036854775807 (0x8000000000000001),smax_value=9223372032559808513 (0x7fffffff00000001),umin_value=1,umax_value=0xffffffff00000001,var_off=(0x1; 0xffffffff00000000),s32_min_value=1,s32_max_value=1,u32_min_value=1,u32_max_value=1) R3_w=inv4294967298 R10=fp0
  9: (5f) r2 &= r3
  10: R0_w=inv1337 R1=ctx(id=0,off=0,imm=0) R2_w=inv(id=0,smin_value=0,smax_value=4294967296 (0x100000000),umin_value=0,umax_value=0x100000000,var_off=(0x0; 0x100000000),s32_min_value=0,s32_max_value=0,u32_min_value=0,u32_max_value=0) R3_w=inv4294967298 R10=fp0
  [...]

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Fixes: 2921c90d4718 ("bpf: Fix a verifier failure with xor")
Reported-by: Manfred Paul (@_manfp)
Reported-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6341,11 +6341,10 @@ static void scalar32_min_max_and(struct
 	s32 smin_val = src_reg->s32_min_value;
 	u32 umax_val = src_reg->u32_max_value;
 
-	/* Assuming scalar64_min_max_and will be called so its safe
-	 * to skip updating register for known 32-bit case.
-	 */
-	if (src_known && dst_known)
+	if (src_known && dst_known) {
+		__mark_reg32_known(dst_reg, var32_off.value);
 		return;
+	}
 
 	/* We get our minimum from the var_off, since that's inherently
 	 * bitwise.  Our maximum is the minimum of the operands' maxima.
@@ -6365,7 +6364,6 @@ static void scalar32_min_max_and(struct
 		dst_reg->s32_min_value = dst_reg->u32_min_value;
 		dst_reg->s32_max_value = dst_reg->u32_max_value;
 	}
-
 }
 
 static void scalar_min_max_and(struct bpf_reg_state *dst_reg,
@@ -6412,11 +6410,10 @@ static void scalar32_min_max_or(struct b
 	s32 smin_val = src_reg->s32_min_value;
 	u32 umin_val = src_reg->u32_min_value;
 
-	/* Assuming scalar64_min_max_or will be called so it is safe
-	 * to skip updating register for known case.
-	 */
-	if (src_known && dst_known)
+	if (src_known && dst_known) {
+		__mark_reg32_known(dst_reg, var32_off.value);
 		return;
+	}
 
 	/* We get our maximum from the var_off, and our minimum is the
 	 * maximum of the operands' minima
@@ -6481,11 +6478,10 @@ static void scalar32_min_max_xor(struct
 	struct tnum var32_off = tnum_subreg(dst_reg->var_off);
 	s32 smin_val = src_reg->s32_min_value;
 
-	/* Assuming scalar64_min_max_xor will be called so it is safe
-	 * to skip updating register for known case.
-	 */
-	if (src_known && dst_known)
+	if (src_known && dst_known) {
+		__mark_reg32_known(dst_reg, var32_off.value);
 		return;
+	}
 
 	/* We get both minimum and maximum from the var32_off. */
 	dst_reg->u32_min_value = var32_off.value;


