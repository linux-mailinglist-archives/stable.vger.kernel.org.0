Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F127B66CCAC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbjAPR2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbjAPR2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:28:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A568599BA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:05:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E58C61089
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C6EC433EF;
        Mon, 16 Jan 2023 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888705;
        bh=P1h2GVKEp5GZq/jne3zz82VUrZTf0ekaOnjBrwvNxSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQurFek+wBUL/kEcQWSCnn/fLokzy0MM4N7foOpEKbd4R61z4seOa/BPzuZUWuv7B
         Pw9vB+zhCsSmNAqXRRikC3HAbd9wet44YbvH1vwDMw8nkZNe/BDnYUOxtQZkgYGZpV
         teaGp2vD6QXNohPdl0jQ5LtK89yJ8zC+Ex0HvgHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 106/338] mmc: toshsd: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:49:39 +0100
Message-Id: <20230116154825.492802762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index dd961c54a6a9..9236965b00fd 100644
--- a/drivers/mmc/host/toshsd.c
+++ b/drivers/mmc/host/toshsd.c
@@ -655,7 +655,9 @@ static int toshsd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto unmap;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto free_irq;
 
 	base = pci_resource_start(pdev, 0);
 	dev_dbg(&pdev->dev, "MMIO %pa, IRQ %d\n", &base, pdev->irq);
@@ -664,6 +666,8 @@ static int toshsd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+free_irq:
+	free_irq(pdev->irq, host);
 unmap:
 	pci_iounmap(pdev, host->ioaddr);
 release:
-- 
2.35.1



