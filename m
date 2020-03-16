Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241F31862E2
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbgCPCdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729648AbgCPCdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:33:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 732D82076B;
        Mon, 16 Mar 2020 02:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326031;
        bh=6LKp/oRxKgmott8F39xSSbLgaXXdxdcuUA0dT6lBzm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scnaQgV9w+0eni3/WWkffpiUzvTwcEYvAstvmkgJ0KSKzTCEFbaevTrwQgQ+4AG8V
         8nly4BXyvwJJ7BbPtmGHdtQ1cLzEagi3npZ6qMUq0+AOA4XkreqH610xEERsoBS3N8
         4JXoBtN9oOhxnWbmZqLm40J9J0PlVc78xgJo4cIQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.5 26/41] dm bio record: save/restore bi_end_io and bi_integrity
Date:   Sun, 15 Mar 2020 22:33:04 -0400
Message-Id: <20200316023319.749-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 1b17159e52bb31f982f82a6278acd7fab1d3f67b ]

Also, save/restore __bi_remaining in case the bio was used in a
BIO_CHAIN (e.g. due to blk_queue_split).

Suggested-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bio-record.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/md/dm-bio-record.h b/drivers/md/dm-bio-record.h
index c82578af56a5b..2ea0360108e1d 100644
--- a/drivers/md/dm-bio-record.h
+++ b/drivers/md/dm-bio-record.h
@@ -20,8 +20,13 @@
 struct dm_bio_details {
 	struct gendisk *bi_disk;
 	u8 bi_partno;
+	int __bi_remaining;
 	unsigned long bi_flags;
 	struct bvec_iter bi_iter;
+	bio_end_io_t *bi_end_io;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	struct bio_integrity_payload *bi_integrity;
+#endif
 };
 
 static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
@@ -30,6 +35,11 @@ static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 	bd->bi_partno = bio->bi_partno;
 	bd->bi_flags = bio->bi_flags;
 	bd->bi_iter = bio->bi_iter;
+	bd->__bi_remaining = atomic_read(&bio->__bi_remaining);
+	bd->bi_end_io = bio->bi_end_io;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	bd->bi_integrity = bio_integrity(bio);
+#endif
 }
 
 static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
@@ -38,6 +48,11 @@ static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
 	bio->bi_partno = bd->bi_partno;
 	bio->bi_flags = bd->bi_flags;
 	bio->bi_iter = bd->bi_iter;
+	atomic_set(&bio->__bi_remaining, bd->__bi_remaining);
+	bio->bi_end_io = bd->bi_end_io;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	bio->bi_integrity = bd->bi_integrity;
+#endif
 }
 
 #endif
-- 
2.20.1

