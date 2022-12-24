Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0AC655794
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbiLXBhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236740AbiLXBgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:36:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E384F65B;
        Fri, 23 Dec 2022 17:32:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54520CE1D03;
        Sat, 24 Dec 2022 01:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D655DC433D2;
        Sat, 24 Dec 2022 01:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845518;
        bh=X63QsewiekVx40rbOX3rnufezCCQ8pXtsFZFuVnMrwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldhe42HIkry2YSb4KrGpUm+dJKiNkYRuYb6BWIEJwizBpHG7yMoe0FQIkT12hWvK9
         778GAnwQjnjrjBAnIoU8GWfXNnAw+2SpdZdTpmud9YBHmA1nJf0N2A0SdnEkdt7vX8
         TluqbEf2lu53nbtt0GUVoBJhZtcx+brPlr8ie5uJII1pxUYjf/tzkh8MYt/xESkln3
         fhyPLw6yygRQaiJ6Pe49P3iozcYqSAUx8JIzj795qQ9+fFw6XR5qDyHxYnQ8ZhKw2+
         ht+pgikB5Hd26UhMkas/KZtX+gFEUkYDK7xAXzDgzRjCSJT2SkR+7tIrLM0lctPlqj
         7ShorSsj2SrSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/14] writeback: Add asserts for adding freed inode to lists
Date:   Fri, 23 Dec 2022 20:31:25 -0500
Message-Id: <20221224013127.393187-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013127.393187-1-sashal@kernel.org>
References: <20221224013127.393187-1-sashal@kernel.org>
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
index f4a5a0c2858a..0f747eb7706a 100644
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
@@ -1164,6 +1166,7 @@ static void inode_cgwb_move_to_attached(struct inode *inode,
 {
 	assert_spin_locked(&wb->list_lock);
 	assert_spin_locked(&inode->i_lock);
+	WARN_ON_ONCE(inode->i_state & I_FREEING);
 
 	inode->i_state &= ~I_SYNC_QUEUED;
 	list_del_init(&inode->i_io_list);
@@ -1329,6 +1332,17 @@ static void redirty_tail_locked(struct inode *inode, struct bdi_writeback *wb)
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
 
@@ -1337,7 +1351,6 @@ static void redirty_tail_locked(struct inode *inode, struct bdi_writeback *wb)
 			inode->dirtied_when = jiffies;
 	}
 	inode_io_list_move_locked(inode, wb, &wb->b_dirty);
-	inode->i_state &= ~I_SYNC_QUEUED;
 }
 
 static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
-- 
2.35.1

