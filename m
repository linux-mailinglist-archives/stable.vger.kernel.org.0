Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C75404B0B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbhIILuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240926AbhIILqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F286124C;
        Thu,  9 Sep 2021 11:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187777;
        bh=0SQO3dsOesV/b1l38s4e7bxFqHBn1nCeqqbt7vgjWlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrV0x7MAwV1BG6sAiQWpHyvEcm0n75rXUedL5QM0JbS39IIawhlrYi/oV8f6psC2j
         8TtolSFdbFrrkc5FlT6KDDrqcF+zV5Pe7gGPECNdXV4997wMKwpfaPMRI2c7Z5a2h9
         ttF2WgK9R+QAq0fI9WetV8YfId9oKoxtuKkXrGDys5Al6hLLxyqehJlCzJJIrQiQZu
         8EF6Q68HuT1Se2P0i0Qy4szM+NbJbPMuKMl2m0yrEOui5d7x+cxkjJcXr6UcFg3v0J
         lpZH0kUeUE+4hPv8bIhIIkJRqwD41U4XbGkivkntCvfwn+ynxuBS7D4yFog5VfU6Fr
         NrCLqvcK2Kkpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 087/252] ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()
Date:   Thu,  9 Sep 2021 07:38:21 -0400
Message-Id: <20210909114106.141462-87-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3ad4a31620355358316fa08fcfab37b9d6c33347 ]

Last change to device managed APIs cleaned up error path to simple phy_exit()
call, which in some cases has been executed with NULL parameter. This per se
is not a problem, but rather logical misconception: no need to free resource
when it's for sure has not been allocated yet. Fix the driver accordingly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210727125130.19977-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index f0ef844428bb..338c2e50f759 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1259,24 +1259,20 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	irq = irq_of_parse_and_map(np, 0);
 	if (irq == NO_IRQ) {
 		dev_err(&ofdev->dev, "no SATA DMA irq\n");
-		err = -ENODEV;
-		goto error_out;
+		return -ENODEV;
 	}
 
 #ifdef CONFIG_SATA_DWC_OLD_DMA
 	if (!of_find_property(np, "dmas", NULL)) {
 		err = sata_dwc_dma_init_old(ofdev, hsdev);
 		if (err)
-			goto error_out;
+			return err;
 	}
 #endif
 
 	hsdev->phy = devm_phy_optional_get(hsdev->dev, "sata-phy");
-	if (IS_ERR(hsdev->phy)) {
-		err = PTR_ERR(hsdev->phy);
-		hsdev->phy = NULL;
-		goto error_out;
-	}
+	if (IS_ERR(hsdev->phy))
+		return PTR_ERR(hsdev->phy);
 
 	err = phy_init(hsdev->phy);
 	if (err)
-- 
2.30.2

