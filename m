Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77005561D5A
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbiF3OIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbiF3OIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:08:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D461076E9F;
        Thu, 30 Jun 2022 06:54:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5557862124;
        Thu, 30 Jun 2022 13:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB9BC34115;
        Thu, 30 Jun 2022 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597292;
        bh=JQvFxHlyvg7oC1HqZzzyFGMHYaktl60NzjfZoKfqJ/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFj49F1EfDDffgsT/ymXpreYbWaeTjy4sgnCYC2DFRkRb9UwCuUIx4wcU12RVMhfa
         0JzAtGzLQ/6V/6Gb3b8WtFFVCxdXvfjC57ZJ4G9NRe4VneJ6eXY7rUdu6+p0EDZYzD
         FLU06q74344pnNLws+CeKxaIaAmR0RT30AokPFDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 06/28] xfs: punch out data fork delalloc blocks on COW writeback failure
Date:   Thu, 30 Jun 2022 15:47:02 +0200
Message-Id: <20220630133233.113538634@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 5ca5916b6bc93577c360c06cb7cdf71adb9b5faf ]

If writeback I/O to a COW extent fails, the COW fork blocks are
punched out and the data fork blocks left alone. It is possible for
COW fork blocks to overlap non-shared data fork blocks (due to
cowextsz hint prealloc), however, and writeback unconditionally maps
to the COW fork whenever blocks exist at the corresponding offset of
the page undergoing writeback. This means it's quite possible for a
COW fork extent to overlap delalloc data fork blocks, writeback to
convert and map to the COW fork blocks, writeback to fail, and
finally for ioend completion to cancel the COW fork blocks and leave
stale data fork delalloc blocks around in the inode. The blocks are
effectively stale because writeback failure also discards dirty page
state.

If this occurs, it is likely to trigger assert failures, free space
accounting corruption and failures in unrelated file operations. For
example, a subsequent reflink attempt of the affected file to a new
target file will trip over the stale delalloc in the source file and
fail. Several of these issues are occasionally reproduced by
generic/648, but are reproducible on demand with the right sequence
of operations and timely I/O error injection.

To fix this problem, update the ioend failure path to also punch out
underlying data fork delalloc blocks on I/O error. This is analogous
to the writeback submission failure path in xfs_discard_page() where
we might fail to map data fork delalloc blocks and consistent with
the successful COW writeback completion path, which is responsible
for unmapping from the data fork and remapping in COW fork blocks.

Fixes: 787eb485509f ("xfs: fix and streamline error handling in xfs_end_io")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_aops.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -82,6 +82,7 @@ xfs_end_ioend(
 	struct iomap_ioend	*ioend)
 {
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 	unsigned int		nofs_flag;
@@ -97,18 +98,26 @@ xfs_end_ioend(
 	/*
 	 * Just clean up the in-memory structures if the fs has been shut down.
 	 */
-	if (xfs_is_shutdown(ip->i_mount)) {
+	if (xfs_is_shutdown(mp)) {
 		error = -EIO;
 		goto done;
 	}
 
 	/*
-	 * Clean up any COW blocks on an I/O error.
+	 * Clean up all COW blocks and underlying data fork delalloc blocks on
+	 * I/O error. The delalloc punch is required because this ioend was
+	 * mapped to blocks in the COW fork and the associated pages are no
+	 * longer dirty. If we don't remove delalloc blocks here, they become
+	 * stale and can corrupt free space accounting on unmount.
 	 */
 	error = blk_status_to_errno(ioend->io_bio->bi_status);
 	if (unlikely(error)) {
-		if (ioend->io_flags & IOMAP_F_SHARED)
+		if (ioend->io_flags & IOMAP_F_SHARED) {
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
+			xfs_bmap_punch_delalloc_range(ip,
+						      XFS_B_TO_FSBT(mp, offset),
+						      XFS_B_TO_FSB(mp, size));
+		}
 		goto done;
 	}
 


