Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998F2657F79
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbiL1QFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiL1QFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:05:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB46186CD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:05:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2366AB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E151C433D2;
        Wed, 28 Dec 2022 16:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243514;
        bh=xUQTlc1D4KPn3pxvsRl1F29e784Z/ZcyQb7a0L/HTl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tao1XoI+4Sp7ARGQqJXMuvM8XhpB0b1gpCgELXt0mD/yD27Sa+Gf5DsKqeJV1bF78
         fQ0Ga75QRkViRk4bKhcH4wySpXGfyK/VOnBqxt8Wpm+McsVz1SCQHY7R6ccjpZHreq
         xeTRAyfoEz24/d8WibKRbfoBuqdWg3VEY5rgmpDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0501/1146] mmc: toshsd: fix return value check of mmc_add_host()
Date:   Wed, 28 Dec 2022 15:34:00 +0100
Message-Id: <20221228144343.786007389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f670744a316ea983113a65313dcd387b5a992444 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host(), besides, free_irq() also needs be called.

Fixes: a5eb8bbd66cc ("mmc: add Toshiba PCI SD controller driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-8-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/toshsd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/toshsd.c b/drivers/mmc/host/toshsd.c
index 8d037c2071ab..497791ffada6 100644
--- a/drivers/mmc/host/toshsd.c
+++ b/drivers/mmc/host/toshsd.c
@@ -651,7 +651,9 @@ static int toshsd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto unmap;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto free_irq;
 
 	base = pci_resource_start(pdev, 0);
 	dev_dbg(&pdev->dev, "MMIO %pa, IRQ %d\n", &base, pdev->irq);
@@ -660,6 +662,8 @@ static int toshsd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+free_irq:
+	free_irq(pdev->irq, host);
 unmap:
 	pci_iounmap(pdev, host->ioaddr);
 release:
-- 
2.35.1



