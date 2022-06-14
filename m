Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F322354B54A
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 18:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356264AbiFNQGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbiFNQGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:06:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F068D3EB89;
        Tue, 14 Jun 2022 09:06:05 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 402CF21B8C;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655222764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vkU/jSyn+kFPvBeQW7f228kBQrxyjZzDCIvwGO/yKY=;
        b=sdXevBRXWa7OTRPXWJLNLcEzV77eEsmBQ6tMZdQ20OSxo6gAzhxcFPeZYxyHtwAVCrDzNC
        pj6HVm6uf4D9KTe+iCM0+Ozyd7Ts9vf2YIQYaF/GM27S/EqGOMzv7wV5t2dYCgFa8/U6gU
        MB69iCdlK/qARuu+mhD2S605DXgv7is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655222764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vkU/jSyn+kFPvBeQW7f228kBQrxyjZzDCIvwGO/yKY=;
        b=7k7PODh0AjVVNwymgp++zLz62rkr8grba9aQRO34jWTZo9987WLZcbGZRg2xtBAdOixSQP
        bYPuDvBwIJcWfsBw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2B1A62C146;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id BFC93A0634; Tue, 14 Jun 2022 18:06:03 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 01/10] mbcache: Don't reclaim used entries
Date:   Tue, 14 Jun 2022 18:05:15 +0200
Message-Id: <20220614160603.20566-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614124146.21594-1-jack@suse.cz>
References: <20220614124146.21594-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1590; h=from:subject; bh=UQ7BhRBWvrAq3UlI+B+lJRwHJqv6fPllDg3HzQWNAMc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiqLG7Q5AoQNYCuzZdIzBlGvZi6ZuSgVGldNtRaRH4 I/MHtBeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYqixuwAKCRCcnaoHP2RA2eUwCA Do6wrrtcT5upau8lWWFThbrVyWyeZMBKDYiI6JQswu+Q+sBOjTL5aHr0dcVeg46K3txhE0scRP/PVW Px1O+6TtOQO+Jq+SimjMYhOaU1ME/0vH/38hp4AslalP+7KoBkXpnIaVkDEaaBbDpVCu4Ph+DOIQ/g u7K5L+Tvj6C/T7KMxHhKsu19881CIP0d1EAZmV/VxJioD4/3RYEHPRmRluR9P+ZP2R/XEX3sEVtmwN 8csSB27UXQ2J1AehHOpy1SsvHOu96X+bUVQnmyTLQX+0X6NrOYMHz8EBEMuh3O4MDqeVzWAaTyrZXF Mk7iS2zPzIawtT7jjZe9aJA75vWXbJ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Do not reclaim entries that are currently used by somebody from a
shrinker. Firstly, these entries are likely useful. Secondly, we will
need to keep such entries to protect pending increment of xattr block
refcount.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
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
2.35.3

