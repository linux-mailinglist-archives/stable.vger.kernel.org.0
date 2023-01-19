Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692F6672DE8
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 02:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjASBQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 20:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjASBPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 20:15:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655EF3B0E1;
        Wed, 18 Jan 2023 17:14:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3F0F61B0E;
        Thu, 19 Jan 2023 01:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE36C433F0;
        Thu, 19 Jan 2023 01:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090868;
        bh=0aKgmZjCcfSnLMYeAl2k/QoZ/2EzP6x+nH6fE9/5Pvo=;
        h=Date:To:From:Subject:From;
        b=JpaVIyJySgN8UM1sMiE35xnaSkXTHVi4+t81ne9ai//o6QFxf2nMiYKiqYad/vU6t
         o6P6mws5qWCzBfyEToLVX+IVbgCHmiQc3wGA/9FOjaGRSyt9KXeJ6juJIuGSUzN/yB
         XrUxUNh5+D3JS7wiAelX+em9wqFrOnW1hsu98P2I=
Date:   Wed, 18 Jan 2023 17:14:27 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-deprecate-charge-moving.patch removed from -mm tree
Message-Id: <20230119011428.5BE36C433F0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: deprecate charge moving
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-deprecate-charge-moving.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: deprecate charge moving
Date: Wed, 7 Dec 2022 14:00:39 +0100

Charge moving mode in cgroup1 allows memory to follow tasks as they
migrate between cgroups.  This is, and always has been, a questionable
thing to do - for several reasons.

First, it's expensive.  Pages need to be identified, locked and isolated
from various MM operations, and reassigned, one by one.

Second, it's unreliable.  Once pages are charged to a cgroup, there isn't
always a clear owner task anymore.  Cache isn't moved at all, for example.
Mapped memory is moved - but if trylocking or isolating a page fails,
it's arbitrarily left behind.  Frequent moving between domains may leave a
task's memory scattered all over the place.

Third, it isn't really needed.  Launcher tasks can kick off workload tasks
directly in their target cgroup.  Using dedicated per-workload groups
allows fine-grained policy adjustments - no need to move tasks and their
physical pages between control domains.  The feature was never
forward-ported to cgroup2, and it hasn't been missed.

Despite it being a niche usecase, the maintenance overhead of supporting
it is enormous.  Because pages are moved while they are live and subject
to various MM operations, the synchronization rules are complicated. 
There are lock_page_memcg() in MM and FS code, which non-cgroup people
don't understand.  In some cases we've been able to shift code and cgroup
API calls around such that we can rely on native locking as much as
possible.  But that's fragile, and sometimes we need to hold MM locks for
longer than we otherwise would (pte lock e.g.).

Mark the feature deprecated. Hopefully we can remove it soon.

And backport into -stable kernels so that people who develop against
earlier kernels are warned about this deprecation as early as possible.

[akpm@linux-foundation.org: fix memory.rst underlining]
Link: https://lkml.kernel.org/r/Y5COd+qXwk/S+n8N@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |   13 +++++++++++--
 mm/memcontrol.c                                |    4 ++++
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~mm-memcontrol-deprecate-charge-moving
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -86,6 +86,8 @@ Brief summary of control files.
  memory.swappiness		     set/show swappiness parameter of vmscan
 				     (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate     set/show controls of moving charges
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
@@ -717,8 +719,15 @@ NOTE2:
        It is recommended to set the soft limit always below the hard limit,
        otherwise the hard limit will take precedence.
 
-8. Move charges at task migration
-=================================
+8. Move charges at task migration (DEPRECATED!)
+===============================================
+
+THIS IS DEPRECATED!
+
+It's expensive and unreliable! It's better practice to launch workload
+tasks directly from inside their target cgroup. Use dedicated workload
+cgroups to allow fine-grained policy adjustments without having to
+move physical pages between control domains.
 
 Users can move charges associated with a task along with task migration, that
 is, uncharge task's pages from the old cgroup and charge them to the new cgroup.
--- a/mm/memcontrol.c~mm-memcontrol-deprecate-charge-moving
+++ a/mm/memcontrol.c
@@ -3919,6 +3919,10 @@ static int mem_cgroup_move_charge_write(
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+	pr_warn_once("Cgroup memory moving (move_charge_at_immigrate) is deprecated. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
+
 	if (val & ~MOVE_MASK)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


