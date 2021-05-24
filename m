Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1293A38EAD3
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbhEXO6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234316AbhEXO4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3370F61440;
        Mon, 24 May 2021 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867740;
        bh=IDRMAJny6+HkyjOT/E48tl0bKg98knhfTnaG8j+C9r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9pCYZkL5o46CKBFoifu4cgHxD/UQUvyfDBG1U+0L+hcDKN0R3y7xKrr7fTHYJ3qd
         6OnU6gpnr69101Vxbssi/jrgsgGZoRiOz6bZQbqbmrTMEObnqSz4TlIQbnD2P9l0NX
         PcI5TjCh96GoXHQ3hLNXXWO3R//dKaJONl/21RfU3kCoUmeD2Wk3h1JsueC0GcLL4H
         wvayWuN0BHWqEE5P4cngKKGVvwg2vlPwm8ZAdopEEaOk/kzvbrFujBkkt4+gZSq9HL
         AYkLSzHFjG3aflJsXhaRp0kzcoWAGBTeJVYGyOZ/sMcBGj6fGr8YC0IBxBAk0e/29T
         VydmafyAsXHrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gulam Mohamed <gulam.mohamed@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 61/62] block: fix a race between del_gendisk and BLKRRPART
Date:   Mon, 24 May 2021 10:47:42 -0400
Message-Id: <20210524144744.2497894-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gulam Mohamed <gulam.mohamed@oracle.com>

[ Upstream commit bc6a385132601c29a6da1dbf8148c0d3c9ad36dc ]

When BLKRRPART is called concurrently with del_gendisk, the partitions
rescan can create a stale partition that will never be be cleaned up.

Fix this by checking the the disk is up before rescanning partitions
while under bd_mutex.

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210514131842.1600568-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/block_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index cacea6bafc22..29f020c4b2d0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1408,6 +1408,9 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 
 	lockdep_assert_held(&bdev->bd_mutex);
 
+	if (!(disk->flags & GENHD_FL_UP))
+		return -ENXIO;
+
 rescan:
 	ret = blk_drop_partitions(bdev);
 	if (ret)
-- 
2.30.2

