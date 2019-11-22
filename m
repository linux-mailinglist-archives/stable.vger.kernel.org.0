Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768BD106595
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfKVFvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:51:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbfKVFvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6656E2070E;
        Fri, 22 Nov 2019 05:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401862;
        bh=FsaOr/rO8jZIyV6MliQ60rSwoFVaHYrbJ/cX0U66GDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/chfsTusoF5lmwVopRHa7d/XUv1wicUleFKlS8BazzUhg+sXwqSPYn0x46CI8epO
         3tBbJ0WgMl5HDSNTxdbMpDefBY7sElWiaRnReG0IJqM+uHay1jcqjUCm4vAsFhNeGc
         z33hYQCBEuqJHMkqcPKJTwrKAISVbwj2RiuZ5IvM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sweet Tea <sweettea@redhat.com>,
        John Dorminy <jdorminy@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 098/219] dm flakey: Properly corrupt multi-page bios.
Date:   Fri, 22 Nov 2019 00:47:10 -0500
Message-Id: <20191122054911.1750-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sweet Tea <sweettea@redhat.com>

[ Upstream commit a00f5276e26636cbf72f24f79831026d2e2868e7 ]

The flakey target is documented to be able to corrupt the Nth byte in
a bio, but does not corrupt byte indices after the first biovec in the
bio. Change the corrupting function to actually corrupt the Nth byte
no matter in which biovec that index falls.

A test device generating two-page bios, atop a flakey device configured
to corrupt a byte index on the second page, verified both the failure
to corrupt before this patch and the expected corruption after this
change.

Signed-off-by: John Dorminy <jdorminy@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-flakey.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b86d2439ffc76..2fcf62fb2844f 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -287,20 +287,31 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 
 static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 {
-	unsigned bio_bytes = bio_cur_bytes(bio);
-	char *data = bio_data(bio);
+	unsigned int corrupt_bio_byte = fc->corrupt_bio_byte - 1;
+
+	struct bvec_iter iter;
+	struct bio_vec bvec;
+
+	if (!bio_has_data(bio))
+		return;
 
 	/*
-	 * Overwrite the Nth byte of the data returned.
+	 * Overwrite the Nth byte of the bio's data, on whichever page
+	 * it falls.
 	 */
-	if (data && bio_bytes >= fc->corrupt_bio_byte) {
-		data[fc->corrupt_bio_byte - 1] = fc->corrupt_bio_value;
-
-		DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
-			"(rw=%c bi_opf=%u bi_sector=%llu cur_bytes=%u)\n",
-			bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
-			(bio_data_dir(bio) == WRITE) ? 'w' : 'r', bio->bi_opf,
-			(unsigned long long)bio->bi_iter.bi_sector, bio_bytes);
+	bio_for_each_segment(bvec, bio, iter) {
+		if (bio_iter_len(bio, iter) > corrupt_bio_byte) {
+			char *segment = (page_address(bio_iter_page(bio, iter))
+					 + bio_iter_offset(bio, iter));
+			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
+			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
+				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",
+				bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
+				(bio_data_dir(bio) == WRITE) ? 'w' : 'r', bio->bi_opf,
+				(unsigned long long)bio->bi_iter.bi_sector, bio->bi_iter.bi_size);
+			break;
+		}
+		corrupt_bio_byte -= bio_iter_len(bio, iter);
 	}
 }
 
-- 
2.20.1

