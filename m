Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FF665133B
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiLST2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiLST0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:26:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F24CE7
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:26:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76022B80EF7
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB14C433D2;
        Mon, 19 Dec 2022 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477985;
        bh=Vh3n+7LqWlbT5bq9mawkUw8tSF8Nd6asBEPhxZKrqzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwLrzPk5iaOyvzwJwNUkcPyftoRUpgMgWp23s1Xxn2GNRU5ATx+pK5PwBfpJUu9Tg
         8esFu2+ofqNd8KW6yP5q4bbXRjYYRXnnaZFEL6d7XXU4FGIibSvf9Ofe18sivhqhiX
         iqJHlRlUynjhCkSabCG1OHzHU2HPfznAK98KM798=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: [PATCH 6.0 10/28] udf: Discard preallocation before extending file with a hole
Date:   Mon, 19 Dec 2022 20:22:57 +0100
Message-Id: <20221219182944.625563768@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 16d0556568148bdcaa45d077cac9f8f7077cf70a upstream.

When extending file with a hole, we tried to preserve existing
preallocation for the file. However that is not very useful and
complicates code because the previous extent may need to be rounded to
block boundary as well (which we forgot to do thus causing data
corruption for sequence like:

xfs_io -f -c "pwrite 0x75e63 11008" -c "truncate 0x7b24b" \
  -c "truncate 0xabaa3" -c "pwrite 0xac70b 22954" \
  -c "pwrite 0x93a43 11358" -c "pwrite 0xb8e65 52211" file

with 512-byte block size. Just discard preallocation before extending
file to simplify things and also fix this data corruption.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -439,6 +439,12 @@ static int udf_get_block(struct inode *i
 		iinfo->i_next_alloc_goal++;
 	}
 
+	/*
+	 * Block beyond EOF and prealloc extents? Just discard preallocation
+	 * as it is not useful and complicates things.
+	 */
+	if (((loff_t)block) << inode->i_blkbits > iinfo->i_lenExtents)
+		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	phys = inode_getblk(inode, block, &err, &new);
 	if (!phys)
@@ -488,8 +494,6 @@ static int udf_do_extend_file(struct ino
 	uint32_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	struct super_block *sb = inode->i_sb;
-	struct kernel_lb_addr prealloc_loc = {};
-	uint32_t prealloc_len = 0;
 	struct udf_inode_info *iinfo;
 	int err;
 
@@ -510,19 +514,6 @@ static int udf_do_extend_file(struct ino
 			~(sb->s_blocksize - 1);
 	}
 
-	/* Last extent are just preallocated blocks? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
-						EXT_NOT_RECORDED_ALLOCATED) {
-		/* Save the extent so that we can reattach it to the end */
-		prealloc_loc = last_ext->extLocation;
-		prealloc_len = last_ext->extLength;
-		/* Mark the extent as a hole */
-		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
-		last_ext->extLocation.logicalBlockNum = 0;
-		last_ext->extLocation.partitionReferenceNum = 0;
-	}
-
 	/* Can we merge with the previous extent? */
 	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
 					EXT_NOT_RECORDED_NOT_ALLOCATED) {
@@ -550,7 +541,7 @@ static int udf_do_extend_file(struct ino
 		 * more extents, we may need to enter possible following
 		 * empty indirect extent.
 		 */
-		if (new_block_bytes || prealloc_len)
+		if (new_block_bytes)
 			udf_next_aext(inode, last_pos, &tmploc, &tmplen, 0);
 	}
 
@@ -584,17 +575,6 @@ static int udf_do_extend_file(struct ino
 	}
 
 out:
-	/* Do we have some preallocated blocks saved? */
-	if (prealloc_len) {
-		err = udf_add_aext(inode, last_pos, &prealloc_loc,
-				   prealloc_len, 1);
-		if (err)
-			return err;
-		last_ext->extLocation = prealloc_loc;
-		last_ext->extLength = prealloc_len;
-		count++;
-	}
-
 	/* last_pos should point to the last written extent... */
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		last_pos->offset -= sizeof(struct short_ad);
@@ -647,8 +627,17 @@ static int udf_extend_file(struct inode
 	else
 		BUG();
 
+	/*
+	 * When creating hole in file, just don't bother with preserving
+	 * preallocation. It likely won't be very useful anyway.
+	 */
+	udf_discard_prealloc(inode);
+
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
 	within_final_block = (etype != -1);
+	/* We don't expect extents past EOF... */
+	WARN_ON_ONCE(etype != -1 &&
+		     elen > ((loff_t)offset + 1) << inode->i_blkbits);
 
 	if ((!epos.bh && epos.offset == udf_file_entry_alloc_offset(inode)) ||
 	    (epos.bh && epos.offset == sizeof(struct allocExtDesc))) {
@@ -777,10 +766,11 @@ static sector_t inode_getblk(struct inod
 		goto out_free;
 	}
 
-	/* Are we beyond EOF? */
+	/* Are we beyond EOF and preallocated extent? */
 	if (etype == -1) {
 		int ret;
 		loff_t hole_len;
+
 		isBeyondEOF = true;
 		if (count) {
 			if (c)


