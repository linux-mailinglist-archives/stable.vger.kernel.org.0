Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABA63D294C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhGVQDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233505AbhGVQCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:02:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17BC06144E;
        Thu, 22 Jul 2021 16:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972158;
        bh=RxE2IuquxR4V0P+IKni5ihJlP8dRBj3o9cbEn/Xf1FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDhdhDtuWV4obj2Q1hwJd52ppgbyZucbLtlr1zKqZPe2cS73nVoEDtznHzwFgphO4
         4Zahmr+gsbp/sVvrpPf4/2Vg+eLYwC/gdSB5KY2tzMaF5d9KGuWtZ7hnbvJ81f2GVx
         PMSUvDrMlBTe+DcAL8EgW8MWzQ3GN9nXNkwJfkZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 122/125] bpf: Track subprog poke descriptors correctly and fix use-after-free
Date:   Thu, 22 Jul 2021 18:31:53 +0200
Message-Id: <20210722155628.761858878@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit f263a81451c12da5a342d90572e317e611846f2c upstream.

Subprograms are calling map_poke_track(), but on program release there is no
hook to call map_poke_untrack(). However, on program release, the aux memory
(and poke descriptor table) is freed even though we still have a reference to
it in the element list of the map aux data. When we run map_poke_run(), we then
end up accessing free'd memory, triggering KASAN in prog_array_map_poke_run():

  [...]
  [  402.824689] BUG: KASAN: use-after-free in prog_array_map_poke_run+0xc2/0x34e
  [  402.824698] Read of size 4 at addr ffff8881905a7940 by task hubble-fgs/4337
  [  402.824705] CPU: 1 PID: 4337 Comm: hubble-fgs Tainted: G          I       5.12.0+ #399
  [  402.824715] Call Trace:
  [  402.824719]  dump_stack+0x93/0xc2
  [  402.824727]  print_address_description.constprop.0+0x1a/0x140
  [  402.824736]  ? prog_array_map_poke_run+0xc2/0x34e
  [  402.824740]  ? prog_array_map_poke_run+0xc2/0x34e
  [  402.824744]  kasan_report.cold+0x7c/0xd8
  [  402.824752]  ? prog_array_map_poke_run+0xc2/0x34e
  [  402.824757]  prog_array_map_poke_run+0xc2/0x34e
  [  402.824765]  bpf_fd_array_map_update_elem+0x124/0x1a0
  [...]

