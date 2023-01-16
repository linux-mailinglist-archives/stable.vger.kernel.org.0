Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F089766CBF1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbjAPRUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbjAPRTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092F82F7BE
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7BA2B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08439C4339B;
        Mon, 16 Jan 2023 16:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888337;
        bh=hU4662M6YQX6OR5tBCuRr2EM/H2kuefWhIXMxCZVt0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDqzSewm7sALySmIzc7ytnj3yixV/rDPyo1DoLvcPNqydBFhPUQJFRdTU7fcekEPR
         ehhURyyvOfgPJhr5h3iSxTuYlYHbQ920PHyTQgvOQvUrx5dccQxEfvZtquECNRz2cY
         E9VomxVIt776qMGQmkvn21tjqiR5xskK6CcMw/1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Mike Galbraith <efault@gmx.de>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 460/521] mbcache: Avoid nesting of cache->c_list_lock under bit locks
Date:   Mon, 16 Jan 2023 16:52:02 +0100
Message-Id: <20230116154907.708507249@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
@@ -89,8 +89,14 @@ int mb_cache_entry_create(struct mb_cach
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
@@ -106,15 +112,12 @@ int mb_cache_entry_create(struct mb_cach
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


