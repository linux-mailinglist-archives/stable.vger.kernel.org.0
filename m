Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C176FF2454
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 02:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732967AbfKGBeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 20:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfKGBeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 20:34:15 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8127217F5;
        Thu,  7 Nov 2019 01:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573090454;
        bh=7ytyTbS+QBQJiT5lf19UQE5mTiofDv63+rIGnTy3CUQ=;
        h=Date:From:To:Subject:From;
        b=OTCGwYWMJfcEkgdlzLzP0nvwGrOdkkpfKBf6mzQL8LYbvxwTL3VifAegW/ZOZgwU5
         1DesKt9RJsYWStH+LOqcb9ixHhGqFXQD/nWYQ//hDRFf5T4pGjqXeWoHlWDWkD4BE9
         sVcNVAZTMEn3uAVdDvLAIMdKY3b81MqITPYKRVNU=
Date:   Wed, 06 Nov 2019 17:34:13 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org
Subject:  +
 mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup.patch added
 to -mm tree
Message-ID: <20191107013413.arvCUv--3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

An exiting task might belong to an offline cgroup.  In this case an
attempt to grab a cgroup reference from the task can end up with an
infinite loop in hugetlb_cgroup_charge_cgroup(), because neither the
cgroup will become online, neither the task will be migrated to a live
cgroup.

Fix this by switching over to css_tryget().  As css_tryget_online() can't
guarantee that the cgroup won't go offline, in most cases the check
doesn't make sense.  In this particular case users of
hugetlb_cgroup_charge_cgroup() are not affected by this change.

A similar problem is described by commit 18fa84a2db0e ("cgroup: Use
css_tryget() instead of css_tryget_online() in task_get_css()").

Link: http://lkml.kernel.org/r/20191106225131.3543616-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup
+++ a/mm/hugetlb_cgroup.c
@@ -196,7 +196,7 @@ int hugetlb_cgroup_charge_cgroup(int idx
 again:
 	rcu_read_lock();
 	h_cg = hugetlb_cgroup_from_task(current);
-	if (!css_tryget_online(&h_cg->css)) {
+	if (!css_tryget(&h_cg->css)) {
 		rcu_read_unlock();
 		goto again;
 	}
_

Patches currently in -mm which might be from guro@fb.com are

mm-slab-make-page_cgroup_ino-to-recognize-non-compound-slab-pages-properly.patch
mm-memcg-switch-to-css_tryget-in-get_mem_cgroup_from_mm.patch
mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup.patch

