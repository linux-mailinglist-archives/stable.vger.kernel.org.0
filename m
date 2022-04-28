Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4D513B93
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 20:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351073AbiD1SfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351083AbiD1SfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 14:35:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF4BBC858;
        Thu, 28 Apr 2022 11:31:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id ED3B92186F;
        Thu, 28 Apr 2022 18:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651170704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=753xZx2E3bh3yXyUeggW3d/Fh8b+RnXgCb38nNJCS+c=;
        b=rKvBhXjN1pTYEj7qICuvDSf+7Noo2UDDU06HQjCPyFaLREGlJSuW2LaXSNhuaRbpw+mAb1
        NDXtdMJHDiWx2N0qHwpN9QiHeUAeZJbjKyxpZaqnXtJ2PGynPXV9/iMqH+0gyOuo+01+RL
        Xi/0wxpTYBZ5XwWMO4O67y5lsYGH4LM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651170704;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=753xZx2E3bh3yXyUeggW3d/Fh8b+RnXgCb38nNJCS+c=;
        b=uEypsh7I+tYaEgGQecB/uBdf0PYIFveETZz1o8DsT7ifzbyAQEmbjE3oWo3UtVSh/H8Oyg
        JE2bMkZu6fAH8uDQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C0B342C143;
        Thu, 28 Apr 2022 18:31:44 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C2A79A0623; Thu, 28 Apr 2022 20:31:43 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ext4: Avoid cycles in directory h-tree
Date:   Thu, 28 Apr 2022 20:31:38 +0200
Message-Id: <20220428183143.5439-2-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428180355.15209-1-jack@suse.cz>
References: <20220428180355.15209-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2654; h=from:subject; bh=RxClARObkvuG8R3IW72U/utffsswWMvIdqciBenEwxc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiat2JvcGzSpul1ayzLA3SFdYV59YLvaWlsi54FO8I jsxnPrKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYmrdiQAKCRCcnaoHP2RA2dFeB/ 42mKlrgOINYupTuh56tuxuJbVC2N1y+PpKf+laD3iDBbcJOCMHMHoUX526mdI1NP8S91hFaL4lHO0s PBixhLNFm7pZfFDgNQhzdJA7YKFxjo7BHajNiG36a5JvADYYY7eES6MnyO7+8uwjxJ1+UT6y0q0pdm eU2MzI/PRhDxd+krQRHLA6t2NodugaCe3UpVMOsxfVoIxEhxfe7FDkrrGsX5tWSNoVh8w+pR7WC6dS J2xDrXmy8siELj1Iz9iD9virdptmaUQmKgjIken9quGtgqH2Vm2jOmDIzFO3yTt2nurTeIAGaTZ+6b BKrbr2YPnh6wUIdDUjobnOmT0UMxPT
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A maliciously corrupted filesystem can contain cycles in the h-tree
stored inside a directory. That can easily lead to the kernel corrupting
tree nodes that were already verified under its hands while doing a node
split and consequently accessing unallocated memory. Fix the problem by
verifying traversed block numbers are unique.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ca6ee9940599..06441ad6104d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -777,12 +777,14 @@ static struct dx_frame *
 dx_probe(struct ext4_filename *fname, struct inode *dir,
 	 struct dx_hash_info *hinfo, struct dx_frame *frame_in)
 {
-	unsigned count, indirect;
+	unsigned count, indirect, level, i;
 	struct dx_entry *at, *entries, *p, *q, *m;
 	struct dx_root *root;
 	struct dx_frame *frame = frame_in;
 	struct dx_frame *ret_err = ERR_PTR(ERR_BAD_DX_DIR);
 	u32 hash;
+	ext4_lblk_t block;
+	ext4_lblk_t blocks[EXT4_HTREE_LEVEL];
 
 	memset(frame_in, 0, EXT4_HTREE_LEVEL * sizeof(frame_in[0]));
 	frame->bh = ext4_read_dirblock(dir, 0, INDEX);
@@ -854,6 +856,8 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	}
 
 	dxtrace(printk("Look up %x", hash));
+	level = 0;
+	blocks[0] = 0;
 	while (1) {
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
@@ -882,15 +886,27 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 			       dx_get_block(at)));
 		frame->entries = entries;
 		frame->at = at;
-		if (!indirect--)
+
+		block = dx_get_block(at);
+		for (i = 0; i <= level; i++) {
+			if (blocks[i] == block) {
+				ext4_warning_inode(dir,
+					"dx entry: tree cycle block %u points back to block %u",
+					blocks[level], block);
+				goto fail;
+			}
+		}
+		blocks[++level] = block;
+		if (level > indirect)
 			return frame;
 		frame++;
-		frame->bh = ext4_read_dirblock(dir, dx_get_block(at), INDEX);
+		frame->bh = ext4_read_dirblock(dir, block, INDEX);
 		if (IS_ERR(frame->bh)) {
 			ret_err = (struct dx_frame *) frame->bh;
 			frame->bh = NULL;
 			goto fail;
 		}
+
 		entries = ((struct dx_node *) frame->bh->b_data)->entries;
 
 		if (dx_get_limit(entries) != dx_node_limit(dir)) {
@@ -1278,7 +1294,7 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
 			count++;
 			cond_resched();
 		}
-		de = ext4_next_entry(de, blocksize);
+		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
 	}
 	return count;
 }
-- 
2.34.1

