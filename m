Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B159140E765
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347501AbhIPRcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353039AbhIPR3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C276113E;
        Thu, 16 Sep 2021 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810798;
        bh=0SQO3dsOesV/b1l38s4e7bxFqHBn1nCeqqbt7vgjWlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2H1BFAL1y6kHBjltq44NpWYymRhm9HOErZYhcEi1w94V+xThTHiUo1+o38O7zgg42
         OtQUI4oMzh84OM+JOA8oiddAGLJiJnKK3EkolA4IrLuI0YEZ6TPi/u1sRfy5XI6QAG
         bcbVlvhrhhscX0W5sftVnPOGWqrL30pHr8u9O77E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 239/432] ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()
Date:   Thu, 16 Sep 2021 17:59:48 +0200
Message-Id: <20210916155818.936644577@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



