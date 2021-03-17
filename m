Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8AE33E423
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhCQA6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhCQA5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6469C64FD2;
        Wed, 17 Mar 2021 00:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942654;
        bh=t549l9Uw5gYRXHZbXiDetHBjMekwEXPSC78muQDnEsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdIhRQ52ahEmHTgXIoxWb+SG9G+vUVlsDwIamhnv6cgdHaZVJWW+PV7m2dx2w4pPr
         aI7kR1ZBR5dBxyvgU4XWrzR99fLJqv+9SvJlnF6dd0MoRKOkeNhKG6xAv7x4DkBp7P
         TxlQzxNSil9GvYk2kpjqHi6VEcHDQ3v0z4O5n72UZIllz/3j3Tmqg59HIROW/RSUnp
         0N1Yb8fXi58oPsEkRKH1BBsIGmAmNsZRVSy9p3Jrr8l54RYd7BbyNYJ+ea1Pm/4GFz
         9oWXLsWghJG02M9ptsaECKbLq1G4gy5J5thwTCJjKf0qi8jTkFa+vyvuQmRxyk54RV
         ly0dZkTMGaopg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 32/54] umem: fix error return code in mm_pci_probe()
Date:   Tue, 16 Mar 2021 20:56:31 -0400
Message-Id: <20210317005654.724862-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

