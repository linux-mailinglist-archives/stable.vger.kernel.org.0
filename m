Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182E36D4849
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbjDCO1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbjDCO1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:27:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA7F31297
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8952B81C15
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A45C4339B;
        Mon,  3 Apr 2023 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532034;
        bh=3B2I5dt0gbxDkIRli7iMMFAhYWMbIn02GHuW6/+RATw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKYdSLN5izi0wCQN/2ySiDzwX9QCRc5azvAA2tkSxKeA/EDuUfIY20bfkPnHfjSz4
         u7mmdgaQ8sK/eJeeDsILbEkMDL1oV4o1ksYmTzP6C9+prnb7rYH+ACUYQUsBR9ZlQF
         k1EjjckRpm3e6Js6W6Wbzg0lshTm5R8u8zAjLkFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 101/173] xfs: dont reuse busy extents on extent trim
Date:   Mon,  3 Apr 2023 16:08:36 +0200
Message-Id: <20230403140417.697788021@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 06058bc40534530e617e5623775c53bb24f032cb upstream.

Freed extents are marked busy from the point the freeing transaction
commits until the associated CIL context is checkpointed to the log.
This prevents reuse and overwrite of recently freed blocks before
the changes are committed to disk, which can lead to corruption
after a crash. The exception to this rule is that metadata
allocation is allowed to reuse busy extents because metadata changes
are also logged.

As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
has allowed modification or complete invalidation of outstanding
busy extents for metadata allocations. This implementation assumes
that use of the associated extent is imminent, which is not always
the case. For example, the trimmed extent might not satisfy the
minimum length of the allocation request, or the allocation
algorithm might be involved in a search for the optimal result based
on locality.

generic/019 reproduces a corruption caused by this scenario. First,
a metadata block (usually a bmbt or symlink block) is freed from an
inode. A subsequent bmbt split on an unrelated inode attempts a near
mode allocation request that invalidates the busy block during the
search, but does not ultimately allocate it. Due to the busy state
invalidation, the block is no longer considered busy to subsequent
allocation. A direct I/O write request immediately allocates the
block and writes to it. Finally, the filesystem crashes while in a
state where the initial metadata block free had not committed to the
on-disk log. After recovery, the original metadata block is in its
original location as expected, but has been corrupted by the
aforementioned dio.

This demonstrates that it is fundamentally unsafe to modify busy
extent state for extents that are not guaranteed to be allocated.
This applies to pretty much all of the code paths that currently
trim busy extents for one reason or another. Therefore to address
this problem, drop the reuse mechanism from the busy extent trim
path. This code already knows how to return partial non-busy ranges
of the targeted free extent and higher level code tracks the busy
state of the allocation attempt. If a block allocation fails where
one or more candidate extents is busy, we force the log and retry
the allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_extent_busy.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -344,7 +344,6 @@ xfs_extent_busy_trim(
 	ASSERT(*len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
-restart:
 	fbno = *bno;
 	flen = *len;
 	rbp = args->pag->pagb_tree.rb_node;
@@ -363,19 +362,6 @@ restart:
 			continue;
 		}
 
-		/*
-		 * If this is a metadata allocation, try to reuse the busy
-		 * extent instead of trimming the allocation.
-		 */
-		if (!(args->datatype & XFS_ALLOC_USERDATA) &&
-		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
-			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
-							  busyp, fbno, flen,
-							  false))
-				goto restart;
-			continue;
-		}
-
 		if (bbno <= fbno) {
 			/* start overlap */
 


