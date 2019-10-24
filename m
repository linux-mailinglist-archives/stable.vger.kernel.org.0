Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01D8E2BE7
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 10:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfJXIRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 04:17:43 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:34446 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbfJXIRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 04:17:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07486;MF=zhangliguang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Tg2GxHS_1571905044;
Received: from localhost(mailfrom:zhangliguang@linux.alibaba.com fp:SMTPD_---0Tg2GxHS_1571905044)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Oct 2019 16:17:31 +0800
From:   luanshi <zhangliguang@linux.alibaba.com>
To:     Xunlei Pang <xlpang@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     alikernel-developer@linux.alibaba.com,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org,
        luanshi <zhangliguang@linux.alibaba.com>
Subject: [PATCH 7u 02/15] resizable namespace.c hashes
Date:   Thu, 24 Oct 2019 16:16:48 +0800
Message-Id: <1571905021-26603-3-git-send-email-zhangliguang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571905021-26603-1-git-send-email-zhangliguang@linux.alibaba.com>
References: <1571905021-26603-1-git-send-email-zhangliguang@linux.alibaba.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 0818bf27c05b2de56c5b2bd08cfae2a939bd5f52 upstream

* switch allocation to alloc_large_system_hash()
* make sizes overridable by boot parameters (mhash_entries=, mphash_entries=)
* switch mountpoint_hashtable from list_head to hlist_head

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: luanshi <zhangliguang@linux.alibaba.com>
---
 7u/fs/mount.h     |  2 +-
 7u/fs/namespace.c | 85 +++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 64 insertions(+), 23 deletions(-)

diff --git a/7u/fs/mount.h b/7u/fs/mount.h
index 7758dd4..75d5615 100644
--- a/7u/fs/mount.h
+++ b/7u/fs/mount.h
@@ -19,7 +19,7 @@ struct mnt_pcp {
 };
 
 struct mountpoint {
-	struct list_head m_hash;
+	struct hlist_node m_hash;
 	struct dentry *m_dentry;
 	int m_count;
 };
diff --git a/7u/fs/namespace.c b/7u/fs/namespace.c
index 76ba0d7..6e1231b 100644
--- a/7u/fs/namespace.c
+++ b/7u/fs/namespace.c
@@ -23,11 +23,34 @@
 #include <linux/uaccess.h>
 #include <linux/proc_ns.h>
 #include <linux/magic.h>
+#include <linux/bootmem.h>
 #include "pnode.h"
 #include "internal.h"
 
