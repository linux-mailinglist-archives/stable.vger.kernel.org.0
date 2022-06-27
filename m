Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A20A55C5FF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbiF0LYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiF0LX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:23:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA596465;
        Mon, 27 Jun 2022 04:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 873CF61473;
        Mon, 27 Jun 2022 11:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80749C341CB;
        Mon, 27 Jun 2022 11:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329036;
        bh=2DDAeQJd086sVGb3mvKxL4YwMs/5y7Tr5uoqX1olOME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpuELNejRGDmVZYmOct3csm5jLHnWiJ+IEdBycmWNrKmiZzGQSiMDD/TjuViXqycf
         vdI5322RvrZO+/vijtPshQtfDFzgYDl+V0NSKFZkbiwGYm6OAt/cAPskfXj4tdqHVB
         uxGRonYKKnxcPuTOk6xO+XWd6AILGNNuUftLYddE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/102] bpf, x86: Fix tail call count offset calculation on bpf2bpf call
Date:   Mon, 27 Jun 2022 13:20:40 +0200
Message-Id: <20220627111934.330367140@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit ff672c67ee7635ca1e28fb13729e8ef0d1f08ce5 ]

On x86-64 the tail call count is passed from one BPF function to another
through %rax. Additionally, on function entry, the tail call count value
is stored on stack right after the BPF program stack, due to register
shortage.

The stored count is later loaded from stack either when performing a tail
call - to check if we have not reached the tail call limit - or before
calling another BPF function call in order to pass it via %rax.

In the latter case, we miscalculate the offset at which the tail call count
was stored on function entry. The JIT does not take into account that the
allocated BPF program stack is always a multiple of 8 on x86, while the
actual stack depth does not have to be.

This leads to a load from an offset that belongs to the BPF stack, as shown
in the example below:

SEC("tc")
int entry(struct __sk_buff *skb)
{
	/* Have data on stack which size is not a multiple of 8 */
	volatile char arr[1] = {};
	return subprog_tail(skb);
}

int entry(struct __sk_buff * skb):
   0: (b4) w2 = 0
   1: (73) *(u8 *)(r10 -1) = r2
   2: (85) call pc+1#bpf_prog_ce2f79bb5f3e06dd_F
   3: (95) exit

int entry(struct __sk_buff * skb):
   0xffffffffa0201788:  nop    DWORD PTR [rax+rax*1+0x0]
   0xffffffffa020178d:  xor    eax,eax
   0xffffffffa020178f:  push   rbp
   0xffffffffa0201790:  mov    rbp,rsp
   0xffffffffa0201793:  sub    rsp,0x8
   0xffffffffa020179a:  push   rax
   0xffffffffa020179b:  xor    esi,esi
   0xffffffffa020179d:  mov    BYTE PTR [rbp-0x1],sil
   0xffffffffa02017a1:  mov    rax,QWORD PTR [rbp-0x9]	!!! tail call count
   0xffffffffa02017a8:  call   0xffffffffa02017d8       !!! is at rbp-0x10
   0xffffffffa02017ad:  leave
   0xffffffffa02017ae:  ret

Fix it by rounding up the BPF stack depth to a multiple of 8, when
calculating the tail call count offset on stack.

Fixes: ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220616162037.535469-2-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index a0a7ead52698..1714e85eb26d 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1261,8 +1261,9 @@ xadd:			if (is_imm8(insn->off))
 		case BPF_JMP | BPF_CALL:
 			func = (u8 *) __bpf_call_base + imm32;
 			if (tail_call_reachable) {
+				/* mov rax, qword ptr [rbp - rounded_stack_depth - 8] */
 				EMIT3_off32(0x48, 0x8B, 0x85,
-					    -(bpf_prog->aux->stack_depth + 8));
+					    -round_up(bpf_prog->aux->stack_depth, 8) - 8);
 				if (!imm32 || emit_call(&prog, func, image + addrs[i - 1] + 7))
 					return -EINVAL;
 			} else {
-- 
2.35.1



