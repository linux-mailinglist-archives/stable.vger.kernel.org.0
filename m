Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0177D49996E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455349AbiAXVfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:35:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41884 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452736AbiAXV00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:26:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17785B8122A;
        Mon, 24 Jan 2022 21:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684BCC340E4;
        Mon, 24 Jan 2022 21:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059583;
        bh=0co8E5XKLYjxH3n0wc4rra2FJH6eQg6IaRzMkRhkBdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E37f8ZBqxnOHiYBTaOZ2ATbdaFDeNTBx+V2luRMf9AyWbO437kESJ0mrgOpqejzzs
         A/+WfQJjRmSzQHXS8dOIJw4gG/vqFeCon0M6vn8Ex8JzNsWZP5ISWsVqsGbbz817sc
         IkRerfu14AwOpf0bJUkOcbtydT9kdb7Z3IFh0P5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shen <shenyang39@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0665/1039] crypto: hisilicon/qm - fix deadlock for remove driver
Date:   Mon, 24 Jan 2022 19:40:54 +0100
Message-Id: <20220124184147.732689466@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 70b0405494db5..1dc6a27ba0e0d 100644
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



