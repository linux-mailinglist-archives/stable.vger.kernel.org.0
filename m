Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9567851A9C7
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357365AbiEDRTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357981AbiEDRPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3324562C4;
        Wed,  4 May 2022 09:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B85161701;
        Wed,  4 May 2022 16:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6862C385A4;
        Wed,  4 May 2022 16:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683533;
        bh=hxNoD72OuIhtoVUGpBnbQHXO6FuEFLgC5dPvsjSXrGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcLMBVu5tKS9O+Jm4pAvL0bRmQvkLMaZGRQeMyhg94T0Iwu8vRryeKg+umziKaqXz
         P0LmY8DW5lawkmYKZ9XgNaTGQTTlv9TEohwBTbc4u0fug0posZSVox9LTQiyyFLfLE
         gE5yPgKcHM41G+6OYCrMJMrmO/zXG5p8TCgb2fZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 191/225] btrfs: fix direct I/O read repair for split bios
Date:   Wed,  4 May 2022 18:47:09 +0200
Message-Id: <20220504153127.311936705@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christoph Hellwig <hch@lst.de>

commit 00d825258bcc09c0e1b99aa7f9ad7d2c2fad41fa upstream.

When a bio is split in btrfs_submit_direct, dip->file_offset contains
the file offset for the first bio.  But this means the start value used
in btrfs_check_read_dio_bio is incorrect for subsequent bios.  Add
a file_offset field to struct btrfs_bio to pass along the correct offset.

Given that check_data_csum only uses start of an error message this
means problems with this miscalculation will only show up when I/O fails
or checksums mismatch.

The logic was removed in f4f39fc5dc30 ("btrfs: remove btrfs_bio::logical
member") but we need it due to the bio splitting.

CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    1 +
 fs/btrfs/inode.c     |   13 +++++--------
 fs/btrfs/volumes.h   |    3 +++
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2657,6 +2657,7 @@ int btrfs_repair_one_sector(struct inode
 
 	repair_bio = btrfs_bio_alloc(1);
 	repair_bbio = btrfs_bio(repair_bio);
+	repair_bbio->file_offset = start;
 	repair_bio->bi_opf = REQ_OP_READ;
 	repair_bio->bi_end_io = failed_bio->bi_end_io;
 	repair_bio->bi_iter.bi_sector = failrec->logical >> 9;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7789,8 +7789,6 @@ static blk_status_t btrfs_check_read_dio
 	const bool csum = !(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM);
 	struct bio_vec bvec;
 	struct bvec_iter iter;
-	const u64 orig_file_offset = dip->file_offset;
-	u64 start = orig_file_offset;
 	u32 bio_offset = 0;
 	blk_status_t err = BLK_STS_OK;
 
@@ -7800,6 +7798,8 @@ static blk_status_t btrfs_check_read_dio
 		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bvec.bv_len);
 		pgoff = bvec.bv_offset;
 		for (i = 0; i < nr_sectors; i++) {
+			u64 start = bbio->file_offset + bio_offset;
+
 			ASSERT(pgoff < PAGE_SIZE);
 			if (uptodate &&
 			    (!csum || !check_data_csum(inode, bbio,
@@ -7812,17 +7812,13 @@ static blk_status_t btrfs_check_read_dio
 			} else {
 				int ret;
 
-				ASSERT((start - orig_file_offset) < UINT_MAX);
-				ret = btrfs_repair_one_sector(inode,
-						&bbio->bio,
-						start - orig_file_offset,
-						bvec.bv_page, pgoff,
+				ret = btrfs_repair_one_sector(inode, &bbio->bio,
+						bio_offset, bvec.bv_page, pgoff,
 						start, bbio->mirror_num,
 						submit_dio_repair_bio);
 				if (ret)
 					err = errno_to_blk_status(ret);
 			}
-			start += sectorsize;
 			ASSERT(bio_offset + sectorsize > bio_offset);
 			bio_offset += sectorsize;
 			pgoff += sectorsize;
@@ -8025,6 +8021,7 @@ static void btrfs_submit_direct(const st
 		bio = btrfs_bio_clone_partial(dio_bio, clone_offset, clone_len);
 		bio->bi_private = dip;
 		bio->bi_end_io = btrfs_end_dio_bio;
+		btrfs_bio(bio)->file_offset = file_offset;
 
 		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
 			status = extract_ordered_extent(BTRFS_I(inode), bio,
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -323,6 +323,9 @@ struct btrfs_fs_devices {
 struct btrfs_bio {
 	unsigned int mirror_num;
 
+	/* for direct I/O */
+	u64 file_offset;
+
 	/* @device is for stripe IO submission. */
 	struct btrfs_device *device;
 	u8 *csum;


