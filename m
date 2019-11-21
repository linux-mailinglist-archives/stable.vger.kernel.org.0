Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB85F105D05
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 00:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKUXGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 18:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfKUXGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 18:06:38 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97983206EC;
        Thu, 21 Nov 2019 23:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574377596;
        bh=4U2zCsvNeSiu6mlfm8gtDULkixItFBRxCy4pG/oemGs=;
        h=Date:From:To:Subject:From;
        b=MUujwEZ1euQkruOL8vk4w4wDzu4UbjNluLtqv1GAoHXTKqEKVQEkRYf5dQaSaaJ7r
         4TiAUaIUkGaoeG9unf0n4l1nMSrYbqPk3tm8xuUJvDpNgURmMkAx9aq6tXrlLEClzH
         PLMWgZK8huNUbEAKoqIR4a2jXfcAwF8GZiWY6dE0=
Date:   Thu, 21 Nov 2019 15:06:36 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, tj@kernel.org
Subject:  [merged]
 mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup.patch
 removed from -mm tree
Message-ID: <20191121230636.2rafUjQ0K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
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


