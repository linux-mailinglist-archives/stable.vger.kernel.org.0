Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD9647B068
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbhLTPhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:37:18 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37480 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231516AbhLTPhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:37:17 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1BKFb5la004483
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 10:37:05 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4968C15C33AF; Mon, 20 Dec 2021 10:37:05 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 5.10 2/3] ext4: check for out-of-order index extents in ext4_valid_extent_entries()
Date:   Mon, 20 Dec 2021 10:36:58 -0500
Message-Id: <20211220153659.2120506-3-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20211220153659.2120506-1-tytso@mit.edu>
References: <20211220153659.2120506-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

Commit 8dd27fecede55e8a4e67eef2878040ecad0f0d33 upstream.

After commit 5946d089379a ("ext4: check for overlapping extents in
ext4_valid_extent_entries()"), we can check out the overlapping extent
entry in leaf extent blocks. But the out-of-order extent entry in index
extent blocks could also trigger bad things if the filesystem is
inconsistent. So this patch add a check to figure out the out-of-order
index extents and return error.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210908120850.4012324-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f2e569e9701d..35648dc3ff50 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -369,6 +369,9 @@ static int ext4_valid_extent_entries(struct inode *inode,
 				     ext4_fsblk_t *pblk, int depth)
 {
 	unsigned short entries;
+	ext4_lblk_t lblock = 0;
+	ext4_lblk_t prev = 0;
+
 	if (eh->eh_entries == 0)
 		return 1;
 
@@ -377,31 +380,35 @@ static int ext4_valid_extent_entries(struct inode *inode,
 	if (depth == 0) {
 		/* leaf entries */
 		struct ext4_extent *ext = EXT_FIRST_EXTENT(eh);
-		ext4_lblk_t lblock = 0;
-		ext4_lblk_t prev = 0;
-		int len = 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
 
 			/* Check for overlapping extents */
 			lblock = le32_to_cpu(ext->ee_block);
-			len = ext4_ext_get_actual_len(ext);
 			if ((lblock <= prev) && prev) {
 				*pblk = ext4_ext_pblock(ext);
 				return 0;
 			}
+			prev = lblock + ext4_ext_get_actual_len(ext) - 1;
 			ext++;
 			entries--;
-			prev = lblock + len - 1;
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx = EXT_FIRST_INDEX(eh);
 		while (entries) {
 			if (!ext4_valid_extent_idx(inode, ext_idx))
 				return 0;
+
+			/* Check for overlapping index extents */
+			lblock = le32_to_cpu(ext_idx->ei_block);
+			if ((lblock <= prev) && prev) {
+				*pblk = ext4_idx_pblock(ext_idx);
+				return 0;
+			}
 			ext_idx++;
 			entries--;
+			prev = lblock;
 		}
 	}
 	return 1;
-- 
2.31.0

