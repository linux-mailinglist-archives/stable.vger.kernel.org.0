Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B2564FA9B
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiLQPg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiLQPfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:35:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702A91E3E7;
        Sat, 17 Dec 2022 07:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30D50B802C7;
        Sat, 17 Dec 2022 15:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34124C433EF;
        Sat, 17 Dec 2022 15:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290980;
        bh=cllDKQ7SeJX1qSJmFd9zSEvXiVqJnvYju0OJrJ6sdYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gw3e8Td4TWdDWmi6v9oZRgsgF7cj+eCej4r6skagFdCPxNb5yATCx8Hr35ITJ1hYw
         klqnV4+30z/aswW0/+USLY57iItKe3gPp72S4S7w/4U4l+bABzuIam6q9U0liUil73
         gS3OdLuqWwQgAQIBT3pM3CJO1jB5r3tiAiLSG478xykmyJfV6iEvymMdm400UiZh4E
         GsXvGSoQUiZwBSXRYCbO7TLaa6CZjgIA2oOWM79FhFl1dEwzqgg1qHP6CM4CNihxUi
         LYLA9Bc1vKfvKrXZiPrH+HI2/2qixRxJg4rD8RbOxHjEbUnRXMCM97WkRrvE1NbF59
         wUbHtHFcjkCqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 7/9] nilfs2: fix shift-out-of-bounds due to too large exponent of block size
Date:   Sat, 17 Dec 2022 10:29:24 -0500
Message-Id: <20221217152927.99012-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152927.99012-1-sashal@kernel.org>
References: <20221217152927.99012-1-sashal@kernel.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit ebeccaaef67a4895d2496ab8d9c2fb8d89201211 ]

If field s_log_block_size of superblock data is corrupted and too large,
init_nilfs() and load_nilfs() still can trigger a shift-out-of-bounds
warning followed by a kernel panic (if panic_on_warn is set):

 shift exponent 38973 is too large for 32-bit type 'int'
 Call Trace:
  <TASK>
  dump_stack_lvl+0xcd/0x134
  ubsan_epilogue+0xb/0x50
  __ubsan_handle_shift_out_of_bounds.cold.12+0x17b/0x1f5
  init_nilfs.cold.11+0x18/0x1d [nilfs2]
  nilfs_mount+0x9b5/0x12b0 [nilfs2]
  ...

This fixes the issue by adding and using a new helper function for getting
block size with sanity check.

Link: https://lkml.kernel.org/r/20221027044306.42774-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/the_nilfs.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 6e2ccdd79c89..211937054c31 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -193,6 +193,34 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
 	return ret;
 }
 
+/**
+ * nilfs_get_blocksize - get block size from raw superblock data
+ * @sb: super block instance
+ * @sbp: superblock raw data buffer
+ * @blocksize: place to store block size
+ *
+ * nilfs_get_blocksize() calculates the block size from the block size
+ * exponent information written in @sbp and stores it in @blocksize,
+ * or aborts with an error message if it's too large.
+ *
+ * Return Value: On success, 0 is returned. If the block size is too
+ * large, -EINVAL is returned.
+ */
+static int nilfs_get_blocksize(struct super_block *sb,
+			       struct nilfs_super_block *sbp, int *blocksize)
+{
+	unsigned int shift_bits = le32_to_cpu(sbp->s_log_block_size);
+
+	if (unlikely(shift_bits >
+		     ilog2(NILFS_MAX_BLOCK_SIZE) - BLOCK_SIZE_BITS)) {
+		nilfs_err(sb, "too large filesystem blocksize: 2 ^ %u KiB",
+			  shift_bits);
+		return -EINVAL;
+	}
+	*blocksize = BLOCK_SIZE << shift_bits;
+	return 0;
+}
+
 /**
  * load_nilfs - load and recover the nilfs
  * @nilfs: the_nilfs structure to be released
@@ -246,11 +274,15 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 		nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
 
 		/* verify consistency between two super blocks */
-		blocksize = BLOCK_SIZE << le32_to_cpu(sbp[0]->s_log_block_size);
+		err = nilfs_get_blocksize(sb, sbp[0], &blocksize);
+		if (err)
+			goto scan_error;
+
 		if (blocksize != nilfs->ns_blocksize) {
 			nilfs_warn(sb,
 				   "blocksize differs between two super blocks (%d != %d)",
 				   blocksize, nilfs->ns_blocksize);
+			err = -EINVAL;
 			goto scan_error;
 		}
 
@@ -609,9 +641,11 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	if (err)
 		goto failed_sbh;
 
-	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
-	if (blocksize < NILFS_MIN_BLOCK_SIZE ||
-	    blocksize > NILFS_MAX_BLOCK_SIZE) {
+	err = nilfs_get_blocksize(sb, sbp, &blocksize);
+	if (err)
+		goto failed_sbh;
+
+	if (blocksize < NILFS_MIN_BLOCK_SIZE) {
 		nilfs_err(sb,
 			  "couldn't mount because of unsupported filesystem blocksize %d",
 			  blocksize);
-- 
2.35.1

