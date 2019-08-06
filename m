Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651C283D58
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 00:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfHFW2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 18:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfHFW2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 18:28:22 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD4A62086D;
        Tue,  6 Aug 2019 22:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565130501;
        bh=AN7BvyRdw0mAVYYIAD4XXFKtyUywdQ0HZCPhVteESzE=;
        h=Date:From:To:Subject:From;
        b=T9eP27GOw+e2oDkP2KJb3P+WShXX0BtS5f+YrR6F5o3LJnTETdbmRPo2bMi2h7mtY
         Gv9gxRRxNXJDbsJwQmJx+CPgHgYzi0LPD4hpGUQUSQXGDc9ohZeZNUwG+dcsFM3yWv
         gb1Flwej4iEK6O52iv9hcFYPskzNRdSFHyLKXOEM=
Date:   Tue, 06 Aug 2019 15:28:20 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, msharbiani@apple.com,
        penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com,
        stable@vger.kernel.org
Subject:  +
 memcg-oom-dont-require-__gfp_fs-when-invoking-memcg-oom-killer.patch added
 to -mm tree
Message-ID: <20190806222820.EWG3_oeiW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: memcg, oom: don't require __GFP_FS when invoking memcg OOM killer
has been added to the -mm tree.  Its filename is
     memcg-oom-dont-require-__gfp_fs-when-invoking-memcg-oom-killer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-oom-dont-require-__gfp_fs-when-invoking-memcg-oom-killer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-oom-dont-require-__gfp_fs-when-invoking-memcg-oom-killer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: memcg, oom: don't require __GFP_FS when invoking memcg OOM killer

