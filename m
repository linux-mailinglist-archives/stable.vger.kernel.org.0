Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9FB6BB12A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjCOMZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjCOMYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A574D96099
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:23:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85FBF61D55
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96319C433EF;
        Wed, 15 Mar 2023 12:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883030;
        bh=dhmhDyv+smABR20keH2v9w1xKzkSe13V2l6HNNeGjd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sy96Vri6rvBu8gN295Cygy019hUZOxYQdqOehJvUcDmjeipZI1x0eUCFAwCJusaTl
         8iTalXBvB+Y7OBREs2pVBvcrilI5jlENEjYG5zgqe9WPhn9fRR8laaYKV+bXVSk9qC
         J3kSGiPXgNedutro0Xu28PyiZGQ6jP5cj22lQy+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.10 093/104] ext4: add strict range checks while freeing blocks
Date:   Wed, 15 Mar 2023 13:13:04 +0100
Message-Id: <20230315115735.830618560@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit a00b482b82fb098956a5bed22bd7873e56f152f1 upstream.

Currently ext4_mb_clear_bb() & ext4_group_add_blocks() only checks
whether the given block ranges (which is to be freed) belongs to any FS
metadata blocks or not, of the block's respective block group.
But to detect any FS error early, it is better to add more strict
checkings in those functions which checks whether the given blocks
belongs to any critical FS metadata or not within system-zone.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/ddd9143d064774e32d6364a99667817c6e8bfdc0.1644992610.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5361,13 +5361,7 @@ do_more:
 		goto error_return;
 	}
 
-	if (in_range(ext4_block_bitmap(sb, gdp), block, count) ||
-	    in_range(ext4_inode_bitmap(sb, gdp), block, count) ||
-	    in_range(block, ext4_inode_table(sb, gdp),
-		     sbi->s_itb_per_group) ||
-	    in_range(block + count - 1, ext4_inode_table(sb, gdp),
-		     sbi->s_itb_per_group)) {
-
+	if (!ext4_inode_block_valid(inode, block, count)) {
 		ext4_error(sb, "Freeing blocks in system zone - "
 			   "Block = %llu, count = %lu", block, count);
 		/* err = 0. ext4_std_error should be a no op */
@@ -5437,7 +5431,7 @@ do_more:
 						 NULL);
 			if (err && err != -EOPNOTSUPP)
 				ext4_msg(sb, KERN_WARNING, "discard request in"
-					 " group:%d block:%d count:%lu failed"
+					 " group:%u block:%d count:%lu failed"
 					 " with %d", block_group, bit, count,
 					 err);
 		} else
@@ -5650,11 +5644,7 @@ int ext4_group_add_blocks(handle_t *hand
 		goto error_return;
 	}
 
-	if (in_range(ext4_block_bitmap(sb, desc), block, count) ||
-	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
-	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
-	    in_range(block + count - 1, ext4_inode_table(sb, desc),
-		     sbi->s_itb_per_group)) {
+	if (!ext4_sb_block_valid(sb, NULL, block, count)) {
 		ext4_error(sb, "Adding blocks in system zones - "
 			   "Block = %llu, count = %lu",
 			   block, count);


