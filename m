Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EADF4329A4
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhJRWSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5EC56113E;
        Mon, 18 Oct 2021 22:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595350;
        bh=r8rlNC+5owR6jRXBclC5Y8cBXnqjPDwrNlGaN/Lxids=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qeUwja0CYgV+66c/DvkYUnCm1rfqPqy977rYTISAwdyGSmpvfd2d1F1O5qTTfOyCk
         xIx1tkcmxiDh0Vx4x/ixA/uuXi+AfuJnmd17B2/xbikTBqIMizgVD6ufdiI+41wnCA
         pdcH3P8uYBrEivFR4NBtKAnlifgkyETB0VT3U+3s=
Date:   Mon, 18 Oct 2021 15:15:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com, linux-mm@kvack.org,
        mgorman@suse.de, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, syzkaller@googlegroups.com,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 09/19] mm/mempolicy: do not allow illegal
 MPOL_F_NUMA_BALANCING | MPOL_LOCAL in mbind()
Message-ID: <20211018221549.lEzQke3fH%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Subject: mm/mempolicy: do not allow illegal MPOL_F_NUMA_BALANCING | MPOL_LOCAL in mbind()

syzbot reported access to unitialized memory in mbind() [1]

Issue came with commit bda420b98505 ("numa balancing: migrate on fault
among multiple bound nodes")

This commit added a new bit in MPOL_MODE_FLAGS, but only checked valid
combination (MPOL_F_NUMA_BALANCING can only be used with MPOL_BIND) in
do_set_mempolicy()

This patch moves the check in sanitize_mpol_flags() so that it is also
used by mbind()

[1]
BUG: KMSAN: uninit-value in __mpol_equal+0x567/0x590 mm/mempolicy.c:2260
 __mpol_equal+0x567/0x590 mm/mempolicy.c:2260
 mpol_equal include/linux/mempolicy.h:105 [inline]
 vma_merge+0x4a1/0x1e60 mm/mmap.c:1190
 mbind_range+0xcc8/0x1e80 mm/mempolicy.c:811
 do_mbind+0xf42/0x15f0 mm/mempolicy.c:1333
 kernel_mbind mm/mempolicy.c:1483 [inline]
 __do_sys_mbind mm/mempolicy.c:1490 [inline]
 __se_sys_mbind+0x437/0xb80 mm/mempolicy.c:1486
 __x64_sys_mbind+0x19d/0x200 mm/mempolicy.c:1486
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_alloc_node mm/slub.c:3221 [inline]
 slab_alloc mm/slub.c:3230 [inline]
 kmem_cache_alloc+0x751/0xff0 mm/slub.c:3235
 mpol_new mm/mempolicy.c:293 [inline]
 do_mbind+0x912/0x15f0 mm/mempolicy.c:1289
 kernel_mbind mm/mempolicy.c:1483 [inline]
 __do_sys_mbind mm/mempolicy.c:1490 [inline]
 __se_sys_mbind+0x437/0xb80 mm/mempolicy.c:1486
 __x64_sys_mbind+0x19d/0x200 mm/mempolicy.c:1486
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae
=====================================================
Kernel panic - not syncing: panic_on_kmsan set ...
CPU: 0 PID: 15049 Comm: syz-executor.0 Tainted: G    B             5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1ff/0x28e lib/dump_stack.c:106
 dump_stack+0x25/0x28 lib/dump_stack.c:113
 panic+0x44f/0xdeb kernel/panic.c:232
 kmsan_report+0x2ee/0x300 mm/kmsan/report.c:186
 __msan_warning+0xd7/0x150 mm/kmsan/instrumentation.c:208
 __mpol_equal+0x567/0x590 mm/mempolicy.c:2260
 mpol_equal include/linux/mempolicy.h:105 [inline]
 vma_merge+0x4a1/0x1e60 mm/mmap.c:1190
 mbind_range+0xcc8/0x1e80 mm/mempolicy.c:811
 do_mbind+0xf42/0x15f0 mm/mempolicy.c:1333
 kernel_mbind mm/mempolicy.c:1483 [inline]
 __do_sys_mbind mm/mempolicy.c:1490 [inline]
 __se_sys_mbind+0x437/0xb80 mm/mempolicy.c:1486
 __x64_sys_mbind+0x19d/0x200 mm/mempolicy.c:1486
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4a41b2c709
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4a3f0a3188 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
RAX: ffffffffffffffda RBX: 00007f4a41c30f60 RCX: 00007f4a41b2c709
RDX: 0000000000002001 RSI: 0000000000c00007 RDI: 0000000020012000
RBP: 00007f4a41b86cb4 R08: 0000000000000000 R09: 0000010000000002
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4a42164b2f R14: 00007f4a3f0a3300 R15: 0000000000022000

Link: https://lkml.kernel.org/r/20211001215630.810592-1-eric.dumazet@gmail.com
Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-do-not-allow-illegal-mpol_f_numa_balancing-mpol_local-in-mbind
+++ a/mm/mempolicy.c
@@ -856,16 +856,6 @@ static long do_set_mempolicy(unsigned sh
 		goto out;
 	}
 
-	if (flags & MPOL_F_NUMA_BALANCING) {
-		if (new && new->mode == MPOL_BIND) {
-			new->flags |= (MPOL_F_MOF | MPOL_F_MORON);
-		} else {
-			ret = -EINVAL;
-			mpol_put(new);
-			goto out;
-		}
-	}
-
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
 		mpol_put(new);
@@ -1458,7 +1448,11 @@ static inline int sanitize_mpol_flags(in
 		return -EINVAL;
 	if ((*flags & MPOL_F_STATIC_NODES) && (*flags & MPOL_F_RELATIVE_NODES))
 		return -EINVAL;
-
+	if (*flags & MPOL_F_NUMA_BALANCING) {
+		if (*mode != MPOL_BIND)
+			return -EINVAL;
+		*flags |= (MPOL_F_MOF | MPOL_F_MORON);
+	}
 	return 0;
 }
 
_
