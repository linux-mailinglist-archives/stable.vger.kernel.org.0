Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA96DD5EE
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 03:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfJSBTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 21:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfJSBTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 21:19:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 622D8222C5;
        Sat, 19 Oct 2019 01:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571447973;
        bh=ED8I6ZU3xp7rcyRpeI5pCNAY+2BU5SOnDRjjdGm0rcg=;
        h=Date:From:To:Subject:From;
        b=G83uLm/2EDfbwgzz7Z5kPZ0n4TygjXZsyIr4PXQ4rJygkqhVhmft/W0x0c1nxMtJZ
         EjuI3nCsuSTBiBZ37RvseflFIjm16BI+JMQxfNgTVqweSBffHTDegoGAqgQZ0B6WXz
         3QbEwd4cSNOHRYdSg6KOAqzhxdC6zEJvfNwF8hQs=
Date:   Fri, 18 Oct 2019 18:19:32 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patch added to -mm
 tree
Message-ID: <20191019011932.yANWy0LFJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix NULL-ptr deref in percpu stats flush
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: memcontrol: fix NULL-ptr deref in percpu stats flush

__mem_cgroup_free() can be called on the failure path in
mem_cgroup_alloc().  However memcg_flush_percpu_vmstats() and
memcg_flush_percpu_vmevents() which are called from __mem_cgroup_free()
access the fields of memcg which can potentially be null if called from
failure path from mem_cgroup_alloc().  Indeed syzbot has reported the
following crash:

	R13: 00000000004bf27d R14: 00000000004db028 R15: 0000000000000003
	kasan: CONFIG_KASAN_INLINE enabled
	kasan: GPF could be caused by NULL-ptr deref or user memory access
	general protection fault: 0000 [#1] PREEMPT SMP KASAN
	CPU: 0 PID: 30393 Comm: syz-executor.1 Not tainted 5.4.0-rc2+ #0
	Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
	RIP: 0010:memcg_flush_percpu_vmstats+0x4ae/0x930 mm/memcontrol.c:3436
	Code: 05 41 89 c0 41 0f b6 04 24 41 38 c7 7c 08 84 c0 0f 85 5d 03 00 00 44 3b 05 33 d5 12 08 0f 83 e2 00 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 0f 85 91 03 00 00 48 8b 85 10 fe ff ff 48 8b b0 90
	RSP: 0018:ffff888095c27980 EFLAGS: 00010206
	RAX: 0000000000000012 RBX: ffff888095c27b28 RCX: ffffc90008192000
	RDX: 0000000000040000 RSI: ffffffff8340fae7 RDI: 0000000000000007
	RBP: ffff888095c27be0 R08: 0000000000000000 R09: ffffed1013f0da33
	R10: ffffed1013f0da32 R11: ffff88809f86d197 R12: fffffbfff138b760
	R13: dffffc0000000000 R14: 0000000000000090 R15: 0000000000000007
	FS:  00007f5027170700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 0000000000710158 CR3: 00000000a7b18000 CR4: 00000000001406f0
	DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
	Call Trace:
	__mem_cgroup_free+0x1a/0x190 mm/memcontrol.c:5021
	mem_cgroup_free mm/memcontrol.c:5033 [inline]
	mem_cgroup_css_alloc+0x3a1/0x1ae0 mm/memcontrol.c:5160
	css_create kernel/cgroup/cgroup.c:5156 [inline]
	cgroup_apply_control_enable+0x44d/0xc40 kernel/cgroup/cgroup.c:3119
	cgroup_mkdir+0x899/0x11b0 kernel/cgroup/cgroup.c:5401
	kernfs_iop_mkdir+0x14d/0x1d0 fs/kernfs/dir.c:1124
	vfs_mkdir+0x42e/0x670 fs/namei.c:3807
	do_mkdirat+0x234/0x2a0 fs/namei.c:3830
	__do_sys_mkdir fs/namei.c:3846 [inline]
	__se_sys_mkdir fs/namei.c:3844 [inline]
	__x64_sys_mkdir+0x5c/0x80 fs/namei.c:3844
	do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
	entry_SYSCALL_64_after_hwframe+0x49/0xbe
	RIP: 0033:0x459a59
	Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
	RSP: 002b:00007f502716fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
	RAX: ffffffffffffffda RBX: 00007f502716fc90 RCX: 0000000000459a59
	RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000180
	RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
	R10: 0000000000000000 R11: 0000000000000246 R12: 00007f50271706d4
	R13: 00000000004bf27d R14: 00000000004db028 R15: 0000000000000003

Fixing this by moving the flush to mem_cgroup_free as there is no need
to flush anything if we see failure in mem_cgroup_alloc().

Link: http://lkml.kernel.org/r/20191018165231.249872-1-shakeelb@google.com
Fixes: bb65f89b7d3d ("mm: memcontrol: flush percpu vmevents before releasing memcg")
Fixes: c350a99ea2b1 ("mm: memcontrol: flush percpu vmstats before releasing memcg")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: syzbot+515d5bcfe179cdf049b2@syzkaller.appspotmail.com
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush
+++ a/mm/memcontrol.c
@@ -5014,12 +5014,6 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
-	/*
-	 * Flush percpu vmstats and vmevents to guarantee the value correctness
-	 * on parent's and all ancestor levels.
-	 */
-	memcg_flush_percpu_vmstats(memcg, false);
-	memcg_flush_percpu_vmevents(memcg);
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->vmstats_percpu);
@@ -5030,6 +5024,12 @@ static void __mem_cgroup_free(struct mem
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	memcg_wb_domain_exit(memcg);
+	/*
+	 * Flush percpu vmstats and vmevents to guarantee the value correctness
+	 * on parent's and all ancestor levels.
+	 */
+	memcg_flush_percpu_vmstats(memcg, false);
+	memcg_flush_percpu_vmevents(memcg);
 	__mem_cgroup_free(memcg);
 }
 
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patch

