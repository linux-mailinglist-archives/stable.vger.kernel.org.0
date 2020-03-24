Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1C01910B4
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgCXNV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728826AbgCXNVz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:21:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA934208CA;
        Tue, 24 Mar 2020 13:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056114;
        bh=H7rAtrMnqgIiYVkTvo3D9J9a+AW7cz6/k54xWmBkSSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFTtGMg+o5cjYPlfYt7FKtUlFxhbV/OB/APrgJf3eIcThJIM46+EXWjo0EexCbuNl
         +WaoMyQoI/dTcpjsUzpYUFSAwM4qQDEXhtU1y5CHXTcrnQwolkXID+nbZxMhbGd1ZI
         dnonYb3yr9/sTP/v7oB1BVCP+i3nLXHYY2nvJgfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 026/119] dm integrity: use dm_bio_record and dm_bio_restore
Date:   Tue, 24 Mar 2020 14:10:11 +0100
Message-Id: <20200324130810.971846304@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 248aa2645aa7fc9175d1107c2593cc90d4af5a4e ]

In cases where dec_in_flight() has to requeue the integrity_bio_wait
work to transfer the rest of the data, the bio's __bi_remaining might
already have been decremented to 0, e.g.: if bio passed to underlying
data device was split via blk_queue_split().

Use dm_bio_{record,restore} rather than effectively open-coding them in
dm-integrity -- these methods now manage __bi_remaining too.

Depends-on: f7f0b057a9c1 ("dm bio record: save/restore bi_end_io and bi_integrity")
Reported-by: Daniel Glöckner <dg@emlix.com>
Suggested-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index e1ad0b53f681a..a82a9c2577443 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -6,6 +6,8 @@
  * This file is released under the GPL.
  */
 
+#include "dm-bio-record.h"
+
 #include <linux/compiler.h>
 #include <linux/module.h>
 #include <linux/device-mapper.h>
@@ -295,11 +297,7 @@ struct dm_integrity_io {
 
 	struct completion *completion;
 
-	struct gendisk *orig_bi_disk;
-	u8 orig_bi_partno;
-	bio_end_io_t *orig_bi_end_io;
-	struct bio_integrity_payload *orig_bi_integrity;
-	struct bvec_iter orig_bi_iter;
+	struct dm_bio_details bio_details;
 };
 
 struct journal_completion {
@@ -1452,14 +1450,9 @@ static void integrity_end_io(struct bio *bio)
 {
 	struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
 
-	bio->bi_iter = dio->orig_bi_iter;
-	bio->bi_disk = dio->orig_bi_disk;
-	bio->bi_partno = dio->orig_bi_partno;
-	if (dio->orig_bi_integrity) {
-		bio->bi_integrity = dio->orig_bi_integrity;
+	dm_bio_restore(&dio->bio_details, bio);
+	if (bio->bi_integrity)
 		bio->bi_opf |= REQ_INTEGRITY;
-	}
-	bio->bi_end_io = dio->orig_bi_end_io;
 
 	if (dio->completion)
 		complete(dio->completion);
@@ -1544,7 +1537,7 @@ static void integrity_metadata(struct work_struct *w)
 			}
 		}
 
-		__bio_for_each_segment(bv, bio, iter, dio->orig_bi_iter) {
+		__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
 			unsigned pos;
 			char *mem, *checksums_ptr;
 
@@ -1588,7 +1581,7 @@ static void integrity_metadata(struct work_struct *w)
 		if (likely(checksums != checksums_onstack))
 			kfree(checksums);
 	} else {
-		struct bio_integrity_payload *bip = dio->orig_bi_integrity;
+		struct bio_integrity_payload *bip = dio->bio_details.bi_integrity;
 
 		if (bip) {
 			struct bio_vec biv;
@@ -2007,20 +2000,13 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 	} else
 		dio->completion = NULL;
 
-	dio->orig_bi_iter = bio->bi_iter;
-
-	dio->orig_bi_disk = bio->bi_disk;
-	dio->orig_bi_partno = bio->bi_partno;
+	dm_bio_record(&dio->bio_details, bio);
 	bio_set_dev(bio, ic->dev->bdev);
-
-	dio->orig_bi_integrity = bio_integrity(bio);
 	bio->bi_integrity = NULL;
 	bio->bi_opf &= ~REQ_INTEGRITY;
-
-	dio->orig_bi_end_io = bio->bi_end_io;
 	bio->bi_end_io = integrity_end_io;
-
 	bio->bi_iter.bi_size = dio->range.n_sectors << SECTOR_SHIFT;
+
 	generic_make_request(bio);
 
 	if (need_sync_io) {
-- 
2.20.1



