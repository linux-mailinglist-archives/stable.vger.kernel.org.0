Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC6033B766
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhCOOAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231422AbhCON7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E4CF64E83;
        Mon, 15 Mar 2021 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816730;
        bh=9ePwYnwhBKuyVuujznYnndoTArbDbP4WcimtpsYv5tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bS2uQpqQI73uTk9HApTeEnnnqVW/pV+h2qFLyCYR7DgD65norQYT/ZFGpLRkiUAwQ
         83212KXEfIPrZ4JCs9Vb5joprY4sqbsJprkspYF8OoSbBMTWQFnJ4vJY5PtS+sou44
         NzI2JzsThMUgxB+FlWRunoxpmBNJ4NVLnZPWDgt4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 24/95] net: stmmac: stop each tx channel independently
Date:   Mon, 15 Mar 2021 14:56:54 +0100
Message-Id: <20210315135741.070108332@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
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
@@ -63,10 +63,6 @@ void dwmac4_dma_stop_tx(void __iomem *io
 
 	value &= ~DMA_CONTROL_ST;
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
-
-	value = readl(ioaddr + GMAC_CONFIG);
-	value &= ~GMAC_CONFIG_TE;
-	writel(value, ioaddr + GMAC_CONFIG);
 }
 
 void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan)


