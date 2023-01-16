Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29FA66CC66
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbjAPRZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjAPRZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:25:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AEF14E9C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:02:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C2AB8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBBFC433D2;
        Mon, 16 Jan 2023 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888546;
        bh=1Yi8Us4WxEV3rc8fw5rXqSOfkYWHcaOv09F+nNtLumE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJpRl9ymLIG8pZTt0reQP8WFXRE3RvWeFmqedsV3KmWh9zwRYoakrkZtokMX/Mv/S
         0//AaNyNbE+sqHY5/gZIL5bmeVRR9oOtlMIdpTFm7F08oTQ9tv9AfzXrrihH9ptNtO
         ZU15Wv7NjzWFm3NIr/8lV4KaRRzz9nZmJ8Tv8KWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.14 016/338] udf: Fix extending file within last block
Date:   Mon, 16 Jan 2023 16:48:09 +0100
Message-Id: <20230116154821.466697153@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

commit 1f3868f06855c97a4954c99b36f3fc9eb8f60326 upstream.

When extending file within last block it can happen that the extent is
already rounded to the blocksize and thus contains the offset we want to
grow up to. In such case we would mistakenly expand the last extent and
make it one block longer than it should be, exposing unallocated block
in a file and causing data corruption. Fix the problem by properly
detecting this case and bailing out.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -585,13 +585,17 @@ out:
 static void udf_do_extend_final_block(struct inode *inode,
 				      struct extent_position *last_pos,
 				      struct kernel_long_ad *last_ext,
-				      uint32_t final_block_len)
+				      uint32_t new_elen)
 {
-	struct super_block *sb = inode->i_sb;
 	uint32_t added_bytes;
 
-	added_bytes = final_block_len -
-		      (last_ext->extLength & (sb->s_blocksize - 1));
+	/*
+	 * Extent already large enough? It may be already rounded up to block
+	 * size...
+	 */
+	if (new_elen <= (last_ext->extLength & UDF_EXTENT_LENGTH_MASK))
+		return;
+	added_bytes = (last_ext->extLength & UDF_EXTENT_LENGTH_MASK) - new_elen;
 	last_ext->extLength += added_bytes;
 	UDF_I(inode)->i_lenExtents += added_bytes;
 
@@ -608,12 +612,12 @@ static int udf_extend_file(struct inode
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
 	sector_t first_block = newsize >> sb->s_blocksize_bits, offset;
-	unsigned long partial_final_block;
+	loff_t new_elen;
 	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	struct kernel_long_ad extent;
 	int err = 0;
-	int within_final_block;
+	bool within_last_ext;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(struct short_ad);
@@ -629,9 +633,9 @@ static int udf_extend_file(struct inode
 	udf_discard_prealloc(inode);
 
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
-	within_final_block = (etype != -1);
+	within_last_ext = (etype != -1);
 	/* We don't expect extents past EOF... */
-	WARN_ON_ONCE(etype != -1 &&
+	WARN_ON_ONCE(within_last_ext &&
 		     elen > ((loff_t)offset + 1) << inode->i_blkbits);
 
 	if ((!epos.bh && epos.offset == udf_file_entry_alloc_offset(inode)) ||
@@ -648,19 +652,17 @@ static int udf_extend_file(struct inode
 		extent.extLength |= etype << 30;
 	}
 
-	partial_final_block = newsize & (sb->s_blocksize - 1);
+	new_elen = ((loff_t)offset << inode->i_blkbits) |
+					(newsize & (sb->s_blocksize - 1));
 
 	/* File has extent covering the new size (could happen when extending
 	 * inside a block)?
 	 */
-	if (within_final_block) {
+	if (within_last_ext) {
 		/* Extending file within the last file block */
-		udf_do_extend_final_block(inode, &epos, &extent,
-					  partial_final_block);
+		udf_do_extend_final_block(inode, &epos, &extent, new_elen);
 	} else {
-		loff_t add = ((loff_t)offset << sb->s_blocksize_bits) |
-			     partial_final_block;
-		err = udf_do_extend_file(inode, &epos, &extent, add);
+		err = udf_do_extend_file(inode, &epos, &extent, new_elen);
 	}
 
 	if (err < 0)


