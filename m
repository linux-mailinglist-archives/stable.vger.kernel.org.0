Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8936F57D61B
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiGUVhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiGUVg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:36:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F49593627;
        Thu, 21 Jul 2022 14:36:55 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n10-20020a17090a670a00b001f22ebae50aso2554003pjj.3;
        Thu, 21 Jul 2022 14:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DeDcxdTOlmqO7A3fAJAdFAkkLdn51ZZV5O1v1AMigUk=;
        b=mvrNt6KI4Um0oFnMA9Zu10rm2jgtP1wVqUPaIv7fiWOHwQwpDWajLQk8RGl3xzxNPz
         WKwqHG6RUdOIz8XFPVn3F5RlfuGMwmwvYwqSaLBm6HNJNo8fC9FoxtmAMg/l3+13GNtI
         qY+F8FZFBS6G7WVL4BvkkkWr+ZGpFBL5yQiyLNqzOOAWSV4XAtE/8tJO5S5W7vNROJl3
         1d0JEiNCSnCEKJPtwtWVky6UJecC/tcCqsojqnTlvTFgryCXDHR2qNsEC0DpjMxPmwrS
         7mTBL9XmtSC0Rd2HFFXfX2Wk9nt4iTgKlDTZMZd2ACppCQ4seC4wVSJM88/EMHeiIMtV
         3uwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DeDcxdTOlmqO7A3fAJAdFAkkLdn51ZZV5O1v1AMigUk=;
        b=FSZdGWLZZGkOG6VEC2M51gW+Gu/DljdhpFrk/HWmdU/4R6Gxcg9OgndTouMkZIPegh
         JsMmPfMgq+9sBJK9vL9tIAkZmGGtqxbsZaOYf5Hpen+Eya3rmu05h8LjrFIiDF9WXc/I
         xWhi3Yao7mI5HKY16hzERQIciN3thFDxqoA0cgG8MF9gzPjjEksd9MxsqzVCe4StzUIP
         cb69Wx9yfa8uZYL2FLxe3vQe0o8fXJ4wbB34mgIsyWeebYt0SzciuBWwSHUEqn6k2fZd
         oRIvXwuBZZQS0odsUGVXLIfVIHi4ZK+zkjWzwLiRgHP4jQ8jE5AEHIdWP6z4Jz1iyFqm
         qZgg==
X-Gm-Message-State: AJIora891B5SrHfXS+q7paDirsNUUtEFIVn5Vh4XLtEE3aI2/13s6pev
        Ja66NVdo9EsQOd7EP9yzj4vg3TEBLZ7oQw==
X-Google-Smtp-Source: AGRyM1tNJjX9Exu3oHYrz9Xa6fCZQWtdy7apyMuuT/HQUtIFSVa1kx/hY6VV3Xb71KQZzOJDb+521g==
X-Received: by 2002:a17:902:6bc5:b0:16c:ea31:5934 with SMTP id m5-20020a1709026bc500b0016cea315934mr296748plt.172.1658439414362;
        Thu, 21 Jul 2022 14:36:54 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:ea45:e7f2:4e46:fc7a])
        by smtp.gmail.com with ESMTPSA id c26-20020a634e1a000000b004114cc062f0sm1919502pgb.65.2022.07.21.14.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:36:45 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 1/6] xfs: fix maxlevels comparisons in the btree staging code
Date:   Thu, 21 Jul 2022 14:36:05 -0700
Message-Id: <20220721213610.2794134-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
In-Reply-To: <20220721213610.2794134-1-leah.rumancik@gmail.com>
References: <20220721213610.2794134-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 78e8ec83a404d63dcc86b251f42e4ee8aff27465 ]

The btree geometry computation function has an off-by-one error in that
it does not allow maximally tall btrees (nlevels == XFS_BTREE_MAXLEVELS).
This can result in repairs failing unnecessarily on very fragmented
filesystems.  Subsequent patches to remove MAXLEVELS usage in favor of
the per-btree type computations will make this a much more likely
occurrence.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_staging.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index ac9e80152b5c..89c8a1498df1 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -662,7 +662,7 @@ xfs_btree_bload_compute_geometry(
 	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
 
 	bbl->nr_records = nr_this_level = nr_records;
-	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
+	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
 		uint64_t	level_blocks;
 		uint64_t	dontcare64;
 		unsigned int	level = cur->bc_nlevels - 1;
@@ -724,7 +724,7 @@ xfs_btree_bload_compute_geometry(
 		nr_this_level = level_blocks;
 	}
 
-	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
+	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;
-- 
2.37.1.359.gd136c6c3e2-goog

