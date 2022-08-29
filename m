Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D48E5A495F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiH2LYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiH2LXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:23:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2531D5E556;
        Mon, 29 Aug 2022 04:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B437B611B3;
        Mon, 29 Aug 2022 11:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEADFC433C1;
        Mon, 29 Aug 2022 11:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771674;
        bh=kpTLujtaa5oLLt5urP0XWv1uKUzg65+TA61+jrRpax4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SB+Hcjh2FiicngGW7xILYFBXLD6MqjxjBPV7UAkVvKWx6byv7dpSO3T9CKXEb75gM
         /RWGzwuJ/Pi0FX6rN0GGOcO1zavpccxJ+YlDaDpwfH0EIMi4NoqxMKEHPa8EGYNZgu
         DFs42BSOabJBdKevi958DoS8r0odO5kjjGLWKQu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Wei Hung <hsinweih@uci.edu>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 136/136] bpf: Dont use tnum_range on array range checking for poke descriptors
Date:   Mon, 29 Aug 2022 13:00:03 +0200
Message-Id: <20220829105810.255238956@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit a657182a5c5150cdfacb6640aad1d2712571a409 upstream.

Hsin-Wei reported a KASAN splat triggered by their BPF runtime fuzzer which
is based on a customized syzkaller:

  BUG: KASAN: slab-out-of-bounds in bpf_int_jit_compile+0x1257/0x13f0
  Read of size 8 at addr ffff888004e90b58 by task syz-executor.0/1489
  CPU: 1 PID: 1489 Comm: syz-executor.0 Not tainted 5.19.0 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  1.13.0-1ubuntu1.1 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x9c/0xc9
   print_address_description.constprop.0+0x1f/0x1f0
   ? bpf_int_jit_compile+0x1257/0x13f0
   kasan_report.cold+0xeb/0x197
   ? kvmalloc_node+0x170/0x200
   ? bpf_int_jit_compile+0x1257/0x13f0
   bpf_int_jit_compile+0x1257/0x13f0
   ? arch_prepare_bpf_dispatcher+0xd0/0xd0
   ? rcu_read_lock_sched_held+0x43/0x70
   bpf_prog_select_runtime+0x3e8/0x640
   ? bpf_obj_name_cpy+0x149/0x1b0
   bpf_prog_load+0x102f/0x2220
   ? __bpf_prog_put.constprop.0+0x220/0x220
   ? find_held_lock+0x2c/0x110
   ? __might_fault+0xd6/0x180
   ? lock_downgrade+0x6e0/0x6e0
   ? lock_is_held_type+0xa6/0x120
   ? __might_fault+0x147/0x180
   __sys_bpf+0x137b/0x6070
   ? bpf_perf_link_attach+0x530/0x530
   ? new_sync_read+0x600/0x600
   ? __fget_files+0x255/0x450
   ? lock_downgrade+0x6e0/0x6e0
   ? fput+0x30/0x1a0
   ? ksys_write+0x1a8/0x260
   __x64_sys_bpf+0x7a/0xc0
   ? syscall_enter_from_user_mode+0x21/0x70
   do_syscall_64+0x3b/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
  RIP: 0033:0x7f917c4e2c2d

The problem here is that a range of tnum_range(0, map->max_entries - 1) has
limited ability to represent the concrete tight range with the tnum as the
set of resulting states from value + mask can result in a superset of the
actual intended range, and as such a tnum_in(range, reg->var_off) check may
yield true when it shouldn't, for example tnum_range(0, 2) would result in
00XX -> v = 0000, m = 0011 such that the intended set of {0, 1, 2} is here
represented by a less precise superset of {0, 1, 2, 3}. As the register is
known const scalar, really just use the concrete reg->var_off.value for the
upper index check.

Fixes: d2e4c1e6c294 ("bpf: Constant map key tracking for prog array pokes")
Reported-by: Hsin-Wei Hung <hsinweih@uci.edu>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/984b37f9fdf7ac36831d2137415a4a915744c1b6.1661462653.git.daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6096,8 +6096,7 @@ record_func_key(struct bpf_verifier_env
 	struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
 	struct bpf_reg_state *regs = cur_regs(env), *reg;
 	struct bpf_map *map = meta->map_ptr;
-	struct tnum range;
-	u64 val;
+	u64 val, max;
 	int err;
 
 	if (func_id != BPF_FUNC_tail_call)
@@ -6107,10 +6106,11 @@ record_func_key(struct bpf_verifier_env
 		return -EINVAL;
 	}
 
-	range = tnum_range(0, map->max_entries - 1);
 	reg = &regs[BPF_REG_3];
+	val = reg->var_off.value;
+	max = map->max_entries;
 
-	if (!register_is_const(reg) || !tnum_in(range, reg->var_off)) {
+	if (!(register_is_const(reg) && val < max)) {
 		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
 		return 0;
 	}
@@ -6118,8 +6118,6 @@ record_func_key(struct bpf_verifier_env
 	err = mark_chain_precision(env, BPF_REG_3);
 	if (err)
 		return err;
-
-	val = reg->var_off.value;
 	if (bpf_map_key_unseen(aux))
 		bpf_map_key_store(aux, val);
 	else if (!bpf_map_key_poisoned(aux) &&


