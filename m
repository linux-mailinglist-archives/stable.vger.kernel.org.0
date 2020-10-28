Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB23829DAD7
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390268AbgJ1XdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390121AbgJ1Xb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 19:31:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10978207BC;
        Wed, 28 Oct 2020 23:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603927915;
        bh=EjC/JUU56nr9jrg/8dZLpVOPHQzV8TPkZLwJsc8DzFA=;
        h=Date:From:To:Subject:From;
        b=I/zwKfFzkeTCXkPR+GYztKgJRGFwq8zFdP6JramvaPW20qqE0Y+YzrhccmCox1QPm
         ohRqsMKvx/m2tXFogwUHiaPVfgFAbXXwfoMSrTkAVRP6hac9GvtLmd5vATFAWdJp6k
         JeUy8pgwAj1t4UgZT9QJ7e3Sr8DXCvy4CRG/lBB8=
Date:   Wed, 28 Oct 2020 16:31:54 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, ltp@lists.linux.it,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        rpalethorpe@suse.com, shakeelb@google.com, stable@vger.kernel.org
Subject:  +
 mm-memcg-link-page-counters-to-root-if-use_hierarchy-is-false.patch added
 to -mm tree
Message-ID: <20201028233154.HmIlG7gKr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg: link page counters to root if use_hierarchy is false
has been added to the -mm tree.  Its filename is
     mm-memcg-link-page-counters-to-root-if-use_hierarchy-is-false.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-link-page-counters-to-root-if-use_hierarchy-is-false.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-link-page-counters-to-root-if-use_hierarchy-is-false.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: link page counters to root if use_hierarchy is false

Richard reported a warning which can be reproduced by running the LTP
madvise6 test (cgroup v1 in the non-hierarchical mode should be used):

[    9.841552] ------------[ cut here ]------------
[    9.841788] WARNING: CPU: 0 PID: 12 at mm/page_counter.c:57 page_counter_uncharge (mm/page_counter.c:57 mm/page_counter.c:50 mm/page_counter.c:156)
[    9.841982] Modules linked in:
[    9.842072] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.9.0-rc7-22-default #77
[    9.842266] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-48-gd9c812d-rebuilt.opensuse.org 04/01/2014
[    9.842571] Workqueue: events drain_local_stock
[    9.842750] RIP: 0010:page_counter_uncharge (mm/page_counter.c:57 mm/page_counter.c:50 mm/page_counter.c:156)
[ 9.842894] Code: 0f c1 45 00 4c 29 e0 48 89 ef 48 89 c3 48 89 c6 e8 2a fe ff ff 48 85 db 78 10 48 8b 6d 28 48 85 ed 75 d8 5b 5d 41 5c 41 5d c3 <0f> 0b eb ec 90 e8 4b f9 88 2a 48 8b 17 48 39 d6 72 41 41 54 49 89
[    9.843438] RSP: 0018:ffffb1c18006be28 EFLAGS: 00010086
[    9.843585] RAX: ffffffffffffffff RBX: ffffffffffffffff RCX: ffff94803bc2cae0
[    9.843806] RDX: 0000000000000001 RSI: ffffffffffffffff RDI: ffff948007d2b248
[    9.844026] RBP: ffff948007d2b248 R08: ffff948007c58eb0 R09: ffff948007da05ac
[    9.844248] R10: 0000000000000018 R11: 0000000000000018 R12: 0000000000000001
[    9.844477] R13: ffffffffffffffff R14: 0000000000000000 R15: ffff94803bc2cac0
[    9.844696] FS:  0000000000000000(0000) GS:ffff94803bc00000(0000) knlGS:0000000000000000
[    9.844915] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.845096] CR2: 00007f0579ee0384 CR3: 000000002cc0a000 CR4: 00000000000006f0
[    9.845319] Call Trace:
[    9.845429] __memcg_kmem_uncharge (mm/memcontrol.c:3022)
[    9.845582] drain_obj_stock (./include/linux/rcupdate.h:689 mm/memcontrol.c:3114)
[    9.845684] drain_local_stock (mm/memcontrol.c:2255)
[    9.845789] process_one_work (./arch/x86/include/asm/jump_label.h:25 ./include/linux/jump_label.h:200 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2274)
[    9.845898] worker_thread (./include/linux/list.h:282 kernel/workqueue.c:2416)
[    9.846034] ? process_one_work (kernel/workqueue.c:2358)
[    9.846162] kthread (kernel/kthread.c:292)
[    9.846271] ? __kthread_bind_mask (kernel/kthread.c:245)
[    9.846420] ret_from_fork (arch/x86/entry/entry_64.S:300)
[    9.846531] ---[ end trace 8b5647c1eba9d18a ]---

The problem occurs because in the non-hierarchical mode non-root page
counters are not linked to root page counters, so the charge is not
propagated to the root memory cgroup.

After the removal of the original memory cgroup and reparenting of the
object cgroup, the root cgroup might be uncharged by draining a objcg
stock, for example.  It leads to an eventual underflow of the charge and
triggers a warning.

Fix it by linking all page counters to corresponding root page counters in
the non-hierarchical mode.

Please note, that in the non-hierarchical mode all objcgs are always
reparented to the root memory cgroup, even if the hierarchy has more than
1 level.  This patch doesn't change it.

The patch also doesn't affect how the hierarchical mode is working, which
is the only sane and truly supported mode now.

Thanks to Richard for reporting, debugging and providing an alternative
version of the fix!

Link: https://lkml.kernel.org/r/20201026231326.3212225-1-guro@fb.com
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Roman Gushchin <guro@fb.com>
Debugged-by: Richard Palethorpe <rpalethorpe@suse.com>
Reported-by: <ltp@lists.linux.it>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-link-page-counters-to-root-if-use_hierarchy-is-false
+++ a/mm/memcontrol.c
@@ -5345,17 +5345,22 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		memcg->swappiness = mem_cgroup_swappiness(parent);
 		memcg->oom_kill_disable = parent->oom_kill_disable;
 	}
-	if (parent && parent->use_hierarchy) {
+	if (!parent) {
+		page_counter_init(&memcg->memory, NULL);
+		page_counter_init(&memcg->swap, NULL);
+		page_counter_init(&memcg->kmem, NULL);
+		page_counter_init(&memcg->tcpmem, NULL);
+	} else if (parent->use_hierarchy) {
 		memcg->use_hierarchy = true;
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 	} else {
-		page_counter_init(&memcg->memory, NULL);
-		page_counter_init(&memcg->swap, NULL);
-		page_counter_init(&memcg->kmem, NULL);
-		page_counter_init(&memcg->tcpmem, NULL);
+		page_counter_init(&memcg->memory, &root_mem_cgroup->memory);
+		page_counter_init(&memcg->swap, &root_mem_cgroup->swap);
+		page_counter_init(&memcg->kmem, &root_mem_cgroup->kmem);
+		page_counter_init(&memcg->tcpmem, &root_mem_cgroup->tcpmem);
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-link-page-counters-to-root-if-use_hierarchy-is-false.patch
mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

