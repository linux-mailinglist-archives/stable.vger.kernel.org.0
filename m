Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C02620E668
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404198AbgF2VrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgF2Sfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A83C247B5;
        Mon, 29 Jun 2020 15:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444118;
        bh=XecgsmYHkcxJy99zryETRJnXYqzJdoT+HrcTpnNLm5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaowFgYUDBtHyEZS7MiDOokoodUQN4/tjwl5sYmYFLXQQryk+n50vaP9RAvxpsR5o
         JxV6n2cDYQtYsucaaUfpJfD3Imq7b9mSeOFg4M3NBiNmG+55ztJC7zDYs6WbosBZ3d
         +YioNKb3DD1njocFxkzrht9vaRLCe/FDZabBSX+w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>, Roman Gushchin <guro@fb.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 229/265] mm, slab: fix sign conversion problem in memcg_uncharge_slab()
Date:   Mon, 29 Jun 2020 11:17:42 -0400
Message-Id: <20200629151818.2493727-230-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit d7670879c5c4aa443d518fb234a9e5f30931efa3 upstream.

It was found that running the LTP test on a PowerPC system could produce
erroneous values in /proc/meminfo, like:

  MemTotal:       531915072 kB
  MemFree:        507962176 kB
  MemAvailable:   1100020596352 kB

Using bisection, the problem is tracked down to commit 9c315e4d7d8c ("mm:
memcg/slab: cache page number in memcg_(un)charge_slab()").

In memcg_uncharge_slab() with a "int order" argument:

  unsigned int nr_pages = 1 << order;
    :
  mod_lruvec_state(lruvec, cache_vmstat_idx(s), -nr_pages);

The mod_lruvec_state() function will eventually call the
__mod_zone_page_state() which accepts a long argument.  Depending on the
compiler and how inlining is done, "-nr_pages" may be treated as a
negative number or a very large positive number.  Apparently, it was
treated as a large positive number in that PowerPC system leading to
incorrect stat counts.  This problem hasn't been seen in x86-64 yet,
perhaps the gcc compiler there has some slight difference in behavior.

It is fixed by making nr_pages a signed value.  For consistency, a similar
change is applied to memcg_charge_slab() as well.

Link: http://lkml.kernel.org/r/20200620184719.10994-1-longman@redhat.com
Fixes: 9c315e4d7d8c ("mm: memcg/slab: cache page number in memcg_(un)charge_slab()").
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 207c83ef6e06d..74f7e09a7cfd1 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -348,7 +348,7 @@ static __always_inline int memcg_charge_slab(struct page *page,
 					     gfp_t gfp, int order,
 					     struct kmem_cache *s)
 {
-	unsigned int nr_pages = 1 << order;
+	int nr_pages = 1 << order;
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	int ret;
@@ -388,7 +388,7 @@ out:
 static __always_inline void memcg_uncharge_slab(struct page *page, int order,
 						struct kmem_cache *s)
 {
-	unsigned int nr_pages = 1 << order;
+	int nr_pages = 1 << order;
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-- 
2.25.1

