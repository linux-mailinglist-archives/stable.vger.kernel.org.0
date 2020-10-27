Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6466329B0CC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901451AbgJ0OXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901439AbgJ0OXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:23:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A75F2072D;
        Tue, 27 Oct 2020 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808627;
        bh=yZCN1zWt+EOsOEH9do1Yu25eQJ98pM3OpKqQUBzaL2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kldFhf3s0XE48mO3+dD21VW0xmoIQgS0sECjExJiIs6cmftsmZr9b3WS50nreYb37
         6awK0gG8d2EDcqTMKTl3jZVisrPEyhVNQOTtlij0lnk0JscMJzs2+xzVTaTHmjYhXo
         91OteXAfjBcH1mynrjWGAHcDXt5h9a6OokmiQenw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/264] ramfs: fix nommu mmap with gaps in the page cache
Date:   Tue, 27 Oct 2020 14:53:41 +0100
Message-Id: <20201027135438.337776272@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 50b7d85680086126d7bd91dae81d57d4cb1ab6b7 ]

ramfs needs to check that pages are both physically contiguous and
contiguous in the file.  If the page cache happens to have, eg, page A for
index 0 of the file, no page for index 1, and page A+1 for index 2, then
an mmap of the first two pages of the file will succeed when it should
fail.

Fixes: 642fb4d1f1dd ("[PATCH] NOMMU: Provide shared-writable mmap support on ramfs")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>
Link: https://lkml.kernel.org/r/20200914122239.GO6583@casper.infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ramfs/file-nommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 3ac1f23870837..5e1ebbe639ebf 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -228,7 +228,7 @@ static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 	if (!pages)
 		goto out_free;
 
-	nr = find_get_pages(inode->i_mapping, &pgoff, lpages, pages);
+	nr = find_get_pages_contig(inode->i_mapping, pgoff, lpages, pages);
 	if (nr != lpages)
 		goto out_free_pages; /* leave if some pages were missing */
 
-- 
2.25.1



