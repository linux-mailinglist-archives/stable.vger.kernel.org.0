Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553BF69CD68
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbjBTNtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjBTNtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:49:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706761E1FF
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0890360EAB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1585DC433EF;
        Mon, 20 Feb 2023 13:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900932;
        bh=y6BrrmqMxEtX/nV7V9XLxSRpo7BPPYHK1/LEjIpeV1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNkjWoNuVyNCpTKCx9GcUhJ2EDY7CbA0M2OsZ0yD4ttcCn8cAkxx8w66qQlU1jY7q
         4aTAETO9x40JleK7Dt0AmdQsUfPaBFx5VEqPlaP7MvDBzWiNQK/3fMZslwtjuY7O62
         4Qem/8bgAnr9EsjNG1HYX0TluvUggS8Q9lF0/zwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 122/156] xfs: fix missing CoW blocks writeback conversion retry
Date:   Mon, 20 Feb 2023 14:36:06 +0100
Message-Id: <20230220133607.664815635@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit c2f09217a4305478c55adc9a98692488dd19cd32 upstream.

[ Set xfs_writepage_ctx->fork to XFS_DATA_FORK since 5.4.y tracks current
  extent's fork in this variable ]

In commit 7588cbeec6df, we tried to fix a race stemming from the lack of
coordination between higher level code that wants to allocate and remap
CoW fork extents into the data fork.  Christoph cites as examples the
always_cow mode, and a directio write completion racing with writeback.

According to the comments before the goto retry, we want to restart the
lookup to catch the extent in the data fork, but we don't actually reset
whichfork or cow_fsb, which means the second try executes using stale
information.  Up until now I think we've gotten lucky that either
there's something left in the CoW fork to cause cow_fsb to be reset, or
either data/cow fork sequence numbers have advanced enough to force a
fresh lookup from the data fork.  However, if we reach the retry with an
empty stable CoW fork and a stable data fork, neither of those things
happens.  The retry foolishly re-calls xfs_convert_blocks on the CoW
fork which fails again.  This time, we toss the write.

I've recently been working on extending reflink to the realtime device.
When the realtime extent size is larger than a single block, we have to
force the page cache to CoW the entire rt extent if a write (or
fallocate) are not aligned with the rt extent size.  The strategy I've
chosen to deal with this is derived from Dave's blocksize > pagesize
series: dirtying around the write range, and ensuring that writeback
always starts mapping on an rt extent boundary.  This has brought this
race front and center, since generic/522 blows up immediately.

However, I'm pretty sure this is a bug outright, independent of that.

Fixes: 7588cbeec6df ("xfs: retry COW fork delalloc conversion when no extent was found")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_aops.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -495,7 +495,7 @@ xfs_map_blocks(
 	ssize_t			count = i_blocksize(inode);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
-	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
+	xfs_fileoff_t		cow_fsb;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
@@ -529,6 +529,8 @@ xfs_map_blocks(
 	 * landed in a hole and we skip the block.
 	 */
 retry:
+	cow_fsb = NULLFILEOFF;
+	wpc->fork = XFS_DATA_FORK;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));


