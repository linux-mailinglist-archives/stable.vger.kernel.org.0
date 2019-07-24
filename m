Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFDF73CA6
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405117AbfGXUKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404993AbfGXT6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:58:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B09722ADC;
        Wed, 24 Jul 2019 19:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998327;
        bh=8+TBomzxAkcDXL5UogI8Nir1ASwsrKUsND8Gix3C+L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9Zz4+dk33mBGvumk1q7nKaLuZX7O5dZ8ImliF64W7FD1J/y5uwoQLRmTxIdtOgXw
         egTeNUpDE5TDOx+/xznh3pm//gFbCum1rTYUmhX5hefpCXHfx4S9mAppdIwZ+0bytL
         nvZzC/8Q3XHS2SawImBc2fyASzgW1wU2rlCn/aAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 326/371] block: Allow mapping of vmalloc-ed buffers
Date:   Wed, 24 Jul 2019 21:21:18 +0200
Message-Id: <20190724191748.387204624@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit b4c5875d36178e8df409bdce232f270cac89fafe upstream.

To allow the SCSI subsystem scsi_execute_req() function to issue
requests using large buffers that are better allocated with vmalloc()
rather than kmalloc(), modify bio_map_kern() to allow passing a buffer
allocated with vmalloc().

To do so, detect vmalloc-ed buffers using is_vmalloc_addr(). For
vmalloc-ed buffers, flush the buffer using flush_kernel_vmap_range(),
use vmalloc_to_page() instead of virt_to_page() to obtain the pages of
the buffer, and invalidate the buffer addresses with
invalidate_kernel_vmap_range() on completion of read BIOs. This last
point is executed using the function bio_invalidate_vmalloc_pages()
which is defined only if the architecture defines
ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE, that is, if the architecture
actually needs the invalidation done.

Fixes: 515ce6061312 ("scsi: sd_zbc: Fix sd_zbc_report_zones() buffer allocation")
Fixes: e76239a3748c ("block: add a report_zones method")
Cc: stable@vger.kernel.org
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bio.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -29,6 +29,7 @@
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
 #include <linux/blk-cgroup.h>
+#include <linux/highmem.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1475,8 +1476,22 @@ void bio_unmap_user(struct bio *bio)
 	bio_put(bio);
 }
 
+static void bio_invalidate_vmalloc_pages(struct bio *bio)
+{
+#ifdef ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
+	if (bio->bi_private && !op_is_write(bio_op(bio))) {
+		unsigned long i, len = 0;
+
+		for (i = 0; i < bio->bi_vcnt; i++)
+			len += bio->bi_io_vec[i].bv_len;
+		invalidate_kernel_vmap_range(bio->bi_private, len);
+	}
+#endif
+}
+
 static void bio_map_kern_endio(struct bio *bio)
 {
+	bio_invalidate_vmalloc_pages(bio);
 	bio_put(bio);
 }
 
@@ -1497,6 +1512,8 @@ struct bio *bio_map_kern(struct request_
 	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned long start = kaddr >> PAGE_SHIFT;
 	const int nr_pages = end - start;
+	bool is_vmalloc = is_vmalloc_addr(data);
+	struct page *page;
 	int offset, i;
 	struct bio *bio;
 
@@ -1504,6 +1521,11 @@ struct bio *bio_map_kern(struct request_
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
+	if (is_vmalloc) {
+		flush_kernel_vmap_range(data, len);
+		bio->bi_private = data;
+	}
+
 	offset = offset_in_page(kaddr);
 	for (i = 0; i < nr_pages; i++) {
 		unsigned int bytes = PAGE_SIZE - offset;
@@ -1514,7 +1536,11 @@ struct bio *bio_map_kern(struct request_
 		if (bytes > len)
 			bytes = len;
 
-		if (bio_add_pc_page(q, bio, virt_to_page(data), bytes,
+		if (!is_vmalloc)
+			page = virt_to_page(data);
+		else
+			page = vmalloc_to_page(data);
+		if (bio_add_pc_page(q, bio, page, bytes,
 				    offset) < bytes) {
 			/* we don't support partial mappings */
 			bio_put(bio);


