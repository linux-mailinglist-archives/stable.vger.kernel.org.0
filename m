Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2BD4521DD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376804AbhKPBHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245367AbhKOTUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 963C963464;
        Mon, 15 Nov 2021 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001195;
        bh=I3QvyV9lx6dCM4VucziVBQB8uN6qW5FH4aZq2qcDa38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdOtAo364msPn8PN+TBF8DhsRLgpo/fCQiZVDnRetvqxtEXW4tVd1ANpf0fzZtH6j
         n/H/SGSAS9nbDDKvNZJFmG6yFe7XoMGr/bZP8TygMG3jnSzuui/2cFjVQF0CBDVacf
         IBtH7PmND5wnmRSSqRUEWqSfm+eB28jT4+Fxu0rE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        yangerkun <yangerkun@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 054/917] ext4: ensure enough credits in ext4_ext_shift_path_extents
Date:   Mon, 15 Nov 2021 17:52:29 +0100
Message-Id: <20211115165430.599035773@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit 4268496e48dc681cfa53b92357314b5d7221e625 upstream.

Like ext4_ext_rm_leaf, we can ensure that there are enough credits
before every call that will consume credits.  As part of this fix we
fold the functionality of ext4_access_path() into
ext4_ext_shift_path_extents().  This change is needed as a preparation
for the next bugfix patch.

Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20210903062748.4118886-3-yangerkun@huawei.com
Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   49 +++++++++++++++----------------------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4978,36 +4978,6 @@ int ext4_get_es_cache(struct inode *inod
 }
 
 /*
- * ext4_access_path:
- * Function to access the path buffer for marking it dirty.
- * It also checks if there are sufficient credits left in the journal handle
- * to update path.
- */
-static int
-ext4_access_path(handle_t *handle, struct inode *inode,
-		struct ext4_ext_path *path)
-{
-	int credits, err;
-
-	if (!ext4_handle_valid(handle))
-		return 0;
-
-	/*
-	 * Check if need to extend journal credits
-	 * 3 for leaf, sb, and inode plus 2 (bmap and group
-	 * descriptor) for each block group; assume two block
-	 * groups
-	 */
-	credits = ext4_writepage_trans_blocks(inode);
-	err = ext4_datasem_ensure_credits(handle, inode, 7, credits, 0);
-	if (err < 0)
-		return err;
-
-	err = ext4_ext_get_access(handle, inode, path);
-	return err;
-}
-
-/*
  * ext4_ext_shift_path_extents:
  * Shift the extents of a path structure lying between path[depth].p_ext
  * and EXT_LAST_EXTENT(path[depth].p_hdr), by @shift blocks. @SHIFT tells
@@ -5021,6 +4991,7 @@ ext4_ext_shift_path_extents(struct ext4_
 	int depth, err = 0;
 	struct ext4_extent *ex_start, *ex_last;
 	bool update = false;
+	int credits, restart_credits;
 	depth = path->p_depth;
 
 	while (depth >= 0) {
@@ -5030,13 +5001,23 @@ ext4_ext_shift_path_extents(struct ext4_
 				return -EFSCORRUPTED;
 
 			ex_last = EXT_LAST_EXTENT(path[depth].p_hdr);
+			/* leaf + sb + inode */
+			credits = 3;
+			if (ex_start == EXT_FIRST_EXTENT(path[depth].p_hdr)) {
+				update = true;
+				/* extent tree + sb + inode */
+				credits = depth + 2;
+			}
 
-			err = ext4_access_path(handle, inode, path + depth);
+			restart_credits = ext4_writepage_trans_blocks(inode);
+			err = ext4_datasem_ensure_credits(handle, inode, credits,
+					restart_credits, 0);
 			if (err)
 				goto out;
 
-			if (ex_start == EXT_FIRST_EXTENT(path[depth].p_hdr))
-				update = true;
+			err = ext4_ext_get_access(handle, inode, path + depth);
+			if (err)
+				goto out;
 
 			while (ex_start <= ex_last) {
 				if (SHIFT == SHIFT_LEFT) {
@@ -5067,7 +5048,7 @@ ext4_ext_shift_path_extents(struct ext4_
 		}
 
 		/* Update index too */
-		err = ext4_access_path(handle, inode, path + depth);
+		err = ext4_ext_get_access(handle, inode, path + depth);
 		if (err)
 			goto out;
 


