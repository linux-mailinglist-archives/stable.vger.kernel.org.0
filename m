Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B81E2E39E8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390140AbgL1N3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:29:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390134AbgL1N3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:29:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D39DF207C9;
        Mon, 28 Dec 2020 13:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162133;
        bh=nGJ90IrqbdsBV/ws8iByTFp1Ml671DcSkl3mZyrk41o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8EXMtH4pa0O0AJ9p3LQEzJMLgwWP8MAjT/VYXObXj4KD87CEiM9U9SYWHiYfsJd8
         RLbFWjsM7FaQxo+pbm6xzSBJtDCptRIPuTQAQy3TM1w9InfaLDmIBlmF8UjZc03b3h
         6IfyMvxlAKygDiNmZRlyHz6iwSCMTJSnvEYfcfww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 199/346] memstick: r592: Fix error return in r592_probe()
Date:   Mon, 28 Dec 2020 13:48:38 +0100
Message-Id: <20201228124929.413698459@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 627d6e62fe313..4559593ecd5a9 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -762,8 +762,10 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto error3;
 
 	dev->mmio = pci_ioremap_bar(pdev, 0);
-	if (!dev->mmio)
+	if (!dev->mmio) {
+		error = -ENOMEM;
 		goto error4;
+	}
 
 	dev->irq = pdev->irq;
 	spin_lock_init(&dev->irq_lock);
@@ -789,12 +791,14 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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



