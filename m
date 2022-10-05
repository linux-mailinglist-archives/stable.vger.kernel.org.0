Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3025F53A2
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiJELho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJELhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:37:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154711FCC2;
        Wed,  5 Oct 2022 04:34:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 153FBB81DB5;
        Wed,  5 Oct 2022 11:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8226AC433C1;
        Wed,  5 Oct 2022 11:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969662;
        bh=UJOpOicRU4NtFi9i6xwfp3NCfWObWtL19QToa62WIt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEOhu5JgFLDG9iHKVfS+DzNMfAtOzXTkTSmL4gTaqmneDpkiHQYHu96DMpo4Opuui
         XK1Bs7PsShbSIQbyueMzHaqpsWNEN+ETwBFQoKohk0Xjn0uJESN32NQ6R2DM/UfsCx
         araMO7WAA2t5L1QfvPfLwg8Z+QILgOtHjG7J9Emc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 41/51] xfs: fix s_maxbytes computation on 32-bit kernels
Date:   Wed,  5 Oct 2022 13:32:29 +0200
Message-Id: <20221005113212.190566979@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 932befe39ddea29cf47f4f1dc080d3dba668f0ca upstream.

I observed a hang in generic/308 while running fstests on a i686 kernel.
The hang occurred when trying to purge the pagecache on a large sparse
file that had a page created past MAX_LFS_FILESIZE, which caused an
integer overflow in the pagecache xarray and resulted in an infinite
loop.

I then noticed that Linus changed the definition of MAX_LFS_FILESIZE in
commit 0cc3b0ec23ce ("Clarify (and fix) MAX_LFS_FILESIZE macros") so
that it is now one page short of the maximum page index on 32-bit
kernels.  Because the XFS function to compute max offset open-codes the
2005-era MAX_LFS_FILESIZE computation and neither the vfs nor mm perform
any sanity checking of s_maxbytes, the code in generic/308 can create a
page above the pagecache's limit and kaboom.

Fix all this by setting s_maxbytes to MAX_LFS_FILESIZE directly and
aborting the mount with a warning if our assumptions ever break.  I have
no answer for why this seems to have been broken for years and nobody
noticed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |   48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -512,32 +512,6 @@ xfs_showargs(
 		seq_puts(m, ",noquota");
 }
 
-static uint64_t
-xfs_max_file_offset(
-	unsigned int		blockshift)
-{
-	unsigned int		pagefactor = 1;
-	unsigned int		bitshift = BITS_PER_LONG - 1;
-
-	/* Figure out maximum filesize, on Linux this can depend on
-	 * the filesystem blocksize (on 32 bit platforms).
-	 * __block_write_begin does this in an [unsigned] long long...
-	 *      page->index << (PAGE_SHIFT - bbits)
-	 * So, for page sized blocks (4K on 32 bit platforms),
-	 * this wraps at around 8Tb (hence MAX_LFS_FILESIZE which is
-	 *      (((u64)PAGE_SIZE << (BITS_PER_LONG-1))-1)
-	 * but for smaller blocksizes it is less (bbits = log2 bsize).
-	 */
-
-#if BITS_PER_LONG == 32
-	ASSERT(sizeof(sector_t) == 8);
-	pagefactor = PAGE_SIZE;
-	bitshift = BITS_PER_LONG;
-#endif
-
-	return (((uint64_t)pagefactor) << bitshift) - 1;
-}
-
 /*
  * Set parameters for inode allocation heuristics, taking into account
  * filesystem size and inode32/inode64 mount options; i.e. specifically
@@ -1650,6 +1624,26 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	/*
+	 * XFS block mappings use 54 bits to store the logical block offset.
+	 * This should suffice to handle the maximum file size that the VFS
+	 * supports (currently 2^63 bytes on 64-bit and ULONG_MAX << PAGE_SHIFT
+	 * bytes on 32-bit), but as XFS and VFS have gotten the s_maxbytes
+	 * calculation wrong on 32-bit kernels in the past, we'll add a WARN_ON
+	 * to check this assertion.
+	 *
+	 * Avoid integer overflow by comparing the maximum bmbt offset to the
+	 * maximum pagecache offset in units of fs blocks.
+	 */
+	if (XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE) > XFS_MAX_FILEOFF) {
+		xfs_warn(mp,
+"MAX_LFS_FILESIZE block offset (%llu) exceeds extent map maximum (%llu)!",
+			 XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE),
+			 XFS_MAX_FILEOFF);
+		error = -EINVAL;
+		goto out_free_sb;
+	}
+
 	error = xfs_filestream_mount(mp);
 	if (error)
 		goto out_free_sb;
@@ -1661,7 +1655,7 @@ xfs_fs_fill_super(
 	sb->s_magic = XFS_SUPER_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
-	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
 	sb->s_time_min = S32_MIN;


