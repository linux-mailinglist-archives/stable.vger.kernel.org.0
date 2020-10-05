Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C3C283A02
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgJEPaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgJEPaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C316208C7;
        Mon,  5 Oct 2020 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911820;
        bh=jCLCaYmNYRlkJqXg9JaoNE0SovWUOxZSbB9szIoLeq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNNyXNDoIMJ5cYvKcc4h5Zi7eFFo/i66dhHJxdzGQP4Xp/0+JbRmWi6DCb/qzKSL7
         PkJXS1FOS7Et3VCNbxnAVn482oz+lTIND917k2Xb5eFMaAkZTcHBkLw6SRamD93Aa4
         7JGocoGbe92NWU/jpLUjqaAZtlQXM1e8cuJw4+b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/57] xfs: trim IO to found COW extent limit
Date:   Mon,  5 Oct 2020 17:26:22 +0200
Message-Id: <20201005142110.303121498@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>

A bug existed in the XFS reflink code between v5.1 and v5.5 in which
the mapping for a COW IO was not trimmed to the mapping of the COW
extent that was found.  This resulted in a too-short copy, and
corruption of other files which shared the original extent.

(This happened only when extent size hints were set, which bypasses
delalloc and led to this code path.)

This was (inadvertently) fixed upstream with

36adcbace24e "xfs: fill out the srcmap in iomap_begin"

and related patches which moved lots of this functionality to
the iomap subsystem.

Hence, this is a -stable only patch, targeted to fix this
corruption vector without other major code changes.

Fixes: 78f0cc9d55cb ("xfs: don't use delalloc extents for COW on files with extsize hints")
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f780e223b1185..239c9548b1568 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1002,9 +1002,15 @@ xfs_file_iomap_begin(
 		 * I/O, which must be block aligned, we need to report the
 		 * newly allocated address.  If the data fork has a hole, copy
 		 * the COW fork mapping to avoid allocating to the data fork.
+		 *
+		 * Otherwise, ensure that the imap range does not extend past
+		 * the range allocated/found in cmap.
 		 */
 		if (directio || imap.br_startblock == HOLESTARTBLOCK)
 			imap = cmap;
+		else
+			xfs_trim_extent(&imap, cmap.br_startoff,
+					cmap.br_blockcount);
 
 		end_fsb = imap.br_startoff + imap.br_blockcount;
 		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
-- 
2.25.1



