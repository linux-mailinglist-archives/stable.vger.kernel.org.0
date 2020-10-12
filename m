Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF7528B8D9
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390145AbgJLNze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389647AbgJLNpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A592076E;
        Mon, 12 Oct 2020 13:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510250;
        bh=XkTdZTGB+cbZnzxqRx5Rw1Abl+GYgDbLeWndkbHi+xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1Ld+tgCga1njFKgPO9nV23D9rY7WP42EAE5Yxr3muK0IULZLqbth64Go+kan929m
         iXzjZ5TC12BVzLpFZw+9MlOc0MMkvim5r5mVgtIWpGw+YKQI9oYfcbZSDLLxMI1WTt
         A55VUWDt03rsEuTHEtSGnMPbcMv5hhydcC8GfrXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Scannell <scannell.smn@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.8 005/124] bpf: Fix scalar32_min_max_or bounds tracking
Date:   Mon, 12 Oct 2020 15:30:09 +0200
Message-Id: <20201012133147.113274078@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 5b9fbeb75b6a98955f628e205ac26689bcb1383e upstream.

Simon reported an issue with the current scalar32_min_max_or() implementation.
That is, compared to the other 32 bit subreg tracking functions, the code in
scalar32_min_max_or() stands out that it's using the 64 bit registers instead
of 32 bit ones. This leads to bounds tracking issues, for example:

  [...]
  8: R0=map_value(id=0,off=0,ks=4,vs=48,imm=0) R10=fp0 fp-8=mmmmmmmm
  8: (79) r1 = *(u64 *)(r0 +0)
   R0=map_value(id=0,off=0,ks=4,vs=48,imm=0) R10=fp0 fp-8=mmmmmmmm
  9: R0=map_value(id=0,off=0,ks=4,vs=48,imm=0) R1_w=inv(id=0) R10=fp0 fp-8=mmmmmmmm
  9: (b7) r0 = 1
  10: R0_w=inv1 R1_w=inv(id=0) R10=fp0 fp-8=mmmmmmmm
  10: (18) r2 = 0x600000002
  12: R0_w=inv1 R1_w=inv(id=0) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  12: (ad) if r1 < r2 goto pc+1
   R0_w=inv1 R1_w=inv(id=0,umin_value=25769803778) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  13: R0_w=inv1 R1_w=inv(id=0,umin_value=25769803778) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  13: (95) exit
  14: R0_w=inv1 R1_w=inv(id=0,umax_value=25769803777,var_off=(0x0; 0x7ffffffff)) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  14: (25) if r1 > 0x0 goto pc+1
   R0_w=inv1 R1_w=inv(id=0,umax_value=0,var_off=(0x0; 0x7fffffff),u32_max_value=2147483647) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  15: R0_w=inv1 R1_w=inv(id=0,umax_value=0,var_off=(0x0; 0x7fffffff),u32_max_value=2147483647) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  15: (95) exit
  16: R0_w=inv1 R1_w=inv(id=0,umin_value=1,umax_value=25769803777,var_off=(0x0; 0x77fffffff),u32_max_value=2147483647) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  16: (47) r1 |= 0
  17: R0_w=inv1 R1_w=inv(id=0,umin_value=1,umax_value=32212254719,var_off=(0x1; 0x700000000),s32_max_value=1,u32_max_value=1) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  [...]

The bound tests on the map value force the upper unsigned bound to be 25769803777
in 64 bit (0b11000000000000000000000000000000001) and then lower one to be 1. By
using OR they are truncated and thus result in the range [1,1] for the 32 bit reg
tracker. This is incorrect given the only thing we know is that the value must be
positive and thus 2147483647 (0b1111111111111111111111111111111) at max for the
subregs. Fix it by using the {u,s}32_{min,max}_value vars instead. This also makes
sense, for example, for the case where we update dst_reg->s32_{min,max}_value in
the else branch we need to use the newly computed dst_reg->u32_{min,max}_value as
we know that these are positive. Previously, in the else branch the 64 bit values
of umin_value=1 and umax_value=32212254719 were used and latter got truncated to
be 1 as upper bound there. After the fix the subreg range is now correct:

  [...]
  8: R0=map_value(id=0,off=0,ks=4,vs=48,imm=0) R10=fp0 fp-8=mmmmmmmm
  8: (79) r1 = *(u64 *)(r0 +0)
   R0=map_value(id=0,off=0,ks=4,vs=48,imm=0) R10=fp0 fp-8=mmmmmmmm
  9: R0=map_value(id=0,off=0,ks=4,vs=48,imm=0) R1_w=inv(id=0) R10=fp0 fp-8=mmmmmmmm
  9: (b7) r0 = 1
  10: R0_w=inv1 R1_w=inv(id=0) R10=fp0 fp-8=mmmmmmmm
  10: (18) r2 = 0x600000002
  12: R0_w=inv1 R1_w=inv(id=0) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  12: (ad) if r1 < r2 goto pc+1
   R0_w=inv1 R1_w=inv(id=0,umin_value=25769803778) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  13: R0_w=inv1 R1_w=inv(id=0,umin_value=25769803778) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  13: (95) exit
  14: R0_w=inv1 R1_w=inv(id=0,umax_value=25769803777,var_off=(0x0; 0x7ffffffff)) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  14: (25) if r1 > 0x0 goto pc+1
   R0_w=inv1 R1_w=inv(id=0,umax_value=0,var_off=(0x0; 0x7fffffff),u32_max_value=2147483647) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  15: R0_w=inv1 R1_w=inv(id=0,umax_value=0,var_off=(0x0; 0x7fffffff),u32_max_value=2147483647) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  15: (95) exit
  16: R0_w=inv1 R1_w=inv(id=0,umin_value=1,umax_value=25769803777,var_off=(0x0; 0x77fffffff),u32_max_value=2147483647) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  16: (47) r1 |= 0
  17: R0_w=inv1 R1_w=inv(id=0,umin_value=1,umax_value=32212254719,var_off=(0x0; 0x77fffffff),u32_max_value=2147483647) R2_w=inv25769803778 R10=fp0 fp-8=mmmmmmmm
  [...]

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Reported-by: Simon Scannell <scannell.smn@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/verifier.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5490,8 +5490,8 @@ static void scalar32_min_max_or(struct b
 	bool src_known = tnum_subreg_is_const(src_reg->var_off);
 	bool dst_known = tnum_subreg_is_const(dst_reg->var_off);
 	struct tnum var32_off = tnum_subreg(dst_reg->var_off);
-	s32 smin_val = src_reg->smin_value;
-	u32 umin_val = src_reg->umin_value;
+	s32 smin_val = src_reg->s32_min_value;
+	u32 umin_val = src_reg->u32_min_value;
 
 	/* Assuming scalar64_min_max_or will be called so it is safe
 	 * to skip updating register for known case.
@@ -5514,8 +5514,8 @@ static void scalar32_min_max_or(struct b
 		/* ORing two positives gives a positive, so safe to
 		 * cast result into s64.
 		 */
-		dst_reg->s32_min_value = dst_reg->umin_value;
-		dst_reg->s32_max_value = dst_reg->umax_value;
+		dst_reg->s32_min_value = dst_reg->u32_min_value;
+		dst_reg->s32_max_value = dst_reg->u32_max_value;
 	}
 }
 


