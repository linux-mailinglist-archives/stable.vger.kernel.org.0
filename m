Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F5869CE6D
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbjBTN7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjBTN7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50741EFE5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04087B80D4F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C165C433EF;
        Mon, 20 Feb 2023 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901512;
        bh=dKm4+i288vmyET0T/ytqj+p+gKmXN7S4Rb6+w17rqVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYKDa7tS9uqVYaB6WDWfnUyKK24Zh8vX60ID36uoji6aSkgw3V1935OOAQB+9bHmA
         iAZNTGc1MzsotCkyEqZ8CKlzPQJ5ihJMgW6rnwEB0zf4NdfMJ4sFfecvvdOvMpmof8
         V9MnY11aLnEj7dHLBj3C+A9ko+4WhdrE8MFvuz4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qi Zheng <zhengqi.arch@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 046/118] mm: shrinkers: fix deadlock in shrinker debugfs
Date:   Mon, 20 Feb 2023 14:36:02 +0100
Message-Id: <20230220133602.274842332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qi Zheng <zhengqi.arch@bytedance.com>

commit badc28d4924bfed73efc93f716a0c3aa3afbdf6f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/shrinker.h |    5 +++--
 mm/shrinker_debug.c      |   13 ++++++++-----
 mm/vmscan.c              |    6 +++++-
 3 files changed, 16 insertions(+), 8 deletions(-)

--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -104,7 +104,7 @@ extern void synchronize_shrinkers(void);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 extern int shrinker_debugfs_add(struct shrinker *shrinker);
-extern void shrinker_debugfs_remove(struct shrinker *shrinker);
+extern struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker);
 extern int __printf(2, 3) shrinker_debugfs_rename(struct shrinker *shrinker,
 						  const char *fmt, ...);
 #else /* CONFIG_SHRINKER_DEBUG */
@@ -112,8 +112,9 @@ static inline int shrinker_debugfs_add(s
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
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
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
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -740,6 +740,8 @@ EXPORT_SYMBOL(register_shrinker);
  */
 void unregister_shrinker(struct shrinker *shrinker)
 {
+	struct dentry *debugfs_entry;
+
 	if (!(shrinker->flags & SHRINKER_REGISTERED))
 		return;
 
@@ -748,9 +750,11 @@ void unregister_shrinker(struct shrinker
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


