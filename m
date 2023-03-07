Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B646C6AF577
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbjCGTZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbjCGTZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:25:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45116CA1C1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5904D61532
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50909C433D2;
        Tue,  7 Mar 2023 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216278;
        bh=DELTKhLaNexudq4o4J97+nghkzwc4Tz02W4DD1DCS+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBPFH68cP3Pja/k5aaIyF6X853bXdy1ZtE+FrNqkLba6IehoWlJ17tVpMwjWOjRVP
         N1iK4y847AGa6LQ0HTtIdc0OkpwBDlMkWlJHlTqWM7kRvPulb1slRmbGL60JNDaFAe
         WZveK97TZlj3xO1kZjs+1QzLusiJw0sILErMR5Ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 531/567] mm: memcontrol: deprecate charge moving
Date:   Tue,  7 Mar 2023 18:04:27 +0100
Message-Id: <20230307165928.977625540@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit da34a8484d162585e22ed8c1e4114aa2f60e3567 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst |   13 +++++++++++--
 mm/memcontrol.c                                |    4 ++++
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -84,6 +84,8 @@ Brief summary of control files.
  memory.swappiness		     set/show swappiness parameter of vmscan
 				     (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate     set/show controls of moving charges
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
@@ -723,8 +725,15 @@ NOTE2:
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
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3872,6 +3872,10 @@ static int mem_cgroup_move_charge_write(
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+	pr_warn_once("Cgroup memory moving (move_charge_at_immigrate) is deprecated. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
+
 	if (val & ~MOVE_MASK)
 		return -EINVAL;
 