Masoud Sharbiani noticed that commit 29ef680ae7c21110 ("memcg, oom: move
out_of_memory back to the charge path") broke memcg OOM called from
__xfs_filemap_fault() path.  It turned out that try_charge() is retrying
forever without making forward progress because mem_cgroup_oom(GFP_NOFS)
cannot invoke the OOM killer due to commit 3da88fb3bacfaa33 ("mm, oom:
move GFP_NOFS check to out_of_memory").

Allowing forced charge due to being unable to invoke memcg OOM killer will
lead to global OOM situation.  Also, just returning -ENOMEM will be risky
because OOM path is lost and some paths (e.g.  get_user_pages()) will leak
-ENOMEM.  Therefore, invoking memcg OOM killer (despite GFP_NOFS) will be
the only choice we can choose for now.

Until 29ef680ae7c21110, we were able to invoke memcg OOM killer when
GFP_KERNEL reclaim failed [1].  But since 29ef680ae7c21110, we need to
invoke memcg OOM killer when GFP_NOFS reclaim failed [2].  Although in the
past we did invoke memcg OOM killer for GFP_NOFS [3], we might get
pre-mature memcg OOM reports due to this patch.

[1]

 leaker invoked oom-killer: gfp_mask=0x6200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null), order=0, oom_score_adj=0
 CPU: 0 PID: 2746 Comm: leaker Not tainted 4.18.0+ #19
 Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
 Call Trace:
  dump_stack+0x63/0x88
  dump_header+0x67/0x27a
  ? mem_cgroup_scan_tasks+0x91/0xf0
  oom_kill_process+0x210/0x410
  out_of_memory+0x10a/0x2c0
  mem_cgroup_out_of_memory+0x46/0x80
  mem_cgroup_oom_synchronize+0x2e4/0x310
  ? high_work_func+0x20/0x20
  pagefault_out_of_memory+0x31/0x76
  mm_fault_error+0x55/0x115
  ? handle_mm_fault+0xfd/0x220
  __do_page_fault+0x433/0x4e0
  do_page_fault+0x22/0x30
  ? page_fault+0x8/0x30
  page_fault+0x1e/0x30
 RIP: 0033:0x4009f0
 Code: 03 00 00 00 e8 71 fd ff ff 48 83 f8 ff 49 89 c6 74 74 48 89 c6 bf c0 0c 40 00 31 c0 e8 69 fd ff ff 45 85 ff 7e 21 31 c9 66 90 <41> 0f be 14 0e 01 d3 f7 c1 ff 0f 00 00 75 05 41 c6 04 0e 2a 48 83
 RSP: 002b:00007ffe29ae96f0 EFLAGS: 00010206
 RAX: 000000000000001b RBX: 0000000000000000 RCX: 0000000001ce1000
 RDX: 0000000000000000 RSI: 000000007fffffe5 RDI: 0000000000000000
 RBP: 000000000000000c R08: 0000000000000000 R09: 00007f94be09220d
 R10: 0000000000000002 R11: 0000000000000246 R12: 00000000000186a0
 R13: 0000000000000003 R14: 00007f949d845000 R15: 0000000002800000
 Task in /leaker killed as a result of limit of /leaker
 memory: usage 524288kB, limit 524288kB, failcnt 158965
 memory+swap: usage 0kB, limit 9007199254740988kB, failcnt 0
 kmem: usage 2016kB, limit 9007199254740988kB, failcnt 0
 Memory cgroup stats for /leaker: cache:844KB rss:521136KB rss_huge:0KB shmem:0KB mapped_file:0KB dirty:132KB writeback:0KB inactive_anon:0KB active_anon:521224KB inactive_file:1012KB active_file:8KB unevictable:0KB
 Memory cgroup out of memory: Kill process 2746 (leaker) score 998 or sacrifice child
 Killed process 2746 (leaker) total-vm:536704kB, anon-rss:521176kB, file-rss:1208kB, shmem-rss:0kB
 oom_reaper: reaped process 2746 (leaker), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB

[2]

 leaker invoked oom-killer: gfp_mask=0x600040(GFP_NOFS), nodemask=(null), order=0, oom_score_adj=0
 CPU: 1 PID: 2746 Comm: leaker Not tainted 4.18.0+ #20
 Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
 Call Trace:
  dump_stack+0x63/0x88
  dump_header+0x67/0x27a
  ? mem_cgroup_scan_tasks+0x91/0xf0
  oom_kill_process+0x210/0x410
  out_of_memory+0x109/0x2d0
  mem_cgroup_out_of_memory+0x46/0x80
  try_charge+0x58d/0x650
  ? __radix_tree_replace+0x81/0x100
  mem_cgroup_try_charge+0x7a/0x100
  __add_to_page_cache_locked+0x92/0x180
  add_to_page_cache_lru+0x4d/0xf0
  iomap_readpages_actor+0xde/0x1b0
  ? iomap_zero_range_actor+0x1d0/0x1d0
  iomap_apply+0xaf/0x130
  iomap_readpages+0x9f/0x150
  ? iomap_zero_range_actor+0x1d0/0x1d0
  xfs_vm_readpages+0x18/0x20 [xfs]
  read_pages+0x60/0x140
  __do_page_cache_readahead+0x193/0x1b0
  ondemand_readahead+0x16d/0x2c0
  page_cache_async_readahead+0x9a/0xd0
  filemap_fault+0x403/0x620
  ? alloc_set_pte+0x12c/0x540
  ? _cond_resched+0x14/0x30
  __xfs_filemap_fault+0x66/0x180 [xfs]
  xfs_filemap_fault+0x27/0x30 [xfs]
  __do_fault+0x19/0x40
  __handle_mm_fault+0x8e8/0xb60
  handle_mm_fault+0xfd/0x220
  __do_page_fault+0x238/0x4e0
  do_page_fault+0x22/0x30
  ? page_fault+0x8/0x30
  page_fault+0x1e/0x30
 RIP: 0033:0x4009f0
 Code: 03 00 00 00 e8 71 fd ff ff 48 83 f8 ff 49 89 c6 74 74 48 89 c6 bf c0 0c 40 00 31 c0 e8 69 fd ff ff 45 85 ff 7e 21 31 c9 66 90 <41> 0f be 14 0e 01 d3 f7 c1 ff 0f 00 00 75 05 41 c6 04 0e 2a 48 83
 RSP: 002b:00007ffda45c9290 EFLAGS: 00010206
 RAX: 000000000000001b RBX: 0000000000000000 RCX: 0000000001a1e000
 RDX: 0000000000000000 RSI: 000000007fffffe5 RDI: 0000000000000000
 RBP: 000000000000000c R08: 0000000000000000 R09: 00007f6d061ff20d
 R10: 0000000000000002 R11: 0000000000000246 R12: 00000000000186a0
 R13: 0000000000000003 R14: 00007f6ce59b2000 R15: 0000000002800000
 Task in /leaker killed as a result of limit of /leaker
 memory: usage 524288kB, limit 524288kB, failcnt 7221
 memory+swap: usage 0kB, limit 9007199254740988kB, failcnt 0
 kmem: usage 1944kB, limit 9007199254740988kB, failcnt 0
 Memory cgroup stats for /leaker: cache:3632KB rss:518232KB rss_huge:0KB shmem:0KB mapped_file:0KB dirty:0KB writeback:0KB inactive_anon:0KB active_anon:518408KB inactive_file:3908KB active_file:12KB unevictable:0KB
 Memory cgroup out of memory: Kill process 2746 (leaker) score 992 or sacrifice child
 Killed process 2746 (leaker) total-vm:536704kB, anon-rss:518264kB, file-rss:1188kB, shmem-rss:0kB
 oom_reaper: reaped process 2746 (leaker), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB

[3]

 leaker invoked oom-killer: gfp_mask=0x50, order=0, oom_score_adj=0
 leaker cpuset=/ mems_allowed=0
 CPU: 1 PID: 3206 Comm: leaker Not tainted 3.10.0-957.27.2.el7.x86_64 #1
 Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
 Call Trace:
  [<ffffffffaf364147>] dump_stack+0x19/0x1b
  [<ffffffffaf35eb6a>] dump_header+0x90/0x229
  [<ffffffffaedbb456>] ? find_lock_task_mm+0x56/0xc0
  [<ffffffffaee32a38>] ? try_get_mem_cgroup_from_mm+0x28/0x60
  [<ffffffffaedbb904>] oom_kill_process+0x254/0x3d0
  [<ffffffffaee36c36>] mem_cgroup_oom_synchronize+0x546/0x570
  [<ffffffffaee360b0>] ? mem_cgroup_charge_common+0xc0/0xc0
  [<ffffffffaedbc194>] pagefault_out_of_memory+0x14/0x90
  [<ffffffffaf35d072>] mm_fault_error+0x6a/0x157
  [<ffffffffaf3717c8>] __do_page_fault+0x3c8/0x4f0
  [<ffffffffaf371925>] do_page_fault+0x35/0x90
  [<ffffffffaf36d768>] page_fault+0x28/0x30
 Task in /leaker killed as a result of limit of /leaker
 memory: usage 524288kB, limit 524288kB, failcnt 20628
 memory+swap: usage 524288kB, limit 9007199254740988kB, failcnt 0
 kmem: usage 0kB, limit 9007199254740988kB, failcnt 0
 Memory cgroup stats for /leaker: cache:840KB rss:523448KB rss_huge:0KB mapped_file:0KB swap:0KB inactive_anon:0KB active_anon:523448KB inactive_file:464KB active_file:376KB unevictable:0KB
 Memory cgroup out of memory: Kill process 3206 (leaker) score 970 or sacrifice child
 Killed process 3206 (leaker) total-vm:536692kB, anon-rss:523304kB, file-rss:412kB, shmem-rss:0kB

Bisected by Masoud Sharbiani.

Link: http://lkml.kernel.org/r/cbe54ed1-b6ba-a056-8899-2dc42526371d@i-love.sakura.ne.jp
Fixes: 3da88fb3bacfaa33 ("mm, oom: move GFP_NOFS check to out_of_memory") [necessary after 29ef680ae7c21110]
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Masoud Sharbiani <msharbiani@apple.com>
Tested-by: Masoud Sharbiani <msharbiani@apple.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/oom_kill.c~memcg-oom-dont-require-__gfp_fs-when-invoking-memcg-oom-killer
+++ a/mm/oom_kill.c
@@ -1068,9 +1068,10 @@ bool out_of_memory(struct oom_control *o
 	 * The OOM killer does not compensate for IO-less reclaim.
 	 * pagefault_out_of_memory lost its gfp context so we have to
 	 * make sure exclude 0 mask - all other users should have at least
-	 * ___GFP_DIRECT_RECLAIM to get here.
+	 * ___GFP_DIRECT_RECLAIM to get here. But mem_cgroup_oom() has to
+	 * invoke the OOM killer even if it is a GFP_NOFS allocation.
 	 */
-	if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS))
+	if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
 		return true;
 
 	/*
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

memcg-oom-dont-require-__gfp_fs-when-invoking-memcg-oom-killer.patch
kernel-hung_taskc-monitor-killed-tasks.patch

