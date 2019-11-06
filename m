Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C03F0E28
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 06:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbfKFFRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 00:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfKFFRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 00:17:05 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE5F4217F4;
        Wed,  6 Nov 2019 05:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573017424;
        bh=KUmijE95Xvc0HyyoAL7SGK4urv4VVLqUFykkOHkDeN4=;
        h=Date:From:To:Subject:From;
        b=CrzJpAaINSLmpt7y2iMrrbVFTsdlRY8/4lhKyO8a7tBXi5fAEVM6qBFnM7O9recn8
         43wLxeqldQMRsyn0MXb+E0jtkn0kWvkQNIc0k7YpOHjAGxPNj6ejLCGQ6Ga/cUaSSS
         Xq24zWCNA9ezeqFu2oYygITP/piZVU8wfms8hhBk=
Date:   Tue, 05 Nov 2019 21:17:03 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, daniel.m.jordan@oracle.com, guro@fb.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, rientjes@google.com,
        shakeelb@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 14/17] mm: slab: make page_cgroup_ino() to
 recognize non-compound slab pages properly
Message-ID: <20191106051703.QdQBp46KO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: slab: make page_cgroup_ino() to recognize non-compound slab pages properly

page_cgroup_ino() doesn't return a valid memcg pointer for non-compound
slab pages, because it depends on PgHead AND PgSlab flags to be set to
determine the memory cgroup from the kmem_cache.  It's correct for
compound pages, but not for generic small pages.  Those don't have PgHead
set, so it ends up returning zero.

Fix this by replacing the condition to PageSlab() && !PageTail().

Before this patch:
[root@localhost ~]# ./page-types -c /sys/fs/cgroup/user.slice/user-0.slice/user@0.service/ | grep slab
0x0000000000000080	        38        0  _______S___________________________________	slab

After this patch:
[root@localhost ~]# ./page-types -c /sys/fs/cgroup/user.slice/user-0.slice/user@0.service/ | grep slab
0x0000000000000080	       147        0  _______S___________________________________	slab


Also, hwpoison_filter_task() uses output of page_cgroup_ino() in order
to filter error injection events based on memcg.  So if
page_cgroup_ino() fails to return memcg pointer, we just fail to inject
memory error.  Considering that hwpoison filter is for testing,
affected users are limited and the impact should be marginal.

[n-horiguchi@ah.jp.nec.com: changelog additions]
Link: http://lkml.kernel.org/r/20191031012151.2722280-1-guro@fb.com
Fixes: 4d96ba353075 ("mm: memcg/slab: stop setting page->mem_cgroup pointer for slab pages")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 mm/slab.h       |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-slab-make-page_cgroup_ino-to-recognize-non-compound-slab-pages-properly
+++ a/mm/memcontrol.c
@@ -484,7 +484,7 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino = 0;
 
 	rcu_read_lock();
-	if (PageHead(page) && PageSlab(page))
+	if (PageSlab(page) && !PageTail(page))
 		memcg = memcg_from_slab_page(page);
 	else
 		memcg = READ_ONCE(page->mem_cgroup);
--- a/mm/slab.h~mm-slab-make-page_cgroup_ino-to-recognize-non-compound-slab-pages-properly
+++ a/mm/slab.h
@@ -323,8 +323,8 @@ static inline struct kmem_cache *memcg_r
  * Expects a pointer to a slab page. Please note, that PageSlab() check
  * isn't sufficient, as it returns true also for tail compound slab pages,
  * which do not have slab_cache pointer set.
- * So this function assumes that the page can pass PageHead() and PageSlab()
- * checks.
+ * So this function assumes that the page can pass PageSlab() && !PageTail()
+ * check.
  *
  * The kmem_cache can be reparented asynchronously. The caller must ensure
  * the memcg lifetime, e.g. by taking rcu_read_lock() or cgroup_mutex.
_
