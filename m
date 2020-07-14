Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7665621FCFB
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgGNSq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbgGNSq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:46:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACF722231B;
        Tue, 14 Jul 2020 18:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752387;
        bh=twPQB/IAqQjDTQxqwlo9kyFexVnEMbyRzMSUlbw0Jdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpjPQBPe+/3QKDoCZlyFXLoSXwi99i4mVFMiTbYK54Ws4zW1sd2zdv91453RzkOvt
         62eVFWdUra6/xPnR7QauMkSSlpsWPOPI0PYZl/13Kzljy/eco63IGoEWnn1iDDSzOb
         BxT+I7DpxpuVz9Al8ESDAddkJkxjw4wKuc68hdkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/58] block: release bip in a right way in error path
Date:   Tue, 14 Jul 2020 20:43:55 +0200
Message-Id: <20200714184057.245267468@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit 0b8eb629a700c0ef15a437758db8255f8444e76c ]

Release bip using kfree() in error path when that was allocated
by kmalloc().

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index a059fad53f1b0..0b96220d0efd4 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -38,6 +38,18 @@ void blk_flush_integrity(void)
 	flush_workqueue(kintegrityd_wq);
 }
 
+void __bio_integrity_free(struct bio_set *bs, struct bio_integrity_payload *bip)
+{
+	if (bs && mempool_initialized(&bs->bio_integrity_pool)) {
+		if (bip->bip_vec)
+			bvec_free(&bs->bvec_integrity_pool, bip->bip_vec,
+				  bip->bip_slab);
+		mempool_free(bip, &bs->bio_integrity_pool);
+	} else {
+		kfree(bip);
+	}
+}
+
 /**
  * bio_integrity_alloc - Allocate integrity payload and attach it to bio
  * @bio:	bio to attach integrity metadata to
@@ -90,7 +102,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 
 	return bip;
 err:
-	mempool_free(bip, &bs->bio_integrity_pool);
+	__bio_integrity_free(bs, bip);
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(bio_integrity_alloc);
@@ -111,14 +123,7 @@ static void bio_integrity_free(struct bio *bio)
 		kfree(page_address(bip->bip_vec->bv_page) +
 		      bip->bip_vec->bv_offset);
 
-	if (bs && mempool_initialized(&bs->bio_integrity_pool)) {
-		bvec_free(&bs->bvec_integrity_pool, bip->bip_vec, bip->bip_slab);
-
-		mempool_free(bip, &bs->bio_integrity_pool);
-	} else {
-		kfree(bip);
-	}
-
+	__bio_integrity_free(bs, bip);
 	bio->bi_integrity = NULL;
 	bio->bi_opf &= ~REQ_INTEGRITY;
 }
-- 
2.25.1



