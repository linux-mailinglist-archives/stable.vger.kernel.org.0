Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9E248E587
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbiANISy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239635AbiANIS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:18:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C64C061749;
        Fri, 14 Jan 2022 00:18:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB0661E1E;
        Fri, 14 Jan 2022 08:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E3AC36AEA;
        Fri, 14 Jan 2022 08:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148307;
        bh=z2GKoe1ITUkmG3HGNX3ZtDY3JzUzn/yv3i6EMOGz600=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDGnTRkPu/MdEu5JQFfqSv5bTbnEzjBaF18+BCTh5VOZ3IHxUzgcb37hIlpoAR+vS
         P4Jw7nzM0a/LEaiPCfIJ9YNbjvT6SU4iIXXfePsVgVsMRnxRG5JzfsWAS/Vmafv2XP
         0BWbUq/7GIa9wDPEHXeTPD9YMl702SosSkqlZNPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 03/25] bpf: Fix out of bounds access from invalid *_or_null type verification
Date:   Fri, 14 Jan 2022 09:16:11 +0100
Message-Id: <20220114081542.816191961@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ no upstream commit given implicitly fixed through the larger refactoring
  in c25b2ae136039ffa820c26138ed4a5e5f3ab3841 ]

While auditing some other code, I noticed missing checks inside the pointer
arithmetic simulation, more specifically, adjust_ptr_min_max_vals(). Several
*_OR_NULL types are not rejected whereas they are _required_ to be rejected
given the expectation is that they get promoted into a 'real' pointer type
for the success case, that is, after an explicit != NULL check.

One case which stands out and is accessible from unprivileged (iff enabled
given disabled by default) is BPF ring buffer. From crafting a PoC, the NULL
check can be bypassed through an offset, and its id marking will then lead
to promotion of mem_or_null to a mem type.

bpf_ringbuf_reserve() helper can trigger this case through passing of reserved
flags, for example.

  func#0 @0
  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (7a) *(u64 *)(r10 -8) = 0
  1: R1=ctx(id=0,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm
  1: (18) r1 = 0x0
  3: R1_w=map_ptr(id=0,off=0,ks=0,vs=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm
  3: (b7) r2 = 8
  4: R1_w=map_ptr(id=0,off=0,ks=0,vs=0,imm=0) R2_w=invP8 R10=fp0 fp-8_w=mmmmmmmm
  4: (b7) r3 = 0
  5: R1_w=map_ptr(id=0,off=0,ks=0,vs=0,imm=0) R2_w=invP8 R3_w=invP0 R10=fp0 fp-8_w=mmmmmmmm
  5: (85) call bpf_ringbuf_reserve#131
  6: R0_w=mem_or_null(id=2,ref_obj_id=2,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm refs=2
  6: (bf) r6 = r0
  7: R0_w=mem_or_null(id=2,ref_obj_id=2,off=0,imm=0) R6_w=mem_or_null(id=2,ref_obj_id=2,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm refs=2
  7: (07) r0 += 1
  8: R0_w=mem_or_null(id=2,ref_obj_id=2,off=1,imm=0) R6_w=mem_or_null(id=2,ref_obj_id=2,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm refs=2
  8: (15) if r0 == 0x0 goto pc+4
   R0_w=mem(id=0,ref_obj_id=0,off=0,imm=0) R6_w=mem(id=0,ref_obj_id=2,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm refs=2
  9: R0_w=mem(id=0,ref_obj_id=0,off=0,imm=0) R6_w=mem(id=0,ref_obj_id=2,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm refs=2
  9: (62) *(u32 *)(r6 +0) = 0
   R0_w=mem(id=0,ref_obj_id=0,off=0,imm=0) R6_w=mem(id=0,ref_obj_id=2,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm refs=2
  10: R0_w=mem(id=0,ref_obj_id=0,off=0,imm=0) R6_w=mem(id=0,ref_obj_id=2,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm refs=2
  10: (bf) r1 = r6
  11: R0_w=mem(id=0,ref_obj_id=0,off=0,imm=0) R1_w=mem(id=0,ref_obj_id=2,off=0,imm=0) R6_w=mem(id=0,ref_obj_id=2,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm refs=2
  11: (b7) r2 = 0
  12: R0_w=mem(id=0,ref_obj_id=0,off=0,imm=0) R1_w=mem(id=0,ref_obj_id=2,off=0,imm=0) R2_w=invP0 R6_w=mem(id=0,ref_obj_id=2,off=0,imm=0) R10=fp0 fp-8_w=mmmmmmmm refs=2
  12: (85) call bpf_ringbuf_submit#132
  13: R6=invP(id=0) R10=fp0 fp-8=mmmmmmmm
  13: (b7) r0 = 0
  14: R0_w=invP0 R6=invP(id=0) R10=fp0 fp-8=mmmmmmmm
  14: (95) exit

  from 8 to 13: safe
  processed 15 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
  OK

All three commits, that is b121b341e598 ("bpf: Add PTR_TO_BTF_ID_OR_NULL support"),
457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it"), and the
afbf21dce668 ("bpf: Support readonly/readwrite buffers in verifier") suffer the same
cause and their *_OR_NULL type pendants must be rejected in adjust_ptr_min_max_vals().

Make the test more robust by reusing reg_type_may_be_null() helper such that we catch
all *_OR_NULL types we have today and in future.

Note that pointer arithmetic on PTR_TO_BTF_ID, PTR_TO_RDONLY_BUF, and PTR_TO_RDWR_BUF
is generally allowed.

Fixes: b121b341e598 ("bpf: Add PTR_TO_BTF_ID_OR_NULL support")
Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Fixes: afbf21dce668 ("bpf: Support readonly/readwrite buffers in verifier")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6037,16 +6037,16 @@ static int adjust_ptr_min_max_vals(struc
 		fallthrough;
 	case PTR_TO_PACKET_END:
 	case PTR_TO_SOCKET:
-	case PTR_TO_SOCKET_OR_NULL:
 	case PTR_TO_SOCK_COMMON:
-	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
-	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+reject:
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
 	default:
+		if (reg_type_may_be_null(ptr_reg->type))
+			goto reject;
 		break;
 	}
 


