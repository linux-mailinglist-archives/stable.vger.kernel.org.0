Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EF333B6BA
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhCON6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232176AbhCON5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80FC264F46;
        Mon, 15 Mar 2021 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816673;
        bh=NA7KxTzMwB/3fc+2h+6SWGrMvXG17Xc0AhBUCDyRlew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhYQ4ZUG6hYfkFCVQM6TasYGt0iyDQ4Vj3AABy0FzoVy0GjUWmxHoyrrd0CL5E4Kq
         x/JR6HShI3yCDJVbYsORztX8PE0aCGOn8TZPsfuIkJTeVdn6Z+vqcRd/BhQfkAkuDv
         XNnuh5Go5d1eGwOdsSq7QndJrbdYBiL8rIqJFNdQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 039/168] net: stmmac: stop each tx channel independently
Date:   Mon, 15 Mar 2021 14:54:31 +0100
Message-Id: <20210315135551.631141231@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit a3e860a83397bf761ec1128a3f0ba186445992c6 upstream.

If clear GMAC_CONFIG_TE bit, it would stop all tx channels, but users
may only want to stop specific tx channel.

Fixes: 48863ce5940f ("stmmac: add DMA support for GMAC 4.xx")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -60,10 +60,6 @@ void dwmac4_dma_stop_tx(void __iomem *io
 
 	value &= ~DMA_CONTROL_ST;
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
-
-	value = readl(ioaddr + GMAC_CONFIG);
-	value &= ~GMAC_CONFIG_TE;
-	writel(value, ioaddr + GMAC_CONFIG);
 }
 
 void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan)


