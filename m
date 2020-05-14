Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97351D2414
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 02:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgENAuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 20:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbgENAuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 20:50:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32EF520659;
        Thu, 14 May 2020 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589417435;
        bh=7SJ2hVqf2rq9LYGfcmZ86AHhQM3CpVOWeH/iESRmbx4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bHhZ7o7xP5oymz/ayeH9QjfdL8fsLUmAejTsu2oyOJpo06AP/Xal7nN2YdjDJ2JDX
         EXLwcfGgg/pCdeI0vjPuJksVR+dSE/f8MSRG+3kAdLOddyR/cRS/orFpIisDzYQjr/
         2abCZQrircPjVUzBJQA1m6utROb0C0hyHx8sik3M=
Date:   Wed, 13 May 2020 17:50:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 1/7] mm, memcg: fix inconsistent oom event
 behavior
Message-ID: <20200514005034.nVmk0GIGf%akpm@linux-foundation.org>
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, memcg: fix inconsistent oom event behavior

A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
memory.events") changes the behavior of memcg events, which will consider
subtrees in memory.events.  But oom_kill event is a special one as it is
used in both cgroup1 and cgroup2.  In cgroup1, it is displayed in
memory.oom_control.  The file memory.oom_control is in both root memcg and
non root memcg, that is different with memory.event as it only in non-root
memcg.  That commit is okay for cgroup2, but it is not okay for cgroup1 as
it will cause inconsistent behavior between root memcg and non-root memcg.

Here's an example on why this behavior is inconsistent in cgroup1.
     root memcg
     /
  memcg foo
   /
memcg bar

Suppose there's an oom_kill in memcg bar, then the oon_kill will be

     root memcg : memory.oom_control(oom_kill)  0
     /
  memcg foo : memory.oom_control(oom_kill)  1
   /
memcg bar : memory.oom_control(oom_kill)  1

For the non-root memcg, its memory.oom_control(oom_kill) includes its
descendants' oom_kill, but for root memcg, it doesn't include its
descendants' oom_kill.  That means, memory.oom_control(oom_kill) has
different meanings in different memcgs.  That is inconsistent.  Then the
user has to know whether the memcg is root or not.

If we can't fully support it in cgroup1, for example by adding
memory.events.local into cgroup1 as well, then let's don't touch its
original behavior.

Link: http://lkml.kernel.org/r/20200502141055.7378-1-laoar.shao@gmail.com
Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcg-fix-inconsistent-oom-event-behavior
+++ a/include/linux/memcontrol.h
@@ -783,6 +783,8 @@ static inline void memcg_memory_event(st
 		atomic_long_inc(&memcg->memory_events[event]);
 		cgroup_file_notify(&memcg->events_file);
 
+		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+			break;
 		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
 			break;
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
_
