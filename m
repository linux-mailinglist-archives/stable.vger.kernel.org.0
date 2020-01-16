Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D0813F87E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389755AbgAPTS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbgAPQy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5104A22525;
        Thu, 16 Jan 2020 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193667;
        bh=wL/Vwkoh3kn1CKFREu9YqM3f6u8k3b3UToJfRagg7Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVyJnyekGEmvVNnS/2lZlN86hDVox0RM4vq1cQbTKWi7xoj+4ro/hEF19req3tpXg
         Gct4kZ799Cxh+u7p9Seox6UTp4+JYc0PBG6VgfgM44494PYZzKzNPBXikrSrEzXJSU
         wxb+LzlBdYeMUES1YSD1W1gB2RgZ0mDDtDMO6HVU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Tee <justin.tee@broadcom.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 193/205] block: fix memleak of bio integrity data
Date:   Thu, 16 Jan 2020 11:42:48 -0500
Message-Id: <20200116164300.6705-193-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit ece841abbed2da71fa10710c687c9ce9efb6bf69 ]

7c20f11680a4 ("bio-integrity: stop abusing bi_end_io") moves
bio_integrity_free from bio_uninit() to bio_integrity_verify_fn()
and bio_endio(). This way looks wrong because bio may be freed
without calling bio_endio(), for example, blk_rq_unprep_clone() is
called from dm_mq_queue_rq() when the underlying queue of dm-mpath
is busy.

So memory leak of bio integrity data is caused by commit 7c20f11680a4.

Fixes this issue by re-adding bio_integrity_free() to bio_uninit().

Fixes: 7c20f11680a4 ("bio-integrity: stop abusing bi_end_io")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by Justin Tee <justin.tee@broadcom.com>

Add commit log, and simplify/fix the original patch wroten by Justin.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 2 +-
 block/bio.c           | 3 +++
 block/blk.h           | 4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index fb95dbb21dd8..bf62c25cde8f 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -87,7 +87,7 @@ EXPORT_SYMBOL(bio_integrity_alloc);
  * Description: Used to free the integrity portion of a bio. Usually
  * called from bio_free().
  */
-static void bio_integrity_free(struct bio *bio)
+void bio_integrity_free(struct bio *bio)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct bio_set *bs = bio->bi_pool;
diff --git a/block/bio.c b/block/bio.c
index c822ceb7c4de..006bcc52a77e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -233,6 +233,9 @@ struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 void bio_uninit(struct bio *bio)
 {
 	bio_disassociate_blkg(bio);
+
+	if (bio_integrity(bio))
+		bio_integrity_free(bio);
 }
 EXPORT_SYMBOL(bio_uninit);
 
diff --git a/block/blk.h b/block/blk.h
index ffea1691470e..ee3d5664d962 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -122,6 +122,7 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
 bool __bio_integrity_endio(struct bio *);
+void bio_integrity_free(struct bio *bio);
 static inline bool bio_integrity_endio(struct bio *bio)
 {
 	if (bio_integrity(bio))
@@ -167,6 +168,9 @@ static inline bool bio_integrity_endio(struct bio *bio)
 {
 	return true;
 }
+static inline void bio_integrity_free(struct bio *bio)
+{
+}
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 unsigned long blk_rq_timeout(unsigned long timeout);
-- 
2.20.1

