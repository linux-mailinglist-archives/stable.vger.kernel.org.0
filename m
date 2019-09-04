Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FD5A8FB1
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388454AbfIDSFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389229AbfIDSFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:05:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46D0A2339E;
        Wed,  4 Sep 2019 18:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620315;
        bh=uQ7bGFvchbc9uVNyqhK0ba5uN7WzGjOtITWIVobccd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2zV+4epRxb2X8e9hgmjDp5Zx8vcaeAfswmasLcXbktW6JF4LtMo+m3HtmGTAujSK
         zf2QkMEUz3gAbCB0Cs8cehGmFF86JoJmyqXdkxJn2jGhxJXcUgo84OQKrV9GXCfiEK
         DlOAN/MVuNbC8M9M4BhCD/yZz1aOeQbdPBUZ6Qh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/93] dmaengine: stm32-mdma: Fix a possible null-pointer dereference in stm32_mdma_irq_handler()
Date:   Wed,  4 Sep 2019 19:53:15 +0200
Message-Id: <20190904175304.282960418@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
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
index 06dd1725375e5..8c3c3e5b812a8 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -1376,7 +1376,7 @@ static irqreturn_t stm32_mdma_irq_handler(int irq, void *devid)
 
 	chan = &dmadev->chan[id];
 	if (!chan) {
-		dev_err(chan2dev(chan), "MDMA channel not initialized\n");
+		dev_dbg(mdma2dev(dmadev), "MDMA channel not initialized\n");
 		goto exit;
 	}
 
-- 
2.20.1



