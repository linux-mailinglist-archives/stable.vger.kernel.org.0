Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C1F14DD57
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgA3OxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:53:24 -0500
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:41388 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727107AbgA3OxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:53:24 -0500
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 7C3462E09A7;
        Thu, 30 Jan 2020 17:53:21 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id wvfQYkFNLV-rHd4Cgwg;
        Thu, 30 Jan 2020 17:53:21 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1580396001; bh=Y84bH2KsE1kXNrx8LdIiH0KlztbKiZ7lW4YKF45II9M=;
        h=Message-ID:Date:To:From:Subject:Cc;
        b=EJtQgDYTUBZfqOWTf1Haall3wHsHinWyL7C0tp+ryWWcKPnZEpFjtqD5k1N7SxWW3
         sx6fhpRzm5YBbHZHOpZn8sDuwaKXLdDBh2AjyRvJzYL/uFbvhRahVjNmqkQ6Y7tuQZ
         dvwQUEjJxAYti8zVeVN+mkBUgNDQ53L4g1tJMJ38=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:8448:fbcc:1dac:c863])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 8PJ41Vi2La-rHXSwIY1;
        Thu, 30 Jan 2020 17:53:17 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH v4.19 1/2] block: cleanup __blkdev_issue_discard()
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     Greg KH <greg@kroah.com>, Stable <stable@vger.kernel.org>
Cc:     linux-block <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dave Chinner <dchinner@redhat.com>,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Ming Lei <ming.lei@redhat.com>
Date:   Thu, 30 Jan 2020 17:53:16 +0300
Message-ID: <158039599680.4465.7011319825891038466.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

Commit ba5d73851e71847ba7f7f4c27a1a6e1f5ab91c79 upstream.

Cleanup __blkdev_issue_discard() a bit:

- remove local variable of 'end_sect'
- remove code block of 'fail'

Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Xiao Ni <xni@redhat.com>
Cc: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 block/blk-lib.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 1f196cf0aa5d..41088d5466c1 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -52,15 +52,12 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if ((sector | nr_sects) & bs_mask)
 		return -EINVAL;
 
-	while (nr_sects) {
-		unsigned int req_sects = nr_sects;
-		sector_t end_sect;
-
-		if (!req_sects)
-			goto fail;
-		req_sects = min(req_sects, bio_allowed_max_sectors(q));
+	if (!nr_sects)
+		return -EINVAL;
 
-		end_sect = sector + req_sects;
+	while (nr_sects) {
+		unsigned int req_sects = min_t(unsigned int, nr_sects,
+				bio_allowed_max_sectors(q));
 
 		bio = next_bio(bio, 0, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
@@ -68,8 +65,8 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		bio_set_op_attrs(bio, op, 0);
 
 		bio->bi_iter.bi_size = req_sects << 9;
+		sector += req_sects;
 		nr_sects -= req_sects;
-		sector = end_sect;
 
 		/*
 		 * We can loop for a long time in here, if someone does
@@ -82,14 +79,6 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 
 	*biop = bio;
 	return 0;
-
-fail:
-	if (bio) {
-		submit_bio_wait(bio);
-		bio_put(bio);
-	}
-	*biop = NULL;
-	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(__blkdev_issue_discard);
 

