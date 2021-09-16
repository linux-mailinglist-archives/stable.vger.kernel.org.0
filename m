Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826A340EBBE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 22:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbhIPUhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 16:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231982AbhIPUhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 16:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 394F160FBF;
        Thu, 16 Sep 2021 20:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631824551;
        bh=PgkVBzwC/ElfXlh5G/WjU2Sucs8A8+5pZ7/S6pKmdvc=;
        h=From:To:Cc:Subject:Date:From;
        b=S05PLZ3Ug1VUZPyP8Tqz0L3jYQOb4tg2H+n7QsqWn3LhYq5w2WtN3XMVO0MayhNtl
         h561fJniEhuHaJOvm0mR3W93Bq6xmn7N1ANrACBs97eK0f5cAsAtHnlwxg8F+iUDiL
         qRMY1+8SQfAX//IqmtP6iAvKRj5EbcTxtX6qRinhEuhIwCe1ltMK2AHIb0qPMOO49U
         rtUZDC31+DPye3+ss45HosYFv28uaV27YEjGPHR+zWuD+MnClIr/E7uwUiw5r5sBWk
         lb9KZXWKk/TmexuiXwNNMNdxH2oaGz7oCwzgZkCXOE3B05BGJsCtT7UI/yMrpU4muG
         qbgc6IOtAhGmw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Boris Burkov <boris@bur.io>
Subject: [PATCH] fs-verity: fix signed integer overflow with i_size near S64_MAX
Date:   Thu, 16 Sep 2021 13:34:24 -0700
Message-Id: <20210916203424.113376-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If the file size is almost S64_MAX, the calculated number of Merkle tree
levels exceeds FS_VERITY_MAX_LEVELS, causing FS_IOC_ENABLE_VERITY to
fail.  This is unintentional, since as the comment above the definition
of FS_VERITY_MAX_LEVELS states, it is enough for over U64_MAX bytes of
data using SHA-256 and 4K blocks.  (Specifically, 4096*128**8 >= 2**64.)

The bug is actually that when the number of blocks in the first level is
calculated from i_size, there is a signed integer overflow due to i_size
being signed.  Fix this by treating i_size is unsigned.

This was found by the new test "generic: test fs-verity EFBIG scenarios"
(https://lkml.kernel.org/r/b1d116cd4d0ea74b9cd86f349c672021e005a75c.1631558495.git.boris@bur.io).

This didn't affect ext4 or f2fs since those have a smaller maximum file
size, but it did affect btrfs which allows files up to S64_MAX bytes.

Reported-by: Boris Burkov <boris@bur.io>
Fixes: 3fda4c617e84 ("fs-verity: implement FS_IOC_ENABLE_VERITY ioctl")
Fixes: fd2d1acfcadf ("fs-verity: add the hook for file ->open()")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/enable.c | 2 +-
 fs/verity/open.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 77e159a0346b1..60a4372aa4d75 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -177,7 +177,7 @@ static int build_merkle_tree(struct file *filp,
 	 * (level 0) and ascending to the root node (level 'num_levels - 1').
 	 * Then at the end (level 'num_levels'), calculate the root hash.
 	 */
-	blocks = (inode->i_size + params->block_size - 1) >>
+	blocks = ((u64)inode->i_size + params->block_size - 1) >>
 		 params->log_blocksize;
 	for (level = 0; level <= params->num_levels; level++) {
 		err = build_merkle_tree_level(filp, level, blocks, params,
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 60ff8af7219fe..92df87f5fa388 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -89,7 +89,7 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 	 */
 
 	/* Compute number of levels and the number of blocks in each level */
-	blocks = (inode->i_size + params->block_size - 1) >> log_blocksize;
+	blocks = ((u64)inode->i_size + params->block_size - 1) >> log_blocksize;
 	pr_debug("Data is %lld bytes (%llu blocks)\n", inode->i_size, blocks);
 	while (blocks > 1) {
 		if (params->num_levels >= FS_VERITY_MAX_LEVELS) {
-- 
2.33.0

