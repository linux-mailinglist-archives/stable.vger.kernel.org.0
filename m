Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9E0A9079
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389655AbfIDSJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389995AbfIDSJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:09:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 331FB206BA;
        Wed,  4 Sep 2019 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620590;
        bh=yMRiPjJCDCrWwaba189PEzv2WS8Kj1Ngv2uHAWDGFeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q63/JtLeWcxsDtVU/ZTI8YorSGSHMhqUgiwk4K/5nvBZrvKplOdpjSsjX1Ek1X2mV
         d+hIOAj/2z7X5mgOMSM1ItvWgsCcTsFHosnhmAuYOKfnCY7QODenRo9CP4erhH+3C5
         0q3oTwQYfP+rM/1ym5cY2L6kd/kiX/EvSqHSSdDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 022/143] dmaengine: stm32-mdma: Fix a possible null-pointer dereference in stm32_mdma_irq_handler()
Date:   Wed,  4 Sep 2019 19:52:45 +0200
Message-Id: <20190904175314.938721216@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 39c71a5b8212f4b502d9a630c6706ac723abd422 ]

In stm32_mdma_irq_handler(), chan is checked on line 1368.
When chan is NULL, it is still used on line 1369:
    dev_err(chan2dev(chan), "MDMA channel not initialized\n");

Thus, a possible null-pointer dereference may occur.

To fix this bug, "dev_dbg(mdma2dev(dmadev), ...)" is used instead.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Fixes: a4ffb13c8946 ("dmaengine: Add STM32 MDMA driver")
Link: https://lore.kernel.org/r/20190729020849.17971-1-baijiaju1990@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-mdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/stm32-mdma.c b/drivers/dma/stm32-mdma.c
index d6e919d3936a2..1311de74bfdde 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -1366,7 +1366,7 @@ static irqreturn_t stm32_mdma_irq_handler(int irq, void *devid)
 
 	chan = &dmadev->chan[id];
 	if (!chan) {
-		dev_err(chan2dev(chan), "MDMA channel not initialized\n");
+		dev_dbg(mdma2dev(dmadev), "MDMA channel not initialized\n");
 		goto exit;
 	}
 
-- 
2.20.1



