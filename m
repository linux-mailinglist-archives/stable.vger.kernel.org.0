Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604175419E2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356496AbiFGV1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377899AbiFGVXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:23:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB3F227360;
        Tue,  7 Jun 2022 12:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DD04B8239E;
        Tue,  7 Jun 2022 19:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41A1C385A5;
        Tue,  7 Jun 2022 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628429;
        bh=seCFZk7YL+TVjD/DOD0zsxuIbf6/QXBn7zKIHdKSTeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ter55OunemYImBJbumkJt8sAzjR6vlDg7LxAy5DpO6pCXuGr1W1qlJQ+3EpZ4A/jL
         01DvWnwQrDsycwegHahq+vVy+sP5Agfn0iRAdRDAifVfvsX8cfCLM87mveCDRbMzqm
         0wGHEtW4EatDZby/wFkSHLGmeodXlq6kZGv0Xyfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 324/879] mtd: rawnand: denali: Use managed device resources
Date:   Tue,  7 Jun 2022 18:57:22 +0200
Message-Id: <20220607165012.258107593@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 3a745b51cddafade99aaea1b93aad31e9614e230 ]

All of the resources used by this driver has managed interfaces, so use
them. Otherwise we will get the following splat:

[    4.472703] denali-nand-pci 0000:00:05.0: timeout while waiting for irq 0x1000
[    4.474071] denali-nand-pci: probe of 0000:00:05.0 failed with error -5
[    4.473538] nand: No NAND device found
[    4.474068] BUG: unable to handle page fault for address: ffffc90005000410
[    4.475169] #PF: supervisor write access in kernel mode
[    4.475579] #PF: error_code(0x0002) - not-present page
[    4.478362] RIP: 0010:iowrite32+0x9/0x50
[    4.486068] Call Trace:
[    4.486269]  <IRQ>
[    4.486443]  denali_isr+0x15b/0x300 [denali]
[    4.486788]  ? denali_direct_write+0x50/0x50 [denali]
[    4.487189]  __handle_irq_event_percpu+0x161/0x3b0
[    4.487571]  handle_irq_event+0x7d/0x1b0
[    4.487884]  handle_fasteoi_irq+0x2b0/0x770
[    4.488219]  __common_interrupt+0xc8/0x1b0
[    4.488549]  common_interrupt+0x9a/0xc0

Fixes: 93db446a424c ("mtd: nand: move raw NAND related code to the raw/ subdir")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220411125808.958276-1-zheyuma97@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/denali_pci.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/nand/raw/denali_pci.c b/drivers/mtd/nand/raw/denali_pci.c
index 20c085a30adc..de7e722d3826 100644
--- a/drivers/mtd/nand/raw/denali_pci.c
+++ b/drivers/mtd/nand/raw/denali_pci.c
@@ -74,22 +74,21 @@ static int denali_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		return ret;
 	}
 
-	denali->reg = ioremap(csr_base, csr_len);
+	denali->reg = devm_ioremap(denali->dev, csr_base, csr_len);
 	if (!denali->reg) {
 		dev_err(&dev->dev, "Spectra: Unable to remap memory region\n");
 		return -ENOMEM;
 	}
 
-	denali->host = ioremap(mem_base, mem_len);
+	denali->host = devm_ioremap(denali->dev, mem_base, mem_len);
 	if (!denali->host) {
 		dev_err(&dev->dev, "Spectra: ioremap failed!");
-		ret = -ENOMEM;
-		goto out_unmap_reg;
+		return -ENOMEM;
 	}
 
 	ret = denali_init(denali);
 	if (ret)
-		goto out_unmap_host;
+		return ret;
 
 	nsels = denali->nbanks;
 
@@ -117,10 +116,6 @@ static int denali_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 out_remove_denali:
 	denali_remove(denali);
-out_unmap_host:
-	iounmap(denali->host);
-out_unmap_reg:
-	iounmap(denali->reg);
 	return ret;
 }
 
@@ -129,8 +124,6 @@ static void denali_pci_remove(struct pci_dev *dev)
 	struct denali_controller *denali = pci_get_drvdata(dev);
 
 	denali_remove(denali);
-	iounmap(denali->reg);
-	iounmap(denali->host);
 }
 
 static struct pci_driver denali_pci_driver = {
-- 
2.35.1



