Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97717CCD72
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 02:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfJFAUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 20:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfJFAUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Oct 2019 20:20:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A8FA222C5;
        Sun,  6 Oct 2019 00:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570321215;
        bh=UPGToWJQ+plG1YbUA3szUfefk4rsiaedpRnvrVDS/Ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tLgMi4oMMWlPjOPa1eQyh6MwFjXyFGG8wPwFDiZ5X1My7eje9KXBMgKRLdD2kAgpm
         DfVMnpBKUi7y9wuONt/wSsLgMDGQ/FeGYYbjBemKvCcXklMM3lu4ceRtnBXkF9n1HG
         3FoEdFvnS9ke6FGHx5jHYQrpyyfvGHD3P/hNDYpU=
Date:   Sat, 5 Oct 2019 20:20:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, daniel@iogearbox.net, songliubraving@fb.com,
        ast@kernel.org
Subject: Re: [v4.14.y] bpf: fix use after free in prog symbol exposure
Message-ID: <20191006002014.GF25255@sasha-vm>
References: <20191004174112.32217-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191004174112.32217-1-zsm@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 10:41:12AM -0700, Zubin Mithra wrote:
>From: Daniel Borkmann <daniel@iogearbox.net>
>
>commit c751798aa224fadc5124b49eeb38fb468c0fa039 upstream.
>
>syzkaller managed to trigger the warning in bpf_jit_free() which checks via
>bpf_prog_kallsyms_verify_off() for potentially unlinked JITed BPF progs
>in kallsyms, and subsequently trips over GPF when walking kallsyms entries:
>
>  [...]
>  8021q: adding VLAN 0 to HW filter on device batadv0
>  8021q: adding VLAN 0 to HW filter on device batadv0
>  WARNING: CPU: 0 PID: 9869 at kernel/bpf/core.c:810 bpf_jit_free+0x1e8/0x2a0
>  Kernel panic - not syncing: panic_on_warn set ...
>  CPU: 0 PID: 9869 Comm: kworker/0:7 Not tainted 5.0.0-rc8+ #1
>  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>  Workqueue: events bpf_prog_free_deferred
>  Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x113/0x167 lib/dump_stack.c:113
>   panic+0x212/0x40b kernel/panic.c:214
>   __warn.cold.8+0x1b/0x38 kernel/panic.c:571
>   report_bug+0x1a4/0x200 lib/bug.c:186
>   fixup_bug arch/x86/kernel/traps.c:178 [inline]
>   do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:271
>   do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:290
>   invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
>  RIP: 0010:bpf_jit_free+0x1e8/0x2a0
>  Code: 02 4c 89 e2 83 e2 07 38 d0 7f 08 84 c0 0f 85 86 00 00 00 48 ba 00 02 00 00 00 00 ad de 0f b6 43 02 49 39 d6 0f 84 5f fe ff ff <0f> 0b e9 58 fe ff ff 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1
>  RSP: 0018:ffff888092f67cd8 EFLAGS: 00010202
>  RAX: 0000000000000007 RBX: ffffc90001947000 RCX: ffffffff816e9d88
>  RDX: dead000000000200 RSI: 0000000000000008 RDI: ffff88808769f7f0
>  RBP: ffff888092f67d00 R08: fffffbfff1394059 R09: fffffbfff1394058
>  R10: fffffbfff1394058 R11: ffffffff89ca02c7 R12: ffffc90001947002
>  R13: ffffc90001947020 R14: ffffffff881eca80 R15: ffff88808769f7e8
>  BUG: unable to handle kernel paging request at fffffbfff400d000
>  #PF error: [normal kernel read fault]
>  PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9f942067 PTE 0
>  Oops: 0000 [#1] PREEMPT SMP KASAN
>  CPU: 0 PID: 9869 Comm: kworker/0:7 Not tainted 5.0.0-rc8+ #1
>  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>  Workqueue: events bpf_prog_free_deferred
>  RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:495 [inline]
>  RIP: 0010:bpf_tree_comp kernel/bpf/core.c:558 [inline]
>  RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
>  RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
>  RIP: 0010:bpf_prog_kallsyms_find+0x107/0x2e0 kernel/bpf/core.c:632
>  Code: 00 f0 ff ff 44 38 c8 7f 08 84 c0 0f 85 fa 00 00 00 41 f6 45 02 01 75 02 0f 0b 48 39 da 0f 82 92 00 00 00 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 45 01 00 00 8b 03 48 c1 e0
>  [...]
>
>Upon further debugging, it turns out that whenever we trigger this
>issue, the kallsyms removal in bpf_prog_ksym_node_del() was /skipped/
>but yet bpf_jit_free() reported that the entry is /in use/.
>
>Problem is that symbol exposure via bpf_prog_kallsyms_add() but also
>perf_event_bpf_event() were done /after/ bpf_prog_new_fd(). Once the
>fd is exposed to the public, a parallel close request came in right
>before we attempted to do the bpf_prog_kallsyms_add().
>
>Given at this time the prog reference count is one, we start to rip
>everything underneath us via bpf_prog_release() -> bpf_prog_put().
>The memory is eventually released via deferred free, so we're seeing
>that bpf_jit_free() has a kallsym entry because we added it from
>bpf_prog_load() but /after/ bpf_prog_put() from the remote CPU.
>
>Therefore, move both notifications /before/ we install the fd. The
>issue was never seen between bpf_prog_alloc_id() and bpf_prog_new_fd()
>because upon bpf_prog_get_fd_by_id() we'll take another reference to
>the BPF prog, so we're still holding the original reference from the
>bpf_prog_load().
>
>Fixes: 6ee52e2a3fe4 ("perf, bpf: Introduce PERF_RECORD_BPF_EVENT")
>Fixes: 74451e66d516 ("bpf: make jited programs visible in traces")
>Reported-by: syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com
>Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>Cc: Song Liu <songliubraving@fb.com>
>Signed-off-by: Zubin Mithra <zsm@chromium.org>
>---
>Notes:
>* Syzkaller triggered a WARNING on 4.14 kernels with the following
>stacktrace:
>Call Trace:
>  dump_stack+0x81/0xb3
>  panic+0x14a/0x2ad
>  ? refcount_error_report+0xf6/0xf6
>  ? set_fs+0x1a/0x29
>  ? bpf_jit_free+0x8b/0xce
>  __warn+0xde/0x112
>  ? bpf_jit_free+0x8b/0xce
>  report_bug+0x91/0xda
>  fixup_bug+0x2c/0x4c
>  do_error_trap+0xda/0x192
>  ? fixup_bug+0x4c/0x4c
>  ? hlock_class+0x6d/0x8b
>  ? mark_lock+0x3a/0x26d
>  ? trace_hardirqs_off_caller+0xf2/0xfb
>  ? trace_hardirqs_off_thunk+0x1a/0x1c
>  invalid_op+0x1b/0x40
>  ? bpf_jit_binary_free+0x15/0x20
>  ? bpf_jit_free+0x7b/0xce
>  process_one_work+0x484/0x793
>  ? wq_calc_node_cpumask.constprop.37+0x25/0x25
>  ? worker_clr_flags+0x52/0x88
>  worker_thread+0x2b8/0x3d1
>  ? rescuer_thread+0x425/0x425
>  kthread+0x192/0x1a2
>  ? __list_del_entry+0x41/0x41
>  ret_from_fork+0x3a/0x50
>
>* The commit is not present in linux-4.19.y. A backport has been sent
>separately.
>
>* The patch resolves conflicts inside bpf_prog_load that arise due to
>trace_bpf_prog_load() not being present upstream when c751798aa224 was
>applied and perf_event_bpf_event() not being present in linux-4.14.y.
>
>* Tests run: Chrome OS tryjobs, Syzkaller reproducer

I've queued this and the 4.14 one, thanks!

A side note: the patch claims to fix 6ee52e2a3fe4 ("perf, bpf: Introduce
PERF_RECORD_BPF_EVENT"), but since you've reproduced it on 4.19 which
doesn't have that commit I've ignored that annotation.

-- 
Thanks,
Sasha
