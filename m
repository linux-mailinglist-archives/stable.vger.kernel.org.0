Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94733CB93E
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 17:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbhGPPFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 11:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhGPPFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 11:05:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2884C06175F;
        Fri, 16 Jul 2021 08:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=qu55q+Wr3c7nhfV+FWSDuP1bQTjuk+H0uzhdHS2+IkU=; b=MQxqwRDBGj/PAKh/l7fZFZzlSh
        1UZ0IMYIjMZueoCINAu+PJtkqnKREZjdnohgCGsI/PAC/B2ueDFZICpqBtq6LLBNpY6Xdo8T8IUW4
        /2GrIOUfDX9stzRA2FD4N8x4WR4EM+X03WV73VhDG883Q8u/ZoG9Pm/OEfZ4wJwDOKtCt5U1q4rj4
        lDuIai9pXCpu8KlGHtewBCl+kkXv34wNUJeh4n3lM5B9QPzGA7xeiRoFyvleHRsWKKmvjjLF0bVpx
        1xXWh8SesJtPYfVs1vy3z+hOQbw2PA5FpoynPThmdEVFNZBe72hE0sgdh2+9hXjUpimUBjB181Dhb
        wcWaZzrg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4PKO-004ZZS-U6; Fri, 16 Jul 2021 15:01:09 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: [PATCH] iomap: Add missing flush_dcache_page
Date:   Fri, 16 Jul 2021 16:00:32 +0100
Message-Id: <20210716150032.1089982-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Inline data needs to be flushed from the kernel's view of a page before
it's mapped by userspace.

Cc: stable@vger.kernel.org
Fixes: 19e0c58f6552 ("iomap: generic inline data handling")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 41da4f14c00b..fe60c603f4ca 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -222,6 +222,7 @@ iomap_read_inline_data(struct inode *inode, struct page *page,
 	memcpy(addr, iomap->inline_data, size);
 	memset(addr + size, 0, PAGE_SIZE - size);
 	kunmap_atomic(addr);
+	flush_dcache_page(page);
 	SetPageUptodate(page);
 }
 
-- 
2.30.2

