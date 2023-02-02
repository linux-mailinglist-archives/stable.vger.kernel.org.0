Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176A6688A7A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 00:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjBBXI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 18:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjBBXI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 18:08:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABEC7E072;
        Thu,  2 Feb 2023 15:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33EB461D10;
        Thu,  2 Feb 2023 23:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856C1C4339E;
        Thu,  2 Feb 2023 23:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675379305;
        bh=ZS8Diohuirv9VE/o7FLxQBN1JgOqSWxxoXwj6DFy7G8=;
        h=Date:To:From:Subject:From;
        b=jDp4JUI6OXYA2gAq6DSXzlloDgTVwwjZinufCs29F0XjzovSm6JYRZDhUZTP7FrD1
         sPqWM6mAZps1ERpvKBV4wMYvOoDDQTof6ull4d9fxA2K5aaean4EYPZfTCnR4Cn2vS
         EsJ9hAGVxC/uCtwDyIgLlQcOUIGtzu4gIALh13lo=
Date:   Thu, 02 Feb 2023 15:08:24 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        kent.overstreet@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-fix-deadlock-in-shrinker-debugfs.patch added to mm-unstable branch
Message-Id: <20230202230825.856C1C4339E@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: shrinkers: fix deadlock in shrinker debugfs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-fix-deadlock-in-shrinker-debugfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-fix-deadlock-in-shrinker-debugfs.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20230202105612.64641-1-zhengqi.arch@bytedance.com
Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -115,7 +115,7 @@ static inline int shrinker_debugfs_add(s
 {
 	return 0;
 }
-static inline void shrinker_debugfs_remove(struct shrinker *shrinker)
+static inline struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker)
 {
 }
 static inline __printf(2, 3)
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
@@ -747,6 +747,8 @@ EXPORT_SYMBOL(register_shrinker);
  */
 void unregister_shrinker(struct shrinker *shrinker)
 {
+	struct dentry *debugfs_entry;
+
 	if (!(shrinker->flags & SHRINKER_REGISTERED))
 		return;
 
@@ -755,9 +757,11 @@ void unregister_shrinker(struct shrinker
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

mm-shrinkers-fix-deadlock-in-shrinker-debugfs.patch

