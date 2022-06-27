Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FAE55D3B1
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiF0GrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiF0GrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:47:17 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5661755AE;
        Sun, 26 Jun 2022 23:47:13 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q5so6197115wrc.2;
        Sun, 26 Jun 2022 23:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SO7FU+0OUbBLhswG2cCvyF6AplpoM05NubU1LyceI0s=;
        b=mB+Dk5HoCM8GSi0Pk6tHfqxwB8Rw2LWF94N5aWCIB1j+lTNVq669gBvf0ncIZM5MnU
         5MbAMMsPjjOF7NjgKkPY5pLqfQfoVCP3g6iQjeE0G0ZZ53LD9yynboR/rHK6wH4chYNI
         MNC8uIS7N1OQIvAG0QLLcFvvPwzDMd8s8Gxf0rbFuXKuckgAI52TykZq5AezG6dJZdre
         qqposgLLheFq/TmEKJKxDbOPbw6Vjoff0A1d1xBBOqx8+6vpPKek+Hjgn370f2QC6Bk9
         XW91B11uCjXWbj03i821AFXl+uRpIw7HzT9dqq3T/l8KueQTFvHBVvLTiLF7WKYiV8iO
         jY1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SO7FU+0OUbBLhswG2cCvyF6AplpoM05NubU1LyceI0s=;
        b=ym6td3Bgg4UTZJqW7g9rYL/5kfNifvQzE8fArlvMI8hBTZgk2a/KzNx2AXfk/EVaFm
         5w67jq/nbZaeW8TB154l1hNGmXnF/RIfVi6r1d/dR/0qBshawT5DjvbuBotmeST3lSaJ
         l5P2LXJj8tYg1wIwHGwS9KdsZZCD1qdnG8KMwUnyEFVKznuCU8Y9kSA0B/3ecX8ldJsU
         Axcu0G4wHf6F3r//bmA+Dyn0h/ojxXKu7dO/Pmmi1QX9r1VjW/IpgDeCv0QnPHHyJ3Ep
         asF8m7WSuBVHz9m7TPKV16MbaxCmQIduAqp+NH5g6RXQEioInbGWkUrcQ5f2XOg5Gl4E
         ISsg==
X-Gm-Message-State: AJIora/uQeh3bWoZWVO8PGnB+5McKx9l7umSB22PuZfT39JESN4Rf9+2
        wo6UgC9cYKaPE6QoYQQuqdg=
X-Google-Smtp-Source: AGRyM1sagRbZHEDsAEcFY7xzT8iSk1jMz2VZCNBuu0VvxbG/WBJwA2b29SacKiIZoXr9VyGb+8UG0w==
X-Received: by 2002:a5d:4522:0:b0:21b:aeac:d799 with SMTP id j2-20020a5d4522000000b0021baeacd799mr10512882wra.587.1656312431680;
        Sun, 26 Jun 2022 23:47:11 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm16460839wmq.26.2022.06.26.23.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:47:11 -0700 (PDT)
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
Subject: [PATCH v3 2/5] xfs: punch out data fork delalloc blocks on COW writeback failure
Date:   Mon, 27 Jun 2022 09:47:00 +0300
Message-Id: <20220627064703.2798133-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627064703.2798133-1-amir73il@gmail.com>
References: <20220627064703.2798133-1-amir73il@gmail.com>
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

