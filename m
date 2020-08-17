Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAA52470F4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390534AbgHQSSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388368AbgHQQFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:05:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FE032063A;
        Mon, 17 Aug 2020 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680331;
        bh=4DXY1vXP3gHlxRm6MrXusWr04+KdDQZB2L/sqduC1dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEz5+yrd4yver8zUmMt0BTLX2xQrTERPDxCoOJmHAPGdo2gZ2JOIfAf4d9imBQvki
         NChdor07T2n/h2kCyeercD1GK+TJdoiwPFV8722S0ydyreLzXFpFBHLCRNxRQF0jRf
         rZ0KdqhW/xSFa3LlHjadwkU7tdw7rWMaXDxO9fmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/270] xfs: dont eat an EIO/ENOSPC writeback error when scrubbing data fork
Date:   Mon, 17 Aug 2020 17:15:28 +0200
Message-Id: <20200817143802.108023009@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit eb0efe5063bb10bcb653e4f8e92a74719c03a347 ]

The data fork scrubber calls filemap_write_and_wait to flush dirty pages
and delalloc reservations out to disk prior to checking the data fork's
extent mappings.  Unfortunately, this means that scrub can consume the
EIO/ENOSPC errors that would otherwise have stayed around in the address
space until (we hope) the writer application calls fsync to persist data
and collect errors.  The end result is that programs that wrote to a
file might never see the error code and proceed as if nothing were
wrong.

xfs_scrub is not in a position to notify file writers about the
writeback failure, and it's only here to check metadata, not file
contents.  Therefore, if writeback fails, we should stuff the error code
back into the address space so that an fsync by the writer application
can pick that up.

Fixes: 99d9d8d05da2 ("xfs: scrub inode block mappings")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/bmap.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index fa6ea6407992a..392fb4df5c127 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -45,9 +45,27 @@ xchk_setup_inode_bmap(
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
 	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
+		struct address_space	*mapping = VFS_I(sc->ip)->i_mapping;
+
 		inode_dio_wait(VFS_I(sc->ip));
-		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
-		if (error)
+
+		/*
+		 * Try to flush all incore state to disk before we examine the
+		 * space mappings for the data fork.  Leave accumulated errors
+		 * in the mapping for the writer threads to consume.
+		 *
+		 * On ENOSPC or EIO writeback errors, we continue into the
+		 * extent mapping checks because write failures do not
+		 * necessarily imply anything about the correctness of the file
+		 * metadata.  The metadata and the file data could be on
+		 * completely separate devices; a media failure might only
+		 * affect a subset of the disk, etc.  We can handle delalloc
+		 * extents in the scrubber, so leaving them in memory is fine.
+		 */
+		error = filemap_fdatawrite(mapping);
+		if (!error)
+			error = filemap_fdatawait_keep_errors(mapping);
+		if (error && (error != -ENOSPC && error != -EIO))
 			goto out;
 	}
 
-- 
2.25.1



