Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B169E51FF82
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbiEIO1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbiEIO1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:27:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1AA1E2502;
        Mon,  9 May 2022 07:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 653E7CE18C3;
        Mon,  9 May 2022 14:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD04C385AB;
        Mon,  9 May 2022 14:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652106230;
        bh=g/s1bZ+fS72zAZzof9qz8XzOroT6LB31TLHSeyMqtUw=;
        h=From:To:Cc:Subject:Date:From;
        b=vOxKA5F6za2BLpLY1HRfROc7zlE8qLgcRIK+UNhiKnPkCjEBcrjPKBqoyith6JsTg
         NHF/xEHhY40caMQUBpxCn0tDgV4py1MbwERk5kygVxlBjK2db1J1jmysbbyLtTP2OM
         jhJDNaLUxrtqpVsdbTUtf48t70CFtSk3Zu0ZXiN5O3oFPSR/pv02CmJGZH9FLUd+ch
         LErUvWixS5sGl7syaZ7uiY0fkIKIMF7GeW1qYhPiiXn6eO8RWIoN7PMdLudcxL21UX
         lZKP2L1aBtBLt29Ek2utZH1fKqoKJ1FjiMk+lNIW5RJg3v//LOmwseYfbgkarb2NE/
         2mvjUhOIISOxQ==
From:   fdmanana@kernel.org
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9-stable] btrfs: always log symlinks in full mode
Date:   Mon,  9 May 2022 15:23:45 +0100
Message-Id: <16faeac0ce3cb44fca8a48e96e5c07feffc363c9.1652106037.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit d0e64a981fd841cb0f28fcd6afcac55e6f1e6994 upstream.

On Linux, empty symlinks are invalid, and attempting to create one with
the system call symlink(2) results in an -ENOENT error and this is
explicitly documented in the man page.

If we rename a symlink that was created in the current transaction and its
parent directory was logged before, we actually end up logging the symlink
without logging its content, which is stored in an inline extent. That
means that after a power failure we can end up with an empty symlink,
having no content and an i_size of 0 bytes.

It can be easily reproduced like this:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt

  $ mkdir /mnt/testdir
  $ sync

  # Create a file inside the directory and fsync the directory.
  $ touch /mnt/testdir/foo
  $ xfs_io -c "fsync" /mnt/testdir

  # Create a symlink inside the directory and then rename the symlink.
  $ ln -s /mnt/testdir/foo /mnt/testdir/bar
  $ mv /mnt/testdir/bar /mnt/testdir/baz

  # Now fsync again the directory, this persist the log tree.
  $ xfs_io -c "fsync" /mnt/testdir

  <power failure>

  $ mount /dev/sdc /mnt
  $ stat -c %s /mnt/testdir/baz
  0
  $ readlink /mnt/testdir/baz
  $

Fix this by always logging symlinks in full mode (LOG_INODE_ALL), so that
their content is also logged.

A test case for fstests will follow.

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tree-log.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cc91b0c564a3..312c050d0dbd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4696,6 +4696,18 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		mutex_lock(&BTRFS_I(inode)->log_mutex);
 	}
 
+	/*
+	 * For symlinks, we must always log their content, which is stored in an
+	 * inline extent, otherwise we could end up with an empty symlink after
+	 * log replay, which is invalid on linux (symlink(2) returns -ENOENT if
+	 * one attempts to create an empty symlink).
+	 * We don't need to worry about flushing delalloc, because when we create
+	 * the inline extent when the symlink is created (we never have delalloc
+	 * for symlinks).
+	 */
+	if (S_ISLNK(inode->i_mode))
+		inode_only = LOG_INODE_ALL;
+
 	/*
 	 * a brute force approach to making sure we get the most uptodate
 	 * copies of everything.
@@ -5271,7 +5283,7 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 			}
 
 			ctx->log_new_dentries = false;
-			if (type == BTRFS_FT_DIR || type == BTRFS_FT_SYMLINK)
+			if (type == BTRFS_FT_DIR)
 				log_mode = LOG_INODE_ALL;
 			ret = btrfs_log_inode(trans, root, di_inode,
 					      log_mode, 0, LLONG_MAX, ctx);
-- 
2.34.1

