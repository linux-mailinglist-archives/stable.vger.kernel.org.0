Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E3523FAE9
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgHHXpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbgHHXie (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D2712073E;
        Sat,  8 Aug 2020 23:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929913;
        bh=bpCArGqYhu7XR0T4plFq2F98eNWRFqKGrxCDzFsaknQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCvCjWkCXNMFho5CSDxtKBaxqeIoLr9Lu+MPg957KIuStaQnKXP2bfP4jE5Ssr3Ug
         JqwZQUO/sHAo7qPjEcqMvSN66jZJSQI8fshTWhS7He888PelER5v7blZ9JLo9OKc7k
         hTlPGaLhVyScxkxvz9ZUjnxd4gyuz2mtS1nBHnDA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "Guilherme G . Piccoli" <gpiccoli@canonical.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 50/58] md: raid0/linear: fix dereference before null check on pointer mddev
Date:   Sat,  8 Aug 2020 19:37:16 -0400
Message-Id: <20200808233724.3618168-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 41eead9cbee98..d5a5c18813985 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -469,17 +469,18 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	struct mddev *mddev = q->queuedata;
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

