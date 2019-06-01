Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE49319BF
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 07:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfFAFa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 01:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfFAFa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 01:30:28 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D847027137;
        Sat,  1 Jun 2019 05:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559367027;
        bh=Zsi0CDNhTZSFZWMqqj0YzIMXT20a6+prykQyF6Zplu8=;
        h=Date:From:To:Subject:From;
        b=YuuVzqgz6k7zCfb3ld9CyUPVfeVIxv2aPYadp8ZLIX+o9jcYH2jGAJnp314tGABOz
         Djw9JquCvAIuzYMvUzK7Oxnz67Glut0MKx1WuwSE+nMlPzZLn3Fx2ySITgnx9ezaU4
         O8H1ZVNF7DIcesXt888okGI/DH48KBCEtqPZTpTI=
Date:   Fri, 31 May 2019 22:30:26 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, jslaby@suse.cz,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        raghavendra.kt@linux.vnet.ibm.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 10/21] memcg: make it work on sparse non-0-node
 systems
Message-ID: <20190601053026.MWRj2O1mO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Subject: memcg: make it work on sparse non-0-node systems

We have a single node system with node 0 disabled:
  Scanning NUMA topology in Northbridge 24
  Number of physical nodes 2
  Skipping disabled node 0
  Node 1 MemBase 0000000000000000 Limit 00000000fbff0000
  NODE_DATA(1) allocated [mem 0xfbfda000-0xfbfeffff]

This causes crashes in memcg when system boots:
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  #PF error: [normal kernel read fault]
...
  RIP: 0010:list_lru_add+0x94/0x170
...
  Call Trace:
   d_lru_add+0x44/0x50
   dput.part.34+0xfc/0x110
   __fput+0x108/0x230
   task_work_run+0x9f/0xc0
   exit_to_usermode_loop+0xf5/0x100

It is reproducible as far as 4.12.  I did not try older kernels.  You have
to have a new enough systemd, e.g.  241 (the reason is unknown -- was not
investigated).  Cannot be reproduced with systemd 234.

The system crashes because the size of lru array is never updated in
memcg_update_all_list_lrus and the reads are past the zero-sized array,
causing dereferences of random memory.

The root cause are list_lru_memcg_aware checks in the list_lru code.  The
test in list_lru_memcg_aware is broken: it assumes node 0 is always
present, but it is not true on some systems as can be seen above.

So fix this by avoiding checks on node 0.  Remember the memcg-awareness by
a bool flag in struct list_lru.

Link: http://lkml.kernel.org/r/20190522091940.3615-1-jslaby@suse.cz
Fixes: 60d3fd32a7a9 ("list_lru: introduce per-memcg lists")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    1 +
 mm/list_lru.c            |    8 +++-----
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/include/linux/list_lru.h~memcg-make-it-work-on-sparse-non-0-node-systems
+++ a/include/linux/list_lru.h
@@ -54,6 +54,7 @@ struct list_lru {
 #ifdef CONFIG_MEMCG_KMEM
 	struct list_head	list;
 	int			shrinker_id;
+	bool			memcg_aware;
 #endif
 };
 
--- a/mm/list_lru.c~memcg-make-it-work-on-sparse-non-0-node-systems
+++ a/mm/list_lru.c
@@ -38,11 +38,7 @@ static int lru_shrinker_id(struct list_l
 
 static inline bool list_lru_memcg_aware(struct list_lru *lru)
 {
-	/*
-	 * This needs node 0 to be always present, even
-	 * in the systems supporting sparse numa ids.
-	 */
-	return !!lru->node[0].memcg_lrus;
+	return lru->memcg_aware;
 }
 
 static inline struct list_lru_one *
@@ -452,6 +448,8 @@ static int memcg_init_list_lru(struct li
 {
 	int i;
 
+	lru->memcg_aware = memcg_aware;
+
 	if (!memcg_aware)
 		return 0;
 
_
