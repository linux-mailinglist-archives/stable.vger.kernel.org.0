Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DE8F7DC9
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKKS7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:59:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbfKKS4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:56:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3810921655;
        Mon, 11 Nov 2019 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498561;
        bh=yHbuZVEu0siH6X7DydD9ZaNfOeGC7T89UYt3yP5tc/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKweOp5irn5xdGVaxrLG2nhh7jZC9qeg/7AzX127I/n1Wy7wrFvPzAQ5f/WBKDkkd
         rlvaD7CqQgPf31R+sXJ5vTv7QxBh9syUvMsuzMO0qbchODQmGIqbRx6xugCKw1tUMz
         sqQ2jrgJNCMx2tzRiOVoyO5k5DfeHTki6P+6zwnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+710043c5d1d5b5013bc7@syzkaller.appspotmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 115/193] bpf: Fix use after free in subprogs jited symbol removal
Date:   Mon, 11 Nov 2019 19:28:17 +0100
Message-Id: <20191111181509.631551630@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit cd7455f1013ef96d5cbf5c05d2b7c06f273810a6 ]

syzkaller managed to trigger the following crash:

  [...]
  BUG: unable to handle page fault for address: ffffc90001923030
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD aa551067 P4D aa551067 PUD aa552067 PMD a572b067 PTE 80000000a1173163
  Oops: 0000 [#1] PREEMPT SMP KASAN
  CPU: 0 PID: 7982 Comm: syz-executor912 Not tainted 5.4.0-rc3+ #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:bpf_jit_binary_hdr include/linux/filter.h:787 [inline]
  RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:531 [inline]
  RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
  RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
  RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
  RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
  RIP: 0010:is_bpf_text_address+0x184/0x3b0 kernel/bpf/core.c:709
  [...]
  Call Trace:
   kernel_text_address kernel/extable.c:147 [inline]
   __kernel_text_address+0x9a/0x110 kernel/extable.c:102
   unwind_get_return_address+0x4c/0x90 arch/x86/kernel/unwind_frame.c:19
   arch_stack_walk+0x98/0xe0 arch/x86/kernel/stacktrace.c:26
   stack_trace_save+0xb6/0x150 kernel/stacktrace.c:123
   save_stack mm/kasan/common.c:69 [inline]
   set_track mm/kasan/common.c:77 [inline]
   __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:510
   kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:518
   slab_post_alloc_hook mm/slab.h:584 [inline]
   slab_alloc mm/slab.c:3319 [inline]
   kmem_cache_alloc+0x1f5/0x2e0 mm/slab.c:3483
   getname_flags+0xba/0x640 fs/namei.c:138
   getname+0x19/0x20 fs/namei.c:209
   do_sys_open+0x261/0x560 fs/open.c:1091
   __do_sys_open fs/open.c:1115 [inline]
   __se_sys_open fs/open.c:1110 [inline]
   __x64_sys_open+0x87/0x90 fs/open.c:1110
   do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [...]

After further debugging it turns out that we walk kallsyms while in parallel
we tear down a BPF program which contains subprograms that have been JITed
though the program itself has not been fully exposed and is eventually bailing
out with error.

The bpf_prog_kallsyms_del_subprogs() in bpf_prog_load()'s error path removes
the symbols, however, bpf_prog_free() tears down the JIT memory too early via
scheduled work. Instead, it needs to properly respect RCU grace period as the
kallsyms walk for BPF is under RCU.

Fix it by refactoring __bpf_prog_put()'s tear down and reuse it in our error
path where we defer final destruction when we have subprogs in the program.

Fixes: 7d1982b4e335 ("bpf: fix panic in prog load calls cleanup")
Fixes: 1c2a088a6626 ("bpf: x64: add JIT support for multi-function programs")
Reported-by: syzbot+710043c5d1d5b5013bc7@syzkaller.appspotmail.com
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: syzbot+710043c5d1d5b5013bc7@syzkaller.appspotmail.com
Link: https://lore.kernel.org/bpf/55f6367324c2d7e9583fa9ccf5385dcbba0d7a6e.1571752452.git.daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h |  1 -
 kernel/bpf/core.c      |  2 +-
 kernel/bpf/syscall.c   | 31 ++++++++++++++++++++-----------
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 92c6e31fb008e..38716f93825f4 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1099,7 +1099,6 @@ static inline void bpf_get_prog_name(const struct bpf_prog *prog, char *sym)
 
 #endif /* CONFIG_BPF_JIT */
 
-void bpf_prog_kallsyms_del_subprogs(struct bpf_prog *fp);
 void bpf_prog_kallsyms_del_all(struct bpf_prog *fp);
 
 #define BPF_ANC		BIT(15)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 66088a9e9b9e2..ef0e1e3e66f4a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -502,7 +502,7 @@ int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
 	return WARN_ON_ONCE(bpf_adj_branches(prog, off, off + cnt, off, false));
 }
 
-void bpf_prog_kallsyms_del_subprogs(struct bpf_prog *fp)
+static void bpf_prog_kallsyms_del_subprogs(struct bpf_prog *fp)
 {
 	int i;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 272071e9112f3..af5c60b07463e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1322,18 +1322,26 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 	bpf_prog_free(aux->prog);
 }
 
+static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
+{
+	bpf_prog_kallsyms_del_all(prog);
+	btf_put(prog->aux->btf);
+	kvfree(prog->aux->func_info);
+	bpf_prog_free_linfo(prog);
+
+	if (deferred)
+		call_rcu(&prog->aux->rcu, __bpf_prog_put_rcu);
+	else
+		__bpf_prog_put_rcu(&prog->aux->rcu);
+}
+
 static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
 {
 	if (atomic_dec_and_test(&prog->aux->refcnt)) {
 		perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
 		/* bpf_prog_free_id() must be called first */
 		bpf_prog_free_id(prog, do_idr_lock);
-		bpf_prog_kallsyms_del_all(prog);
-		btf_put(prog->aux->btf);
-		kvfree(prog->aux->func_info);
-		bpf_prog_free_linfo(prog);
-
-		call_rcu(&prog->aux->rcu, __bpf_prog_put_rcu);
+		__bpf_prog_put_noref(prog, true);
 	}
 }
 
@@ -1730,11 +1738,12 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	return err;
 
 free_used_maps:
-	bpf_prog_free_linfo(prog);
-	kvfree(prog->aux->func_info);
-	btf_put(prog->aux->btf);
-	bpf_prog_kallsyms_del_subprogs(prog);
-	free_used_maps(prog->aux);
+	/* In case we have subprogs, we need to wait for a grace
+	 * period before we can tear down JIT memory since symbols
+	 * are already exposed under kallsyms.
+	 */
+	__bpf_prog_put_noref(prog, prog->aux->func_cnt);
+	return err;
 free_prog:
 	bpf_prog_uncharge_memlock(prog);
 free_prog_sec:
-- 
2.20.1