-#define HASH_SHIFT 12
-#define HASH_SIZE (1UL << HASH_SHIFT)
+static unsigned int m_hash_mask __read_mostly;
+static unsigned int m_hash_shift __read_mostly;
+static unsigned int mp_hash_mask __read_mostly;
+static unsigned int mp_hash_shift __read_mostly;
+
+static __initdata unsigned long mhash_entries;
+static int __init set_mhash_entries(char *str)
+{
+	if (!str)
+		return 0;
+	mhash_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("mhash_entries=", set_mhash_entries);
+
+static __initdata unsigned long mphash_entries;
+static int __init set_mphash_entries(char *str)
+{
+	if (!str)
+		return 0;
+	mphash_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("mphash_entries=", set_mphash_entries);
 
 static u64 event;
 static DEFINE_IDA(mnt_id_ida);
@@ -36,8 +59,8 @@ static DEFINE_SPINLOCK(mnt_id_lock);
 static int mnt_id_start = 0;
 static int mnt_group_start = 1;
 
-static struct list_head mount_hashtable[HASH_SIZE];
-static struct list_head mountpoint_hashtable[HASH_SIZE];
+static struct list_head *mount_hashtable __read_mostly;
+static struct hlist_head *mountpoint_hashtable __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
@@ -55,12 +78,19 @@ EXPORT_SYMBOL_GPL(fs_kobj);
  */
 DEFINE_BRLOCK(vfsmount_lock);
 
-static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
+static inline struct list_head *m_hash(struct vfsmount *mnt, struct dentry *dentry)
 {
 	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
 	tmp += ((unsigned long)dentry / L1_CACHE_BYTES);
-	tmp = tmp + (tmp >> HASH_SHIFT);
-	return tmp & (HASH_SIZE - 1);
+	tmp = tmp + (tmp >> m_hash_shift);
+	return &mount_hashtable[tmp & m_hash_mask];
+}
+
+static inline struct hlist_head *mp_hash(struct dentry *dentry)
+{
+	unsigned long tmp = ((unsigned long)dentry / L1_CACHE_BYTES);
+	tmp = tmp + (tmp >> mp_hash_shift);
+	return &mountpoint_hashtable[tmp & mp_hash_mask];
 }
 
 #define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
@@ -555,7 +585,7 @@ static void free_vfsmnt(struct mount *mnt)
  */
 struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry)
 {
-	struct list_head *head = mount_hashtable + hash(mnt, dentry);
+	struct list_head *head = m_hash(mnt, dentry);
 	struct mount *p;
 
 	list_for_each_entry(p, head, mnt_hash)
@@ -570,7 +600,7 @@ struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry)
  */
 struct mount *__lookup_mnt_last(struct vfsmount *mnt, struct dentry *dentry)
 {
-	struct list_head *head = mount_hashtable + hash(mnt, dentry);
+	struct list_head *head = m_hash(mnt, dentry);
 	struct mount *p;
 
 	list_for_each_entry_reverse(p, head, mnt_hash)
@@ -613,11 +643,11 @@ struct vfsmount *lookup_mnt(struct path *path)
 
 static struct mountpoint *new_mountpoint(struct dentry *dentry)
 {
-	struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
+	struct hlist_head *chain = mp_hash(dentry);
 	struct mountpoint *mp;
 	int ret;
 
-	list_for_each_entry(mp, chain, m_hash) {
+	hlist_for_each_entry(mp, chain, m_hash) {
 		if (mp->m_dentry == dentry) {
 			/* might be worth a WARN_ON() */
 			if (d_unlinked(dentry))
@@ -639,7 +669,7 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
 
 	mp->m_dentry = dentry;
 	mp->m_count = 1;
-	list_add(&mp->m_hash, chain);
+	hlist_add_head(&mp->m_hash, chain);
 	return mp;
 }
 
@@ -650,7 +680,7 @@ static void put_mountpoint(struct mountpoint *mp)
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags &= ~DCACHE_MOUNTED;
 		spin_unlock(&dentry->d_lock);
-		list_del(&mp->m_hash);
+		hlist_del(&mp->m_hash);
 		kfree(mp);
 	}
 }
@@ -719,8 +749,7 @@ static void attach_mnt(struct mount *mnt,
 			struct mountpoint *mp)
 {
 	mnt_set_mountpoint(parent, mp, mnt);
-	list_add_tail(&mnt->mnt_hash, mount_hashtable +
-			hash(&parent->mnt, mp->m_dentry));
+	list_add_tail(&mnt->mnt_hash, m_hash(&parent->mnt, mp->m_dentry));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
 }
 
@@ -742,8 +771,8 @@ static void commit_tree(struct mount *mnt)
 
 	list_splice(&head, n->list.prev);
 
-	list_add_tail(&mnt->mnt_hash, mount_hashtable +
-				hash(&parent->mnt, mnt->mnt_mountpoint));
+	list_add_tail(&mnt->mnt_hash,
+		    m_hash(&parent->mnt, mnt->mnt_mountpoint));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
 	touch_mnt_namespace(n);
 }
@@ -2792,12 +2821,24 @@ void __init mnt_init(void)
 	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
 			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 
-	printk(KERN_INFO "Mount-cache hash table entries: %lu\n", HASH_SIZE);
-
-	for (u = 0; u < HASH_SIZE; u++)
+	mount_hashtable = alloc_large_system_hash("Mount-cache",
+		    sizeof(struct list_head),
+		    mhash_entries, 19,
+		    0,
+		    &m_hash_shift, &m_hash_mask, 0, 0);
+	mountpoint_hashtable = alloc_large_system_hash("Mountpoint-cache",
+		    sizeof(struct hlist_head),
+		    mphash_entries, 19,
+		    0,
+		    &mp_hash_shift, &mp_hash_mask, 0, 0);
+
+	if (!mount_hashtable || !mountpoint_hashtable)
+		panic("Failed to allocate mount hash table\n");
+
+	for (u = 0; u <= m_hash_mask; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
-	for (u = 0; u < HASH_SIZE; u++)
-		INIT_LIST_HEAD(&mountpoint_hashtable[u]);
+	for (u = 0; u <= mp_hash_mask; u++)
+		INIT_HLIST_HEAD(&mountpoint_hashtable[u]);
 
 	br_lock_init(&vfsmount_lock);
 
-- 
1.8.3.1

