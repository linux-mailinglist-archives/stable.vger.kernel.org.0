Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35D33D61D8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhGZPdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231502AbhGZPbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B04D60F6F;
        Mon, 26 Jul 2021 16:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315897;
        bh=jl+bJWfu9W+5Tlxagle6vY70YacAfD/KUnku19Ktwqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FB6dmPQQv0Mhm3cUwM4wM4FvVBv8WVNJqN26RdzRZ03CZN6H0BghiuUZHisK3vQyx
         rhAYtwbsdUwKMp48gucWv4X669XFh2V25rUIpl17WkDdfrjCA8IAdYB3XgvHft/lXT
         QnRM6zI7TEFShqJp2PuRxluoMiFc9RVAkSabNMuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 074/223] bpf: Fix tail_call_reachable rejection for interpreter when jit failed
Date:   Mon, 26 Jul 2021 17:37:46 +0200
Message-Id: <20210726153848.677341124@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 5dd0a6b8582ffbfa88351949d50eccd5b6694ade ]

During testing of f263a81451c1 ("bpf: Track subprog poke descriptors correctly
and fix use-after-free") under various failure conditions, for example, when
jit_subprogs() fails and tries to clean up the program to be run under the
interpreter, we ran into the following freeze:

  [...]
  #127/8 tailcall_bpf2bpf_3:FAIL
  [...]
  [   92.041251] BUG: KASAN: slab-out-of-bounds in ___bpf_prog_run+0x1b9d/0x2e20
  [   92.042408] Read of size 8 at addr ffff88800da67f68 by task test_progs/682
  [   92.043707]
  [   92.044030] CPU: 1 PID: 682 Comm: test_progs Tainted: G   O   5.13.0-53301-ge6c08cb33a30-dirty #87
  [   92.045542] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
  [   92.046785] Call Trace:
  [   92.047171]  ? __bpf_prog_run_args64+0xc0/0xc0
  [   92.047773]  ? __bpf_prog_run_args32+0x8b/0xb0
  [   92.048389]  ? __bpf_prog_run_args64+0xc0/0xc0
  [   92.049019]  ? ktime_get+0x117/0x130
  [...] // few hundred [similar] lines more
  [   92.659025]  ? ktime_get+0x117/0x130
  [   92.659845]  ? __bpf_prog_run_args64+0xc0/0xc0
  [   92.660738]  ? __bpf_prog_run_args32+0x8b/0xb0
  [   92.661528]  ? __bpf_prog_run_args64+0xc0/0xc0
  [   92.662378]  ? print_usage_bug+0x50/0x50
  [   92.663221]  ? print_usage_bug+0x50/0x50
  [   92.664077]  ? bpf_ksym_find+0x9c/0xe0
  [   92.664887]  ? ktime_get+0x117/0x130
  [   92.665624]  ? kernel_text_address+0xf5/0x100
  [   92.666529]  ? __kernel_text_address+0xe/0x30
  [   92.667725]  ? unwind_get_return_address+0x2f/0x50
  [   92.668854]  ? ___bpf_prog_run+0x15d4/0x2e20
  [   92.670185]  ? ktime_get+0x117/0x130
  [   92.671130]  ? __bpf_prog_run_args64+0xc0/0xc0
  [   92.672020]  ? __bpf_prog_run_args32+0x8b/0xb0
  [   92.672860]  ? __bpf_prog_run_args64+0xc0/0xc0
  [   92.675159]  ? ktime_get+0x117/0x130
  [   92.677074]  ? lock_is_held_type+0xd5/0x130
  [   92.678662]  ? ___bpf_prog_run+0x15d4/0x2e20
  [   92.680046]  ? ktime_get+0x117/0x130
  [   92.681285]  ? __bpf_prog_run32+0x6b/0x90
  [   92.682601]  ? __bpf_prog_run64+0x90/0x90
  [   92.683636]  ? lock_downgrade+0x370/0x370
  [   92.684647]  ? mark_held_locks+0x44/0x90
  [   92.685652]  ? ktime_get+0x117/0x130
  [   92.686752]  ? lockdep_hardirqs_on+0x79/0x100
  [   92.688004]  ? ktime_get+0x117/0x130
  [   92.688573]  ? __cant_migrate+0x2b/0x80
  [   92.689192]  ? bpf_test_run+0x2f4/0x510
  [   92.689869]  ? bpf_test_timer_continue+0x1c0/0x1c0
  [   92.690856]  ? rcu_read_lock_bh_held+0x90/0x90
  [   92.691506]  ? __kasan_slab_alloc+0x61/0x80
  [   92.692128]  ? eth_type_trans+0x128/0x240
  [   92.692737]  ? __build_skb+0x46/0x50
  [   92.693252]  ? bpf_prog_test_run_skb+0x65e/0xc50
  [   92.693954]  ? bpf_prog_test_run_raw_tp+0x2d0/0x2d0
  [   92.694639]  ? __fget_light+0xa1/0x100
  [   92.695162]  ? bpf_prog_inc+0x23/0x30
  [   92.695685]  ? __sys_bpf+0xb40/0x2c80
  [   92.696324]  ? bpf_link_get_from_fd+0x90/0x90
  [   92.697150]  ? mark_held_locks+0x24/0x90
  [   92.698007]  ? lockdep_hardirqs_on_prepare+0x124/0x220
  [   92.699045]  ? finish_task_switch+0xe6/0x370
  [   92.700072]  ? lockdep_hardirqs_on+0x79/0x100
  [   92.701233]  ? finish_task_switch+0x11d/0x370
  [   92.702264]  ? __switch_to+0x2c0/0x740
  [   92.703148]  ? mark_held_locks+0x24/0x90
  [   92.704155]  ? __x64_sys_bpf+0x45/0x50
  [   92.705146]  ? do_syscall_64+0x35/0x80
  [   92.706953]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
  [...]

Turns out that the program rejection from e411901c0b77 ("bpf: allow for tailcalls
in BPF subprograms for x64 JIT") is buggy since env->prog->aux->tail_call_reachable
is never true. Commit ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall
handling in JIT") added a tracker into check_max_stack_depth() which propagates
the tail_call_reachable condition throughout the subprograms. This info is then
assigned to the subprogram's func[i]->aux->tail_call_reachable. However, in the
case of the rejection check upon JIT failure, env->prog->aux->tail_call_reachable
is used. func[0]->aux->tail_call_reachable which represents the main program's
information did not propagate this to the outer env->prog->aux, though. Add this
propagation into check_max_stack_depth() where it needs to belong so that the
check can be done reliably.

Fixes: ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
Fixes: e411901c0b77 ("bpf: allow for tailcalls in BPF subprograms for x64 JIT")
Co-developed-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/bpf/618c34e3163ad1a36b1e82377576a6081e182f25.1626123173.git.daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d8a6fcd28e39..e6db39a00de2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3675,6 +3675,8 @@ continue_func:
 	if (tail_call_reachable)
 		for (j = 0; j < frame; j++)
 			subprog[ret_prog[j]].tail_call_reachable = true;
+	if (subprog[0].tail_call_reachable)
+		env->prog->aux->tail_call_reachable = true;
 
 	/* end of for() loop means the last insn of the 'subprog'
 	 * was reached. Doesn't matter whether it was JA or EXIT
-- 
2.30.2



