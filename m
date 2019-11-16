Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0535FFF105
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfKPPt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:49:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730279AbfKPPt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:49:27 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F160920729;
        Sat, 16 Nov 2019 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919366;
        bh=qG+GTWJUCtUCh6z1mTFgs8RZeHFD3rjOGTuiY9vZXrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoH5ejTeYuOHgczhDuUQiLnq9vc8XdDSXFe7TIJN9tXBCkTR0XyOmZSctPJz/mU0H
         nYh4L/m3iX59K1XWHCZHfW7ULcgHR4sKRx8oSL3O2EPhV7Qw+TaD+HjW6nXMHv+UU2
         55aCglAK2vJXv2TteUSwQhK30MwFtpZrH6U7LnHw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 088/150] vfs: avoid problematic remapping requests into partial EOF block
Date:   Sat, 16 Nov 2019 10:46:26 -0500
Message-Id: <20191116154729.9573-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 07d19dc9fbe9128378b9e226abe886fd8fd473df ]

A deduplication data corruption is exposed in XFS and btrfs. It is
caused by extending the block match range to include the partial EOF
block, but then allowing unknown data beyond EOF to be considered a
"match" to data in the destination file because the comparison is only
made to the end of the source file. This corrupts the destination file
when the source extent is shared with it.

The VFS remapping prep functions  only support whole block dedupe, but
we still need to appear to support whole file dedupe correctly.  Hence
if the dedupe request includes the last block of the souce file, don't
include it in the actual dedupe operation. If the rest of the range
dedupes successfully, then reject the entire request.  A subsequent
patch will enable us to shorten dedupe requests correctly.

When reflinking sub-file ranges, a data corruption can occur when the
source file range includes a partial EOF block. This shares the unknown
data beyond EOF into the second file at a position inside EOF, exposing
stale data in the second file.

If the reflink request includes the last block of the souce file, only
proceed with the reflink operation if it lands at or past the
destination file's current EOF. If it lands within the destination file
EOF, reject the entire request with -EINVAL and make the caller go the
hard way.  A subsequent patch will enable us to shorten reflink requests
correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index 38a8bcccf0dd0..e8136a72c13f3 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1709,6 +1709,34 @@ static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
 
 	return security_file_permission(file, write ? MAY_WRITE : MAY_READ);
 }
+/*
+ * Ensure that we don't remap a partial EOF block in the middle of something
+ * else.  Assume that the offsets have already been checked for block
+ * alignment.
+ *
+ * For deduplication we always scale down to the previous block because we
+ * can't meaningfully compare post-EOF contents.
+ *
+ * For clone we only link a partial EOF block above the destination file's EOF.
+ */
+static int generic_remap_check_len(struct inode *inode_in,
+				   struct inode *inode_out,
+				   loff_t pos_out,
+				   u64 *len,
+				   bool is_dedupe)
+{
+	u64 blkmask = i_blocksize(inode_in) - 1;
+
+	if ((*len & blkmask) == 0)
+		return 0;
+
+	if (is_dedupe)
+		*len &= ~blkmask;
+	else if (pos_out + *len < i_size_read(inode_out))
+		return -EINVAL;
+
+	return 0;
+}
 
 /*
  * Check that the two inodes are eligible for cloning, the ranges make
@@ -1815,6 +1843,11 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
 			return -EBADE;
 	}
 
+	ret = generic_remap_check_len(inode_in, inode_out, pos_out, len,
+			is_dedupe);
+	if (ret)
+		return ret;
+
 	return 1;
 }
 EXPORT_SYMBOL(vfs_clone_file_prep_inodes);
-- 
2.20.1

