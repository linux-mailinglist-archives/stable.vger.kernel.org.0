Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65F129C048
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817131AbgJ0RNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784489AbgJ0O7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B2722264;
        Tue, 27 Oct 2020 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810750;
        bh=F9YLbQ7d6XA/72vF+miC17GBj9k7XMq2X/J7Q/+oMjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9cE1H8Sd+jDF7wb2hbPEnjpkuS+50imgy0YSrMN/2waOveN/XkZoAgpaj/4XsUco
         hzzOhUKlg8HPCyFvYpKhkJyjg1UtzZuN8eAGCu8dROkhJhOyFuJXL1+pLE/alKzVDN
         AQfndFR20SffAjOnVyXlHdflr7Unx3uzRJ0G6VOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 209/633] iomap: Clear page error before beginning a write
Date:   Tue, 27 Oct 2020 14:49:12 +0100
Message-Id: <20201027135532.484255852@linuxfoundation.org>
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

[ Upstream commit e6e7ca92623a43156100306861272e04d46385fc ]

If we find a page in write_begin which is !Uptodate, we need
to clear any error on the page before starting to read data
into it.  This matches how filemap_fault(), do_read_cache_page()
and generic_file_buffered_read() handle PageError on !Uptodate pages.
When calling iomap_set_range_uptodate() in __iomap_write_begin(), blocks
were not being marked as uptodate.

This was found with generic/127 and a specially modified kernel which
would fail (some) readahead I/Os.  The test read some bytes in a prior
page which caused readahead to extend into page 0x34.  There was
a subsequent write to page 0x34, followed by a read to page 0x34.
Because the blocks were still marked as !Uptodate, the read caused all
blocks to be re-read, overwriting the write.  With this change, and the
next one, the bytes which were written are marked as being Uptodate, so
even though the page is still marked as !Uptodate, the blocks containing
the written data are not re-read from storage.

Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index bcfc288dba3fb..c95454784df48 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -578,6 +578,7 @@ __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, int flags,
 
 	if (PageUptodate(page))
 		return 0;
+	ClearPageError(page);
 
 	do {
 		iomap_adjust_read_range(inode, iop, &block_start,
-- 
2.25.1



