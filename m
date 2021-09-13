Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1152D409244
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbhIMOKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244661AbhIMOHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3AB661A7F;
        Mon, 13 Sep 2021 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540433;
        bh=JBQB5X22bH4OzR+eKPJgzLOALvNt7tgd3bqA+ZtKwIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2M9dbxeRz0h9bp66rp134CKaisdqc0+ScZxIWokMPRzn2CxP253smQE0Yyg5fMLE
         SNN5wcgmBsBWRCRLDWNK4t9sNwXtrv8c1UFoiIiLOjjLOqpwfyiqDvv7JXfWamDKXc
         Vd0SqQiqKb85OKqdyZ5i6Ef6Jgvc0Mw5gsX1ihoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Voon Weifeng <weifeng.voon@intel.com>,
        Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 190/300] net: stmmac: fix INTR TBU status affecting irq count statistic
Date:   Mon, 13 Sep 2021 15:14:11 +0200
Message-Id: <20210913131115.803296796@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

[ Upstream commit 1975df880b959e30f28d66148a12d77b458abd76 ]

DMA channel status "Transmit buffer unavailable(TBU)" bit is not
considered as a successful dma tx. Hence, it should not affect
all the irq count statistic.

Fixes: 1103d3a5531c ("net: stmmac: dwmac4: Also use TBU interrupt to clean TX path")
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index e63270267578..f83db62938dd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -172,11 +172,12 @@ int dwmac4_dma_interrupt(void __iomem *ioaddr,
 		x->rx_normal_irq_n++;
 		ret |= handle_rx;
 	}
-	if (likely(intr_status & (DMA_CHAN_STATUS_TI |
-		DMA_CHAN_STATUS_TBU))) {
+	if (likely(intr_status & DMA_CHAN_STATUS_TI)) {
 		x->tx_normal_irq_n++;
 		ret |= handle_tx;
 	}
+	if (unlikely(intr_status & DMA_CHAN_STATUS_TBU))
+		ret |= handle_tx;
 	if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
 		x->rx_early_irq++;
 
-- 
2.30.2



