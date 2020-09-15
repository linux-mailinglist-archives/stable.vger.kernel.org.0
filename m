Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDBD26B504
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgIOXfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727143AbgIOOfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:35:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65E7A22241;
        Tue, 15 Sep 2020 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179949;
        bh=f17enNH3l8GhW1DjaXkY/8QBfmSKH+/OaPdvEdBb4Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9pKa/ZacY1jC9h42LWm3MYq76vzBO4SKcps1y7tjgJ4Dx7eTaxSa5d/tU63z7RsW
         lmPrbkVgT1nrq9Z7FO4z1mnryEJ0RSHApKQgvZHAJO4GLJdlZ6WykrhXaohkWCpxz8
         vYBdOG4KrL44EmSQvznvb3VuxUrbUnZzin3S4r8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 048/177] block: restore a specific error code in bdev_del_partition
Date:   Tue, 15 Sep 2020 16:11:59 +0200
Message-Id: <20200915140655.927381074@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 88ce2a530cc9865a894454b2e40eba5957a60e1a ]

mdadm relies on the fact that deleting an invalid partition returns
-ENXIO or -ENOTTY to detect if a block device is a partition or a
whole device.

Fixes: 08fc1ab6d748 ("block: fix locking in bdev_del_partition")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 534e11285a8d4..b45539764c994 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -529,7 +529,7 @@ int bdev_del_partition(struct block_device *bdev, int partno)
 
 	bdevp = bdget_disk(bdev->bd_disk, partno);
 	if (!bdevp)
-		return -ENOMEM;
+		return -ENXIO;
 
 	mutex_lock(&bdevp->bd_mutex);
 	mutex_lock_nested(&bdev->bd_mutex, 1);
-- 
2.25.1



