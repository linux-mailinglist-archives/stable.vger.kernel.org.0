Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31D1657E22
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbiL1Pu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbiL1PuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:50:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D477717E3E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ED8BB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AF3C433EF;
        Wed, 28 Dec 2022 15:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242622;
        bh=uqAdmF1FaDGQ10Ckz+SV5eiJjH+tRdfj9Fty0e54Wpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKQgYBzMe5ajLPUWrpTPY0ZKSc4DK5BNejOo1rWCiPVfE2yjcl9Mv2h8g+BvJmEEW
         PSFh/tCr6ZzmslQlQgR5W0DG8Bp5xKCP076mjtjPQeVLfEtRL+JAdjM2u+BUTDpwLt
         2SHcYv/ldwRmoxZVWXdxTyDcFV/8ZYHy24Cl4Hbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 626/731] nilfs2: fix shift-out-of-bounds due to too large exponent of block size
Date:   Wed, 28 Dec 2022 15:42:13 +0100
Message-Id: <20221228144314.673006624@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 6a86acd35696..6aa6cef0757f 100644
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



