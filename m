Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86371AA21B
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370434AbgDOMut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408919AbgDOLmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:42:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E63320775;
        Wed, 15 Apr 2020 11:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950970;
        bh=JTDIwijcZwHGMxB9O0aoixYI7r3ZtbL2U0goW3aJfk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+Y4i3ijZL3asZQ/EA+QxL0VtKrNcOegJvwBcpvkTkeRXukhm4uRL/FSa/zfIWEHb
         08gT/arsTBryYUh9mc3wK5OHFMx9Vt620no/j0GArPdR7gCcUHP+7tQRKk53M05QR5
         sr+oDD/ZQvBsoMICA2Ig3cW0G2V+jiEWaEjrlFbg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tommi Rantala <tommi.t.rantala@nokia.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 019/106] xfs: fix regression in "cleanup xfs_dir2_block_getdents"
Date:   Wed, 15 Apr 2020 07:40:59 -0400
Message-Id: <20200415114226.13103-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

[ Upstream commit 3d28e7e278913a267b1de360efcd5e5274065ce2 ]

Commit 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents") introduced
a getdents regression, when it converted the pointer arithmetics to
offset calculations: offset is updated in the loop already for the next
iteration, but the updated offset value is used incorrectly in two
places, where we should have used the not-yet-updated value.

This caused for example "git clean -ffdx" failures to cleanup certain
directory structures when running in a container.

Fix the regression by making sure we use proper offset in the loop body.
Thanks to Christoph Hellwig for suggestion how to best fix the code.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_dir2_readdir.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 0d3b640cf1cce..871ec22c9aee9 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -147,7 +147,7 @@ xfs_dir2_block_getdents(
 	xfs_off_t		cook;
 	struct xfs_da_geometry	*geo = args->geo;
 	int			lock_mode;
-	unsigned int		offset;
+	unsigned int		offset, next_offset;
 	unsigned int		end;
 
 	/*
@@ -173,9 +173,10 @@ xfs_dir2_block_getdents(
 	 * Loop over the data portion of the block.
 	 * Each object is a real entry (dep) or an unused one (dup).
 	 */
-	offset = geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
-	while (offset < end) {
+	for (offset = geo->data_entry_offset;
+	     offset < end;
+	     offset = next_offset) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
 		uint8_t filetype;
@@ -184,14 +185,15 @@ xfs_dir2_block_getdents(
 		 * Unused, skip it.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			offset += be16_to_cpu(dup->length);
+			next_offset = offset + be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/*
 		 * Bump pointer for the next iteration.
 		 */
-		offset += xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
+		next_offset = offset +
+			xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
 
 		/*
 		 * The entry is before the desired starting point, skip it.
-- 
2.20.1

