Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C08B60ABAB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbiJXNzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236777AbiJXNyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:54:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCACFBC476;
        Mon, 24 Oct 2022 05:43:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C77A3612FC;
        Mon, 24 Oct 2022 12:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA17C433D6;
        Mon, 24 Oct 2022 12:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614518;
        bh=xUR1DwuGdTG1CYeye9s5R/gGLasGeNQAl7kbcdATpBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6kfXTBrplyJIN4LlAErJDG1hfCxehAlCiSzOMyzNKUzhQKWhqIiSlqfV8RALpK90
         QpSHNMAoxR+r5vXh1Vgki0ab8bYYxlXzMSLLo1o+/izwpD3UCwSF42EBR0QqrLNvIv
         Z8Ia1JCqXOiMbau08ySuaFBOxmne4Ge2GE8wgK0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lei Li <noctis.akm@gmail.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/390] f2fs: fix to avoid REQ_TIME and CP_TIME collision
Date:   Mon, 24 Oct 2022 13:31:29 +0200
Message-Id: <20221024113035.422754576@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 493720a4854343b7c3fe100cda6a3a2c3f8d4b5d ]

Lei Li reported a issue: if foreground operations are frequent, background
checkpoint may be always skipped due to below check, result in losing more
data after sudden power-cut.

f2fs_balance_fs_bg()
...
	if (!is_idle(sbi, REQ_TIME) &&
		(!excess_dirty_nats(sbi) && !excess_dirty_nodes(sbi)))
		return;

E.g:
cp_interval = 5 second
idle_interval = 2 second
foreground operation interval = 1 second (append 1 byte per second into file)

In such case, no matter when it calls f2fs_balance_fs_bg(), is_idle(, REQ_TIME)
returns false, result in skipping background checkpoint.

This patch changes as below to make trigger condition being more reasonable:
- trigger sync_fs() if dirty_{nats,nodes} and prefree segs exceeds threshold;
- skip triggering sync_fs() if there is any background inflight IO or there is
foreground operation recently and meanwhile cp_rwsem is being held by someone;

Reported-by: Lei Li <noctis.akm@gmail.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: d80afefb17e0 ("f2fs: fix to account FS_CP_DATA_IO correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    | 19 +++++++++++++------
 fs/f2fs/segment.c | 47 +++++++++++++++++++++++++++--------------------
 2 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index dbe9fcef07e3..70fec13d35b7 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2426,24 +2426,31 @@ static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
 	return entry;
 }
 
-static inline bool is_idle(struct f2fs_sb_info *sbi, int type)
+static inline bool is_inflight_io(struct f2fs_sb_info *sbi, int type)
 {
-	if (sbi->gc_mode == GC_URGENT_HIGH)
-		return true;
-
 	if (get_pages(sbi, F2FS_RD_DATA) || get_pages(sbi, F2FS_RD_NODE) ||
 		get_pages(sbi, F2FS_RD_META) || get_pages(sbi, F2FS_WB_DATA) ||
 		get_pages(sbi, F2FS_WB_CP_DATA) ||
 		get_pages(sbi, F2FS_DIO_READ) ||
 		get_pages(sbi, F2FS_DIO_WRITE))
-		return false;
+		return true;
 
 	if (type != DISCARD_TIME && SM_I(sbi) && SM_I(sbi)->dcc_info &&
 			atomic_read(&SM_I(sbi)->dcc_info->queued_discard))
-		return false;
+		return true;
 
 	if (SM_I(sbi) && SM_I(sbi)->fcc_info &&
 			atomic_read(&SM_I(sbi)->fcc_info->queued_flush))
+		return true;
+	return false;
+}
+
+static inline bool is_idle(struct f2fs_sb_info *sbi, int type)
+{
+	if (sbi->gc_mode == GC_URGENT_HIGH)
+		return true;
+
+	if (is_inflight_io(sbi, type))
 		return false;
 
 	if (sbi->gc_mode == GC_URGENT_LOW &&
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 19224e7d2ad0..173161f1ced0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -536,31 +536,38 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi, bool from_bg)
 	else
 		f2fs_build_free_nids(sbi, false, false);
 
-	if (!is_idle(sbi, REQ_TIME) &&
-		(!excess_dirty_nats(sbi) && !excess_dirty_nodes(sbi)))
+	if (excess_dirty_nats(sbi) || excess_dirty_nodes(sbi) ||
+		excess_prefree_segs(sbi))
+		goto do_sync;
+
+	/* there is background inflight IO or foreground operation recently */
+	if (is_inflight_io(sbi, REQ_TIME) ||
+		(!f2fs_time_over(sbi, REQ_TIME) && rwsem_is_locked(&sbi->cp_rwsem)))
 		return;
 
+	/* exceed periodical checkpoint timeout threshold */
+	if (f2fs_time_over(sbi, CP_TIME))
+		goto do_sync;
+
 	/* checkpoint is the only way to shrink partial cached entries */
-	if (!f2fs_available_free_memory(sbi, NAT_ENTRIES) ||
-			!f2fs_available_free_memory(sbi, INO_ENTRIES) ||
-			excess_prefree_segs(sbi) ||
-			excess_dirty_nats(sbi) ||
-			excess_dirty_nodes(sbi) ||
-			f2fs_time_over(sbi, CP_TIME)) {
-		if (test_opt(sbi, DATA_FLUSH) && from_bg) {
-			struct blk_plug plug;
-
-			mutex_lock(&sbi->flush_lock);
-
-			blk_start_plug(&plug);
-			f2fs_sync_dirty_inodes(sbi, FILE_INODE);
-			blk_finish_plug(&plug);
+	if (f2fs_available_free_memory(sbi, NAT_ENTRIES) ||
+		f2fs_available_free_memory(sbi, INO_ENTRIES))
+		return;
 
-			mutex_unlock(&sbi->flush_lock);
-		}
-		f2fs_sync_fs(sbi->sb, true);
-		stat_inc_bg_cp_count(sbi->stat_info);
+do_sync:
+	if (test_opt(sbi, DATA_FLUSH) && from_bg) {
+		struct blk_plug plug;
+
+		mutex_lock(&sbi->flush_lock);
+
+		blk_start_plug(&plug);
+		f2fs_sync_dirty_inodes(sbi, FILE_INODE);
+		blk_finish_plug(&plug);
+
+		mutex_unlock(&sbi->flush_lock);
 	}
+	f2fs_sync_fs(sbi->sb, true);
+	stat_inc_bg_cp_count(sbi->stat_info);
 }
 
 static int __submit_flush_wait(struct f2fs_sb_info *sbi,
-- 
2.35.1