The elements concerned are walked as follows:

    for (i = 0; i < elem->aux->size_poke_tab; i++) {
           poke = &elem->aux->poke_tab[i];
    [...]

The access to size_poke_tab is a 4 byte read, verified by checking offsets
in the KASAN dump:

  [  402.825004] The buggy address belongs to the object at ffff8881905a7800
                 which belongs to the cache kmalloc-1k of size 1024
  [  402.825008] The buggy address is located 320 bytes inside of
                 1024-byte region [ffff8881905a7800, ffff8881905a7c00)

The pahole output of bpf_prog_aux:

  struct bpf_prog_aux {
    [...]
    /* --- cacheline 5 boundary (320 bytes) --- */
    u32                        size_poke_tab;        /*   320     4 */
    [...]

In general, subprograms do not necessarily manage their own data structures.
For example, BTF func_info and linfo are just pointers to the main program
structure. This allows reference counting and cleanup to be done on the latter
which simplifies their management a bit. The aux->poke_tab struct, however,
did not follow this logic. The initial proposed fix for this use-after-free
bug further embedded poke data tracking into the subprogram with proper
reference counting. However, Daniel and Alexei questioned why we were treating
these objects special; I agree, its unnecessary. The fix here removes the per
subprogram poke table allocation and map tracking and instead simply points
the aux->poke_tab pointer at the main programs poke table. This way, map
tracking is simplified to the main program and we do not need to manage them
per subprogram.

This also means, bpf_prog_free_deferred(), which unwinds the program reference
counting and kfrees objects, needs to ensure that we don't try to double free
the poke_tab when free'ing the subprog structures. This is easily solved by
NULL'ing the poke_tab pointer. The second detail is to ensure that per
subprogram JIT logic only does fixups on poke_tab[] entries it owns. To do
this, we add a pointer in the poke structure to point at the subprogram value
so JITs can easily check while walking the poke_tab structure if the current
entry belongs to the current program. The aux pointer is stable and therefore
suitable for such comparison. On the jit_subprogs() error path, we omit
cleaning up the poke->aux field because these are only ever referenced from
the JIT side, but on error we will never make it to the JIT, so its fine to
leave them dangling. Removing these pointers would complicate the error path
for no reason. However, we do need to untrack all poke descriptors from the
main program as otherwise they could race with the freeing of JIT memory from
the subprograms. Lastly, a748c6975dea3 ("bpf: propagate poke descriptors to
subprograms") had an off-by-one on the subprogram instruction index range
check as it was testing 'insn_idx >= subprog_start && insn_idx <= subprog_end'.
However, subprog_end is the next subprogram's start instruction.

Fixes: a748c6975dea3 ("bpf: propagate poke descriptors to subprograms")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210707223848.14580-2-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |    3 ++
 include/linux/bpf.h         |    1 
 kernel/bpf/core.c           |    8 +++++
 kernel/bpf/verifier.c       |   60 +++++++++++++++-----------------------------
 4 files changed, 32 insertions(+), 40 deletions(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -564,6 +564,9 @@ static void bpf_tail_call_direct_fixup(s
 
 	for (i = 0; i < prog->aux->size_poke_tab; i++) {
 		poke = &prog->aux->poke_tab[i];
+		if (poke->aux && poke->aux != prog->aux)
+			continue;
+
 		WARN_ON_ONCE(READ_ONCE(poke->tailcall_target_stable));
 
 		if (poke->reason != BPF_POKE_REASON_TAIL_CALL)
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -752,6 +752,7 @@ struct bpf_jit_poke_descriptor {
 	void *tailcall_target;
 	void *tailcall_bypass;
 	void *bypass_addr;
+	void *aux;
 	union {
 		struct {
 			struct bpf_map *map;
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2167,8 +2167,14 @@ static void bpf_prog_free_deferred(struc
 #endif
 	if (aux->dst_trampoline)
 		bpf_trampoline_put(aux->dst_trampoline);
-	for (i = 0; i < aux->func_cnt; i++)
+	for (i = 0; i < aux->func_cnt; i++) {
+		/* We can just unlink the subprog poke descriptor table as
+		 * it was originally linked to the main program and is also
+		 * released along with it.
+		 */
+		aux->func[i]->aux->poke_tab = NULL;
 		bpf_jit_free(aux->func[i]);
+	}
 	if (aux->func_cnt) {
 		kfree(aux->func);
 		bpf_prog_unlock_free(aux->prog);
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11157,33 +11157,19 @@ static int jit_subprogs(struct bpf_verif
 			goto out_free;
 		func[i]->is_func = 1;
 		func[i]->aux->func_idx = i;
-		/* the btf and func_info will be freed only at prog->aux */
+		/* Below members will be freed only at prog->aux */
 		func[i]->aux->btf = prog->aux->btf;
 		func[i]->aux->func_info = prog->aux->func_info;
+		func[i]->aux->poke_tab = prog->aux->poke_tab;
+		func[i]->aux->size_poke_tab = prog->aux->size_poke_tab;
 
 		for (j = 0; j < prog->aux->size_poke_tab; j++) {
-			u32 insn_idx = prog->aux->poke_tab[j].insn_idx;
-			int ret;
+			struct bpf_jit_poke_descriptor *poke;
 
-			if (!(insn_idx >= subprog_start &&
-			      insn_idx <= subprog_end))
-				continue;
-
-			ret = bpf_jit_add_poke_descriptor(func[i],
-							  &prog->aux->poke_tab[j]);
-			if (ret < 0) {
-				verbose(env, "adding tail call poke descriptor failed\n");
-				goto out_free;
-			}
-
-			func[i]->insnsi[insn_idx - subprog_start].imm = ret + 1;
-
-			map_ptr = func[i]->aux->poke_tab[ret].tail_call.map;
-			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
-			if (ret < 0) {
-				verbose(env, "tracking tail call prog failed\n");
-				goto out_free;
-			}
+			poke = &prog->aux->poke_tab[j];
+			if (poke->insn_idx < subprog_end &&
+			    poke->insn_idx >= subprog_start)
+				poke->aux = func[i]->aux;
 		}
 
 		/* Use bpf_prog_F_tag to indicate functions in stack traces.
@@ -11213,18 +11199,6 @@ static int jit_subprogs(struct bpf_verif
 		cond_resched();
 	}
 
-	/* Untrack main program's aux structs so that during map_poke_run()
-	 * we will not stumble upon the unfilled poke descriptors; each
-	 * of the main program's poke descs got distributed across subprogs
-	 * and got tracked onto map, so we are sure that none of them will
-	 * be missed after the operation below
-	 */
-	for (i = 0; i < prog->aux->size_poke_tab; i++) {
-		map_ptr = prog->aux->poke_tab[i].tail_call.map;
-
-		map_ptr->ops->map_poke_untrack(map_ptr, prog->aux);
-	}
-
 	/* at this point all bpf functions were successfully JITed
 	 * now populate all bpf_calls with correct addresses and
 	 * run last pass of JIT
@@ -11293,14 +11267,22 @@ static int jit_subprogs(struct bpf_verif
 	bpf_prog_free_unused_jited_linfo(prog);
 	return 0;
 out_free:
+	/* We failed JIT'ing, so at this point we need to unregister poke
+	 * descriptors from subprogs, so that kernel is not attempting to
+	 * patch it anymore as we're freeing the subprog JIT memory.
+	 */
+	for (i = 0; i < prog->aux->size_poke_tab; i++) {
+		map_ptr = prog->aux->poke_tab[i].tail_call.map;
+		map_ptr->ops->map_poke_untrack(map_ptr, prog->aux);
+	}
+	/* At this point we're guaranteed that poke descriptors are not
+	 * live anymore. We can just unlink its descriptor table as it's
+	 * released with the main prog.
+	 */
 	for (i = 0; i < env->subprog_cnt; i++) {
 		if (!func[i])
 			continue;
-
-		for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
-			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
-			map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
-		}
+		func[i]->aux->poke_tab = NULL;
 		bpf_jit_free(func[i]);
 	}
 	kfree(func);


