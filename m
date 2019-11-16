Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85876FEA1F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 02:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfKPBes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 20:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfKPBer (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 20:34:47 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1BED20801;
        Sat, 16 Nov 2019 01:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573868087;
        bh=60kyimPkkJ43qUVqz95AE0kOfdwI6q9v9JeiE5R2PNQ=;
        h=Date:From:To:Subject:From;
        b=mOmoIu11lDZhDXKOIiVOqHopzNBfM+DKhE24J7wArXim+ugbfP8jBWEmUmM11mZUL
         mrnJPL55QCEB6wyqc0xAR/zi6fSTtn/HBxVKx/6apoGJdBcunWFnpdwCKESms5Aj3R
         amhpPqAHXfCijhCBMnogASdH92QecOca3hxlyIoA=
Date:   Fri, 15 Nov 2019 17:34:46 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 05/11] mm: hugetlb: switch to css_tryget() in
 hugetlb_cgroup_charge_cgroup()
Message-ID: <20191116013446.bRPtIAIB3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
