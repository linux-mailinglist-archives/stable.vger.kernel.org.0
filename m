Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E902D655764
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiLXBeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236573AbiLXBda (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:33:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4614C3B403;
        Fri, 23 Dec 2022 17:31:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA328B8213E;
        Sat, 24 Dec 2022 01:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80DAC4339B;
        Sat, 24 Dec 2022 01:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845484;
        bh=kXQlVjf3vnLUSScOv77+QVgJYKKNnEWwb3U7X6e5OM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Beo1o5ZkzBj4wiPzXh2FzWqUA6hccAIZ0ZLaJMGVHwyXYZS/rSDkKwUcqWCHbHoM8
         IkUfEsXIuhAne/KalC2/60bpzZVRexoWUo84bmKXPelEExjHqxQsjHWFCbx5k2RuB0
         9fCTcf/Qt/qVY1r8+iOeK+hJ2F08PPwIdEg+ZVDtzneKRKHkP4meYZwQRefyM0txTy
         /bstG92Ol2DCFHxtVBdrMUqFg36w66IQpqTnSIlTm502w2K0lPcUMum0NLIqEAQvJV
         rtXtCSLVpXDWX8rCutX2G6szcDukoRuq/otaHNdb3Gv/9mK9WrE4PRqjCYcTzJ5MEX
         iO4BmRAs4hEmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 16/18] writeback: Add asserts for adding freed inode to lists
Date:   Fri, 23 Dec 2022 20:30:32 -0500
Message-Id: <20221224013034.392810-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013034.392810-1-sashal@kernel.org>
References: <20221224013034.392810-1-sashal@kernel.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit a9438b44bc7015b18931e312bbd249a25bb59a65 ]

In the past we had several use-after-free issues with inodes getting
added to writeback lists after evict() removed them. These are painful
to debug so add some asserts to catch the problem earlier. The only
non-obvious change in the commit is that we need to tweak
redirty_tail_locked() to avoid triggering assertion in
inode_io_list_move_locked().

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221212113633.29181-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9958d4020771..7ee235680006 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -121,6 +121,7 @@ static bool inode_io_list_move_locked(struct inode *inode,
 {
 	assert_spin_locked(&wb->list_lock);
 	assert_spin_locked(&inode->i_lock);
+	WARN_ON_ONCE(inode->i_state & I_FREEING);
 
 	list_move(&inode->i_io_list, head);
 
@@ -280,6 +281,7 @@ static void inode_cgwb_move_to_attached(struct inode *inode,
 {
 	assert_spin_locked(&wb->list_lock);
 	assert_spin_locked(&inode->i_lock);
+	WARN_ON_ONCE(inode->i_state & I_FREEING);
 
 	inode->i_state &= ~I_SYNC_QUEUED;
 	if (wb != &wb->bdi->wb)
@@ -1129,6 +1131,7 @@ static void inode_cgwb_move_to_attached(struct inode *inode,
 {
 	assert_spin_locked(&wb->list_lock);
 	assert_spin_locked(&inode->i_lock);
+	WARN_ON_ONCE(inode->i_state & I_FREEING);
 
 	inode->i_state &= ~I_SYNC_QUEUED;
 	list_del_init(&inode->i_io_list);
@@ -1294,6 +1297,17 @@ static void redirty_tail_locked(struct inode *inode, struct bdi_writeback *wb)
 {
 	assert_spin_locked(&inode->i_lock);
 
+	inode->i_state &= ~I_SYNC_QUEUED;
+	/*
+	 * When the inode is being freed just don't bother with dirty list
+	 * tracking. Flush worker will ignore this inode anyway and it will
+	 * trigger assertions in inode_io_list_move_locked().
+	 */
+	if (inode->i_state & I_FREEING) {
+		list_del_init(&inode->i_io_list);
+		wb_io_lists_depopulated(wb);
+		return;
+	}
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -1302,7 +1316,6 @@ static void redirty_tail_locked(struct inode *inode, struct bdi_writeback *wb)
 			inode->dirtied_when = jiffies;
 	}
 	inode_io_list_move_locked(inode, wb, &wb->b_dirty);
-	inode->i_state &= ~I_SYNC_QUEUED;
 }
 
 static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
-- 
2.35.1

