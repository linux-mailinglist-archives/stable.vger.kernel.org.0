Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D345717A8
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 12:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiGLKym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 06:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbiGLKyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 06:54:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D5AAE3BB;
        Tue, 12 Jul 2022 03:54:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 633721F901;
        Tue, 12 Jul 2022 10:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657623277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vkU/jSyn+kFPvBeQW7f228kBQrxyjZzDCIvwGO/yKY=;
        b=Qhljyv9eTykswr41MUM8AZAbGyAlTkZLEGxWBG8wgEfcZ6+IMHKND1wGzF3EMQvMW7RpVH
        9taeacAxzRpEF6RusAkE5bkVHZXxrk++WPBol6n8k/hW+2uMBf1PoZfrnoBFSnol2q4ucU
        No+H3DrjAAWlQ6k8qbSio205b71tfNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657623277;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vkU/jSyn+kFPvBeQW7f228kBQrxyjZzDCIvwGO/yKY=;
        b=qPkqVQFnbB7AZlNuPNKqEWph8YDyqloqSUx0ldgS11F0CwFk1UQR1QvKlzKJ7qlk7VDe1d
        zT3mqDJa0qqxESDw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4FEFE2C142;
        Tue, 12 Jul 2022 10:54:37 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id EE446A0640; Tue, 12 Jul 2022 12:54:36 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 01/10] mbcache: Don't reclaim used entries
Date:   Tue, 12 Jul 2022 12:54:20 +0200
Message-Id: <20220712105436.32204-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712104519.29887-1-jack@suse.cz>
References: <20220712104519.29887-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1590; h=from:subject; bh=UQ7BhRBWvrAq3UlI+B+lJRwHJqv6fPllDg3HzQWNAMc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBizVLcQ5AoQNYCuzZdIzBlGvZi6ZuSgVGldNtRaRH4 I/MHtBeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYs1S3AAKCRCcnaoHP2RA2TMvCA CKbU2SMCYmAAZu67GpUJbb370eZeqvSkR14u3olM/S+HZkdgIdeb7ug5Rngpp7Zh1JltNyGIzBlB2u nGRXL5LLla2KcD/+UmqW29LG2rJcnZXwsJHLOgLc9kDe2h/qvR7cAnLRx5v3QaUojebHz6eIk4MW3V 39tRolbvWzLK3XfXjmkT/j+S2mgllO5g6m5X2GZ6SmUSvwaZqDOls8zaKtf0CevmRLsrGw0nLOqblH qhXiQfau4ipda523cm6ZiY1WYW56zN/S0pzR0MdWdwpQlqdpCM4u2ZfcA2eWawP7BuarWhO6IpnDNZ pmdSzqGTVOc3T1ibyv2nGy1lHIvvTM
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

