Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D00938D17B
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 00:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhEUWaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 18:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhEUWaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 18:30:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92AAC61176;
        Fri, 21 May 2021 22:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621636116;
        bh=VUdBfGxFYo+S3qttMHWfMxhCSVNMRVH7saVfarsg1vA=;
        h=From:To:Cc:Subject:Date:From;
        b=Mh9rSZb5f8D1Jci4xNsWkaX6Hw39gWjMkfDVHqFpPGJDviKH/4lsqtsUhA6MJrxMD
         8DKa+YuZk7s5KRKlE/6XP1X3bFGoxCBfkul1vJRWAdoTpUCYv/HWGz3/qVn10cELI4
         /Xbu6SIF9CTg1PzRBG666+enKfPd/m+OOqdicemjgLKY5VQEe96kiXxPpamc5bb0+t
         lV0s8AvZDBFkz+2xE+JtB/VkTsa2J5gw/K1I5IKXAL23sn5tgCpQQfrTgd23BLf1X3
         HcCfJZQBzt9C00mR3i+YZ2XPYsRSIgG8zwNS1898WY5FRsrZLZdpd7e5NGvioq4V/N
         DOZNgqCB3E1Qw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, Yunlei He <heyunlei@hihonor.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5.4] ext4: fix error handling in ext4_end_enable_verity()
Date:   Fri, 21 May 2021 15:27:25 -0700
Message-Id: <20210521222725.812825-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit f053cf7aa66cd9d592b0fc967f4d887c2abff1b7 upstream.
[Please apply to 5.4-stable.]

ext4 didn't properly clean up if verity failed to be enabled on a file:

- It left verity metadata (pages past EOF) in the page cache, which
  would be exposed to userspace if the file was later extended.

- It didn't truncate the verity metadata at all (either from cache or
  from disk) if an error occurred while setting the verity bit.

Fix these bugs by adding a call to truncate_inode_pages() and ensuring
that we truncate the verity metadata (both from cache and from disk) in
all error paths.  Also rework the code to cleanly separate the success
path from the error paths, which makes it much easier to understand.

Reported-by: Yunlei He <heyunlei@hihonor.com>
Fixes: c93d8f885809 ("ext4: add basic fs-verity support")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20210302200420.137977-2-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/verity.c | 89 ++++++++++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index d0d8a9795dd6..6a30e54c1128 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -198,55 +198,76 @@ static int ext4_end_enable_verity(struct file *filp, const void *desc,
 	struct inode *inode = file_inode(filp);
 	const int credits = 2; /* superblock and inode for ext4_orphan_del() */
 	handle_t *handle;
+	struct ext4_iloc iloc;
 	int err = 0;
-	int err2;
 
-	if (desc != NULL) {
-		/* Succeeded; write the verity descriptor. */
-		err = ext4_write_verity_descriptor(inode, desc, desc_size,
-						   merkle_tree_size);
-
-		/* Write all pages before clearing VERITY_IN_PROGRESS. */
-		if (!err)
-			err = filemap_write_and_wait(inode->i_mapping);
-	}
+	/*
+	 * If an error already occurred (which fs/verity/ signals by passing
+	 * desc == NULL), then only clean-up is needed.
+	 */
+	if (desc == NULL)
+		goto cleanup;
 
-	/* If we failed, truncate anything we wrote past i_size. */
-	if (desc == NULL || err)
-		ext4_truncate(inode);
+	/* Append the verity descriptor. */
+	err = ext4_write_verity_descriptor(inode, desc, desc_size,
+					   merkle_tree_size);
+	if (err)
+		goto cleanup;
 
 	/*
-	 * We must always clean up by clearing EXT4_STATE_VERITY_IN_PROGRESS and
-	 * deleting the inode from the orphan list, even if something failed.
-	 * If everything succeeded, we'll also set the verity bit in the same
-	 * transaction.
+	 * Write all pages (both data and verity metadata).  Note that this must
+	 * happen before clearing EXT4_STATE_VERITY_IN_PROGRESS; otherwise pages
+	 * beyond i_size won't be written properly.  For crash consistency, this
+	 * also must happen before the verity inode flag gets persisted.
 	 */
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err)
+		goto cleanup;
 
-	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
+	/*
+	 * Finally, set the verity inode flag and remove the inode from the
+	 * orphan list (in a single transaction).
+	 */
 
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, credits);
 	if (IS_ERR(handle)) {
-		ext4_orphan_del(NULL, inode);
-		return PTR_ERR(handle);
+		err = PTR_ERR(handle);
+		goto cleanup;
 	}
 
-	err2 = ext4_orphan_del(handle, inode);
-	if (err2)
-		goto out_stop;
+	err = ext4_orphan_del(handle, inode);
+	if (err)
+		goto stop_and_cleanup;
 
-	if (desc != NULL && !err) {
-		struct ext4_iloc iloc;
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err)
+		goto stop_and_cleanup;
 
-		err = ext4_reserve_inode_write(handle, inode, &iloc);
-		if (err)
-			goto out_stop;
-		ext4_set_inode_flag(inode, EXT4_INODE_VERITY);
-		ext4_set_inode_flags(inode);
-		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
-	}
-out_stop:
+	ext4_set_inode_flag(inode, EXT4_INODE_VERITY);
+	ext4_set_inode_flags(inode);
+	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+	if (err)
+		goto stop_and_cleanup;
+
+	ext4_journal_stop(handle);
+
+	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
+	return 0;
+
+stop_and_cleanup:
 	ext4_journal_stop(handle);
-	return err ?: err2;
+cleanup:
+	/*
+	 * Verity failed to be enabled, so clean up by truncating any verity
+	 * metadata that was written beyond i_size (both from cache and from
+	 * disk), removing the inode from the orphan list (if it wasn't done
+	 * already), and clearing EXT4_STATE_VERITY_IN_PROGRESS.
+	 */
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	ext4_truncate(inode);
+	ext4_orphan_del(NULL, inode);
+	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
+	return err;
 }
 
 static int ext4_get_verity_descriptor_location(struct inode *inode,
-- 
2.31.1.818.g46aad6cb9e-goog

