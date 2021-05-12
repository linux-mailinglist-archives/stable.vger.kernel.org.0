Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E9D37C666
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhELPvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236340AbhELPpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:45:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 690A761448;
        Wed, 12 May 2021 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832996;
        bh=noY43Ms3frC2zVlwj4jTXqQLcktGyY7QRDoL/59cmdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xME/fh0zGU6nXKp6YU9pu1pa4lI2oiLTmK6bbXZ40UZ4dMTt+E7z7eCcM1dzEhRot
         X/q+SCn/ciLOMuWlgcIL6awNwKj+JlhltSjY2dBGy+yydAka/WgOFuaQtQuc6WVq/u
         KLOGnpjSviIgH89XQudf6cf3nH88/Nxns/vdBQzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 507/530] bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds
Date:   Wed, 12 May 2021 16:50:17 +0200
Message-Id: <20210512144836.425813399@linuxfoundation.org>
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

[ Upstream commit 10bf4e83167cc68595b85fd73bb91e8f2c086e36 ]

Similarly as b02709587ea3 ("bpf: Fix propagation of 32-bit signed bounds
from 64-bit bounds."), we also need to fix the propagation of 32 bit
unsigned bounds from 64 bit counterparts. That is, really only set the
u32_{min,max}_value when /both/ {umin,umax}_value safely fit in 32 bit
space. For example, the register with a umin_value == 1 does /not/ imply
that u32_min_value is also equal to 1, since umax_value could be much
larger than 32 bit subregister can hold, and thus u32_min_value is in
the interval [0,1] instead.

Before fix, invalid tracking result of R2_w=inv1:

  [...]
  5: R0_w=inv1337 R1=ctx(id=0,off=0,imm=0) R2_w=inv(id=0) R10=fp0
  5: (35) if r2 >= 0x1 goto pc+1
  [...] // goto path
  7: R0=inv1337 R1=ctx(id=0,off=0,imm=0) R2=inv(id=0,umin_value=1) R10=fp0
  7: (b6) if w2 <= 0x1 goto pc+1
  [...] // goto path
  9: R0=inv1337 R1=ctx(id=0,off=0,imm=0) R2=inv(id=0,smin_value=-9223372036854775807,smax_value=9223372032559808513,umin_value=1,umax_value=18446744069414584321,var_off=(0x1; 0xffffffff00000000),s32_min_value=1,s32_max_value=1,u32_max_value=1) R10=fp0
  9: (bc) w2 = w2
  10: R0=inv1337 R1=ctx(id=0,off=0,imm=0) R2_w=inv1 R10=fp0
  [...]

After fix, correct tracking result of R2_w=inv(id=0,umax_value=1,var_off=(0x0; 0x1)):

  [...]
  5: R0_w=inv1337 R1=ctx(id=0,off=0,imm=0) R2_w=inv(id=0) R10=fp0
  5: (35) if r2 >= 0x1 goto pc+1
  [...] // goto path
  7: R0=inv1337 R1=ctx(id=0,off=0,imm=0) R2=inv(id=0,umin_value=1) R10=fp0
  7: (b6) if w2 <= 0x1 goto pc+1
  [...] // goto path
  9: R0=inv1337 R1=ctx(id=0,off=0,imm=0) R2=inv(id=0,smax_value=9223372032559808513,umax_value=18446744069414584321,var_off=(0x0; 0xffffffff00000001),s32_min_value=0,s32_max_value=1,u32_max_value=1) R10=fp0
  9: (bc) w2 = w2
  10: R0=inv1337 R1=ctx(id=0,off=0,imm=0) R2_w=inv(id=0,umax_value=1,var_off=(0x0; 0x1)) R10=fp0
  [...]

Thus, same issue as in b02709587ea3 holds for unsigned subregister tracking.
Also, align __reg64_bound_u32() similarly to __reg64_bound_s32() as done in
b02709587ea3 to make them uniform again.

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Reported-by: Manfred Paul (@_manfp)
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                               | 8 +++-----
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b6656d181c9e..dbde00ce60f0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1303,9 +1303,7 @@ static bool __reg64_bound_s32(s64 a)
 
 static bool __reg64_bound_u32(u64 a)
 {
-	if (a > U32_MIN && a < U32_MAX)
-		return true;
-	return false;
+	return a > U32_MIN && a < U32_MAX;
 }
 
 static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
@@ -1316,10 +1314,10 @@ static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
 		reg->s32_min_value = (s32)reg->smin_value;
 		reg->s32_max_value = (s32)reg->smax_value;
 	}
-	if (__reg64_bound_u32(reg->umin_value))
+	if (__reg64_bound_u32(reg->umin_value) && __reg64_bound_u32(reg->umax_value)) {
 		reg->u32_min_value = (u32)reg->umin_value;
-	if (__reg64_bound_u32(reg->umax_value))
 		reg->u32_max_value = (u32)reg->umax_value;
+	}
 
 	/* Intersecting with the old var_off might have improved our bounds
 	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
index 1b138cd2b187..1b1c798e9248 100644
--- a/tools/testing/selftests/bpf/verifier/array_access.c
+++ b/tools/testing/selftests/bpf/verifier/array_access.c
@@ -186,7 +186,7 @@
 	},
 	.fixup_map_hash_48b = { 3 },
 	.errstr_unpriv = "R0 leaks addr",
-	.errstr = "invalid access to map value, value_size=48 off=44 size=8",
+	.errstr = "R0 unbounded memory access",
 	.result_unpriv = REJECT,
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
-- 
2.30.2



