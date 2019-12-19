Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B49126B19
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfLSSxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfLSSxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:53:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959BA20674;
        Thu, 19 Dec 2019 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781632;
        bh=knusUoqwZQL1QLE28RvfgCLM2mj6K/kZIXYFkIBGjQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zi+maUsdq1V9KEKUSpPKcTTtK8Io/EFKW1KFFkGnYmu3ZYZWC8kzDVuIf70ecFtSG
         hVSRuLU3jVr/0PIsobAUpNMmN7BuOvr/MzX+MMBDIPxHOGaNoXgHtUUAPWWAKe3RLy
         3GisbQO1O0X+IMK7Kx6XugcR8Y/lMXPzE0/l/AKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.4 17/80] gfs2: Multi-block allocations in gfs2_page_mkwrite
Date:   Thu, 19 Dec 2019 19:34:09 +0100
Message-Id: <20191219183054.444146240@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit f53056c43063257ae4159d83c425eaeb772bcd71 upstream.

In gfs2_page_mkwrite's gfs2_allocate_page_backing helper, try to
allocate as many blocks at once as we need.  Pass in the size of the
requested allocation.

Fixes: 35af80aef99b ("gfs2: don't use buffer_heads in gfs2_allocate_page_backing")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/file.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -381,27 +381,28 @@ static void gfs2_size_hint(struct file *
 /**
  * gfs2_allocate_page_backing - Allocate blocks for a write fault
  * @page: The (locked) page to allocate backing for
+ * @length: Size of the allocation
  *
  * We try to allocate all the blocks required for the page in one go.  This
  * might fail for various reasons, so we keep trying until all the blocks to
  * back this page are allocated.  If some of the blocks are already allocated,
  * that is ok too.
  */
-static int gfs2_allocate_page_backing(struct page *page)
+static int gfs2_allocate_page_backing(struct page *page, unsigned int length)
 {
 	u64 pos = page_offset(page);
-	u64 size = PAGE_SIZE;
 
 	do {
 		struct iomap iomap = { };
 
-		if (gfs2_iomap_get_alloc(page->mapping->host, pos, 1, &iomap))
+		if (gfs2_iomap_get_alloc(page->mapping->host, pos, length, &iomap))
 			return -EIO;
 
-		iomap.length = min(iomap.length, size);
-		size -= iomap.length;
+		if (length < iomap.length)
+			iomap.length = length;
+		length -= iomap.length;
 		pos += iomap.length;
-	} while (size > 0);
+	} while (length > 0);
 
 	return 0;
 }
@@ -501,7 +502,7 @@ static vm_fault_t gfs2_page_mkwrite(stru
 	if (gfs2_is_stuffed(ip))
 		ret = gfs2_unstuff_dinode(ip, page);
 	if (ret == 0)
-		ret = gfs2_allocate_page_backing(page);
+		ret = gfs2_allocate_page_backing(page, PAGE_SIZE);
 
 out_trans_end:
 	if (ret)


