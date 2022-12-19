Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB026515B6
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 23:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiLSWyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 17:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiLSWyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 17:54:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5B612A99;
        Mon, 19 Dec 2022 14:54:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14356B81041;
        Mon, 19 Dec 2022 22:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86B6C433EF;
        Mon, 19 Dec 2022 22:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671490478;
        bh=56zPAhXWjjrQVaeIzfV2LiLrLyHiDNRWM2KQd62kxg8=;
        h=Date:To:From:Subject:From;
        b=PCfa14NCYRy2ITzD7/AVVHsGMtztpg1kkeCjAcxxERNdMIFB1IXcUlPveKrHO3XcT
         4+g/kH5JJhNaPr+kDM5Fr0kFvKSIv00fhVHTkifQk9koj3udRIMKGs3ngUBmDS7/2W
         zTwc0eDIJkcHAHGBwCSMgz6DvKOuPZc/7v+10/l4=
Date:   Mon, 19 Dec 2022 14:54:37 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-deprecate-charge-moving.patch added to mm-unstable branch
Message-Id: <20221219225438.B86B6C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: deprecate charge moving
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-deprecate-charge-moving.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-deprecate-charge-moving.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 Documentation/admin-guide/cgroup-v1/memory.rst |   11 ++++++++++-
 mm/memcontrol.c                                |    4 ++++
 2 files changed, 14 insertions(+), 1 deletion(-)

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
@@ -717,9 +719,16 @@ NOTE2:
        It is recommended to set the soft limit always below the hard limit,
        otherwise the hard limit will take precedence.
 
-8. Move charges at task migration
+8. Move charges at task migration (DEPRECATED!)
 =================================
 
+THIS IS DEPRECATED!
+
+It's expensive and unreliable! It's better practice to launch workload
+tasks directly from inside their target cgroup. Use dedicated workload
+cgroups to allow fine-grained policy adjustments without having to
+move physical pages between control domains.
+
 Users can move charges associated with a task along with task migration, that
 is, uncharge task's pages from the old cgroup and charge them to the new cgroup.
 This feature is not supported in !CONFIG_MMU environments because of lack of
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

mm-memcontrol-skip-moving-non-present-pages-that-are-mapped-elsewhere.patch
mm-rmap-remove-lock_page_memcg.patch
mm-memcontrol-deprecate-charge-moving.patch

