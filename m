Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4032C1B3F2D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgDVKfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbgDVKXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:23:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674CF20776;
        Wed, 22 Apr 2020 10:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551014;
        bh=JTDIwijcZwHGMxB9O0aoixYI7r3ZtbL2U0goW3aJfk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uh2Xni0b88S0EFeU3e95+ZQVMqf/sm+pn7ADna7ZqCKqyUFdKtz0xgpNlTalZFbLm
         b8MfOuQkRdJid7AhyzE7pm/iY7jSvDuhV1SrCxyiEsrLO3ogY9bV1IdLpBFRr4JVY1
         ryDmWwOVZilVhDQyiN5hBOIr7RGAblDzC67wSJZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Tommi Rantala <tommi.t.rantala@nokia.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 064/166] xfs: fix regression in "cleanup xfs_dir2_block_getdents"
Date:   Wed, 22 Apr 2020 11:56:31 +0200
Message-Id: <20200422095055.718696569@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



