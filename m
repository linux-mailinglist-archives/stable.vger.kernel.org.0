Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845CC29B40E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782929AbgJ0O5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782878AbgJ0O5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:57:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9F94204FD;
        Tue, 27 Oct 2020 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810657;
        bh=NEdFkFp1HTWa8b0HGnfZPUuQLWzTa0Fb2pVQZ0f0wFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhZ+X/OIUEMGplnCRwYvG5uxHQOcgLjvyY7R4W50CIDwliJDBQBHwy/RLOHXpqfoQ
         eti27DXGFDvhvejqMY92xJxKM/lavJ0v2NTHOPteGZUmf/onRaki0d7pE+ShsS7IGe
         /wUePxq7Vqzkv0LYtO1Yqa0e5bmNOuhTUxcg1uF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 210/633] iomap: Mark read blocks uptodate in write_begin
Date:   Tue, 27 Oct 2020 14:49:13 +0100
Message-Id: <20201027135532.532477028@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 14284fedf59f1647264f4603d64418cf1fcd3eb0 ]

When bringing (portions of) a page uptodate, we were marking blocks that
were zeroed as being uptodate, but not blocks that were read from storage.

Like the previous commit, this problem was found with generic/127 and
a kernel which failed readahead I/Os.  This bug causes writes to be
silently lost when working with flaky storage.

Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index c95454784df48..897ab9a26a74c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -574,7 +574,6 @@ __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, int flags,
 	loff_t block_start = pos & ~(block_size - 1);
 	loff_t block_end = (pos + len + block_size - 1) & ~(block_size - 1);
 	unsigned from = offset_in_page(pos), to = from + len, poff, plen;
-	int status;
 
 	if (PageUptodate(page))
 		return 0;
@@ -595,14 +594,13 @@ __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, int flags,
 			if (WARN_ON_ONCE(flags & IOMAP_WRITE_F_UNSHARE))
 				return -EIO;
 			zero_user_segments(page, poff, from, to, poff + plen);
-			iomap_set_range_uptodate(page, poff, plen);
-			continue;
+		} else {
+			int status = iomap_read_page_sync(block_start, page,
+					poff, plen, srcmap);
+			if (status)
+				return status;
 		}
-
-		status = iomap_read_page_sync(block_start, page, poff, plen,
-				srcmap);
-		if (status)
-			return status;
+		iomap_set_range_uptodate(page, poff, plen);
 	} while ((block_start += plen) < block_end);
 
 	return 0;
-- 
2.25.1



