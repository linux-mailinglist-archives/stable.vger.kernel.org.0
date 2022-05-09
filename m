Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F22B51FF6F
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbiEIO1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237105AbiEIO1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:27:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A4A1DF675;
        Mon,  9 May 2022 07:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFC0C615B3;
        Mon,  9 May 2022 14:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E75C385AE;
        Mon,  9 May 2022 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652106189;
        bh=zexsLfWgz5fPx78t8Ef125Nl2PiXfZ1mBOY4SVmuXF4=;
        h=From:To:Cc:Subject:Date:From;
        b=Tfpfvocmp8JbaO/uzG/LeERyT18Roqz3c8YcNXok8YPT2eh84nhtGr5+CpXFsN+HL
         74xRDDYlXWv515yoyw7UMpiNUGaeOyR95xN7PeNQQAXU+Lmd7YCBhnI0cFeWMo2gwS
         xRkMQ/ZYM6J4GQL4Kdc0HNEGzfS0h7uCoM/tU0VMePePCP4yTXLFXRUlsFTPGlrqcq
         0kHp0CAq3pN7IfRwOi7Wl3CBbuC5nRR1tE8QqFIq7FhXUl7nk90vyqFCtx2q5kvbFh
         dkauMrUS1URTT9CL0P/lAfHpRAlGH/IfwpJlSIK3kE8DNs/57BAuP7K3mWCILUP1ei
         +ov4VdpQxh6Dw==
From:   fdmanana@kernel.org
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4-stable] btrfs: always log symlinks in full mode
Date:   Mon,  9 May 2022 15:23:02 +0100
Message-Id: <a723741f9d3b92276f8e0482c0e4176a1abf11c4.1652104393.git.fdmanana@suse.com>
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
index 9b703c0db979..b7bfecfc2ea3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5294,6 +5294,18 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		mutex_lock(&inode->log_mutex);
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
+	if (S_ISLNK(inode->vfs_inode.i_mode))
+		inode_only = LOG_INODE_ALL;
+
 	/*
 	 * a brute force approach to making sure we get the most uptodate
 	 * copies of everything.
@@ -5707,7 +5719,7 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 			}
 
 			ctx->log_new_dentries = false;
-			if (type == BTRFS_FT_DIR || type == BTRFS_FT_SYMLINK)
+			if (type == BTRFS_FT_DIR)
 				log_mode = LOG_INODE_ALL;
 			ret = btrfs_log_inode(trans, root, BTRFS_I(di_inode),
 					      log_mode, 0, LLONG_MAX, ctx);
-- 
2.34.1

