Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6266677D6
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbjALOtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240082AbjALOsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:48:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74CB657A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:36:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E1E8B81E7C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC921C433D2;
        Thu, 12 Jan 2023 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534166;
        bh=K3Z/voQ6voqtb0S8pqAhrrojJQY4E6tYR2H3+PP6jXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRBUREGl4kapR3oE7EXOPGd5D0+FQbVPcxvkS9T7wSa26lwa/VEZ2Fmu4MZ0fvzWi
         WaBVECkBRCveNGVkSRcEv7Qp2yRoR0kDD0tASCRybTmZuW0ibs6Njq6NmQ1tzVt9XR
         uOqdFu9JCWPZWyyqi+2VkMlKV22UxOlrwkMYFA2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 717/783] mbcache: dont reclaim used entries
Date:   Thu, 12 Jan 2023 14:57:13 +0100
Message-Id: <20230112135557.609416589@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 58318914186c157477b978b1739dfe2f1b9dc0fe ]

Do not reclaim entries that are currently used by somebody from a
shrinker. Firstly, these entries are likely useful. Secondly, we will
need to keep such entries to protect pending increment of xattr block
refcount.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220712105436.32204-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a44e84a9b776 ("ext4: fix deadlock due to mbcache entry corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/mbcache.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 97c54d3a2227..cfc28129fb6f 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -288,7 +288,7 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 	while (nr_to_scan-- && !list_empty(&cache->c_list)) {
 		entry = list_first_entry(&cache->c_list,
 					 struct mb_cache_entry, e_list);
-		if (entry->e_referenced) {
+		if (entry->e_referenced || atomic_read(&entry->e_refcnt) > 2) {
 			entry->e_referenced = 0;
 			list_move_tail(&entry->e_list, &cache->c_list);
 			continue;
@@ -302,6 +302,14 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 		spin_unlock(&cache->c_list_lock);
 		head = mb_cache_entry_head(cache, entry->e_key);
 		hlist_bl_lock(head);
+		/* Now a reliable check if the entry didn't get used... */
+		if (atomic_read(&entry->e_refcnt) > 2) {
+			hlist_bl_unlock(head);
+			spin_lock(&cache->c_list_lock);
+			list_add_tail(&entry->e_list, &cache->c_list);
+			cache->c_entry_count++;
+			continue;
+		}
 		if (!hlist_bl_unhashed(&entry->e_hash_list)) {
 			hlist_bl_del_init(&entry->e_hash_list);
 			atomic_dec(&entry->e_refcnt);
-- 
2.35.1



