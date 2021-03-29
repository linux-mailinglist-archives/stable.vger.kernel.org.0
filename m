Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC9434C9DF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhC2IeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234534AbhC2IdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00260619B6;
        Mon, 29 Mar 2021 08:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006727;
        bh=K0RLDAuiVTT5C+OzX/vgFn8GSq79fX1tu5MTpoeHFjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsDs+2LUVRxFHEl5sKtZrL6/rfh1mwLbPMzMFUy/Sj/Xr4RlqvefSqSNJVKuA+XO6
         6XASdXt951uFazHg/B7iGfYh6opOmj0VQVLJMh13x3USwoj7aKyTnnoE13aJHDq5o6
         e0t3G7fULJH69MY4S07arZi7ZK//OJ+CmgKiCT+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Omar Sandoval <osandov@fb.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 069/254] btrfs: fix check_data_csum() error message for direct I/O
Date:   Mon, 29 Mar 2021 09:56:25 +0200
Message-Id: <20210329075635.418910414@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

commit c1d6abdac46ca8127274bea195d804e3f2cec7ee upstream.

Commit 1dae796aabf6 ("btrfs: inode: sink parameter start and len to
check_data_csum()") replaced the start parameter to check_data_csum()
with page_offset(), but page_offset() is not meaningful for direct I/O
pages. Bring back the start parameter.

Fixes: 265d4ac03fdf ("btrfs: sink parameter start and len to check_data_csum")
CC: stable@vger.kernel.org # 5.11+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2947,11 +2947,13 @@ void btrfs_writepage_endio_finish_ordere
  * @bio_offset:	offset to the beginning of the bio (in bytes)
  * @page:	page where is the data to be verified
  * @pgoff:	offset inside the page
+ * @start:	logical offset in the file
  *
  * The length of such check is always one sector size.
  */
 static int check_data_csum(struct inode *inode, struct btrfs_io_bio *io_bio,
-			   u32 bio_offset, struct page *page, u32 pgoff)
+			   u32 bio_offset, struct page *page, u32 pgoff,
+			   u64 start)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
@@ -2978,8 +2980,8 @@ static int check_data_csum(struct inode
 	kunmap_atomic(kaddr);
 	return 0;
 zeroit:
-	btrfs_print_data_csum_error(BTRFS_I(inode), page_offset(page) + pgoff,
-				    csum, csum_expected, io_bio->mirror_num);
+	btrfs_print_data_csum_error(BTRFS_I(inode), start, csum, csum_expected,
+				    io_bio->mirror_num);
 	if (io_bio->device)
 		btrfs_dev_stat_inc_and_print(io_bio->device,
 					     BTRFS_DEV_STAT_CORRUPTION_ERRS);
@@ -3032,7 +3034,8 @@ int btrfs_verify_data_csum(struct btrfs_
 	     pg_off += sectorsize, bio_offset += sectorsize) {
 		int ret;
 
-		ret = check_data_csum(inode, io_bio, bio_offset, page, pg_off);
+		ret = check_data_csum(inode, io_bio, bio_offset, page, pg_off,
+				      page_offset(page) + pg_off);
 		if (ret < 0)
 			return -EIO;
 	}
@@ -7742,7 +7745,8 @@ static blk_status_t btrfs_check_read_dio
 			ASSERT(pgoff < PAGE_SIZE);
 			if (uptodate &&
 			    (!csum || !check_data_csum(inode, io_bio,
-					bio_offset, bvec.bv_page, pgoff))) {
+						       bio_offset, bvec.bv_page,
+						       pgoff, start))) {
 				clean_io_failure(fs_info, failure_tree, io_tree,
 						 start, bvec.bv_page,
 						 btrfs_ino(BTRFS_I(inode)),


