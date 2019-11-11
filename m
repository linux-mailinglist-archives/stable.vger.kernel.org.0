Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC87DF7E36
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfKKSs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbfKKSs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 794082173B;
        Mon, 11 Nov 2019 18:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498138;
        bh=0X9NP6AA4C5Pok2ipJC483Zn772eJcPhllHCRHphyX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5KTpLRAqwREgkjihVd900rCOxpLysaF7q1SWi4xJVqnsxdcpL4d5sP5c2ChXxxGI
         O+qPIWNKNG9LnZXQ4HFcwJeJV7AV8hwM95macRfNiQqZlHQiId5bnwTEZZNTCMRec4
         0u1agqAEEtF4Evq/DstQqA1pQvawB63KduNLc6G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Shakeel Butt <shakeelb@google.com>,
        David Rientjes <rientjes@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 034/193] mm: slab: make page_cgroup_ino() to recognize non-compound slab pages properly
Date:   Mon, 11 Nov 2019 19:26:56 +0100
Message-Id: <20191111181503.283304344@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit 221ec5c0a46c1a1740f34fb36fc661a5284d01b0 upstream.

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
memory error.  Considering that hwpoison filter is for testing, affected
users are limited and the impact should be marginal.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    2 +-
 mm/slab.h       |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -486,7 +486,7 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino = 0;
 
 	rcu_read_lock();
-	if (PageHead(page) && PageSlab(page))
+	if (PageSlab(page) && !PageTail(page))
 		memcg = memcg_from_slab_page(page);
 	else
 		memcg = READ_ONCE(page->mem_cgroup);
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -259,8 +259,8 @@ static inline struct kmem_cache *memcg_r
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


