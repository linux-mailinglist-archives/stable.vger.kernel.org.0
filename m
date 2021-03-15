Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A90D33B8FB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhCOOFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231396AbhCON6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F032D64F09;
        Mon, 15 Mar 2021 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816714;
        bh=1Y5FO9BvAPAx2ArE/6bv6jyWdZ4YW6aGlxWmcnfu9lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXL/O5iNcnEseOSKHknOx3liiIEinW1kEFxn7nwrJSAeZcagNRfjUb/QLSy7l3NUY
         QAnLkWFGo0aKY2xgxTaMCsQv4VJg6E817ox4lk+COyfPDnyP7hAMACBCpFU+HTRg2c
         ZBZpf/7Ev8Rn0ODxPpd8zT+ukfgy9xNSMxsRUncc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.11 080/306] net: stmmac: stop each tx channel independently
Date:   Mon, 15 Mar 2021 14:52:23 +0100
Message-Id: <20210315135510.349640185@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
@@ -53,10 +53,6 @@ void dwmac4_dma_stop_tx(void __iomem *io
 
 	value &= ~DMA_CONTROL_ST;
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
-
-	value = readl(ioaddr + GMAC_CONFIG);
-	value &= ~GMAC_CONFIG_TE;
-	writel(value, ioaddr + GMAC_CONFIG);
 }
 
 void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan)


