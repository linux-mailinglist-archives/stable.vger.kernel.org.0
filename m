Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5705434C7E8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhC2ISa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233446AbhC2IRr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:17:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9271861960;
        Mon, 29 Mar 2021 08:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005867;
        bh=t549l9Uw5gYRXHZbXiDetHBjMekwEXPSC78muQDnEsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ugi4zYHiA8jGEwI8TdMVOJVksyLrgtLLmwbG2h3zVntT1hIYgsPSwZp9JpzeqJAbQ
         CZDxsgDX1FNHujpWrCwWhXPNL9pVEuKirB4BGQlk1bHVRpyUgAPpzZlEsKMRAcoZIo
         7fDt/6IHSD8VuqKrBXxrVpmJI9aCKqNf6CmqMLfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/221] umem: fix error return code in mm_pci_probe()
Date:   Mon, 29 Mar 2021 09:56:05 +0200
Message-Id: <20210329075630.299087227@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit eeb05595d22c19c8f814ff893dcf88ec277a2365 ]

Fix to return negative error code -ENOMEM from the blk_alloc_queue()
and dma_alloc_coherent() error handling cases instead of 0, as done
elsewhere in this function.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210308123501.2573816-1-weiyongjun1@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/umem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 2b95d7b33b91..5eb44e4a91ee 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -877,6 +877,7 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (card->mm_pages[0].desc == NULL ||
 	    card->mm_pages[1].desc == NULL) {
 		dev_printk(KERN_ERR, &card->dev->dev, "alloc failed\n");
+		ret = -ENOMEM;
 		goto failed_alloc;
 	}
 	reset_page(&card->mm_pages[0]);
@@ -888,8 +889,10 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	spin_lock_init(&card->lock);
 
 	card->queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!card->queue)
+	if (!card->queue) {
+		ret = -ENOMEM;
 		goto failed_alloc;
+	}
 
 	tasklet_init(&card->tasklet, process_page, (unsigned long)card);
 
-- 
2.30.1



