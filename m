Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBFD24F904
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgHXIqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729330AbgHXIqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:46:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31CE1204FD;
        Mon, 24 Aug 2020 08:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258775;
        bh=G/McZE4QBg9BkUHnwrJRZBU4YvBJ3uxeKAUg6szMSYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arobwEZkndPlKFrIDOpzVwXxoJS8vaXrM6Of53oyw3TEJAONFAzeC1VCxAYyxI56+
         h1/0BDro+ImiVakm8oHtrMbP3WN29WQIVN9dX9aAu6FcVpPbvmtDfDeImf6YtPq6jh
         nr5+EemXoraoaULJOw7kQr7KW2FRAIq8NUvZlAM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/107] gfs2: Improve mmap write vs. punch_hole consistency
Date:   Mon, 24 Aug 2020 10:29:37 +0200
Message-Id: <20200824082405.621982099@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 39c3a948ecf6e7b8f55f0e91a5febc924fede4d7 ]

When punching a hole in a file, use filemap_write_and_wait_range to
write back any dirty pages in the range of the hole.  As a side effect,
if the hole isn't page aligned, this marks unaligned pages at the
beginning and the end of the hole read-only.  This is required when the
block size is smaller than the page size: when those pages are written
to again after the hole punching, we must make sure that page_mkwrite is
called for those pages so that the page will be fully allocated and any
blocks turned into holes from the hole punching will be reallocated.
(If a page is writably mapped, page_mkwrite won't be called.)

Fixes xfstest generic/567.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index adbb8fef22162..4846e0c47e6af 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2442,8 +2442,16 @@ int __gfs2_punch_hole(struct file *file, loff_t offset, loff_t length)
 	struct inode *inode = file_inode(file);
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	unsigned int blocksize = i_blocksize(inode);
+	loff_t start, end;
 	int error;
 
+	start = round_down(offset, blocksize);
+	end = round_up(offset + length, blocksize) - 1;
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+
 	if (gfs2_is_jdata(ip))
 		error = gfs2_trans_begin(sdp, RES_DINODE + 2 * RES_JDATA,
 					 GFS2_JTRUNC_REVOKES);
@@ -2457,9 +2465,8 @@ int __gfs2_punch_hole(struct file *file, loff_t offset, loff_t length)
 		if (error)
 			goto out;
 	} else {
-		unsigned int start_off, end_len, blocksize;
+		unsigned int start_off, end_len;
 
-		blocksize = i_blocksize(inode);
 		start_off = offset & (blocksize - 1);
 		end_len = (offset + length) & (blocksize - 1);
 		if (start_off) {
-- 
2.25.1



