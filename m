Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4301D319BE
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 07:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfFAFaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 01:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfFAFaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 01:30:25 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B33B27134;
        Sat,  1 Jun 2019 05:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559367023;
        bh=y6rhXHgM1jhy0w7rWsAqI2i4DnzdBqw1rSPBRQ75ERg=;
        h=Date:From:To:Subject:From;
        b=v71xAm2312cC/1rAC4JYdxS18ZyZIwLqtelrjxEeHbpZQ7Mnuh6DdphDdKgEEFOWa
         1vn4O94gfHCW+paV6SRBihHBFLSXnA6+q3O+niaq7DQO7ZmcNkMd4fWhUHw3MJS/oS
         QxLgzU5E+1CxdHaMfk9ASD1Y3f+kHtC/221U19pY=
Date:   Fri, 31 May 2019 22:30:22 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chris@chrisdown.name, dennis@kernel.org,
        guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, surenb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 09/21] mm, memcg: consider subtrees in
 memory.events
Message-ID: <20190601053022.1FiUj8UZE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: consider subtrees in memory.events

memory.stat and other files already consider subtrees in their output, and
we should too in order to not present an inconsistent interface.

The current situation is fairly confusing, because people interacting with
cgroups expect hierarchical behaviour in the vein of memory.stat,
cgroup.events, and other files.  For example, this causes confusion when
debugging reclaim events under low, as currently these always read "0" at
non-leaf memcg nodes, which frequently causes people to misdiagnose breach
behaviour.  The same confusion applies to other counters in this file when
debugging issues.

Aggregation is done at write time instead of at read-time since these
counters aren't hot (unlike memory.stat which is per-page, so it does it
at read time), and it makes sense to bundle this with the file
notifications.

After this patch, events are propagated up the hierarchy:

    [root@ktst ~]# cat /sys/fs/cgroup/system.slice/memory.events
    low 0
    high 0
    max 0
    oom 0
    oom_kill 0
    [root@ktst ~]# systemd-run -p MemoryMax=1 true
    Running as unit: run-r251162a189fb4562b9dabfdc9b0422f5.service
    [root@ktst ~]# cat /sys/fs/cgroup/system.slice/memory.events
    low 0
    high 0
    max 7
    oom 1
    oom_kill 1

As this is a change in behaviour, this can be reverted to the old
behaviour by mounting with the `memory_localevents' flag set.  However, we
use the new behaviour by default as there's a lack of evidence that there
are any current users of memory.events that would find this change
undesirable.

akpm: this is a behaviour change, so Cc:stable.  THis is so that
forthcoming distros which use cgroup v2 are more likely to pick up the
revised behaviour.

Link: http://lkml.kernel.org/r/20190208224419.GA24772@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    9 +++++++++
 include/linux/cgroup-defs.h             |    5 +++++
 include/linux/memcontrol.h              |   10 ++++++++--
 kernel/cgroup/cgroup.c                  |   16 ++++++++++++++--
 4 files changed, 36 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-consider-subtrees-in-memoryevents
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -177,6 +177,15 @@ cgroup v2 currently supports the followi
 	ignored on non-init namespace mounts.  Please refer to the
 	Delegation section for details.
 
+  memory_localevents
+
+        Only populate memory.events with data for the current cgroup,
+        and not any subtrees. This is legacy behaviour, the default
+        behaviour without this option is to include subtree counts.
+        This option is system wide and can only be set on mount or
+        modified through remount from the init namespace. The mount
+        option is ignored on non-init namespace mounts.
+
 
 Organizing Processes and Threads
 --------------------------------
--- a/include/linux/cgroup-defs.h~mm-consider-subtrees-in-memoryevents
+++ a/include/linux/cgroup-defs.h
@@ -89,6 +89,11 @@ enum {
 	 * Enable cpuset controller in v1 cgroup to use v2 behavior.
 	 */
 	CGRP_ROOT_CPUSET_V2_MODE = (1 << 4),
+
+	/*
+	 * Enable legacy local memory.events.
+	 */
+	CGRP_ROOT_MEMORY_LOCAL_EVENTS = (1 << 5),
 };
 
 /* cftype->flags */
--- a/include/linux/memcontrol.h~mm-consider-subtrees-in-memoryevents
+++ a/include/linux/memcontrol.h
@@ -737,8 +737,14 @@ static inline void count_memcg_event_mm(
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
-	atomic_long_inc(&memcg->memory_events[event]);
-	cgroup_file_notify(&memcg->events_file);
+	do {
+		atomic_long_inc(&memcg->memory_events[event]);
+		cgroup_file_notify(&memcg->events_file);
+
+		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+			break;
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		 !mem_cgroup_is_root(memcg));
 }
 
 static inline void memcg_memory_event_mm(struct mm_struct *mm,
--- a/kernel/cgroup/cgroup.c~mm-consider-subtrees-in-memoryevents
+++ a/kernel/cgroup/cgroup.c
@@ -1810,11 +1810,13 @@ int cgroup_show_path(struct seq_file *sf
 
 enum cgroup2_param {
 	Opt_nsdelegate,
+	Opt_memory_localevents,
 	nr__cgroup2_params
 };
 
 static const struct fs_parameter_spec cgroup2_param_specs[] = {
-	fsparam_flag  ("nsdelegate",		Opt_nsdelegate),
+	fsparam_flag("nsdelegate",		Opt_nsdelegate),
+	fsparam_flag("memory_localevents",	Opt_memory_localevents),
 	{}
 };
 
@@ -1837,6 +1839,9 @@ static int cgroup2_parse_param(struct fs
 	case Opt_nsdelegate:
 		ctx->flags |= CGRP_ROOT_NS_DELEGATE;
 		return 0;
+	case Opt_memory_localevents:
+		ctx->flags |= CGRP_ROOT_MEMORY_LOCAL_EVENTS;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -1848,6 +1853,11 @@ static void apply_cgroup_root_flags(unsi
 			cgrp_dfl_root.flags |= CGRP_ROOT_NS_DELEGATE;
 		else
 			cgrp_dfl_root.flags &= ~CGRP_ROOT_NS_DELEGATE;
+
+		if (root_flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+			cgrp_dfl_root.flags |= CGRP_ROOT_MEMORY_LOCAL_EVENTS;
+		else
+			cgrp_dfl_root.flags &= ~CGRP_ROOT_MEMORY_LOCAL_EVENTS;
 	}
 }
 
@@ -1855,6 +1865,8 @@ static int cgroup_show_options(struct se
 {
 	if (cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
 		seq_puts(seq, ",nsdelegate");
+	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+		seq_puts(seq, ",memory_localevents");
 	return 0;
 }
 
@@ -6325,7 +6337,7 @@ static struct kobj_attribute cgroup_dele
 static ssize_t features_show(struct kobject *kobj, struct kobj_attribute *attr,
 			     char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "nsdelegate\n");
+	return snprintf(buf, PAGE_SIZE, "nsdelegate\nmemory_localevents\n");
 }
 static struct kobj_attribute cgroup_features_attr = __ATTR_RO(features);
 
_
