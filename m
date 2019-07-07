Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71239616E2
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfGGTiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57254 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727547AbfGGTiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:08 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0006h3-Kg; Sun, 07 Jul 2019 20:38:03 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0005b1-5X; Sun, 07 Jul 2019 20:38:02 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "yangerkun" <yangerkun@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.291988630@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 059/129] ext4: add mask of ext4 flags to swap
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

commit abdc644e8cbac2e9b19763680e5a7cf9bab2bee7 upstream.

The reason is that while swapping two inode, we swap the flags too.
Some flags such as EXT4_JOURNAL_DATA_FL can really confuse the things
since we're not resetting the address operations structure.  The
simplest way to keep things sane is to restrict the flags that can be
swapped.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/ext4.h  | 3 +++
 fs/ext4/ioctl.c | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -405,6 +405,9 @@ struct flex_groups {
 /* Flags that are appropriate for non-directories/regular files. */
 #define EXT4_OTHER_FLMASK (EXT4_NODUMP_FL | EXT4_NOATIME_FL)
 
+/* The only flags that should be swapped */
+#define EXT4_FL_SHOULD_SWAP (EXT4_HUGE_FILE_FL | EXT4_EXTENTS_FL)
+
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
 {
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -61,6 +61,7 @@ static void swap_inode_data(struct inode
 	loff_t isize;
 	struct ext4_inode_info *ei1;
 	struct ext4_inode_info *ei2;
+	unsigned long tmp;
 
 	ei1 = EXT4_I(inode1);
 	ei2 = EXT4_I(inode2);
@@ -71,7 +72,10 @@ static void swap_inode_data(struct inode
 	memswap(&inode1->i_mtime, &inode2->i_mtime, sizeof(inode1->i_mtime));
 
 	memswap(ei1->i_data, ei2->i_data, sizeof(ei1->i_data));
-	memswap(&ei1->i_flags, &ei2->i_flags, sizeof(ei1->i_flags));
+	tmp = ei1->i_flags & EXT4_FL_SHOULD_SWAP;
+	ei1->i_flags = (ei2->i_flags & EXT4_FL_SHOULD_SWAP) |
+		(ei1->i_flags & ~EXT4_FL_SHOULD_SWAP);
+	ei2->i_flags = tmp | (ei2->i_flags & ~EXT4_FL_SHOULD_SWAP);
 	memswap(&ei1->i_disksize, &ei2->i_disksize, sizeof(ei1->i_disksize));
 	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
 	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);

