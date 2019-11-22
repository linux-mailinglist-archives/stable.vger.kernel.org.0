Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0EE106AE1
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfKVKjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:39:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbfKVKjG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:39:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D48CF20637;
        Fri, 22 Nov 2019 10:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419144;
        bh=ruFM6nBCHdcOlFs3rbW4BGJ/ZQW+sZpJNoS0Qbdzh6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvgEqFiCWWUZwnrByfycGgrBApUPwb1coEyFQfGjytkGc93FukOKbNzCCS+r01FNN
         yQKLzjkWwGG6RWIV7lZD7lcTQZsVEarnFygrmmZGRupbWXVswCK6GuQU5vOSftDsZ6
         aSccbW+2Q/HmxL6CjL1lunJ/3/cTT7bU54ymA/EA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Shakeel Butt <shakeeb@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Koutn <mkoutny@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 013/222] mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
Date:   Fri, 22 Nov 2019 11:25:53 +0100
Message-Id: <20191122100833.915522594@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -741,7 +741,7 @@ static struct mem_cgroup *get_mem_cgroup
 			if (unlikely(!memcg))
 				memcg = root_mem_cgroup;
 		}
-	} while (!css_tryget_online(&memcg->css));
+	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
 }


