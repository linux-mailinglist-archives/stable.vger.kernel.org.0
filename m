Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D95F66C991
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbjAPQvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbjAPQvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:51:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1D94996C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:36:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3505B8107D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06348C433F1;
        Mon, 16 Jan 2023 16:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887016;
        bh=v8GU30uc5aO/9TH6gYD8oImHwGa2PrG6xi5Z028w67k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMt78Iy34sPnDhNyP0yQriaiSfGCCg+HwaIkHPu2gfXrq+sZi2d1CKTHUbOn3DZTT
         IRsqhzv7XOaf/HYktLVab9/X06mXMy+fu7CVo6GNwPwJZwDCcB0KiA8V/kVNea+KqS
         A2kE3u3c47eeMymcw78zWb8DW4db6v462WPpHfYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 618/658] ext4, jbd2: Provide accessor function for handle credits
Date:   Mon, 16 Jan 2023 16:51:46 +0100
Message-Id: <20230116154937.773758900@linuxfoundation.org>
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

[ Upstream commit a9a8344ee1714f835ba394077e8c13d751e2f148 ]

Provide accessor function to get number of credits available in a handle
and use it from ext4. Later, computation of available credits won't be
so straightforward.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-11-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d87a7b4c77a9 ("jbd2: use the correct print format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4_jbd2.c  | 13 +++++++------
 fs/ext4/ext4_jbd2.h  |  7 -------
 fs/ext4/xattr.c      |  2 +-
 include/linux/jbd2.h |  6 ++++++
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 2b98d893cda9..731bbfdbce5b 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -119,8 +119,8 @@ handle_t *__ext4_journal_start_reserved(handle_t *handle, unsigned int line,
 		return ext4_get_nojournal();
 
 	sb = handle->h_journal->j_private;
-	trace_ext4_journal_start_reserved(sb, handle->h_buffer_credits,
-					  _RET_IP_);
+	trace_ext4_journal_start_reserved(sb,
+				jbd2_handle_buffer_credits(handle), _RET_IP_);
 	err = ext4_journal_check_start(sb);
 	if (err < 0) {
 		jbd2_journal_free_reserved(handle);
@@ -138,10 +138,10 @@ int __ext4_journal_ensure_credits(handle_t *handle, int check_cred,
 {
 	if (!ext4_handle_valid(handle))
 		return 0;
-	if (handle->h_buffer_credits >= check_cred)
+	if (jbd2_handle_buffer_credits(handle) >= check_cred)
 		return 0;
 	return ext4_journal_extend(handle,
-				   extend_cred - handle->h_buffer_credits);
+			   extend_cred - jbd2_handle_buffer_credits(handle));
 }
 
 static void ext4_journal_abort_handle(const char *caller, unsigned int line,
@@ -289,7 +289,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 				       handle->h_type,
 				       handle->h_line_no,
 				       handle->h_requested_credits,
-				       handle->h_buffer_credits, err);
+				       jbd2_handle_buffer_credits(handle), err);
 				return err;
 			}
 			ext4_error_inode(inode, where, line,
@@ -300,7 +300,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 					 handle->h_type,
 					 handle->h_line_no,
 					 handle->h_requested_credits,
-					 handle->h_buffer_credits, err);
+					 jbd2_handle_buffer_credits(handle),
+					 err);
 		}
 	} else {
 		if (inode)
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 481bf770a374..a4b980eae4da 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -288,13 +288,6 @@ static inline int ext4_handle_is_aborted(handle_t *handle)
 	return 0;
 }
 
-static inline int ext4_handle_has_enough_credits(handle_t *handle, int needed)
-{
-	if (ext4_handle_valid(handle) && handle->h_buffer_credits < needed)
-		return 0;
-	return 1;
-}
-
 #define ext4_journal_start_sb(sb, type, nblocks)			\
 	__ext4_journal_start_sb((sb), __LINE__, (type), (nblocks), 0)
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index cf1af6a4a567..40f76cf6d031 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2330,7 +2330,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 						   flags & XATTR_CREATE);
 		brelse(bh);
 
-		if (!ext4_handle_has_enough_credits(handle, credits)) {
+		if (jbd2_handle_buffer_credits(handle) < credits) {
 			error = -ENOSPC;
 			goto cleanup;
 		}
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index b0e97e5de8ca..a0768a4b3e84 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1644,6 +1644,12 @@ static inline tid_t  jbd2_get_latest_transaction(journal_t *journal)
 	return tid;
 }
 
+
+static inline int jbd2_handle_buffer_credits(handle_t *handle)
+{
+	return handle->h_buffer_credits;
+}
+
 #ifdef __KERNEL__
 
 #define buffer_trace_init(bh)	do {} while (0)
-- 
2.35.1



