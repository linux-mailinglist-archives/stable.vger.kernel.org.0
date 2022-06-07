Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AF5540DB9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353557AbiFGStt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354431AbiFGSrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADDA44749;
        Tue,  7 Jun 2022 11:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E97DF616B6;
        Tue,  7 Jun 2022 18:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DD0C3411C;
        Tue,  7 Jun 2022 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624871;
        bh=Th3DUZqFk8+1/xRoOYXgybjrLnW/ivzgL1Rlj1RfciY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLE/JclFbYmZ5ZSHsjv2g2QrJAAQJ+1R8g0rDS8xdFmU3EsdOWQYVc2w3G/c+jQCD
         enuq65DounycUIBRNN1zMjapoUP67q3Y8jY/UoEt08f6fsbqgw4JH94eVT54Fdxg4P
         lr3QGicdi3WFDSE8fxfBjphnw/nlMKdyebXBpfn66P2GJQyF62zg0Cy8DMMnjYyhSp
         NuJ9eLqhAttKsnHUFXvLEOcYXNwcNeW67lX2d2Z3MMTUza2nC2lpkGEFDFsF4+BswX
         IcjfHfjEjPRsQfzrspgtRVqCm4dattSIvKKewbRz4aW68Vq6ay41YLzTKX9w+u0xx7
         XTJrd/uwofvtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Zheyu Ma <zheyuma97@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, hare@kernel.org,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/34] scsi: myrb: Fix up null pointer access on myrb_cleanup()
Date:   Tue,  7 Jun 2022 13:59:58 -0400
Message-Id: <20220607180011.481266-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180011.481266-1-sashal@kernel.org>
References: <20220607180011.481266-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit f9f0a46141e2e39bedb4779c88380d1b5f018c14 ]

When myrb_probe() fails the callback might not be set, so we need to
validate the 'disable_intr' callback in myrb_cleanup() to not cause a null
pointer exception. And while at it do not call myrb_cleanup() if we cannot
enable the PCI device at all.

Link: https://lore.kernel.org/r/20220523120244.99515-1-hare@suse.de
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Tested-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/myrb.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 539ac8ce4fcd..35b32920a94a 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1241,7 +1241,8 @@ static void myrb_cleanup(struct myrb_hba *cb)
 	myrb_unmap(cb);
 
 	if (cb->mmio_base) {
-		cb->disable_intr(cb->io_base);
+		if (cb->disable_intr)
+			cb->disable_intr(cb->io_base);
 		iounmap(cb->mmio_base);
 	}
 	if (cb->irq)
@@ -3516,9 +3517,13 @@ static struct myrb_hba *myrb_detect(struct pci_dev *pdev,
 	mutex_init(&cb->dcmd_mutex);
 	mutex_init(&cb->dma_mutex);
 	cb->pdev = pdev;
+	cb->host = shost;
 
-	if (pci_enable_device(pdev))
-		goto failure;
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "Failed to enable PCI device\n");
+		scsi_host_put(shost);
+		return NULL;
+	}
 
 	if (privdata->hw_init == DAC960_PD_hw_init ||
 	    privdata->hw_init == DAC960_P_hw_init) {
-- 
2.35.1

