Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F12339018
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731861AbfFGPs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731413AbfFGPs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:48:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 900D320840;
        Fri,  7 Jun 2019 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922537;
        bh=bZgYaphRmPDbhmb/WQZhy6Hk70Ar0tMY8eVhx9SVZRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkoPKUNM/TUND/UeRq+j5ZQdF2t5ozxEwOso1huSyHlyJCo2dPt7F5Tl3o9AYjZDX
         i11lJq6tsTHFYgf3UwaeNFCTzllOIKj37FXxWszMY9wK5qIBBGWOMFyGjo7bdZ1dDc
         OCkQQzHYCsqNXgoImBj23wsOA0qZDtvuV5zciO7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Down <chris@chrisdown.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 48/85] mm, memcg: consider subtrees in memory.events
Date:   Fri,  7 Jun 2019 17:39:33 +0200
Message-Id: <20190607153854.908885718@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Down <chris@chrisdown.name>

commit 9852ae3fe5293264f01c49f2571ef7688f7823ce upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/cgroup-v2.rst |    9 +++++++++
 include/linux/cgroup-defs.h             |    5 +++++
 include/linux/memcontrol.h              |   10 ++++++++--
 kernel/cgroup/cgroup.c                  |   16 ++++++++++++++--
 4 files changed, 36 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
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
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -83,6 +83,11 @@ enum {
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
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -777,8 +777,14 @@ static inline void count_memcg_event_mm(
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
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1775,11 +1775,13 @@ int cgroup_show_path(struct seq_file *sf
 
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
 
@@ -1802,6 +1804,9 @@ static int cgroup2_parse_param(struct fs
 	case Opt_nsdelegate:
 		ctx->flags |= CGRP_ROOT_NS_DELEGATE;
 		return 0;
+	case Opt_memory_localevents:
+		ctx->flags |= CGRP_ROOT_MEMORY_LOCAL_EVENTS;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -1813,6 +1818,11 @@ static void apply_cgroup_root_flags(unsi
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
 
@@ -1820,6 +1830,8 @@ static int cgroup_show_options(struct se
 {
 	if (cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
 		seq_puts(seq, ",nsdelegate");
+	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+		seq_puts(seq, ",memory_localevents");
 	return 0;
 }
 
@@ -6122,7 +6134,7 @@ static struct kobj_attribute cgroup_dele
 static ssize_t features_show(struct kobject *kobj, struct kobj_attribute *attr,
 			     char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "nsdelegate\n");
+	return snprintf(buf, PAGE_SIZE, "nsdelegate\nmemory_localevents\n");
 }
 static struct kobj_attribute cgroup_features_attr = __ATTR_RO(features);
 


