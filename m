Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D065C47AD37
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbhLTOu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38042 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbhLTOrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4055611A1;
        Mon, 20 Dec 2021 14:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDB6C36AEB;
        Mon, 20 Dec 2021 14:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011633;
        bh=dNyrVbPmgdZg1bvjrL3jh7O1C/mKk/RCYqyDKGoORk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNnecrBwDAMZNpDHctPiPFtyJZpf3EnwMIaXXiUV2DpFAFppJegRPsGdSMaI2USNl
         sdbzUhw+XwWVbSHJMPU8RzuOMOsi7YR9Snax4DmOl3NCU5iffedJwwJOhOO9rad+9Q
         0NutmbSpIRjsYbIB6NfFyMolFG+kxARyfR/3ySdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuee K1r0a <liulin063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 08/99] bpf: Fix signed bounds propagation after mov32
Date:   Mon, 20 Dec 2021 15:33:41 +0100
Message-Id: <20211220143029.627091478@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 3cf2b61eb06765e27fec6799292d9fb46d0b7e60 upstream.

For the case where both s32_{min,max}_value bounds are positive, the
__reg_assign_32_into_64() directly propagates them to their 64 bit
counterparts, otherwise it pessimises them into [0,u32_max] universe and
tries to refine them later on by learning through the tnum as per comment
in mentioned function. However, that does not always happen, for example,
in mov32 operation we call zext_32_to_64(dst_reg) which invokes the
__reg_assign_32_into_64() as is without subsequent bounds update as
elsewhere thus no refinement based on tnum takes place.

Thus, not calling into the __update_reg_bounds() / __reg_deduce_bounds() /
__reg_bound_offset() triplet as we do, for example, in case of ALU ops via
adjust_scalar_min_max_vals(), will lead to more pessimistic bounds when
dumping the full register state:

Before fix:

  0: (b4) w0 = -1
  1: R0_w=invP4294967295
     (id=0,imm=ffffffff,
      smin_value=4294967295,smax_value=4294967295,
      umin_value=4294967295,umax_value=4294967295,
      var_off=(0xffffffff; 0x0),
      s32_min_value=-1,s32_max_value=-1,
      u32_min_value=-1,u32_max_value=-1)

  1: (bc) w0 = w0
  2: R0_w=invP4294967295
     (id=0,imm=ffffffff,
      smin_value=0,smax_value=4294967295,
      umin_value=4294967295,umax_value=4294967295,
      var_off=(0xffffffff; 0x0),
      s32_min_value=-1,s32_max_value=-1,
      u32_min_value=-1,u32_max_value=-1)

Technically, the smin_value=0 and smax_value=4294967295 bounds are not
incorrect, but given the register is still a constant, they break assumptions
about const scalars that smin_value == smax_value and umin_value == umax_value.

After fix:

  0: (b4) w0 = -1
  1: R0_w=invP4294967295
     (id=0,imm=ffffffff,
      smin_value=4294967295,smax_value=4294967295,
      umin_value=4294967295,umax_value=4294967295,
      var_off=(0xffffffff; 0x0),
      s32_min_value=-1,s32_max_value=-1,
      u32_min_value=-1,u32_max_value=-1)

  1: (bc) w0 = w0
  2: R0_w=invP4294967295
     (id=0,imm=ffffffff,
      smin_value=4294967295,smax_value=4294967295,
      umin_value=4294967295,umax_value=4294967295,
      var_off=(0xffffffff; 0x0),
      s32_min_value=-1,s32_max_value=-1,
      u32_min_value=-1,u32_max_value=-1)

Without the smin_value == smax_value and umin_value == umax_value invariant
being intact for const scalars, it is possible to leak out kernel pointers
from unprivileged user space if the latter is enabled. For example, when such
registers are involved in pointer arithmtics, then adjust_ptr_min_max_vals()
will taint the destination register into an unknown scalar, and the latter
can be exported and stored e.g. into a BPF map value.

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Reported-by: Kuee K1r0a <liulin063@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7125,6 +7125,10 @@ static int check_alu_op(struct bpf_verif
 							 insn->dst_reg);
 				}
 				zext_32_to_64(dst_reg);
+
+				__update_reg_bounds(dst_reg);
+				__reg_deduce_bounds(dst_reg);
+				__reg_bound_offset(dst_reg);
 			}
 		} else {
 			/* case: R = imm


