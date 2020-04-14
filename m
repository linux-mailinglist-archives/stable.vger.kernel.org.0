Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9731A70C5
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 04:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403924AbgDNCAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 22:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727867AbgDNCAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 22:00:07 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEE4C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 19:00:07 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w3so4097792plz.5
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 19:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jioPbgVo9Yj4CEfIRDyGfI7olAR404zuuwj5DU8a6S4=;
        b=naRICs6tMO6+WIKTe7Ons2paw6UBSb4LdcNdrI/d+kTWuuycOKOPYv2fuFqdTH3rW9
         WM94EfazlRNSg/dj+NjhNldXzxg3HUSs2+/GosK9qtJkFzWrrCfsKTKvPf7j9s7IvGOj
         vXZ2Y3437zLOdiANxDgcOh7/UwJnnZOKdGre6Cw02aPflfwJyXnVeCcUhbOd0GkMHi4K
         dafjueOQSuWcfF+FWI2WYSadCNQ4gOjsdyOYdjiHsKYdwklqROSfTT12lprrI0pSZFmp
         bobLm1ZbY0irdZNyFv6sINdlNUL3nEOvFyvKb3GDOlIqsqJslVxNwjnyqwR2c0pG8MZL
         pCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jioPbgVo9Yj4CEfIRDyGfI7olAR404zuuwj5DU8a6S4=;
        b=kw0XiLJm4Jt+9G0yo2Hkb56Ad3w/Tehc7B3n5rDbMsIW9nOqdqyi4V8vPDEWYQowMn
         uQZN0IL52zzvVNhR4PgFEytTPdTW+kU47s7/TB4Lr9PUpeDTb1LG2E1iD5woFErJwMye
         p0Zh3jTQnr1NYrjIhalx3NaBweUydhXpVxcuA1wcDHmvAzMrLdquQOVmYQ88qHpVN/1+
         VhLl+8WFNbWqXYhNzZsW3XDffBzRyHP2mesW1BSVZ8Rp6lN0nuyhqlLXAnFoiskUrqfj
         Z+KwHsgyeysGtuv22rENLbZJQ4A2w2LlkPKIyj76mzkeBeIgGAYAvww2GK/OkMQzvtLG
         rrWQ==
X-Gm-Message-State: AGi0PubMeIj57OUJAtfMToE7cYJohONb8MeqahznFNr0fwN0B9Vp6RJK
        H6Q6ZFUeCpdCErf4lDRAcuI=
X-Google-Smtp-Source: APiQypLJzTcMq383lhPvI/c4rqgqPjiU3o5IrIj0BOxlMdOGRS6muNQ2z+5gT7A3Y+povs0vMyaGEg==
X-Received: by 2002:a17:90b:2355:: with SMTP id ms21mr14031489pjb.163.1586829606806;
        Mon, 13 Apr 2020 19:00:06 -0700 (PDT)
Received: from localhost.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id y126sm4496835pgy.91.2020.04.13.19.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 19:00:05 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     shakeelb@google.com, chris@chrisdown.name, hannes@cmpxchg.org,
        mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] mm, memcg: fix inconsistent oom event behavior
Date:   Mon, 13 Apr 2020 21:59:52 -0400
Message-Id: <20200414015952.3590-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
memory.events") changes the behavior of memcg events, which will
consider subtrees in memory.events. But oom_kill event is a special one
as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
in memory.oom_control. The file memory.oom_control is in both root memcg
and non root memcg, that is different with memory.event as it only in
non-root memcg. That commit is okay for cgroup2, but it is not okay for
cgroup1 as it will cause inconsistent behavior between root memcg and
non-root memcg.

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
descendants' oom_kill. That means, memory.oom_control(oom_kill) has
different meanings in different memcgs. That is inconsistent. Then the user
has to know whether the memcg is root or not.

If we can't fully support it in cgroup1, for example by adding
memory.events.local into cgroup1 as well, then let's don't touch
its original behavior. So let's recover the original behavior for cgroup1.

Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8c340e6b347f..a0ae080a67d1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -798,7 +798,8 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
 		atomic_long_inc(&memcg->memory_events[event]);
 		cgroup_file_notify(&memcg->events_file);
 
-		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS ||
+		    !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 			break;
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
-- 
2.18.2

