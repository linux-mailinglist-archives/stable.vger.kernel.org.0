Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388B2318DF7
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhBKPSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:18:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhBKPNU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2ABC64EEB;
        Thu, 11 Feb 2021 15:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055879;
        bh=RZJCqCXn11wHTzCPP5wG03A7IxvzoLzu9ChCbyv9pYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lI9hoZnSwn2+hHKCrZ1LgSaT3t9dJN2FDHUHCCsrwM/ffpJ3RGDKWM3RW1B+npiPn
         06SjSVaSDBEKMShkdm4iLkqId7pbaTUtDimunyFm6eXkMV9/f1uPctg1fonGIVj8f8
         SwT2Ie4B4V3yh5/KmRYvJ2QshlnFNcPH2MLLXakk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anatoly Trosinenko <anatoly.trosinenko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 44/54] bpf: Fix verifier jmp32 pruning decision logic
Date:   Thu, 11 Feb 2021 16:02:28 +0100
Message-Id: <20210211150154.796346115@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit fd675184fc7abfd1e1c52d23e8e900676b5a1c1a upstream.

Anatoly has been fuzzing with kBdysch harness and reported a hang in
one of the outcomes:

  func#0 @0
  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (b7) r0 = 808464450
  1: R0_w=invP808464450 R1=ctx(id=0,off=0,imm=0) R10=fp0
  1: (b4) w4 = 808464432
  2: R0_w=invP808464450 R1=ctx(id=0,off=0,imm=0) R4_w=invP808464432 R10=fp0
  2: (9c) w4 %= w0
  3: R0_w=invP808464450 R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R10=fp0
  3: (66) if w4 s> 0x30303030 goto pc+0
   R0_w=invP808464450 R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),s32_max_value=808464432) R10=fp0
  4: R0_w=invP808464450 R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),s32_max_value=808464432) R10=fp0
  4: (7f) r0 >>= r0
  5: R0_w=invP(id=0) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),s32_max_value=808464432) R10=fp0
  5: (9c) w4 %= w0
  6: R0_w=invP(id=0) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0) R10=fp0
  6: (66) if w0 s> 0x3030 goto pc+0
   R0_w=invP(id=0,s32_max_value=12336) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0) R10=fp0
  7: R0=invP(id=0,s32_max_value=12336) R1=ctx(id=0,off=0,imm=0) R4=invP(id=0) R10=fp0
  7: (d6) if w0 s<= 0x303030 goto pc+1
  9: R0=invP(id=0,s32_max_value=12336) R1=ctx(id=0,off=0,imm=0) R4=invP(id=0) R10=fp0
  9: (95) exit
  propagating r0

  from 6 to 7: safe
  4: R0_w=invP808464450 R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0,umin_value=808464433,umax_value=2147483647,var_off=(0x0; 0x7fffffff)) R10=fp0
  4: (7f) r0 >>= r0
  5: R0_w=invP(id=0) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0,umin_value=808464433,umax_value=2147483647,var_off=(0x0; 0x7fffffff)) R10=fp0
  5: (9c) w4 %= w0
  6: R0_w=invP(id=0) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0) R10=fp0
  6: (66) if w0 s> 0x3030 goto pc+0
   R0_w=invP(id=0,s32_max_value=12336) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0) R10=fp0
  propagating r0
  7: safe
  propagating r0

  from 6 to 7: safe
  processed 15 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 1

The underlying program was xlated as follows:

  # bpftool p d x i 10
   0: (b7) r0 = 808464450
   1: (b4) w4 = 808464432
   2: (bc) w0 = w0
   3: (15) if r0 == 0x0 goto pc+1
   4: (9c) w4 %= w0
   5: (66) if w4 s> 0x30303030 goto pc+0
   6: (7f) r0 >>= r0
   7: (bc) w0 = w0
   8: (15) if r0 == 0x0 goto pc+1
   9: (9c) w4 %= w0
  10: (66) if w0 s> 0x3030 goto pc+0
  11: (d6) if w0 s<= 0x303030 goto pc+1
  12: (05) goto pc-1
  13: (95) exit

The verifier rewrote original instructions it recognized as dead code with
'goto pc-1', but reality differs from verifier simulation in that we are
actually able to trigger a hang due to hitting the 'goto pc-1' instructions.

