Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B547812202E
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfLQAwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:52:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35564 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727215AbfLQAvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15O-0003PV-08; Tue, 17 Dec 2019 00:51:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0005fy-Gg; Tue, 17 Dec 2019 00:51:35 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Shakeel Butt" <shakeeb@google.com>,
        "Michal Koutn" <mkoutny@suse.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        "Tejun Heo" <tj@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Roman Gushchin" <guro@fb.com>, "Michal Hocko" <mhocko@kernel.org>
Date:   Tue, 17 Dec 2019 00:47:44 +0000
Message-ID: <lsq.1576543535.67878392@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 130/136] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Gushchin <guro@fb.com>

commit 00d484f354d85845991b40141d40ba9e5eb60faf upstream.

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
   get_signal+0x132/0x7c0
   do_signal+0x36/0x640
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1073,7 +1073,7 @@ static struct mem_cgroup *get_mem_cgroup
 			if (unlikely(!memcg))
 				memcg = root_mem_cgroup;
 		}
-	} while (!css_tryget_online(&memcg->css));
+	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
 }

