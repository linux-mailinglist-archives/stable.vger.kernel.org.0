Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D6540E7CF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344960AbhIPRgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353449AbhIPRdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D631061A71;
        Thu, 16 Sep 2021 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810903;
        bh=57tZxUZd7v0GCY6kUSgZ3vGo5+VQ9Riqq6db6pSfRmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIlXEm6xOVgRf5Bn8B9cWSod9zn3nqymJLxSc0i+QuTaRLtryfCMID+6m6LQnefGv
         GcmckKhZbR+DsDR+leQsEwzIIj14xrq1Z3/KetanFZTO/ym8/TlW9tXQmoZ2ffE5gY
         RoAvx3thcsUNldNnIhvgzIBVtJKUHPQgSpvI9ApY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 311/432] iomap: pass writeback errors to the mapping
Date:   Thu, 16 Sep 2021 18:01:00 +0200
Message-Id: <20210916155821.364409662@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index 87ccb3438bec..b06138c6190b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1016,7 +1016,7 @@ iomap_finish_page_writeback(struct inode *inode, struct page *page,
 
 	if (error) {
 		SetPageError(page);
-		mapping_set_error(inode->i_mapping, -EIO);
+		mapping_set_error(inode->i_mapping, error);
 	}
 
 	WARN_ON_ONCE(i_blocks_per_page(inode, page) > 1 && !iop);
-- 
2.30.2



