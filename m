Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9DF6DB1E
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfGSEGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732340AbfGSEGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:06:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10FD1218C3;
        Fri, 19 Jul 2019 04:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509205;
        bh=Y0Q9ALJB74CP3qZ6hN9OkLmocQCROe9zoqgAJwZbTXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlpPDQshVtVGQ4Ux5ObORhqY3EjLUvI/+7dsrSpesidvbtefHaKPangG7bz9jVeDp
         W4ncSIKsJvZqV+AYjIc07XnbZ5xzZAknKKFhn2tghe8X9xoVcZ40gz7bx74t1MD3OE
         rEJkhum94NPHBrwntdz0BqBzbZhCkAxcFQ3M0VPQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.1 127/141] 9p: pass the correct prototype to read_cache_page
Date:   Fri, 19 Jul 2019 00:02:32 -0400
Message-Id: <20190719040246.15945-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit f053cbd4366051d7eb6ba1b8d529d20f719c2963 ]

Fix the callback 9p passes to read_cache_page to actually have the
proper type expected.  Casting around function pointers can easily
hide typing bugs, and defeats control flow protection.

Link: http://lkml.kernel.org/r/20190520055731.24538-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_addr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 0bcbcc20f769..02e0fc51401e 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -50,8 +50,9 @@
  * @page: structure to page
  *
  */
-static int v9fs_fid_readpage(struct p9_fid *fid, struct page *page)
+static int v9fs_fid_readpage(void *data, struct page *page)
 {
+	struct p9_fid *fid = data;
 	struct inode *inode = page->mapping->host;
 	struct bio_vec bvec = {.bv_page = page, .bv_len = PAGE_SIZE};
 	struct iov_iter to;
@@ -122,7 +123,8 @@ static int v9fs_vfs_readpages(struct file *filp, struct address_space *mapping,
 	if (ret == 0)
 		return ret;
 
-	ret = read_cache_pages(mapping, pages, (void *)v9fs_vfs_readpage, filp);
+	ret = read_cache_pages(mapping, pages, v9fs_fid_readpage,
+			filp->private_data);
 	p9_debug(P9_DEBUG_VFS, "  = %d\n", ret);
 	return ret;
 }
-- 
2.20.1

