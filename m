Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462B66CB83C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 09:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjC1HgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 03:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbjC1HgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 03:36:04 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D813140F7;
        Tue, 28 Mar 2023 00:35:24 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i9so11110283wrp.3;
        Tue, 28 Mar 2023 00:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679988920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKJxxj+cvUAFiVFn2VAKaQpn1Fx+oJPp1pod/bKLcS8=;
        b=EHTnwhxsKMl5uhFL8hInR6fI9YmziRblHUBHqu51WZFAIwHsbVF55k7mNnzki0RXpo
         Vbj5pc8toiKmkibfhOFip68AG2qrnNFJlykW1lGQEq/Wc9w4eJ/b36MCeteL6C7n9ymL
         JE7HOFycFDKLk0ykwau7TqhMBQOvyGqIJqcytUDoDVMol4DTEPHkH3a7KjHCXsNgbGOU
         berPTxa4LZJ6cZjtg9iVlBv+l6W7R10Sl3GNYJX529TtqLLxyQcL6nkm+C0DgJquQCII
         8B06DvDOgoLT99QVxyxNFYvgFBfRr5S13lFA/TT/uZYD1ldTmI4/PBXs10k83ZZTAZmq
         cR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679988920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MKJxxj+cvUAFiVFn2VAKaQpn1Fx+oJPp1pod/bKLcS8=;
        b=c4CyeFEu3iUYcxrTqQG12jPqVUTyn16QlFkkwIhBh6Jb/SwhvkjaNN2/biY1cyOtZw
         b5YfgxNfZ/M4L3bAaHMjP6Ns8G5lsqNNTwPk54djxvAnhd/gQa24yNxg8c8Z+Tosq4dk
         qQ8HV6sji+aM2dYWoQK5znjTf4VFeh/RtolEsE/3AZp6HOa1z+xCSyIuDA1sLbZU8uz5
         GhY6vt0MVyhiP8ECUjf1jJiGhfX5D7VMFO/SgOVEj8a7zZFrLy56yvs95SosJnF1nogk
         QW5ZxCz0kDHG8Rx0hwjzR/KngSGoaIegut2YwJs9dP2hfsjUZQbecPChnbrUFqNDRpXG
         O6yg==
X-Gm-Message-State: AAQBX9eEs7Q52CiBBhIwIgMVIizN1Y6+KZ1shXFFZrcl9RH8S7fYrYFQ
        mA1ITUZfajCi23dyDQmYkUc=
X-Google-Smtp-Source: AKy350a4OUaB8U3RXGO0IJFLwwi94/rajBKgQRkubQCeEkS6MIJLn4Av7IArzAqs7pGwYlmdYLglgQ==
X-Received: by 2002:a5d:4b04:0:b0:2d7:67bc:344a with SMTP id v4-20020a5d4b04000000b002d767bc344amr12730689wrq.37.1679988920020;
        Tue, 28 Mar 2023 00:35:20 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id u11-20020a05600c00cb00b003ef64affec7sm9717940wmm.22.2023.03.28.00.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 00:35:19 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 2/2] xfs: don't reuse busy extents on extent trim
Date:   Tue, 28 Mar 2023 10:35:12 +0300
Message-Id: <20230328073512.460533-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230328073512.460533-1-amir73il@gmail.com>
References: <20230328073512.460533-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
---
 fs/xfs/xfs_extent_busy.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 5c2695a42de1..a4075685d9eb 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -344,7 +344,6 @@ xfs_extent_busy_trim(
 	ASSERT(*len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
-restart:
 	fbno = *bno;
 	flen = *len;
 	rbp = args->pag->pagb_tree.rb_node;
@@ -363,19 +362,6 @@ xfs_extent_busy_trim(
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
 
-- 
2.34.1

