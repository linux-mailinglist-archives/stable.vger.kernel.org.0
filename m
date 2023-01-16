Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4318866C93B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbjAPQrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbjAPQq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:46:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CF023DB4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:34:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 910C46106E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39DBC433EF;
        Mon, 16 Jan 2023 16:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886873;
        bh=5PSiAyXwH78FC2CxoOVvMpg4fqE65O7a2dLACCLpZVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCmmiNMotjf9UwTnccdY1Z16YihIBQYqYv/UH0gwwK12Q5KJQg7L/lWk/0HDulSq+
         kRV3rzcRP47WeATA3hDk8RbIzuoQK0z13XNcm+qkO8jY150sDYNerbnUq0ntUuVLPe
         /Ixa7ndAKJE0Y8N5D5126ZoQN/IceQ6+xxIDZsx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Mike Galbraith <efault@gmx.de>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 595/658] mbcache: Avoid nesting of cache->c_list_lock under bit locks
Date:   Mon, 16 Jan 2023 16:51:23 +0100
Message-Id: <20230116154936.694195924@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
 fs/mbcache.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -90,8 +90,14 @@ int mb_cache_entry_create(struct mb_cach
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
 	entry->e_flags = 0;
@@ -107,15 +113,12 @@ int mb_cache_entry_create(struct mb_cach
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


