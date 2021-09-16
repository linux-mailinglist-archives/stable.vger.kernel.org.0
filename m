Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6042A40E04C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240789AbhIPQUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241093AbhIPQTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:19:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA77A6138B;
        Thu, 16 Sep 2021 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808788;
        bh=Pa/TsOTkeToUqSfDytYXPjHwWOrJDllgJUZXJA2hrxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLR/5dNTWSwaoUvqiIr8mukE5e1fciBAKZ343qrljutLQJ6Hzlq64IBTDsLel+OHI
         tFJ7TrmeOswQ4t8DYzNACYS37iY4fEfIDRcaqhVNgNK+vyew7RYBNp6RIsdzstqPkH
         tNYGjCO8BhBcaAckM8QNFWtQ8KeFZkRrYxMzCOuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/306] iomap: pass writeback errors to the mapping
Date:   Thu, 16 Sep 2021 17:59:28 +0200
Message-Id: <20210916155801.654535592@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit b69eea82d37d9ee7cfb3bf05103549dd4ed5ffc3 ]

Modern-day mapping_set_error has the ability to squash the usual
negative error code into something appropriate for long-term storage in
a struct address_space -- ENOSPC becomes AS_ENOSPC, and everything else
becomes EIO.  iomap squashes /everything/ to EIO, just as XFS did before
that, but this doesn't make sense.

Fix this by making it so that we can pass ENOSPC to userspace when
writeback fails due to space problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 10cc7979ce38..caed9d98c64a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1045,7 +1045,7 @@ iomap_finish_page_writeback(struct inode *inode, struct page *page,
 
 	if (error) {
 		SetPageError(page);
-		mapping_set_error(inode->i_mapping, -EIO);
+		mapping_set_error(inode->i_mapping, error);
 	}
 
 	WARN_ON_ONCE(i_blocks_per_page(inode, page) > 1 && !iop);
-- 
2.30.2



