Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D1D55ECC0
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiF1SkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiF1SkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:40:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4B422B16;
        Tue, 28 Jun 2022 11:40:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id go6so13471196pjb.0;
        Tue, 28 Jun 2022 11:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+DnQkEplT8yWF8rUNzXw53fIrMrZXJEC5FULg3fZdeo=;
        b=e4RCSgXodQ2XOls0Z1MpaQjBaZNEpILYUy1GrDxnSUNuk6iUSQ3I34+/xDSGardQAv
         u9tO1WYqEYfio5GqZPiNe9AdqMkpWTbGQ6l5gePXV8/Xc1krURUMCYpqhbdzIVdArHvb
         s3fvNkAacS52BXe+a7C8uEnz6muM7TGF/gUhzf20h29gT6tyT0x6XM7tccxghzuoFkbz
         T5ZT54lXTd92LbhNM2vU6d2aKZhhIjJ6iMAVHT0uFgA9vWun72onDW7JYu+nZH4gM4vv
         xSAmVgBk1ZsIHtIN+EmZID4jOInBm5cQCJBD+0LZ7ZdSkR9SKP4YJKzKJ7tzaNEP3XvH
         jwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+DnQkEplT8yWF8rUNzXw53fIrMrZXJEC5FULg3fZdeo=;
        b=ggOi5O9+SHfAYxuNvQtqVORZSy4c4AoDeq6onrGvdVb2rAaT0+HziFpyT/SstjimdT
         jiRMSLVdo2pn0txLKlnv1kxuQ9AzLlY+8f5IC6uPlitCS0UJ6I9Sz3oWYxsWAYs91TS8
         z88XCqUDfyLVHLQS+b2wgw43UcXe03EpJ4xv3N3mgSX3QnDatBhpL8uAdWWRM5qZTnEG
         ivSZY7OJCLQGtO4spJr3euMsCTy30JIB5gIHwEbxJLwGJynSQCfx73cU9hlDvKIedRVM
         X9qk+clKmAN5/yCU+Z7QRr2sqEI/NWASWzE/8ZsQ6UjupoN4iGlQ5oaR4ERm0ax1zJ63
         tXmw==
X-Gm-Message-State: AJIora/vknC1I8b2Rt1/2B+O0Q6mVUHAEJq9x64iymmFfMys79L7DSjN
        mt2n7unh4LhEWfvMmD3GgDYnEAXPYjtk2g==
X-Google-Smtp-Source: AGRyM1s9ZtEqJpCGNze5R+oqqVUGlVsQf7SAr4DciOH4mm1wws6XZa18rSE+FsoHhfA2eGFccehH1A==
X-Received: by 2002:a17:90b:3b47:b0:1ee:d48b:26d9 with SMTP id ot7-20020a17090b3b4700b001eed48b26d9mr1093768pjb.129.1656441622708;
        Tue, 28 Jun 2022 11:40:22 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:1d5d:7791:41a3:902a])
        by smtp.gmail.com with ESMTPSA id a20-20020a621a14000000b005251bea0d53sm9743498pfa.83.2022.06.28.11.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:40:22 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v4 2/7] xfs: punch out data fork delalloc blocks on COW writeback failure
Date:   Tue, 28 Jun 2022 11:39:46 -0700
Message-Id: <20220628183951.3425528-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220628183951.3425528-1-leah.rumancik@gmail.com>
References: <20220628183951.3425528-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 fs/xfs/xfs_aops.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 34fc6148032a..c8c15c3c3147 100644
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
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

