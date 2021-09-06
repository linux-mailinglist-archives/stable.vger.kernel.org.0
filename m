Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A9740128C
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbhIFBVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238749AbhIFBVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A61BD61054;
        Mon,  6 Sep 2021 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891212;
        bh=Q78iZj1z+aPDomDiRWa/HraSx72nx4Z0Tki2Fi8AuMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UoJbZe0gS+88W2kdoI0heKnqvHCyRbRA7pHGE420/cX/eNyRS2eV6+19y8yByALNA
         Q1K7r7itIk2T+Ap+gK6f2surMD8csAbbmZU3KwKXcM98RBsXeFGz/1dKZIZdDukGEa
         rU4aXHUikzahRgap+9hxkJmNDBduLiVSR0SrrldfoU9D3jay4XWH195vssjChALCF9
         EY6trQqsVipBYwc0RtZz042EfzH8IhRdiTOcwgxY0uN8cuv+o4wjSR7/Mgp14RyC4y
         v/KMEv6BAtt/rdBsOPu3xaysx5+jQEHsvPlfcinv7c4v46ar59NIWFWf0RXQdUvHJq
         H7v6FzQKYBk3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 17/47] bcache: add proper error unwinding in bcache_device_init
Date:   Sun,  5 Sep 2021 21:19:21 -0400
Message-Id: <20210906011951.928679-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 224b0683228c5f332f9cee615d85e75e9a347170 ]

Except for the IDA none of the allocations in bcache_device_init is
unwound on error, fix that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20210809064028.1198327-7-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 185246a0d855..d0f08e946453 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -931,20 +931,20 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
 	d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
 	if (!d->full_dirty_stripes)
-		return -ENOMEM;
+		goto out_free_stripe_sectors_dirty;
 
 	idx = ida_simple_get(&bcache_device_idx, 0,
 				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
 	if (idx < 0)
-		return idx;
+		goto out_free_full_dirty_stripes;
 
 	if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
 			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
-		goto err;
+		goto out_ida_remove;
 
 	d->disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!d->disk)
-		goto err;
+		goto out_bioset_exit;
 
 	set_capacity(d->disk, sectors);
 	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
@@ -987,8 +987,14 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 
 	return 0;
 
-err:
+out_bioset_exit:
+	bioset_exit(&d->bio_split);
+out_ida_remove:
 	ida_simple_remove(&bcache_device_idx, idx);
+out_free_full_dirty_stripes:
+	kvfree(d->full_dirty_stripes);
+out_free_stripe_sectors_dirty:
+	kvfree(d->stripe_sectors_dirty);
 	return -ENOMEM;
 
 }
-- 
2.30.2

