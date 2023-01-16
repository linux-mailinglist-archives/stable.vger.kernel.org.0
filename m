Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C827166C959
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjAPQtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbjAPQsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:48:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432DB43440
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:35:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C27116104D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B98C433D2;
        Mon, 16 Jan 2023 16:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886937;
        bh=YhsH/oUVPApq0j5zJ+WHPcTDTTkOrfW1IZrGcBgKWjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odNQUlCLD6EY9yN9yRab0Gm/FEeMXBja9CbKDCYjdK4ZbkOf1IenT8PqEXW45gOPD
         1s0XjZ0hOwV8/PsZIn2PD9NvSUFrSTfy58bZwcdbyHSLbATWGAvArMmt+D0FuQ8lYc
         2oJY5CHiU1y1WJl/lX3UbjWgWAox6o2/dMtYVrBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 619/658] ocfs2: Use accessor function for h_buffer_credits
Date:   Mon, 16 Jan 2023 16:51:47 +0100
Message-Id: <20230116154937.823775808@linuxfoundation.org>
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

[ Upstream commit 9797a902480521dc8e7a478e38f0c896ffff8784 ]

Use the jbd2 accessor function for h_buffer_credits.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-12-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d87a7b4c77a9 ("jbd2: use the correct print format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/alloc.c   | 32 ++++++++++++++++----------------
 fs/ocfs2/journal.c |  4 ++--
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4db87b26cf7b..9bc3e926b717 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2288,9 +2288,9 @@ static int ocfs2_extend_rotate_transaction(handle_t *handle, int subtree_depth,
 	int ret = 0;
 	int credits = (path->p_tree_depth - subtree_depth) * 2 + 1 + op_credits;
 
-	if (handle->h_buffer_credits < credits)
+	if (jbd2_handle_buffer_credits(handle) < credits)
 		ret = ocfs2_extend_trans(handle,
-					 credits - handle->h_buffer_credits);
+				credits - jbd2_handle_buffer_credits(handle));
 
 	return ret;
 }
@@ -2367,7 +2367,7 @@ static int ocfs2_rotate_tree_right(handle_t *handle,
 				   struct ocfs2_path *right_path,
 				   struct ocfs2_path **ret_left_path)
 {
-	int ret, start, orig_credits = handle->h_buffer_credits;
+	int ret, start, orig_credits = jbd2_handle_buffer_credits(handle);
 	u32 cpos;
 	struct ocfs2_path *left_path = NULL;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
@@ -3148,7 +3148,7 @@ static int ocfs2_rotate_tree_left(handle_t *handle,
 				  struct ocfs2_path *path,
 				  struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
-	int ret, orig_credits = handle->h_buffer_credits;
+	int ret, orig_credits = jbd2_handle_buffer_credits(handle);
 	struct ocfs2_path *tmp_path = NULL, *restart_path = NULL;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
@@ -3386,8 +3386,8 @@ static int ocfs2_merge_rec_right(struct ocfs2_path *left_path,
 							right_path);
 
 		ret = ocfs2_extend_rotate_transaction(handle, subtree_index,
-						      handle->h_buffer_credits,
-						      right_path);
+					jbd2_handle_buffer_credits(handle),
+					right_path);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3548,8 +3548,8 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 							right_path);
 
 		ret = ocfs2_extend_rotate_transaction(handle, subtree_index,
-						      handle->h_buffer_credits,
-						      left_path);
+					jbd2_handle_buffer_credits(handle),
+					left_path);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3623,7 +3623,7 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 		    le16_to_cpu(el->l_next_free_rec) == 1) {
 			/* extend credit for ocfs2_remove_rightmost_path */
 			ret = ocfs2_extend_rotate_transaction(handle, 0,
-					handle->h_buffer_credits,
+					jbd2_handle_buffer_credits(handle),
 					right_path);
 			if (ret) {
 				mlog_errno(ret);
@@ -3669,7 +3669,7 @@ static int ocfs2_try_to_merge_extent(handle_t *handle,
 	if (ctxt->c_split_covers_rec && ctxt->c_has_empty_extent) {
 		/* extend credit for ocfs2_remove_rightmost_path */
 		ret = ocfs2_extend_rotate_transaction(handle, 0,
-				handle->h_buffer_credits,
+				jbd2_handle_buffer_credits(handle),
 				path);
 		if (ret) {
 			mlog_errno(ret);
@@ -3725,7 +3725,7 @@ static int ocfs2_try_to_merge_extent(handle_t *handle,
 
 		/* extend credit for ocfs2_remove_rightmost_path */
 		ret = ocfs2_extend_rotate_transaction(handle, 0,
-					handle->h_buffer_credits,
+					jbd2_handle_buffer_credits(handle),
 					path);
 		if (ret) {
 			mlog_errno(ret);
@@ -3755,7 +3755,7 @@ static int ocfs2_try_to_merge_extent(handle_t *handle,
 
 		/* extend credit for ocfs2_remove_rightmost_path */
 		ret = ocfs2_extend_rotate_transaction(handle, 0,
-				handle->h_buffer_credits,
+				jbd2_handle_buffer_credits(handle),
 				path);
 		if (ret) {
 			mlog_errno(ret);
@@ -3799,7 +3799,7 @@ static int ocfs2_try_to_merge_extent(handle_t *handle,
 		if (ctxt->c_split_covers_rec) {
 			/* extend credit for ocfs2_remove_rightmost_path */
 			ret = ocfs2_extend_rotate_transaction(handle, 0,
-					handle->h_buffer_credits,
+					jbd2_handle_buffer_credits(handle),
 					path);
 			if (ret) {
 				mlog_errno(ret);
@@ -5358,7 +5358,7 @@ static int ocfs2_truncate_rec(handle_t *handle,
 	if (ocfs2_is_empty_extent(&el->l_recs[0]) && index > 0) {
 		/* extend credit for ocfs2_remove_rightmost_path */
 		ret = ocfs2_extend_rotate_transaction(handle, 0,
-				handle->h_buffer_credits,
+				jbd2_handle_buffer_credits(handle),
 				path);
 		if (ret) {
 			mlog_errno(ret);
@@ -5427,8 +5427,8 @@ static int ocfs2_truncate_rec(handle_t *handle,
 	}
 
 	ret = ocfs2_extend_rotate_transaction(handle, 0,
-					      handle->h_buffer_credits,
-					      path);
+					jbd2_handle_buffer_credits(handle),
+					path);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index da95ed79c12e..595745602f1e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -420,7 +420,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 	if (!nblocks)
 		return 0;
 
-	old_nblocks = handle->h_buffer_credits;
+	old_nblocks = jbd2_handle_buffer_credits(handle);
 
 	trace_ocfs2_extend_trans(old_nblocks, nblocks);
 
@@ -461,7 +461,7 @@ int ocfs2_allocate_extend_trans(handle_t *handle, int thresh)
 
 	BUG_ON(!handle);
 
-	old_nblks = handle->h_buffer_credits;
+	old_nblks = jbd2_handle_buffer_credits(handle);
 	trace_ocfs2_allocate_extend_trans(old_nblks, thresh);
 
 	if (old_nblks < thresh)
-- 
2.35.1



