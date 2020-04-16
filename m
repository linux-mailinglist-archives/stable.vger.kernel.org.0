Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA51E1AC4A8
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441896AbgDPOCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437792AbgDPOC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:02:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12D91217D8;
        Thu, 16 Apr 2020 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045748;
        bh=DE/MUp+D9xEnl5fSXNOQCd3Xb0ffRixuxH0Cb4zLX7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sx4y+mj5WoaW/KhhJymDQdVXZTro686vMCm9dx37aWQk5UZZIRQcvwUIBJhzS06Cy
         xrZysRmqklrku+0McXnsBFa2pIS3k1hdrmXbg55kQqG7FGtVHDicVJgCHDIaFfcSG6
         zM8+/z1SOjVrPVx9FnAuX+iN12pNjANhAvYIALHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 5.6 233/254] xen/blkfront: fix memory allocation flags in blkfront_setup_indirect()
Date:   Thu, 16 Apr 2020 15:25:22 +0200
Message-Id: <20200416131354.732182370@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 3a169c0be75b59dd85d159493634870cdec6d3c4 upstream.

Commit 1d5c76e664333 ("xen-blkfront: switch kcalloc to kvcalloc for
large array allocation") didn't fix the issue it was meant to, as the
flags for allocating the memory are GFP_NOIO, which will lead the
memory allocation falling back to kmalloc().

So instead of GFP_NOIO use GFP_KERNEL and do all the memory allocation
in blkfront_setup_indirect() in a memalloc_noio_{save,restore} section.

Fixes: 1d5c76e664333 ("xen-blkfront: switch kcalloc to kvcalloc for large array allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Acked-by: Roger Pau Monné <roger.pau@citrix.com>
Link: https://lore.kernel.org/r/20200403090034.8753-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkfront.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -47,6 +47,7 @@
 #include <linux/bitmap.h>
 #include <linux/list.h>
 #include <linux/workqueue.h>
+#include <linux/sched/mm.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -2189,10 +2190,12 @@ static void blkfront_setup_discard(struc
 
 static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo)
 {
-	unsigned int psegs, grants;
+	unsigned int psegs, grants, memflags;
 	int err, i;
 	struct blkfront_info *info = rinfo->dev_info;
 
+	memflags = memalloc_noio_save();
+
 	if (info->max_indirect_segments == 0) {
 		if (!HAS_EXTRA_REQ)
 			grants = BLKIF_MAX_SEGMENTS_PER_REQUEST;
@@ -2224,7 +2227,7 @@ static int blkfront_setup_indirect(struc
 
 		BUG_ON(!list_empty(&rinfo->indirect_pages));
 		for (i = 0; i < num; i++) {
-			struct page *indirect_page = alloc_page(GFP_NOIO);
+			struct page *indirect_page = alloc_page(GFP_KERNEL);
 			if (!indirect_page)
 				goto out_of_memory;
 			list_add(&indirect_page->lru, &rinfo->indirect_pages);
@@ -2235,15 +2238,15 @@ static int blkfront_setup_indirect(struc
 		rinfo->shadow[i].grants_used =
 			kvcalloc(grants,
 				 sizeof(rinfo->shadow[i].grants_used[0]),
-				 GFP_NOIO);
+				 GFP_KERNEL);
 		rinfo->shadow[i].sg = kvcalloc(psegs,
 					       sizeof(rinfo->shadow[i].sg[0]),
-					       GFP_NOIO);
+					       GFP_KERNEL);
 		if (info->max_indirect_segments)
 			rinfo->shadow[i].indirect_grants =
 				kvcalloc(INDIRECT_GREFS(grants),
 					 sizeof(rinfo->shadow[i].indirect_grants[0]),
-					 GFP_NOIO);
+					 GFP_KERNEL);
 		if ((rinfo->shadow[i].grants_used == NULL) ||
 			(rinfo->shadow[i].sg == NULL) ||
 		     (info->max_indirect_segments &&
@@ -2252,6 +2255,7 @@ static int blkfront_setup_indirect(struc
 		sg_init_table(rinfo->shadow[i].sg, psegs);
 	}
 
+	memalloc_noio_restore(memflags);
 
 	return 0;
 
@@ -2271,6 +2275,9 @@ out_of_memory:
 			__free_page(indirect_page);
 		}
 	}
+
+	memalloc_noio_restore(memflags);
+
 	return -ENOMEM;
 }
 


