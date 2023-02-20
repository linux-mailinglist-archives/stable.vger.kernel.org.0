Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7148869CDD1
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbjBTNxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjBTNxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:53:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A971CAC0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 845ECB80D44
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD405C433D2;
        Mon, 20 Feb 2023 13:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901187;
        bh=NXVTRYFMDHQcZuEjpnGmbq4UB6wgycTk9jV1D9WkAac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxNuDf+zwrXdwoop9zY7LnTNrCHRcmrD18+YKZbUnz0waoBfMd7wVhZFiW9jk43N+
         IBIRUwLxSXwxb+vlMtUxdt/gu1mgras5ei7gNd5rVYjoH2OBa+fM9+NnTIQUGx7KXI
         FdzvBF3GOuNYG1nPjJRSU9V2SgonY0070VWiBBBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/83] xfs: dont leak btree cursor when insrec fails after a split
Date:   Mon, 20 Feb 2023 14:36:06 +0100
Message-Id: <20230220133554.814652941@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit a54f78def73d847cb060b18c4e4a3d1d26c9ca6d ]

The recent patch to improve btree cycle checking caused a regression
when I rebased the in-memory btree branch atop the 5.19 for-next branch,
because in-memory short-pointer btrees do not have AG numbers.  This
produced the following complaint from kmemleak:

unreferenced object 0xffff88803d47dde8 (size 264):
  comm "xfs_io", pid 4889, jiffies 4294906764 (age 24.072s)
  hex dump (first 32 bytes):
    90 4d 0b 0f 80 88 ff ff 00 a0 bd 05 80 88 ff ff  .M..............
    e0 44 3a a0 ff ff ff ff 00 df 08 06 80 88 ff ff  .D:.............
  backtrace:
    [<ffffffffa0388059>] xfbtree_dup_cursor+0x49/0xc0 [xfs]
    [<ffffffffa029887b>] xfs_btree_dup_cursor+0x3b/0x200 [xfs]
    [<ffffffffa029af5d>] __xfs_btree_split+0x6ad/0x820 [xfs]
    [<ffffffffa029b130>] xfs_btree_split+0x60/0x110 [xfs]
    [<ffffffffa029f6da>] xfs_btree_make_block_unfull+0x19a/0x1f0 [xfs]
    [<ffffffffa029fada>] xfs_btree_insrec+0x3aa/0x810 [xfs]
    [<ffffffffa029fff3>] xfs_btree_insert+0xb3/0x240 [xfs]
    [<ffffffffa02cb729>] xfs_rmap_insert+0x99/0x200 [xfs]
    [<ffffffffa02cf142>] xfs_rmap_map_shared+0x192/0x5f0 [xfs]
    [<ffffffffa02cf60b>] xfs_rmap_map_raw+0x6b/0x90 [xfs]
    [<ffffffffa0384a85>] xrep_rmap_stash+0xd5/0x1d0 [xfs]
    [<ffffffffa0384dc0>] xrep_rmap_visit_bmbt+0xa0/0xf0 [xfs]
    [<ffffffffa0384fb6>] xrep_rmap_scan_iext+0x56/0xa0 [xfs]
    [<ffffffffa03850d8>] xrep_rmap_scan_ifork+0xd8/0x160 [xfs]
    [<ffffffffa0385195>] xrep_rmap_scan_inode+0x35/0x80 [xfs]
    [<ffffffffa03852ee>] xrep_rmap_find_rmaps+0x10e/0x270 [xfs]

I noticed that xfs_btree_insrec has a bunch of debug code that return
out of the function immediately, without freeing the "new" btree cursor
that can be returned when _make_block_unfull calls xfs_btree_split.  Fix
the error return in this function to free the btree cursor.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 482a4ccc65682..dffe4ca584935 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3266,7 +3266,7 @@ xfs_btree_insrec(
 	struct xfs_btree_block	*block;	/* btree block */
 	struct xfs_buf		*bp;	/* buffer for block */
 	union xfs_btree_ptr	nptr;	/* new block ptr */
-	struct xfs_btree_cur	*ncur;	/* new btree cursor */
+	struct xfs_btree_cur	*ncur = NULL;	/* new btree cursor */
 	union xfs_btree_key	nkey;	/* new block key */
 	union xfs_btree_key	*lkey;
 	int			optr;	/* old key/record index */
@@ -3346,7 +3346,7 @@ xfs_btree_insrec(
 #ifdef DEBUG
 	error = xfs_btree_check_block(cur, block, level, bp);
 	if (error)
-		return error;
+		goto error0;
 #endif
 
 	/*
@@ -3366,7 +3366,7 @@ xfs_btree_insrec(
 		for (i = numrecs - ptr; i >= 0; i--) {
 			error = xfs_btree_debug_check_ptr(cur, pp, i, level);
 			if (error)
-				return error;
+				goto error0;
 		}
 
 		xfs_btree_shift_keys(cur, kp, 1, numrecs - ptr + 1);
@@ -3451,6 +3451,8 @@ xfs_btree_insrec(
 	return 0;
 
 error0:
+	if (ncur)
+		xfs_btree_del_cursor(ncur, error);
 	return error;
 }
 
-- 
2.39.0



