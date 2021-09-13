Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64689409060
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbhIMNwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242910AbhIMNun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 444876137B;
        Mon, 13 Sep 2021 13:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540017;
        bh=P3byreIPuZnbPrwJUZckS3L+rpi9RwiluUft/czke64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dd1yqXAYzBdQbtZJHAe98tQuGkMcF4VgSkjQWdZiSS5BFu0z5eyjf4ScvmALdXWRg
         N+x200IUyrtKBgL/Wtm9NxRnK+QNv3xa1LhFuZoUDE0pVW1lijB961ce77qckgUR0e
         oBhp6g5bqSKYa/tu5XKKFIECvBhmW6jDTf9rG9YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 017/300] bcache: add proper error unwinding in bcache_device_init
Date:   Mon, 13 Sep 2021 15:11:18 +0200
Message-Id: <20210913131109.885797732@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index bea8c4429ae8..a407e3be0f17 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -935,20 +935,20 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
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
 
 	d->disk = alloc_disk(BCACHE_MINORS);
 	if (!d->disk)
-		goto err;
+		goto out_bioset_exit;
 
 	set_capacity(d->disk, sectors);
 	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
@@ -994,8 +994,14 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 
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



