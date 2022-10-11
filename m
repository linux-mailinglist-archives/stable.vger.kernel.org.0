Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2193A5FB571
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJKOyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiJKOxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FB49AFCA;
        Tue, 11 Oct 2022 07:51:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36852611C6;
        Tue, 11 Oct 2022 14:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99B9C433C1;
        Tue, 11 Oct 2022 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499876;
        bh=m5XLNmell0PrmFO8ifP66AP9KRaK8RMcLJHNEUlfM0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9v+QSpCGQBdxjwMnPQ0DdivuRJtHhVBm72NwUn3JNEg6CQaAZERrP09HXSPdpoG/
         JXiqr8lARkSLnVsfjrgPneVnI5hW/hIy85tDjOJCUrxD+ZhZST/HrX36l8NmPKQbta
         C4EAAgjH90Y+Bt2n9x+AaB3I28a8vfuWbS+uNFAxHRq2ZW/3nOTUG9lybCQd+1HOYz
         jR2Qo7FG3ZMrwNqMcNDbU3ZQULM0CJDghEggo+y5NdbyQyu/y4HQXDZYh8ArjdAbyb
         qBPpyKCDkpd4v6PCuQAu/1QUsDdqWObPnWD3TL+wi25SPYTSCDVoI6xQ17AX0AvldW
         C+fsEw80Z44hA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 39/46] btrfs: add KCSAN annotations for unlocked access to block_rsv->full
Date:   Tue, 11 Oct 2022 10:50:07 -0400
Message-Id: <20221011145015.1622882-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 748f553c3c4c4f175c6c834358632aff802d72cf ]

KCSAN reports that there's unlocked access mixed with locked access,
which is technically correct but is not a bug.  To avoid false alerts at
least from KCSAN, add annotation and use a wrapper whenever ->full is
accessed for read outside of lock.

It is used as a fast check and only advisory.  In the worst case the
block reserve is found !full and becomes full in the meantime, but
properly handled.

Depending on the value of ->full, btrfs_block_rsv_release decides
where to return the reservation, and block_rsv_release_bytes handles a
NULL pointer for block_rsv and if it's not NULL then it double checks
the full status under a lock.

Link: https://lore.kernel.org/linux-btrfs/CAAwBoOJDjei5Hnem155N_cJwiEkVwJYvgN-tQrwWbZQGhFU=cA@mail.gmail.com/
Link: https://lore.kernel.org/linux-btrfs/YvHU/vsXd7uz5V6j@hungrycats.org
Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-rsv.c   | 2 +-
 fs/btrfs/block-rsv.h   | 9 +++++++++
 fs/btrfs/transaction.c | 4 ++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 06be0644dd37..046caf14a4bb 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -286,7 +286,7 @@ u64 btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
 	 */
 	if (block_rsv == delayed_rsv)
 		target = global_rsv;
-	else if (block_rsv != global_rsv && !delayed_rsv->full)
+	else if (block_rsv != global_rsv && !btrfs_block_rsv_full(delayed_rsv))
 		target = delayed_rsv;
 
 	if (target && block_rsv->space_info != target->space_info)
diff --git a/fs/btrfs/block-rsv.h b/fs/btrfs/block-rsv.h
index 0c183709be00..578c3497a455 100644
--- a/fs/btrfs/block-rsv.h
+++ b/fs/btrfs/block-rsv.h
@@ -92,4 +92,13 @@ static inline void btrfs_unuse_block_rsv(struct btrfs_fs_info *fs_info,
 	btrfs_block_rsv_release(fs_info, block_rsv, 0, NULL);
 }
 
+/*
+ * Fast path to check if the reserve is full, may be carefully used outside of
+ * locks.
+ */
+static inline bool btrfs_block_rsv_full(const struct btrfs_block_rsv *rsv)
+{
+	return data_race(rsv->full);
+}
+
 #endif /* BTRFS_BLOCK_RSV_H */
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4c87bf2abc14..49570ad23f2e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -594,7 +594,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 		 */
 		num_bytes = btrfs_calc_insert_metadata_size(fs_info, num_items);
 		if (flush == BTRFS_RESERVE_FLUSH_ALL &&
-		    delayed_refs_rsv->full == 0) {
+		    btrfs_block_rsv_full(delayed_refs_rsv) == 0) {
 			delayed_refs_bytes = num_bytes;
 			num_bytes <<= 1;
 		}
@@ -619,7 +619,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 		if (rsv->space_info->force_alloc)
 			do_chunk_alloc = true;
 	} else if (num_items == 0 && flush == BTRFS_RESERVE_FLUSH_ALL &&
-		   !delayed_refs_rsv->full) {
+		   !btrfs_block_rsv_full(delayed_refs_rsv)) {
 		/*
 		 * Some people call with btrfs_start_transaction(root, 0)
 		 * because they can be throttled, but have some other mechanism
-- 
2.35.1

