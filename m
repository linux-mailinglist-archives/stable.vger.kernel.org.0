Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7A51F2E99
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgFIAnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729065AbgFHXMR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23BD02100A;
        Mon,  8 Jun 2020 23:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657937;
        bh=8nQncJi5dmbaNaaPI8nXqY9KO2UFv5f5/j9HKgRd4LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwQD0iSAu9xR4HE8FUSHPtJC0p25sx/mKqO5EUObo1UzSZ7lvj4bYSwqOjRSNSlAI
         ZPpAFdwOcoxDliRMkEDNCItNomR1TG4wTkvyTrOrZARwrprlzx1tUrQhNGcb+4jqa1
         LcQdLGXMl1thpDk7QG/TNiq6QLlsPWCBC0x3ENHM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Chris Down <chris@chrisdown.name>,
        Michal Hocko <mhocko@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 004/606] mm, memcg: fix inconsistent oom event behavior
Date:   Mon,  8 Jun 2020 19:02:09 -0400
Message-Id: <20200608231211.3363633-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 04fd61a4e01028210a91f0efc408c8bc61a3018c ]

A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
memory.events") changed the behavior of memcg events, which will now
consider subtrees in memory.events.

But oom_kill event is a special one as it is used in both cgroup1 and
cgroup2.  In cgroup1, it is displayed in memory.oom_control.  The file
memory.oom_control is in both root memcg and non root memcg, that is
different with memory.event as it only in non-root memcg.  That commit
is okay for cgroup2, but it is not okay for cgroup1 as it will cause
inconsistent behavior between root memcg and non-root memcg.

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

Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200502141055.7378-1-laoar.shao@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e9ba01336d4e..bc5a3621a9d7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -783,6 +783,8 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
 		atomic_long_inc(&memcg->memory_events[event]);
 		cgroup_file_notify(&memcg->events_file);
 
+		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+			break;
 		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
 			break;
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
-- 
2.25.1

