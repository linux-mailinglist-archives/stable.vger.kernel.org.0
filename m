Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F6055CFFE
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiF0GwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiF0GwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:52:02 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12572661;
        Sun, 26 Jun 2022 23:52:01 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so969269wmb.3;
        Sun, 26 Jun 2022 23:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SO7FU+0OUbBLhswG2cCvyF6AplpoM05NubU1LyceI0s=;
        b=LNfuVhn54ss15M6eP02Daut2II42b5qXdXLr24a5w/2KxR+6lrmuJxIg4S/l5zo7J5
         xArOxeL+6X08NRMJZNy4wO0zrbMPsx8QjU9dqN3SMuNy4tKWyVN3jFKwbhuGoVn3EmoA
         VrQcRNCzqFDkXr6Ua9GufngivwWt0JWib4QQS0UPwX42gtHoGas6J0EC1JqN7GAsQxda
         PWF25idYpfp6e2A/Sdkl2Ez055DhWN5hbPUa4ZQglgl45JiGcNNkGukawQlhhFu3Jihb
         WLLY8FzKqQvBWmTZF786HNXJ0uOqrNkO04NlOoxQuqZ3ozstHazn/Q3O0CK/zp8kJ3l+
         g09g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SO7FU+0OUbBLhswG2cCvyF6AplpoM05NubU1LyceI0s=;
        b=lxceNzGpShxl7keneSecldmZeor24Y1FOjAV8yMkNS4tTUN8UVNyZPzlGoPheqsB/O
         dimuUcOxlQQLKnXgPlUYhz97m+KtVWb9xXXus9SWVzt8qfeikcwNHS4JQLfBUcmo2vVj
         W1WbGtlIiLSNwHHkxWTTU2idEgFEwhX0l2N/xG4NrpCc6i2Rd/+jd5eCxu9f9rJ3BkhD
         jrXToxJxM+/0XmDjV4bn8FgpHe19NKnI0c+At8Cg12cf9jQmL4y7EJGUSZmmQDHX0rDO
         KOZqyvXBsjk0bEgzCklCZ0S+II3dfaoQbTITsETLfPyoJRBrVvnTkvGr8tWaV041Cvv6
         IoYw==
X-Gm-Message-State: AJIora8KimzA2+OSCHxScBR/vGBCS1sUvPunbkIgrl1JOmqathcdKWFD
        Tq5TvS4Kn6BJpzLumj8h8ZwRIS50Ym//0Q==
X-Google-Smtp-Source: AGRyM1uHbrDCrzZ2cbhxIdC2uPc2kG6G82WvgoG1/f/WeNFZo1kfS9FQ39K6oqdwDVSJm41W9WCyXA==
X-Received: by 2002:a05:600c:214c:b0:3a0:401a:6f4b with SMTP id v12-20020a05600c214c00b003a0401a6f4bmr12395850wml.15.1656312720474;
        Sun, 26 Jun 2022 23:52:00 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id e10-20020adffd0a000000b0021a3dd1c5d5sm9415076wrr.96.2022.06.26.23.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:52:00 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 v4 2/5] xfs: punch out data fork delalloc blocks on COW writeback failure
Date:   Mon, 27 Jun 2022 09:51:37 +0300
Message-Id: <20220627065140.2798412-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627065140.2798412-1-amir73il@gmail.com>
References: <20220627065140.2798412-1-amir73il@gmail.com>
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

commit 5ca5916b6bc93577c360c06cb7cdf71adb9b5faf upstream.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4304c6416fbb..4b76a32d2f16 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -145,6 +145,7 @@ xfs_end_ioend(
 	struct iomap_ioend	*ioend)
 {
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 	unsigned int		nofs_flag;
@@ -160,18 +161,26 @@ xfs_end_ioend(
 	/*
 	 * Just clean up the in-memory strutures if the fs has been shut down.
 	 */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (XFS_FORCED_SHUTDOWN(mp)) {
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
2.25.1

