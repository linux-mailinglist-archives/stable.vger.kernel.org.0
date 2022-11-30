Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769C063DFC5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiK3Su0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiK3SuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAFA9D823
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEE2B61D70
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8531C433C1;
        Wed, 30 Nov 2022 18:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834218;
        bh=xMJkzBIVWQrmtu7hgyrOOw+KdBPXmnY7o6g9MkAUpJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgznraUaMxYNhzGqWQJjwpbti5cy/UfbYNx/TQ593ypSfiFk8Xwf8kHfv+gV+IsPV
         nzroqst4lVZXTJDYZ190pOSAa5tkLY8lXPwupBtaCApV7GB4FHvHnagwi4Pa7DBWwI
         838xOsFKn/SX5EiaITL3WCQASIQHWg8ZRF/vJqzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+a76f6a6e524cf2080aa3@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Zhang Peng <zhangpeng362@huawei.com>,
        Jingbo Xu <jefflexu@linux.alibaba.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        v9fs-developer@lists.sourceforge.net, linux-cachefs@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 145/289] fscache: fix OOB Read in __fscache_acquire_volume
Date:   Wed, 30 Nov 2022 19:22:10 +0100
Message-Id: <20221130180547.424547936@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 9f0933ac026f7e54fe096797af9de20724e79097 ]

The type of a->key[0] is char in fscache_volume_same().  If the length
of cache volume key is greater than 127, the value of a->key[0] is less
than 0.  In this case, klen becomes much larger than 255 after type
conversion, because the type of klen is size_t.  As a result, memcmp()
is read out of bounds.

This causes a slab-out-of-bounds Read in __fscache_acquire_volume(), as
reported by Syzbot.

Fix this by changing the type of the stored key to "u8 *" rather than
"char *" (it isn't a simple string anyway).  Also put in a check that
the volume name doesn't exceed NAME_MAX.

  BUG: KASAN: slab-out-of-bounds in memcmp+0x16f/0x1c0 lib/string.c:757
  Read of size 8 at addr ffff888016f3aa90 by task syz-executor344/3613
  Call Trace:
   memcmp+0x16f/0x1c0 lib/string.c:757
   memcmp include/linux/fortify-string.h:420 [inline]
   fscache_volume_same fs/fscache/volume.c:133 [inline]
   fscache_hash_volume fs/fscache/volume.c:171 [inline]
   __fscache_acquire_volume+0x76c/0x1080 fs/fscache/volume.c:328
   fscache_acquire_volume include/linux/fscache.h:204 [inline]
   v9fs_cache_session_get_cookie+0x143/0x240 fs/9p/cache.c:34
   v9fs_session_init+0x1166/0x1810 fs/9p/v9fs.c:473
   v9fs_mount+0xba/0xc90 fs/9p/vfs_super.c:126
   legacy_get_tree+0x105/0x220 fs/fs_context.c:610
   vfs_get_tree+0x89/0x2f0 fs/super.c:1530
   do_new_mount fs/namespace.c:3040 [inline]
   path_mount+0x1326/0x1e20 fs/namespace.c:3370
   do_mount fs/namespace.c:3383 [inline]
   __do_sys_mount fs/namespace.c:3591 [inline]
   __se_sys_mount fs/namespace.c:3568 [inline]
   __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568

Fixes: 62ab63352350 ("fscache: Implement volume registration")
Reported-by: syzbot+a76f6a6e524cf2080aa3@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Zhang Peng <zhangpeng362@huawei.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
cc: Dominique Martinet <asmadeus@codewreck.org>
cc: Jeff Layton <jlayton@kernel.org>
cc: v9fs-developer@lists.sourceforge.net
cc: linux-cachefs@redhat.com
Link: https://lore.kernel.org/r/Y3OH+Dmi0QIOK18n@codewreck.org/ # Zhang Peng's v1 fix
Link: https://lore.kernel.org/r/20221115140447.2971680-1-zhangpeng362@huawei.com/ # Zhang Peng's v2 fix
Link: https://lore.kernel.org/r/166869954095.3793579.8500020902371015443.stgit@warthog.procyon.org.uk/ # v1
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fscache/volume.c     | 7 +++++--
 include/linux/fscache.h | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/fscache/volume.c b/fs/fscache/volume.c
index a058e0136bfe..ab8ceddf9efa 100644
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -203,7 +203,11 @@ static struct fscache_volume *fscache_alloc_volume(const char *volume_key,
 	struct fscache_volume *volume;
 	struct fscache_cache *cache;
 	size_t klen, hlen;
-	char *key;
+	u8 *key;
+
+	klen = strlen(volume_key);
+	if (klen > NAME_MAX)
+		return NULL;
 
 	if (!coherency_data)
 		coherency_len = 0;
@@ -229,7 +233,6 @@ static struct fscache_volume *fscache_alloc_volume(const char *volume_key,
 	/* Stick the length on the front of the key and pad it out to make
 	 * hashing easier.
 	 */
-	klen = strlen(volume_key);
 	hlen = round_up(1 + klen + 1, sizeof(__le32));
 	key = kzalloc(hlen, GFP_KERNEL);
 	if (!key)
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 36e5dd84cf59..8e312c8323a8 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -75,7 +75,7 @@ struct fscache_volume {
 	atomic_t			n_accesses;	/* Number of cache accesses in progress */
 	unsigned int			debug_id;
 	unsigned int			key_hash;	/* Hash of key string */
-	char				*key;		/* Volume ID, eg. "afs@example.com@1234" */
+	u8				*key;		/* Volume ID, eg. "afs@example.com@1234" */
 	struct list_head		proc_link;	/* Link in /proc/fs/fscache/volumes */
 	struct hlist_bl_node		hash_link;	/* Link in hash table */
 	struct work_struct		work;
-- 
2.35.1



