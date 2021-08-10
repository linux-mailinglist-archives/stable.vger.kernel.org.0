Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053773E5D9A
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242988AbhHJOWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243484AbhHJOTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D34E861107;
        Tue, 10 Aug 2021 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628605029;
        bh=bXXPPSl3UEzk1Aov3GYXRmLxrCKsx+1rwjgrEp9BZgc=;
        h=From:To:Cc:Subject:Date:From;
        b=BEoRu3TFkNb/uVtt6+M85DqcDYuDpTRZsdifLjTHZEa7ZPq7X7sWn1mONiEc3Cx2e
         F88vtmnaX9JiAyIokTVOs/AFfDAgyFNem4kNNOkEf+z54LFt3sCaVCOrOX0BeJoJwb
         jMJDgrIP0Qg9Vi/9oOaWrsOKZHIAYELRH5f1kbCzhj+oCm2g30y50lY/l2g3hUcCWX
         WV07eMf6FNFQgtFTfHCx6qEIpPOsUqj45NJT+8h95uKbPz6mLM09r5aom+vKWbmdRH
         xmg0VxxGYplMPCwnaT3gRPnrESoZo3VpzWSgpyBZMr1zu41rFtsL9eEj6fDrxJRmH0
         3VWpwEIPEMIBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/6] dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()
Date:   Tue, 10 Aug 2021 10:17:02 -0400
Message-Id: <20210810141707.3118714-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 1da569fa7ec8cb0591c74aa3050d4ea1397778b4 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by moving the error_pm label above the pm_runtime_put() in
the error path.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20210706124521.1371901-1-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/usb-dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sh/usb-dmac.c b/drivers/dma/sh/usb-dmac.c
index cc8fc601ed47..416057d9f0b6 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -863,8 +863,8 @@ static int usb_dmac_probe(struct platform_device *pdev)
 
 error:
 	of_dma_controller_free(pdev->dev.of_node);
-	pm_runtime_put(&pdev->dev);
 error_pm:
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return ret;
 }
-- 
2.30.2

