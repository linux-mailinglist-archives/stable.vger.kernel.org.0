Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DA2302AC5
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbhAYSwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbhAYSv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E44FD22D58;
        Mon, 25 Jan 2021 18:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600703;
        bh=NXCoRw8jWVWg/ALVt88gHWgx5yI3XWaO0ufkZBNv6Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Czag61t7Ow5G+KGqzUnJkZbnD5lNjrgKm6RIjmVJWI36Ta3BzWHA9bdAE+jegHMiM
         tkGjf/dr0uqY+HOyYiJAdOdcn4H90vXpMD2VYUXn8A17TXKYPf3JHMW1mLt316+ZlZ
         qzDNBcWSAucUNsu3lwvwOPxik/CQLo007i3sEXKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/199] bpf: Reject too big ctx_size_in for raw_tp test run
Date:   Mon, 25 Jan 2021 19:38:33 +0100
Message-Id: <20210125183220.111680584@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit 7ac6ad051150592557520b45773201b987ecfce3 ]

syzbot reported a WARNING for allocating too big memory:

WARNING: CPU: 1 PID: 8484 at mm/page_alloc.c:4976 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5011
Modules linked in:
CPU: 1 PID: 8484 Comm: syz-executor862 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
RSP: 0018:ffffc900012efb10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff9200025df66 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000140dc0
RBP: 0000000000140dc0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81b1f7e1 R11: 0000000000000000 R12: 0000000000000014
R13: 0000000000000014 R14: 0000000000000000 R15: 0000000000000000
FS:  000000000190c880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f08b7f316c0 CR3: 0000000012073000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
alloc_pages include/linux/gfp.h:547 [inline]
kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
kmalloc include/linux/slab.h:557 [inline]
kzalloc include/linux/slab.h:682 [inline]
bpf_prog_test_run_raw_tp+0x4b5/0x670 net/bpf/test_run.c:282
bpf_prog_test_run kernel/bpf/syscall.c:3120 [inline]
__do_sys_bpf+0x1ea9/0x4f10 kernel/bpf/syscall.c:4398
do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440499
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe1f3bfb18 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440499
RDX: 0000000000000048 RSI: 0000000020000600 RDI: 000000000000000a
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ca0
R13: 0000000000401d30 R14: 0000000000000000 R15: 0000000000000000

This is because we didn't filter out too big ctx_size_in. Fix it by
rejecting ctx_size_in that are bigger than MAX_BPF_FUNC_ARGS (12) u64
numbers.

Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
Reported-by: syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210112234254.1906829-1-songliubraving@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index c1c30a9f76f34..8b796c499cbb2 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -272,7 +272,8 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 	    kattr->test.repeat)
 		return -EINVAL;
 
-	if (ctx_size_in < prog->aux->max_ctx_offset)
+	if (ctx_size_in < prog->aux->max_ctx_offset ||
+	    ctx_size_in > MAX_BPF_FUNC_ARGS * sizeof(u64))
 		return -EINVAL;
 
 	if ((kattr->test.flags & BPF_F_TEST_RUN_ON_CPU) == 0 && cpu != 0)
-- 
2.27.0



