Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6595E6914F4
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 00:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjBIX5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 18:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBIX5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 18:57:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8060A552A8;
        Thu,  9 Feb 2023 15:57:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D647B8237D;
        Thu,  9 Feb 2023 23:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C96C433EF;
        Thu,  9 Feb 2023 23:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675987039;
        bh=EimtB5JKds8OUJCRIIr9unO8IjKs+/HwWrMpSoPhw6k=;
        h=Date:To:From:Subject:From;
        b=dyZbB/hEwuGwONGE5nMooacWFBoxhfox1YxfOhSrWGgKk+LqZtblzzZWL6UR+RlH5
         +VIgnrFlEp5UdXggSTSxxEUl5OhhxjDizOgEO9St8awZOt4llPGdOBKTL5Gh7dyK6z
         Bcy7uufcA/6HSrjRzY2QmR9hMze2B1tX1NK5W4Bs=
Date:   Thu, 09 Feb 2023 15:57:19 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        kent.overstreet@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shrinkers-fix-deadlock-in-shrinker-debugfs.patch removed from -mm tree
Message-Id: <20230209235719.B2C96C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: shrinkers: fix deadlock in shrinker debugfs
has been removed from the -mm tree.  Its filename was
     mm-shrinkers-fix-deadlock-in-shrinker-debugfs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: shrinkers: fix deadlock in shrinker debugfs
Date: Thu, 2 Feb 2023 18:56:12 +0800

The debugfs_remove_recursive() is invoked by unregister_shrinker(), which
is holding the write lock of shrinker_rwsem.  It will waits for the
handler of debugfs file complete.  The handler also needs to hold the read
lock of shrinker_rwsem to do something.  So it may cause the following
deadlock:

 	CPU0				CPU1

debugfs_file_get()
shrinker_debugfs_count_show()/shrinker_debugfs_scan_write()

     				unregister_shrinker()
				--> down_write(&shrinker_rwsem);
				    debugfs_remove_recursive()
					// wait for (A)
				    --> wait_for_completion();

    // wait for (B)
--> down_read_killable(&shrinker_rwsem)
debugfs_file_put() -- (A)

				    up_write() -- (B)

The down_read_killable() can be killed, so that the above deadlock can be
recovered.  But it still requires an extra kill action, otherwise it will
block all subsequent shrinker-related operations, so it's better to fix
it.

[akpm@linux-foundation.org: fix CONFIG_SHRINKER_DEBUG=n stub]
Link: https://lkml.kernel.org/r/20230202105612.64641-1-zhengqi.arch@bytedance.com
Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |    5 +++--
 mm/shrinker_debug.c      |   13 ++++++++-----
 mm/vmscan.c              |    6 +++++-
 3 files changed, 16 insertions(+), 8 deletions(-)

--- a/include/linux/shrinker.h~mm-shrinkers-fix-deadlock-in-shrinker-debugfs
+++ a/include/linux/shrinker.h
@@ -107,7 +107,7 @@ extern void synchronize_shrinkers(void);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 extern int shrinker_debugfs_add(struct shrinker *shrinker);
-extern void shrinker_debugfs_remove(struct shrinker *shrinker);
+extern struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker);
 extern int __printf(2, 3) shrinker_debugfs_rename(struct shrinker *shrinker,
 						  const char *fmt, ...);
 #else /* CONFIG_SHRINKER_DEBUG */
@@ -115,8 +115,9 @@ static inline int shrinker_debugfs_add(s
 {
 	return 0;
 }
-static inline void shrinker_debugfs_remove(struct shrinker *shrinker)
+static inline struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker)
 {
+	return NULL;
 }
 static inline __printf(2, 3)
 int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
--- a/mm/shrinker_debug.c~mm-shrinkers-fix-deadlock-in-shrinker-debugfs
+++ a/mm/shrinker_debug.c
@@ -246,18 +246,21 @@ int shrinker_debugfs_rename(struct shrin
 }
 EXPORT_SYMBOL(shrinker_debugfs_rename);
 
-void shrinker_debugfs_remove(struct shrinker *shrinker)
+struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker)
 {
+	struct dentry *entry = shrinker->debugfs_entry;
+
 	lockdep_assert_held(&shrinker_rwsem);
 
 	kfree_const(shrinker->name);
 	shrinker->name = NULL;
 
-	if (!shrinker->debugfs_entry)
-		return;
+	if (entry) {
+		ida_free(&shrinker_debugfs_ida, shrinker->debugfs_id);
+		shrinker->debugfs_entry = NULL;
+	}
 
-	debugfs_remove_recursive(shrinker->debugfs_entry);
-	ida_free(&shrinker_debugfs_ida, shrinker->debugfs_id);
+	return entry;
 }
 
 static int __init shrinker_debugfs_init(void)
--- a/mm/vmscan.c~mm-shrinkers-fix-deadlock-in-shrinker-debugfs
+++ a/mm/vmscan.c
@@ -741,6 +741,8 @@ EXPORT_SYMBOL(register_shrinker);
  */
 void unregister_shrinker(struct shrinker *shrinker)
 {
+	struct dentry *debugfs_entry;
+
 	if (!(shrinker->flags & SHRINKER_REGISTERED))
 		return;
 
@@ -749,9 +751,11 @@ void unregister_shrinker(struct shrinker
 	shrinker->flags &= ~SHRINKER_REGISTERED;
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
-	shrinker_debugfs_remove(shrinker);
+	debugfs_entry = shrinker_debugfs_remove(shrinker);
 	up_write(&shrinker_rwsem);
 
+	debugfs_remove_recursive(debugfs_entry);
+
 	kfree(shrinker->nr_deferred);
 	shrinker->nr_deferred = NULL;
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


