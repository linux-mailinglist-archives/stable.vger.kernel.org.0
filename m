Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D92524695E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgHQPVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbgHQPU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:20:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BD6D2065C;
        Mon, 17 Aug 2020 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677657;
        bh=AiOlWcS4Nc4rzG2Flyr2zCMjKAcNKrD8KD3GG6vV3I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rB0zAR1IS7hc6vXyZDuurCgvKJAJHgPqfq85AktSmEtvAgTCDwEnjOoR4dvumv3dO
         DJMp37Lpa8Nrty42ecaH4m6DdwvIe6x971TptmUt+8FBxGQv97yJY5kD5ILoFT0c2N
         JT4iDKM5HgMwpFBRwBeG0k2kfLcOwBvEFH5k7gdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 062/464] md: raid0/linear: fix dereference before null check on pointer mddev
Date:   Mon, 17 Aug 2020 17:10:15 +0200
Message-Id: <20200817143836.734203816@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9a5a85972c073f720d81a7ebd08bfe278e6e16db ]

Pointer mddev is being dereferenced with a test_bit call before mddev
is being null checked, this may cause a null pointer dereference. Fix
this by moving the null pointer checks to sanity check mddev before
it is dereferenced.

Addresses-Coverity: ("Dereference before null check")
Fixes: 62f7b1989c02 ("md raid0/linear: Mark array as 'broken' and fail BIOs if a member is gone")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f567f536b529b..90756450b9588 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -470,17 +470,18 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	struct mddev *mddev = bio->bi_disk->private_data;
 	unsigned int sectors;
 
-	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
+	if (mddev == NULL || mddev->pers == NULL) {
 		bio_io_error(bio);
 		return BLK_QC_T_NONE;
 	}
 
-	blk_queue_split(q, &bio);
-
-	if (mddev == NULL || mddev->pers == NULL) {
+	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
 		bio_io_error(bio);
 		return BLK_QC_T_NONE;
 	}
+
+	blk_queue_split(q, &bio);
+
 	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
 		if (bio_sectors(bio) != 0)
 			bio->bi_status = BLK_STS_IOERR;
-- 
2.25.1



