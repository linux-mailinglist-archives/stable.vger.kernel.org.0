Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079C2603BFD
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiJSImM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiJSIl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E94E28D;
        Wed, 19 Oct 2022 01:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EEA6617D1;
        Wed, 19 Oct 2022 08:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C053CC433D7;
        Wed, 19 Oct 2022 08:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168759;
        bh=GgGuYB/cFi90xrtwqmYT0ptnVlghrdpQ68XgLT2iUHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsMCmNa9fP15fyRMooNA3BnuO/cKaPWGH9f9UfV0QS1lpUqlP8XklDlqcrAqZQ5n4
         uqZAdHgpXzvnqI+KmhHjY+8ANF5XRDyOShhBs4KU58hQUSiY/33s7GWplNmlxPBmle
         TwOkQVB129+JMpgDD7k7/KnAmu5OO4ZG/ISrXolU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Mike Galbraith <efault@gmx.de>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 045/862] mbcache: Avoid nesting of cache->c_list_lock under bit locks
Date:   Wed, 19 Oct 2022 10:22:12 +0200
Message-Id: <20221019083251.985522115@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 5fc4cbd9fde5d4630494fd6ffc884148fb618087 upstream.

Commit 307af6c87937 ("mbcache: automatically delete entries from cache
on freeing") started nesting cache->c_list_lock under the bit locks
protecting hash buckets of the mbcache hash table in
mb_cache_entry_create(). This causes problems for real-time kernels
because there spinlocks are sleeping locks while bitlocks stay atomic.
Luckily the nesting is easy to avoid by holding entry reference until
the entry is added to the LRU list. This makes sure we cannot race with
entry deletion.

Cc: stable@kernel.org
Fixes: 307af6c87937 ("mbcache: automatically delete entries from cache on freeing")
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220908091032.10513-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/mbcache.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 47ccfcbe0a22..e272ad738faf 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -90,8 +90,14 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&entry->e_list);
-	/* Initial hash reference */
-	atomic_set(&entry->e_refcnt, 1);
+	/*
+	 * We create entry with two references. One reference is kept by the
+	 * hash table, the other reference is used to protect us from
+	 * mb_cache_entry_delete_or_get() until the entry is fully setup. This
+	 * avoids nesting of cache->c_list_lock into hash table bit locks which
+	 * is problematic for RT.
+	 */
+	atomic_set(&entry->e_refcnt, 2);
 	entry->e_key = key;
 	entry->e_value = value;
 	entry->e_reusable = reusable;
@@ -106,15 +112,12 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 		}
 	}
 	hlist_bl_add_head(&entry->e_hash_list, head);
-	/*
-	 * Add entry to LRU list before it can be found by
-	 * mb_cache_entry_delete() to avoid races
-	 */
+	hlist_bl_unlock(head);
 	spin_lock(&cache->c_list_lock);
 	list_add_tail(&entry->e_list, &cache->c_list);
 	cache->c_entry_count++;
 	spin_unlock(&cache->c_list_lock);
-	hlist_bl_unlock(head);
+	mb_cache_entry_put(cache, entry);
 
 	return 0;
 }
-- 
2.38.0



