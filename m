Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0800122EFA4
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgG0OSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730365AbgG0OR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:17:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 438362075A;
        Mon, 27 Jul 2020 14:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859478;
        bh=Hs1apUF6pzLa7pMZi6aK6zvEfY1TgSs8aSzgRfjS6aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTJlplefWeq1RP6qN/CNywq8oRKgirX0v3aOsKhmvw/uBTlR2FCaueMKor9Ca1XwZ
         ijDLbN6sn9uqqrM43/aZSV/jbGPJDtBm4YEJMVq6F/fOvA72OptuGY6O2rOXkHh0us
         +G0ExzpZ11wteflCOJxKc1ajTm+6R7htuWMA1nqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 124/138] mm: memcg/slab: fix memory leak at non-root kmem_cache destroy
Date:   Mon, 27 Jul 2020 16:05:19 +0200
Message-Id: <20200727134931.631085643@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit d38a2b7a9c939e6d7329ab92b96559ccebf7b135 upstream.

If the kmem_cache refcount is greater than one, we should not mark the
root kmem_cache as dying.  If we mark the root kmem_cache dying
incorrectly, the non-root kmem_cache can never be destroyed.  It
resulted in memory leak when memcg was destroyed.  We can use the
following steps to reproduce.

  1) Use kmem_cache_create() to create a new kmem_cache named A.
  2) Coincidentally, the kmem_cache A is an alias for kmem_cache B,
     so the refcount of B is just increased.
  3) Use kmem_cache_destroy() to destroy the kmem_cache A, just
     decrease the B's refcount but mark the B as dying.
  4) Create a new memory cgroup and alloc memory from the kmem_cache
     B. It leads to create a non-root kmem_cache for allocating memory.
  5) When destroy the memory cgroup created in the step 4), the
     non-root kmem_cache can never be destroyed.

If we repeat steps 4) and 5), this will cause a lot of memory leak.  So
only when refcount reach zero, we mark the root kmem_cache as dying.

Fixes: 92ee383f6daa ("mm: fix race between kmem_cache destroy, create and deactivate")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200716165103.83462-1-songmuchun@bytedance.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab_common.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -326,6 +326,14 @@ int slab_unmergeable(struct kmem_cache *
 	if (s->refcount < 0)
 		return 1;
 
+#ifdef CONFIG_MEMCG_KMEM
+	/*
+	 * Skip the dying kmem_cache.
+	 */
+	if (s->memcg_params.dying)
+		return 1;
+#endif
+
 	return 0;
 }
 
@@ -886,12 +894,15 @@ static int shutdown_memcg_caches(struct
 	return 0;
 }
 
-static void flush_memcg_workqueue(struct kmem_cache *s)
+static void memcg_set_kmem_cache_dying(struct kmem_cache *s)
 {
 	spin_lock_irq(&memcg_kmem_wq_lock);
 	s->memcg_params.dying = true;
 	spin_unlock_irq(&memcg_kmem_wq_lock);
+}
 
+static void flush_memcg_workqueue(struct kmem_cache *s)
+{
 	/*
 	 * SLAB and SLUB deactivate the kmem_caches through call_rcu. Make
 	 * sure all registered rcu callbacks have been invoked.
@@ -923,10 +934,6 @@ static inline int shutdown_memcg_caches(
 {
 	return 0;
 }
-
-static inline void flush_memcg_workqueue(struct kmem_cache *s)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 void slab_kmem_cache_release(struct kmem_cache *s)
@@ -944,8 +951,6 @@ void kmem_cache_destroy(struct kmem_cach
 	if (unlikely(!s))
 		return;
 
-	flush_memcg_workqueue(s);
-
 	get_online_cpus();
 	get_online_mems();
 
@@ -955,6 +960,22 @@ void kmem_cache_destroy(struct kmem_cach
 	if (s->refcount)
 		goto out_unlock;
 
+#ifdef CONFIG_MEMCG_KMEM
+	memcg_set_kmem_cache_dying(s);
+
+	mutex_unlock(&slab_mutex);
+
+	put_online_mems();
+	put_online_cpus();
+
+	flush_memcg_workqueue(s);
+
+	get_online_cpus();
+	get_online_mems();
+
+	mutex_lock(&slab_mutex);
+#endif
+
 	err = shutdown_memcg_caches(s);
 	if (!err)
 		err = shutdown_cache(s);


