Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1BA66769E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbjALOdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237975AbjALOdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:33:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C08C5F48F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:24:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C92F4CE1E6B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71CDC433D2;
        Thu, 12 Jan 2023 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533484;
        bh=cllDKQ7SeJX1qSJmFd9zSEvXiVqJnvYju0OJrJ6sdYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUuNdOQFrBvS/kECKGSIaLWorSUjcEsDiUhfKIQBZi368/NPIUfomgI5OBuzNN9N1
         ZAugmNFrJba19zLTkI8ZxVlwvgTH4CXtc72KfxmNGH4e5dVFhESfzYGD+/k/DZ+2jd
         AKN59ixepcfQho5NGvHgc6YKcmPrLlmTREsptFyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 493/783] nilfs2: fix shift-out-of-bounds due to too large exponent of block size
Date:   Thu, 12 Jan 2023 14:53:29 +0100
Message-Id: <20230112135547.047996002@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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



