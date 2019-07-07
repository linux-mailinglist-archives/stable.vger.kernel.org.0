Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E28E616DF
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfGGTiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57336 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727557AbfGGTiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:09 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0006gp-F0; Sun, 07 Jul 2019 20:38:03 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0005ar-0O; Sun, 07 Jul 2019 20:38:02 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Theodore Ts'o" <tytso@mit.edu>, "yangerkun" <yangerkun@huawei.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.661866988@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 057/129] ext4: fix check of inode in swap_inode_boot_loader
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

commit 67a11611e1a5211f6569044fbf8150875764d1d0 upstream.

Before really do swap between inode and boot inode, something need to
check to avoid invalid or not permitted operation, like does this inode
has inline data. But the condition check should be protected by inode
lock to avoid change while swapping. Also some other condition will not
change between swapping, but there has no problem to do this under inode
lock.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[bwh: Backported to 3.16: There's no support or test for filesytem encryption]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/ioctl.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -118,15 +118,6 @@ static long swap_inode_boot_loader(struc
 	struct ext4_inode_info *ei_bl;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
-	    IS_SWAPFILE(inode) ||
-	    ext4_has_inline_data(inode))
-		return -EINVAL;
-
-	if (IS_RDONLY(inode) || IS_APPEND(inode) || IS_IMMUTABLE(inode) ||
-	    !inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
 	if (IS_ERR(inode_bl))
 		return PTR_ERR(inode_bl);
@@ -139,6 +130,19 @@ static long swap_inode_boot_loader(struc
 	 * that only 1 swap_inode_boot_loader is running. */
 	lock_two_nondirectories(inode, inode_bl);
 
+	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
+	    IS_SWAPFILE(inode) ||
+	    ext4_has_inline_data(inode)) {
+		err = -EINVAL;
+		goto journal_err_out;
+	}
+
+	if (IS_RDONLY(inode) || IS_APPEND(inode) || IS_IMMUTABLE(inode) ||
+	    !inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto journal_err_out;
+	}
+
 	/* Wait for all existing dio workers */
 	ext4_inode_block_unlocked_dio(inode);
 	ext4_inode_block_unlocked_dio(inode_bl);

