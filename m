Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890CB5AEC95
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiIFOAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241173AbiIFN75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403D38276E;
        Tue,  6 Sep 2022 06:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D54DBB8162F;
        Tue,  6 Sep 2022 13:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA26C433C1;
        Tue,  6 Sep 2022 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471830;
        bh=9CD0oUxuKuG8Xrr38N9ng/nqQ6fejRpM3iKhYYLrVkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEAIMuF3ldfqn95HrQD/u5Mn4t0Ife7iozA8m90GUfSg2QHLrkwZPCwdbzCGjESPf
         OsgiQZeEUuAGYHEJbF84qYzX5EjNIaRas6p16ZDH0Os0vNK27pcf2gAZSXuxJu1VbI
         MM+qRbd6+l2GSuWrKmohvqyQ6kfJC3yLlKYaE2Wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 053/155] mm/slab_common: Deleting kobject in kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock
Date:   Tue,  6 Sep 2022 15:30:01 +0200
Message-Id: <20220906132831.662030592@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 0495e337b7039191dfce6e03f5f830454b1fae6b ]

A circular locking problem is reported by lockdep due to the following
circular locking dependency.

  +--> cpu_hotplug_lock --> slab_mutex --> kn->active --+
  |                                                     |
  +-----------------------------------------------------+

The forward cpu_hotplug_lock ==> slab_mutex ==> kn->active dependency
happens in

  kmem_cache_destroy():	cpus_read_lock(); mutex_lock(&slab_mutex);
  ==> sysfs_slab_unlink()
      ==> kobject_del()
          ==> kernfs_remove()
	      ==> __kernfs_remove()
	          ==> kernfs_drain(): rwsem_acquire(&kn->dep_map, ...);

The backward kn->active ==> cpu_hotplug_lock dependency happens in

  kernfs_fop_write_iter(): kernfs_get_active();
  ==> slab_attr_store()
      ==> cpu_partial_store()
          ==> flush_all(): cpus_read_lock()

One way to break this circular locking chain is to avoid holding
cpu_hotplug_lock and slab_mutex while deleting the kobject in
sysfs_slab_unlink() which should be equivalent to doing a write_lock
and write_unlock pair of the kn->active virtual lock.

Since the kobject structures are not protected by slab_mutex or the
cpu_hotplug_lock, we can certainly release those locks before doing
the delete operation.

Move sysfs_slab_unlink() and sysfs_slab_release() to the newly
created kmem_cache_release() and call it outside the slab_mutex &
cpu_hotplug_lock critical sections. There will be a slight delay
in the deletion of sysfs files if kmem_cache_release() is called
indirectly from a work function.

Fixes: 5a836bf6b09f ("mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: David Rientjes <rientjes@google.com>
Link: https://lore.kernel.org/all/YwOImVd+nRUsSAga@hyeyoo/
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab_common.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 77c3adf40e504..dbd4b6f9b0e79 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -420,6 +420,28 @@ kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
+#ifdef SLAB_SUPPORTS_SYSFS
+/*
+ * For a given kmem_cache, kmem_cache_destroy() should only be called
+ * once or there will be a use-after-free problem. The actual deletion
+ * and release of the kobject does not need slab_mutex or cpu_hotplug_lock
+ * protection. So they are now done without holding those locks.
+ *
+ * Note that there will be a slight delay in the deletion of sysfs files
+ * if kmem_cache_release() is called indrectly from a work function.
+ */
+static void kmem_cache_release(struct kmem_cache *s)
+{
+	sysfs_slab_unlink(s);
+	sysfs_slab_release(s);
+}
+#else
+static void kmem_cache_release(struct kmem_cache *s)
+{
+	slab_kmem_cache_release(s);
+}
+#endif
+
 static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work)
 {
 	LIST_HEAD(to_destroy);
@@ -446,11 +468,7 @@ static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work)
 	list_for_each_entry_safe(s, s2, &to_destroy, list) {
 		debugfs_slab_release(s);
 		kfence_shutdown_cache(s);
-#ifdef SLAB_SUPPORTS_SYSFS
-		sysfs_slab_release(s);
-#else
-		slab_kmem_cache_release(s);
-#endif
+		kmem_cache_release(s);
 	}
 }
 
@@ -465,20 +483,11 @@ static int shutdown_cache(struct kmem_cache *s)
 	list_del(&s->list);
 
 	if (s->flags & SLAB_TYPESAFE_BY_RCU) {
-#ifdef SLAB_SUPPORTS_SYSFS
-		sysfs_slab_unlink(s);
-#endif
 		list_add_tail(&s->list, &slab_caches_to_rcu_destroy);
 		schedule_work(&slab_caches_to_rcu_destroy_work);
 	} else {
 		kfence_shutdown_cache(s);
 		debugfs_slab_release(s);
-#ifdef SLAB_SUPPORTS_SYSFS
-		sysfs_slab_unlink(s);
-		sysfs_slab_release(s);
-#else
-		slab_kmem_cache_release(s);
-#endif
 	}
 
 	return 0;
@@ -493,14 +502,16 @@ void slab_kmem_cache_release(struct kmem_cache *s)
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
+	int refcnt;
+
 	if (unlikely(!s) || !kasan_check_byte(s))
 		return;
 
 	cpus_read_lock();
 	mutex_lock(&slab_mutex);
 
-	s->refcount--;
-	if (s->refcount)
+	refcnt = --s->refcount;
+	if (refcnt)
 		goto out_unlock;
 
 	WARN(shutdown_cache(s),
@@ -509,6 +520,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
 out_unlock:
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
+	if (!refcnt && !(s->flags & SLAB_TYPESAFE_BY_RCU))
+		kmem_cache_release(s);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
-- 
2.35.1



