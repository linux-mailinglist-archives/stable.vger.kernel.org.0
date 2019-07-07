Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E5161706
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfGGTog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:44:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57250 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727545AbfGGTiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:08 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0006h0-Id; Sun, 07 Jul 2019 20:38:03 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0005aw-2R; Sun, 07 Jul 2019 20:38:02 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Theodore Ts'o" <tytso@mit.edu>, "yangerkun" <yangerkun@huawei.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.920702981@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 058/129] ext4: update quota information while
 swapping boot loader inode
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: yangerkun <yangerkun@huawei.com>

commit aa507b5faf38784defe49f5e64605ac3c4425e26 upstream.

While do swap between two inode, they swap i_data without update
quota information. Also, swap_inode_boot_loader can do "revert"
somtimes, so update the quota while all operations has been finished.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[bwh: Backported to 3.16:
 - Include <linux/quotaops.h>
 - dquot_initialize() does not return an erro
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -14,6 +14,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/file.h>
+#include <linux/quotaops.h>
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
@@ -66,9 +67,6 @@ static void swap_inode_data(struct inode
 
 	memswap(&inode1->i_version, &inode2->i_version,
 		  sizeof(inode1->i_version));
-	memswap(&inode1->i_blocks, &inode2->i_blocks,
-		  sizeof(inode1->i_blocks));
-	memswap(&inode1->i_bytes, &inode2->i_bytes, sizeof(inode1->i_bytes));
 	memswap(&inode1->i_atime, &inode2->i_atime, sizeof(inode1->i_atime));
 	memswap(&inode1->i_mtime, &inode2->i_mtime, sizeof(inode1->i_mtime));
 
@@ -117,6 +115,9 @@ static long swap_inode_boot_loader(struc
 	struct inode *inode_bl;
 	struct ext4_inode_info *ei_bl;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	qsize_t size, size_bl, diff;
+	blkcnt_t blocks;
+	unsigned short bytes;
 
 	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
 	if (IS_ERR(inode_bl))
@@ -179,6 +180,11 @@ static long swap_inode_boot_loader(struc
 			memset(ei_bl->i_data, 0, sizeof(ei_bl->i_data));
 	}
 
+	dquot_initialize(inode);
+
+	size = (qsize_t)(inode->i_blocks) * (1 << 9) + inode->i_bytes;
+	size_bl = (qsize_t)(inode_bl->i_blocks) * (1 << 9) + inode_bl->i_bytes;
+	diff = size - size_bl;
 	swap_inode_data(inode, inode_bl);
 
 	inode->i_ctime = inode_bl->i_ctime = ext4_current_time(inode);
@@ -194,24 +200,46 @@ static long swap_inode_boot_loader(struc
 
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err < 0) {
+		/* No need to update quota information. */
 		ext4_warning(inode->i_sb,
 			"couldn't mark inode #%lu dirty (err %d)",
 			inode->i_ino, err);
 		/* Revert all changes: */
 		swap_inode_data(inode, inode_bl);
 		ext4_mark_inode_dirty(handle, inode);
-	} else {
-		err = ext4_mark_inode_dirty(handle, inode_bl);
-		if (err < 0) {
-			ext4_warning(inode_bl->i_sb,
-				"couldn't mark inode #%lu dirty (err %d)",
-				inode_bl->i_ino, err);
-			/* Revert all changes: */
-			swap_inode_data(inode, inode_bl);
-			ext4_mark_inode_dirty(handle, inode);
-			ext4_mark_inode_dirty(handle, inode_bl);
-		}
+		goto err_out1;
 	}
+
+	blocks = inode_bl->i_blocks;
+	bytes = inode_bl->i_bytes;
+	inode_bl->i_blocks = inode->i_blocks;
+	inode_bl->i_bytes = inode->i_bytes;
+	err = ext4_mark_inode_dirty(handle, inode_bl);
+	if (err < 0) {
+		/* No need to update quota information. */
+		ext4_warning(inode_bl->i_sb,
+			"couldn't mark inode #%lu dirty (err %d)",
+			inode_bl->i_ino, err);
+		goto revert;
+	}
+
+	/* Bootloader inode should not be counted into quota information. */
+	if (diff > 0)
+		dquot_free_space(inode, diff);
+	else
+		err = dquot_alloc_space(inode, -1 * diff);
+
+	if (err < 0) {
+revert:
+		/* Revert all changes: */
+		inode_bl->i_blocks = blocks;
+		inode_bl->i_bytes = bytes;
+		swap_inode_data(inode, inode_bl);
+		ext4_mark_inode_dirty(handle, inode);
+		ext4_mark_inode_dirty(handle, inode_bl);
+	}
+
+err_out1:
 	ext4_journal_stop(handle);
 	ext4_double_up_write_data_sem(inode, inode_bl);
 

