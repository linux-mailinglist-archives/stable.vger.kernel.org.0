Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6ADE3A8E1
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388771AbfFIRFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388767AbfFIRFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7A2204EC;
        Sun,  9 Jun 2019 17:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099912;
        bh=bHZ4aaVFEmlSR4bTMBhy68Z1lxPlv8QPy3sx6xdrr6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ym2zjL7pZCjkU/reFqNjAvkWiqKAN140yGyUivVkYNF5AfOqeX2FEANTlFtznxdq4
         6vZ70uHZMg1i070S7i1CMqFzmbiHQOeqKfszF/2QqR31Vc45MhUS7XbKtrc0nBk8fN
         11grbgpcMJHcm3tSPywprytZ8q08GlCqEKOCUGbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 211/241] memcg: make it work on sparse non-0-node systems
Date:   Sun,  9 Jun 2019 18:42:33 +0200
Message-Id: <20190609164154.754769930@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 3e8589963773a5c23e2f1fe4bcad0e9a90b7f471 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/list_lru.h |    1 +
 mm/list_lru.c            |    8 +++-----
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -51,6 +51,7 @@ struct list_lru {
 	struct list_lru_node	*node;
 #ifdef CONFIG_MEMCG_KMEM
 	struct list_head	list;
+	bool			memcg_aware;
 #endif
 };
 
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -42,11 +42,7 @@ static void list_lru_unregister(struct l
 #ifdef CONFIG_MEMCG_KMEM
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
@@ -389,6 +385,8 @@ static int memcg_init_list_lru(struct li
 {
 	int i;
 
+	lru->memcg_aware = memcg_aware;
+
 	if (!memcg_aware)
 		return 0;
 


