Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47FA49161A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244671AbiARCcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40636 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343774AbiARC1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:27:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68248B81259;
        Tue, 18 Jan 2022 02:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5B2C36AE3;
        Tue, 18 Jan 2022 02:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472832;
        bh=B3cfPb453Nfcm6OQAWeKGIZpO4YqJTunOFtE/0tb9IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nj3ZbNhTS/7HxQ8KVPi/hcO8XKWGNHtgM3RXxJs6p3NSt4Xycpa4JraV0faSZlFXH
         I5RphB1mjkmMKvzDkFy7sBZlcJdlpS/9xlxiDWVfPkhZjCZEX5WRzFfgyWXWzdjifi
         V5vpJNS+mr8h2isMpSPnSgB0Z47DP2KTFgS3rPEsjzBSCQXyPman29GBAVAmsVlQ90
         yJc9+gzMcEfP3Pndc9LBOIaETYScxUn4G5TZdGju5Aay9nr66iuAn0bw8ArrFbt82A
         IgyTHgAKp70ZzCoJdan4FrHavLKCjyWfbPfNn6ug21w2U0adTsv7kTdBvi6ucs/rpy
         l/wuX2IS7YJGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Shen <shenyang39@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, wangzhou1@hisilicon.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 148/217] crypto: hisilicon/qm - fix deadlock for remove driver
Date:   Mon, 17 Jan 2022 21:18:31 -0500
Message-Id: <20220118021940.1942199-148-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shen <shenyang39@huawei.com>

[ Upstream commit fc6c01f0cd10b89c4b01dd2940e0b0cda1bd82fb ]

When remove the driver and executing the task occur at the same time,
the following deadlock will be triggered:

Chain exists of:
    sva_lock --> uacce_mutex --> &qm->qps_lock
    Possible unsafe locking scenario:
		CPU0                    CPU1
		----                    ----
	lock(&qm->qps_lock);
					lock(uacce_mutex);
					lock(&qm->qps_lock);
	lock(sva_lock);

And the lock 'qps_lock' is used to protect qp. Therefore, it's reasonable
cycle is to continue until the qp memory is released. So move the release
lock infront of 'uacce_remove'.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 52d6cca6262e2..39517aa9630bb 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3399,6 +3399,7 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 		dma_free_coherent(dev, qm->qdma.size,
 				  qm->qdma.va, qm->qdma.dma);
 	}
+	up_write(&qm->qps_lock);
 
 	qm_irq_unregister(qm);
 	hisi_qm_pci_uninit(qm);
@@ -3406,8 +3407,6 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 		uacce_remove(qm->uacce);
 		qm->uacce = NULL;
 	}
-
-	up_write(&qm->qps_lock);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_uninit);
 
-- 
2.34.1

