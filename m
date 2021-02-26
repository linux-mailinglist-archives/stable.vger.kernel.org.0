Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B101B32603A
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 10:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhBZJir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 04:38:47 -0500
Received: from first.geanix.com ([116.203.34.67]:34444 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhBZJi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 04:38:29 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2021 04:38:27 EST
Received: from zen.. (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id 3BA0210234E1;
        Fri, 26 Feb 2021 09:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1614331794; bh=vcrmu95vnJRJusz0UYr/l1XS/6bCR87a3Z2nnZWR1ME=;
        h=From:To:Cc:Subject:Date;
        b=cJhtUC6/dYjkxU4y+B79V0P2IOMKu1xcgHE5AYLQkoCIzwjvL8EMz25FEiaTmSCt6
         2jgKTxJI1XN3ya6Zrx22Uom2W0vpsaI/W8f+1B/K20rtdvxMdgU9kBEp/t8qmS+iSn
         VIEbP3ja4BEe552iertDMbVH2cmhvSH2itu8HXXYfDhrZ1hDAby9NrXYiIPbDM8xLx
         pWbEcjiLY+YAfNxlxelsyiwZAeBXfRbm87oVMMmbzHBmEztqUpuLzlqHZCBazfDvgV
         +ne0doLVUl9hgGct/Dn2z2ykVc/fF7Yo/G5cJP0Bi4Uodd7Xm0S5V2y7dLM48TJRWm
         MYB92YqjH1GRQ==
From:   Sean Nyekjaer <sean@geanix.com>
To:     Phillip Lougher <phillip@squashfs.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Sean Nyekjaer <sean@geanix.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] squashfs: fix inode lookup sanity checks
Date:   Fri, 26 Feb 2021 10:29:03 +0100
Message-Id: <20210226092903.1473545-1-sean@geanix.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When mouting a squashfs image created without inode compression it
fails with: "unable to read inode lookup table"

It turns out that the BLOCK_OFFSET is missing when checking
the SQUASHFS_METADATA_SIZE agaist the actual size.

Fixes: eabac19e40c0 ("squashfs: add more sanity checks in inode lookup")
CC: stable@vger.kernel.org
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
---
 fs/squashfs/export.c      | 8 ++++++--
 fs/squashfs/squashfs_fs.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
index eb02072d28dd..723763746238 100644
--- a/fs/squashfs/export.c
+++ b/fs/squashfs/export.c
@@ -152,14 +152,18 @@ __le64 *squashfs_read_inode_lookup_table(struct super_block *sb,
 		start = le64_to_cpu(table[n]);
 		end = le64_to_cpu(table[n + 1]);
 
-		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+		if (start >= end
+		    || (end - start) >
+		    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 			kfree(table);
 			return ERR_PTR(-EINVAL);
 		}
 	}
 
 	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= lookup_table_start || (lookup_table_start - start) > SQUASHFS_METADATA_SIZE) {
+	if (start >= lookup_table_start ||
+	    (lookup_table_start - start) >
+	    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index 8d64edb80ebf..b3fdc8212c5f 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -17,6 +17,7 @@
 
 /* size of metadata (inode and directory) blocks */
 #define SQUASHFS_METADATA_SIZE		8192
+#define SQUASHFS_BLOCK_OFFSET		2
 
 /* default size of block device I/O */
 #ifdef CONFIG_SQUASHFS_4K_DEVBLK_SIZE
-- 
2.29.2

