Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC1B29B895
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368851AbgJ0PmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800521AbgJ0PgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81EE82225E;
        Tue, 27 Oct 2020 15:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812960;
        bh=RZ+5VD9ybZSeh234RZFKzDilgJlIPKhw3NZlDfaCNz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+d+v7LY+gnhNKx+9OllCHzhfonnVQ56Q2fee2XP5x+jUgs8uCj4q7v4iAmnZBGHr
         YmCPmb6mnypK2x0EqsGt1226YWfKDbCMCGTzemowgl2QTAF9REMoSvsFCfwudq4KYI
         vKj4uIXMZhYxlUmpn5u4WdbAqb9zzGOuUfUb93Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 390/757] mm: memcg/slab: fix racy access to page->mem_cgroup in mem_cgroup_from_obj()
Date:   Tue, 27 Oct 2020 14:50:40 +0100
Message-Id: <20201027135508.844925336@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

[ Upstream commit 19b629c9795bfe67bf77be8fb611b84424b56d91 ]

mem_cgroup_from_obj() checks the lowest bit of the page->mem_cgroup
pointer to determine if the page has an attached obj_cgroup vector instead
of a regular memcg pointer.  If it's not set, it simple returns the
page->mem_cgroup value as a struct mem_cgroup pointer.

The commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
for all allocations") changed the moment when this bit is set: if
previously it was set on the allocation of the slab page, now it can be
set well after, when the first accounted object is allocated on this page.

It opened a race: if page->mem_cgroup is set concurrently after the first
page_has_obj_cgroups(page) check, a pointer to the obj_cgroups array can
be returned as a memory cgroup pointer.

A simple check for page->mem_cgroup pointer for NULL before the
page_has_obj_cgroups() check fixes the race.  Indeed, if the pointer is
not NULL, it's either a simple mem_cgroup pointer or a pointer to
obj_cgroup vector.  The pointer can be asynchronously changed from NULL to
(obj_cgroup_vec | 0x1UL), but can't be changed from a valid memcg pointer
to objcg vector or back.

If the object passed to mem_cgroup_from_obj() is a slab object and
page->mem_cgroup is NULL, it means that the object is not accounted, so
the function must return NULL.

I've discovered the race looking at the code, so far I haven't seen it in
the wild.

Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Link: https://lkml.kernel.org/r/20200910022435.2773735-1-guro@fb.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6877c765b8d03..b9688a4b1d550 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2887,6 +2887,17 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
 
 	page = virt_to_head_page(p);
 
+	/*
+	 * If page->mem_cgroup is set, it's either a simple mem_cgroup pointer
+	 * or a pointer to obj_cgroup vector. In the latter case the lowest
+	 * bit of the pointer is set.
+	 * The page->mem_cgroup pointer can be asynchronously changed
+	 * from NULL to (obj_cgroup_vec | 0x1UL), but can't be changed
+	 * from a valid memcg pointer to objcg vector or back.
+	 */
+	if (!page->mem_cgroup)
+		return NULL;
+
 	/*
 	 * Slab objects are accounted individually, not per-page.
 	 * Memcg membership data for each individual object is saved in
-- 
2.25.1



