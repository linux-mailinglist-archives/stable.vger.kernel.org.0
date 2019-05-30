Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E56B2F547
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfE3EqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbfE3DLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:48 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A22A244D1;
        Thu, 30 May 2019 03:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185907;
        bh=k0t5KQDOFfbBweh2TDKsMquyrzON3Gj9IXtzdt7R1cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNsijWRhEklZomKs8chbNOblCvLhC+laZqvuQviy4cIQ7qjQMm4+Mwo6L4tmXVItO
         jeL1ExmAlq7XtvvOMWkeemkmbKGNlo0Ibprh2xRxGZOLHuLhV03BK1iml6OfCwI6IT
         ceCwEv02M9F+U6anaPSz+MkfbGSkk6TzVEXPzjS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, Omar Sandoval <osandov@fb.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 280/405] block: pass page to xen_biovec_phys_mergeable
Date:   Wed, 29 May 2019 20:04:38 -0700
Message-Id: <20190530030555.055576682@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0383ad4374f7ad7edd925a2ee4753035c3f5508a ]

xen_biovec_phys_mergeable() only needs .bv_page of the 2nd bio bvec
for checking if the two bvecs can be merged, so pass page to
xen_biovec_phys_mergeable() directly.

No function change.

Cc: ris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: xen-devel@lists.xenproject.org
Cc: Omar Sandoval <osandov@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk.h            | 2 +-
 drivers/xen/biomerge.c | 5 +++--
 include/xen/xen.h      | 4 +++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 5d636ee416630..e27fd1512e4bb 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -75,7 +75,7 @@ static inline bool biovec_phys_mergeable(struct request_queue *q,
 
 	if (addr1 + vec1->bv_len != addr2)
 		return false;
-	if (xen_domain() && !xen_biovec_phys_mergeable(vec1, vec2))
+	if (xen_domain() && !xen_biovec_phys_mergeable(vec1, vec2->bv_page))
 		return false;
 	if ((addr1 | mask) != ((addr2 + vec2->bv_len - 1) | mask))
 		return false;
diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
index f3fbb700f5697..05a286d24f148 100644
--- a/drivers/xen/biomerge.c
+++ b/drivers/xen/biomerge.c
@@ -4,12 +4,13 @@
 #include <xen/xen.h>
 #include <xen/page.h>
 
+/* check if @page can be merged with 'vec1' */
 bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
-			       const struct bio_vec *vec2)
+			       const struct page *page)
 {
 #if XEN_PAGE_SIZE == PAGE_SIZE
 	unsigned long bfn1 = pfn_to_bfn(page_to_pfn(vec1->bv_page));
-	unsigned long bfn2 = pfn_to_bfn(page_to_pfn(vec2->bv_page));
+	unsigned long bfn2 = pfn_to_bfn(page_to_pfn(page));
 
 	return bfn1 + PFN_DOWN(vec1->bv_offset + vec1->bv_len) == bfn2;
 #else
diff --git a/include/xen/xen.h b/include/xen/xen.h
index 19d032373de5a..19a72f591e2bd 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -43,8 +43,10 @@ extern struct hvm_start_info pvh_start_info;
 #endif	/* CONFIG_XEN_DOM0 */
 
 struct bio_vec;
+struct page;
+
 bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
-		const struct bio_vec *vec2);
+		const struct page *page);
 
 #if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_XEN_BALLOON)
 extern u64 xen_saved_max_mem_size;
-- 
2.20.1



