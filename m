Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CB343A2B7
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbhJYTvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237428AbhJYTtk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:49:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C25361251;
        Mon, 25 Oct 2021 19:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190916;
        bh=uV89N0vC3aNBinJGFFRnOJN0PftXVKeOCX1Zd4WM3j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMRtCaoxfLbF6HbuakQqneALYXhcbBNYubEyIAaY6AwqVAz1Bs0pVSfhsxg0ZngwF
         wT2+OouNcxR/1wPKXY3Qr0pfsfpgZICBUkA3y+xtiE7EJQPQcMvQnJyakegvQZXZPt
         qhbfGwrxZiO0o9VA19im0UYJtTxTAiSlow61qxRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mel Gorman <mgorman@suse.de>,
        "Huang, Ying" <ying.huang@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 082/169] mm/mempolicy: do not allow illegal MPOL_F_NUMA_BALANCING | MPOL_LOCAL in mbind()
Date:   Mon, 25 Oct 2021 21:14:23 +0200
Message-Id: <20211025191027.693567597@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 6d2aec9e123bb9c49cb5c7fc654f25f81e688e8c upstream.

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

Link: https://lkml.kernel.org/r/20211001215630.810592-1-eric.dumazet@gmail.com
Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -857,16 +857,6 @@ static long do_set_mempolicy(unsigned sh
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
@@ -1450,7 +1440,11 @@ static inline int sanitize_mpol_flags(in
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
 


