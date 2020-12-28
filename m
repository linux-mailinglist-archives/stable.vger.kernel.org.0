Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046272E40EF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440184AbgL1ON3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440179AbgL1ON3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FFCD20715;
        Mon, 28 Dec 2020 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164793;
        bh=aVFpPXGvmw0OX3WEYtjlnggwAkKFDkbWOUwsy8Faa/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwPaxwZ25xP8CELDWFH/1/HMzwwFUXEoru3zb9VuL1wj1SXA15lr3uXHHIBsZWWGp
         AdY1N8zbUpy6esPe22RUXpwqBbGK0GuwubnGQpuDu3c/QZ3Ln9lhOhx/Dajf40Oxx7
         deJgLSGxhX4zC/UaZcxAW2hYUaly8z9nQq0hlbOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/717] memstick: r592: Fix error return in r592_probe()
Date:   Mon, 28 Dec 2020 13:44:58 +0100
Message-Id: <20201228125035.401919220@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit db29d3d1c2451e673e29c7257471e3ce9d50383a ]

Fix to return a error code from the error handling case instead of 0.

Fixes: 926341250102 ("memstick: add driver for Ricoh R5C592 card reader")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Link: https://lore.kernel.org/r/20201125014718.153563-1-jingxiangfeng@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/host/r592.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index dd3a1f3dcc191..d2ef46337191c 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -759,8 +759,10 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto error3;
 
 	dev->mmio = pci_ioremap_bar(pdev, 0);
-	if (!dev->mmio)
+	if (!dev->mmio) {
+		error = -ENOMEM;
 		goto error4;
+	}
 
 	dev->irq = pdev->irq;
 	spin_lock_init(&dev->irq_lock);
@@ -786,12 +788,14 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		&dev->dummy_dma_page_physical_address, GFP_KERNEL);
 	r592_stop_dma(dev , 0);
 
-	if (request_irq(dev->irq, &r592_irq, IRQF_SHARED,
-			  DRV_NAME, dev))
+	error = request_irq(dev->irq, &r592_irq, IRQF_SHARED,
+			  DRV_NAME, dev);
+	if (error)
 		goto error6;
 
 	r592_update_card_detect(dev);
-	if (memstick_add_host(host))
+	error = memstick_add_host(host);
+	if (error)
 		goto error7;
 
 	message("driver successfully loaded");
-- 
2.27.0