Taking a closer look at the verifier analysis, the reason is that it misjudges
its pruning decision at the first 'from 6 to 7: safe' occasion. What happens
is that while both old/cur registers are marked as precise, they get misjudged
for the jmp32 case as range_within() yields true, meaning that the prior
verification path with a wider register bound could be verified successfully
and therefore the current path with a narrower register bound is deemed safe
as well whereas in reality it's not. R0 old/cur path's bounds compare as
follows:

  old: smin_value=0x8000000000000000,smax_value=0x7fffffffffffffff,umin_value=0x0,umax_value=0xffffffffffffffff,var_off=(0x0; 0xffffffffffffffff)
  cur: smin_value=0x8000000000000000,smax_value=0x7fffffff7fffffff,umin_value=0x0,umax_value=0xffffffff7fffffff,var_off=(0x0; 0xffffffff7fffffff)

  old: s32_min_value=0x80000000,s32_max_value=0x00003030,u32_min_value=0x00000000,u32_max_value=0xffffffff
  cur: s32_min_value=0x00003031,s32_max_value=0x7fffffff,u32_min_value=0x00003031,u32_max_value=0x7fffffff

The 64 bit bounds generally look okay and while the information that got
propagated from 32 to 64 bit looks correct as well, it's not precise enough
for judging a conditional jmp32. Given the latter only operates on subregisters
we also need to take these into account as well for a range_within() probe
in order to be able to prune paths. Extending the range_within() constraint
to both bounds will be able to tell us that the old signed 32 bit bounds are
not wider than the cur signed 32 bit bounds.

With the fix in place, the program will now verify the 'goto' branch case as
it should have been:

  [...]
  6: R0_w=invP(id=0) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0) R10=fp0
  6: (66) if w0 s> 0x3030 goto pc+0
   R0_w=invP(id=0,s32_max_value=12336) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0) R10=fp0
  7: R0=invP(id=0,s32_max_value=12336) R1=ctx(id=0,off=0,imm=0) R4=invP(id=0) R10=fp0
  7: (d6) if w0 s<= 0x303030 goto pc+1
  9: R0=invP(id=0,s32_max_value=12336) R1=ctx(id=0,off=0,imm=0) R4=invP(id=0) R10=fp0
  9: (95) exit

  7: R0_w=invP(id=0,smax_value=9223372034707292159,umax_value=18446744071562067967,var_off=(0x0; 0xffffffff7fffffff),s32_min_value=12337,u32_min_value=12337,u32_max_value=2147483647) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0) R10=fp0
  7: (d6) if w0 s<= 0x303030 goto pc+1
   R0_w=invP(id=0,smax_value=9223372034707292159,umax_value=18446744071562067967,var_off=(0x0; 0xffffffff7fffffff),s32_min_value=3158065,u32_min_value=3158065,u32_max_value=2147483647) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0) R10=fp0
  8: R0_w=invP(id=0,smax_value=9223372034707292159,umax_value=18446744071562067967,var_off=(0x0; 0xffffffff7fffffff),s32_min_value=3158065,u32_min_value=3158065,u32_max_value=2147483647) R1=ctx(id=0,off=0,imm=0) R4_w=invP(id=0) R10=fp0
  8: (30) r0 = *(u8 *)skb[808464432]
  BPF_LD_[ABS|IND] uses reserved fields
  processed 11 insns (limit 1000000) max_states_per_insn 1 total_states 1 peak_states 1 mark_read 1

The bug is quite subtle in the sense that when verifier would determine that
a given branch is dead code, it would (here: wrongly) remove these instructions
from the program and hard-wire the taken branch for privileged programs instead
of the 'goto pc-1' rewrites which will cause hard to debug problems.

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8465,7 +8465,11 @@ static bool range_within(struct bpf_reg_
 	return old->umin_value <= cur->umin_value &&
 	       old->umax_value >= cur->umax_value &&
 	       old->smin_value <= cur->smin_value &&
-	       old->smax_value >= cur->smax_value;
+	       old->smax_value >= cur->smax_value &&
+	       old->u32_min_value <= cur->u32_min_value &&
+	       old->u32_max_value >= cur->u32_max_value &&
+	       old->s32_min_value <= cur->s32_min_value &&
+	       old->s32_max_value >= cur->s32_max_value;
 }
 
 /* Maximum number of register states that can exist at once */


