Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B035632B2B4
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343929AbhCCAx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350532AbhCBUGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 15:06:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CF6164F21;
        Tue,  2 Mar 2021 20:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614715504;
        bh=PsxMo4HzObRVzmAihudWFkfU25b1OePLRuCHAZt3lws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFYkSokSkZIrOsAhufSj4OgDGiZzR1QFqw6ap7Q8lsdWmzsGRrm8FoKp4gA60lJcp
         mPW8rZYuJQlmL7QpSElzGmJ5ikWWo6rNVZvfm0eFqML5xylkOrq4XWgt0/zxFZM2/M
         v1GR4H0YUyQb7pBds78dOcYpSyi9ffAnm2Wjv75UUIpTN74QHFX06e34cvRhC+JJEo
         q8v/BnsoP+QZdjN9ZZiNAxnc1a5LIaaWYyEwtCsGBju9Bnlx/s/5MY6nzMrtpfqqrR
         bV7j415NAb9Jq/xdjU/nSBcAxBT0enq51G2Hv3tb68MnP4TxLAX8IVg86vMwT9Rs5M
         4B/dWwkV/klVw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org, Yunlei He <heyunlei@hihonor.com>,
        bintian.wang@hihonor.com, stable@vger.kernel.org
Subject: [PATCH 1/2] ext4: fix error handling in ext4_end_enable_verity()
Date:   Tue,  2 Mar 2021 12:04:19 -0800
Message-Id: <20210302200420.137977-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302200420.137977-1-ebiggers@kernel.org>
References: <20210302200420.137977-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/verity.c | 90 ++++++++++++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 5b7ba8f711538..acb12441c549b 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -201,55 +201,77 @@ static int ext4_end_enable_verity(struct file *filp, const void *desc,
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
+
+	ext4_set_inode_flag(inode, EXT4_INODE_VERITY);
+	ext4_set_inode_flags(inode, false);
+	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+	if (err)
+		goto stop_and_cleanup;
 
-		err = ext4_reserve_inode_write(handle, inode, &iloc);
-		if (err)
-			goto out_stop;
-		ext4_set_inode_flag(inode, EXT4_INODE_VERITY);
-		ext4_set_inode_flags(inode, false);
-		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
-	}
-out_stop:
 	ext4_journal_stop(handle);
-	return err ?: err2;
+
+	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
+	return 0;
+
+
+stop_and_cleanup:
+	ext4_journal_stop(handle);
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
2.30.1

