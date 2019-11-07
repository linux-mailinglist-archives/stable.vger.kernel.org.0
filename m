Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4CCF2451
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 02:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732889AbfKGBeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 20:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbfKGBeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 20:34:12 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 369F9217F5;
        Thu,  7 Nov 2019 01:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573090451;
        bh=unaCt7tLLg2qX+uz1fi+U21wun84dJ5esZR0Gfgtr2w=;
        h=Date:From:To:Subject:From;
        b=PD8pHeclyMtnD/cFwiV77rwkct65SP/1/N05eqyP3lO3f94ifFjKjSUK56bKsvOX1
         Ee2PsEzoqSpHMCG6lw/IUKoDXlMasT9aYRCMbDsZoth+6GqstY1uIUI16q1XL4/ULJ
         CViTDV58PISJfx6aM0yQNjt+EiX/mv6eg2Wj72lA=
Date:   Wed, 06 Nov 2019 17:34:10 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org
Subject:  +
 mm-memcg-switch-to-css_tryget-in-get_mem_cgroup_from_mm.patch added to -mm
 tree
Message-ID: <20191107013410.BhQ6pwGQb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
has been added to the -mm tree.  Its filename is
     mm-memcg-switch-to-css_tryget-in-get_mem_cgroup_from_mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-switch-to-css_tryget-in-get_mem_cgroup_from_mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-switch-to-css_tryget-in-get_mem_cgroup_from_mm.patch

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
Subject: mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()

We've encountered a rcu stall in get_mem_cgroup_from_mm():

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu: 33-....: (21000 ticks this GP) idle=6c6/1/0x4000000000000002 softirq=35441/35441 fqs=5017
 (t=21031 jiffies g=324821 q=95837) NMI backtrace for cpu 33
 <...>
 RIP: 0010:get_mem_cgroup_from_mm+0x2f/0x90
 <...>
 __memcg_kmem_charge+0x55/0x140
 __alloc_pages_nodemask+0x267/0x320
 pipe_write+0x1ad/0x400
 new_sync_write+0x127/0x1c0
 __kernel_write+0x4f/0xf0
 dump_emit+0x91/0xc0
 writenote+0xa0/0xc0
 elf_core_dump+0x11af/0x1430
 do_coredump+0xc65/0xee0
 ? unix_stream_sendmsg+0x37d/0x3b0
 get_signal+0x132/0x7c0
 do_signal+0x36/0x640
 ? recalc_sigpending+0x17/0x50
 exit_to_usermode_loop+0x61/0xd0
 do_syscall_64+0xd4/0x100
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The problem is caused by an exiting task which is associated with an
offline memcg.  We're iterating over and over in the do {} while
(!css_tryget_online()) loop, but obviously the memcg won't become online
and the exiting task won't be migrated to a live memcg.

Let's fix it by switching from css_tryget_online() to css_tryget().

As css_tryget_online() cannot guarantee that the memcg won't go offline,
the check is usually useless, except some rare cases when for example it
determines if something should be presented to a user.

A similar problem is described by commit 18fa84a2db0e ("cgroup: Use
css_tryget() instead of css_tryget_online() in task_get_css()").

Johannes:

: The bug aside, it doesn't matter whether the cgroup is online for the
: callers.  It used to matter when offlining needed to evacuate all charges
: from the memcg, and so needed to prevent new ones from showing up, but we
: don't care now.

Link: http://lkml.kernel.org/r/20191106225131.3543616-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-switch-to-css_tryget-in-get_mem_cgroup_from_mm
+++ a/mm/memcontrol.c
@@ -960,7 +960,7 @@ struct mem_cgroup *get_mem_cgroup_from_m
 			if (unlikely(!memcg))
 				memcg = root_mem_cgroup;
 		}
-	} while (!css_tryget_online(&memcg->css));
+	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
 }
_

Patches currently in -mm which might be from guro@fb.com are

mm-slab-make-page_cgroup_ino-to-recognize-non-compound-slab-pages-properly.patch
mm-memcg-switch-to-css_tryget-in-get_mem_cgroup_from_mm.patch
mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup.patch

