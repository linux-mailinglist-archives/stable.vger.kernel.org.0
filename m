Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B92F3C5429
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347555AbhGLH5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244812AbhGLHxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B69A60200;
        Mon, 12 Jul 2021 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076216;
        bh=JkNkwONVUfUEZw+rVMf8CC5y8F9LIaPCBOCLnPm7lz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHNtnv50zuO2zdgQJj6jj3fbc3pFEBXD43qD13RMBsn2S9KMOECG7uV6F3sP/A9mw
         vuojLY7cTSrQ7lfJfxvQU48rW3lnuVrGgLaXl1u9vfRDrJjuoKKwHiKubs0LCH0w6M
         obTRW9RMKVp7to/+0COUuEPC1y+Vkp9aWxLVjq2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Maki <joamaki@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 547/800] bpf: Fix null ptr deref with mixed tail calls and subprogs
Date:   Mon, 12 Jul 2021 08:09:30 +0200
Message-Id: <20210712061025.570038392@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 7506d211b932870155bcb39e3dd9e39fab45a7c7 ]

The sub-programs prog->aux->poke_tab[] is populated in jit_subprogs() and
then used when emitting 'BPF_JMP|BPF_TAIL_CALL' insn->code from the
individual JITs. The poke_tab[] to use is stored in the insn->imm by
the code adding it to that array slot. The JIT then uses imm to find the
right entry for an individual instruction. In the x86 bpf_jit_comp.c
this is done by calling emit_bpf_tail_call_direct with the poke_tab[]
of the imm value.

However, we observed the below null-ptr-deref when mixing tail call
programs with subprog programs. For this to happen we just need to
mix bpf-2-bpf calls and tailcalls with some extra calls or instructions
that would be patched later by one of the fixup routines. So whats
happening?

Before the fixup_call_args() -- where the jit op is done -- various
code patching is done by do_misc_fixups(). This may increase the
insn count, for example when we patch map_lookup_up using map_gen_lookup
hook. This does two things. First, it means the instruction index,
insn_idx field, of a tail call instruction will move by a 'delta'.

In verifier code,

 struct bpf_jit_poke_descriptor desc = {
  .reason = BPF_POKE_REASON_TAIL_CALL,
  .tail_call.map = BPF_MAP_PTR(aux->map_ptr_state),
  .tail_call.key = bpf_map_key_immediate(aux),
  .insn_idx = i + delta,
 };

Then subprog start values subprog_info[i].start will be updated
with the delta and any poke descriptor index will also be updated
with the delta in adjust_poke_desc(). If we look at the adjust
subprog starts though we see its only adjusted when the delta
occurs before the new instructions,

        /* NOTE: fake 'exit' subprog should be updated as well. */
        for (i = 0; i <= env->subprog_cnt; i++) {
                if (env->subprog_info[i].start <= off)
                        continue;

Earlier subprograms are not changed because their start values
are not moved. But, adjust_poke_desc() does the offset + delta
indiscriminately. The result is poke descriptors are potentially
corrupted.

Then in jit_subprogs() we only populate the poke_tab[]
when the above insn_idx is less than the next subprogram start. From
above we corrupted our insn_idx so we might incorrectly assume a
poke descriptor is not used in a subprogram omitting it from the
subprogram. And finally when the jit runs it does the deref of poke_tab
when emitting the instruction and crashes with below. Because earlier
step omitted the poke descriptor.

The fix is straight forward with above context. Simply move same logic
from adjust_subprog_starts() into adjust_poke_descs() and only adjust
insn_idx when needed.

[   82.396354] bpf_testmod: version magic '5.12.0-rc2alu+ SMP preempt mod_unload ' should be '5.12.0+ SMP preempt mod_unload '
[   82.623001] loop10: detected capacity change from 0 to 8
[   88.487424] ==================================================================
[   88.487438] BUG: KASAN: null-ptr-deref in do_jit+0x184a/0x3290
[   88.487455] Write of size 8 at addr 0000000000000008 by task test_progs/5295
[   88.487471] CPU: 7 PID: 5295 Comm: test_progs Tainted: G          I       5.12.0+ #386
[   88.487483] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
[   88.487490] Call Trace:
[   88.487498]  dump_stack+0x93/0xc2
[   88.487515]  kasan_report.cold+0x5f/0xd8
[   88.487530]  ? do_jit+0x184a/0x3290
[   88.487542]  do_jit+0x184a/0x3290
 ...
[   88.487709]  bpf_int_jit_compile+0x248/0x810
 ...
[   88.487765]  bpf_check+0x3718/0x5140
 ...
[   88.487920]  bpf_prog_load+0xa22/0xf10

Fixes: a748c6975dea3 ("bpf: propagate poke descriptors to subprograms")
Reported-by: Jussi Maki <joamaki@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c6a27574242d..6e2ebcb0d66f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11459,7 +11459,7 @@ static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len
 	}
 }
 
-static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
+static void adjust_poke_descs(struct bpf_prog *prog, u32 off, u32 len)
 {
 	struct bpf_jit_poke_descriptor *tab = prog->aux->poke_tab;
 	int i, sz = prog->aux->size_poke_tab;
@@ -11467,6 +11467,8 @@ static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
 
 	for (i = 0; i < sz; i++) {
 		desc = &tab[i];
+		if (desc->insn_idx <= off)
+			continue;
 		desc->insn_idx += len - 1;
 	}
 }
@@ -11487,7 +11489,7 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 	if (adjust_insn_aux_data(env, new_prog, off, len))
 		return NULL;
 	adjust_subprog_starts(env, off, len);
-	adjust_poke_descs(new_prog, len);
+	adjust_poke_descs(new_prog, off, len);
 	return new_prog;
 }
 
-- 
2.30.2



