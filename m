Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCFA3CE3FE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347533AbhGSPli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348466AbhGSPfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF5686162C;
        Mon, 19 Jul 2021 16:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711230;
        bh=0PlvzfLiJ+k98d3szNpOOpxdwIBwSKvyIySsNoeI9Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URhUmJANGbzwdfLojIQPTSe0mXcA8zmtE02H7PBMhBLQbQBs8LzSibb2BGzPgCZrl
         PJhHMSjljzAbOGvmBaqs8bdZTip68/CUB1o5lpEt3V+g1+jkon0O+0f580LgsXItu1
         tUkU406vpuBi46t1RjMd4cfbZlD3e4FJfpUlYotA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 242/351] block: grab a device refcount in disk_uevent
Date:   Mon, 19 Jul 2021 16:53:08 +0200
Message-Id: <20210719144952.951063295@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 498dcc13fd6463de29b94e160f40ed04d5477cd8 ]

Sending uevents requires the struct device to be alive.  To
ensure that grab the device refcount instead of just an inode
reference.

Fixes: bc359d03c7ec ("block: add a disk_uevent helper")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210701081638.246552-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9f8cb7beaad1..ad7436bd60c1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -402,12 +402,12 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action)
 	xa_for_each(&disk->part_tbl, idx, part) {
 		if (bdev_is_partition(part) && !bdev_nr_sectors(part))
 			continue;
-		if (!bdgrab(part))
+		if (!kobject_get_unless_zero(&part->bd_device.kobj))
 			continue;
 
 		rcu_read_unlock();
 		kobject_uevent(bdev_kobj(part), action);
-		bdput(part);
+		put_device(&part->bd_device);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.30.2



