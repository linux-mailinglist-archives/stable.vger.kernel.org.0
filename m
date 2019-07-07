Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5218861725
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfGGTpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:45:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57082 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727517AbfGGTiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:05 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0006fz-1W; Sun, 07 Jul 2019 20:38:02 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz2-0005Za-RS; Sun, 07 Jul 2019 20:38:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jan Kara" <jack@suse.cz>, "yangerkun" <yangerkun@huawei.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.826051651@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 041/129] ext2: Fix underflow in ext2_max_size()
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

From: Jan Kara <jack@suse.cz>

commit 1c2d14212b15a60300a2d4f6364753e87394c521 upstream.

When ext2 filesystem is created with 64k block size, ext2_max_size()
will return value less than 0. Also, we cannot write any file in this fs
since the sb->maxbytes is less than 0. The core of the problem is that
the size of block index tree for such large block size is more than
i_blocks can carry. So fix the computation to count with this
possibility.

File size limits computed with the new function for the full range of
possible block sizes look like:

bits file_size
10     17247252480
11    275415851008
12   2196873666560
13   2197948973056
14   2198486220800
15   2198754754560
16   2198888906752

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext2/super.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -701,7 +701,8 @@ static loff_t ext2_max_size(int bits)
 {
 	loff_t res = EXT2_NDIR_BLOCKS;
 	int meta_blocks;
-	loff_t upper_limit;
+	unsigned int upper_limit;
+	unsigned int ppb = 1 << (bits-2);
 
 	/* This is calculated to be the largest file size for a
 	 * dense, file such that the total number of
@@ -715,24 +716,34 @@ static loff_t ext2_max_size(int bits)
 	/* total blocks in file system block size */
 	upper_limit >>= (bits - 9);
 
-
-	/* indirect blocks */
-	meta_blocks = 1;
-	/* double indirect blocks */
-	meta_blocks += 1 + (1LL << (bits-2));
-	/* tripple indirect blocks */
-	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
-
-	upper_limit -= meta_blocks;
-	upper_limit <<= bits;
-
+	/* Compute how many blocks we can address by block tree */
 	res += 1LL << (bits-2);
 	res += 1LL << (2*(bits-2));
 	res += 1LL << (3*(bits-2));
+	/* Does block tree limit file size? */
+	if (res < upper_limit)
+		goto check_lfs;
+
+	res = upper_limit;
+	/* How many metadata blocks are needed for addressing upper_limit? */
+	upper_limit -= EXT2_NDIR_BLOCKS;
+	/* indirect blocks */
+	meta_blocks = 1;
+	upper_limit -= ppb;
+	/* double indirect blocks */
+	if (upper_limit < ppb * ppb) {
+		meta_blocks += 1 + DIV_ROUND_UP(upper_limit, ppb);
+		res -= meta_blocks;
+		goto check_lfs;
+	}
+	meta_blocks += 1 + ppb;
+	upper_limit -= ppb * ppb;
+	/* tripple indirect blocks for the rest */
+	meta_blocks += 1 + DIV_ROUND_UP(upper_limit, ppb) +
+		DIV_ROUND_UP(upper_limit, ppb*ppb);
+	res -= meta_blocks;
+check_lfs:
 	res <<= bits;
-	if (res > upper_limit)
-		res = upper_limit;
-
 	if (res > MAX_LFS_FILESIZE)
 		res = MAX_LFS_FILESIZE;
 

