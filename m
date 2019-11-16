Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03635FEA1E
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 02:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfKPBeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 20:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfKPBeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 20:34:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95F91207FA;
        Sat, 16 Nov 2019 01:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573868084;
        bh=RRKnxqH/UF5xqW+DkjcMaAJpH5mIXzSIhZsl5Lyjvo4=;
        h=Date:From:To:Subject:From;
        b=cQFszwHwprJHX1i1mzvfhtKY/0oLTiIhfFhjc23a8UPifuKbfoQ91sFPflFsAKvzh
         Goe4aJiLPDzhjFMF3zWm4ygg1KTd7m+7YVfJ0cqfN/H/DuZugJI44QwHktD7/fHW9t
         6V4+/QtPG4dpjeDhXsefjf/nSVdzVmTOmjIYSfj8=
Date:   Fri, 15 Nov 2019 17:34:43 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeeb@google.com,
        stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 04/11] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191116013443.bdFrXzwW-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Shakeel Butt <shakeeb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutn <mkoutny@suse.com>
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
