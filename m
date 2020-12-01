Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB352C9D2C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390755AbgLAJTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389221AbgLAJJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:09:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C326D206CA;
        Tue,  1 Dec 2020 09:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813774;
        bh=XU355mrKT77scx7mv1cBMHYh9RK2g5pjjm9Cv/KA7NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSQuqMh6r2lKA+kxsykHoUjTxRYqI89/mcYGdhJMAEGgr6vE5LssVCpSMj9N1O8ys
         uYp0GoMAdkjTbg19jGsMu0P5TuevQ1oKgJIrxeZl8WwESmtamWYqoYQgUk0D6Tk1ig
         AY/VgR0hNtiDKfO5hjOcn8hzeBh1/crHFY170dp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 055/152] net: stmmac: dwmac_lib: enlarge dma reset timeout
Date:   Tue,  1 Dec 2020 09:52:50 +0100
Message-Id: <20201201084719.147963033@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit 56311a315da7ebc668dbcc2f1c99689cc10796c4 ]

If the phy enables power saving technology, the dwmac's software reset
needs more time to complete, enlarge dma reset timeout to 200000us.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Link: https://lore.kernel.org/r/20201113090902.5c7aab1a@xhacker.debian
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index cb87d31a99dfb..57a53a600aa55 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -23,7 +23,7 @@ int dwmac_dma_reset(void __iomem *ioaddr)
 
 	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
 				 !(value & DMA_BUS_MODE_SFT_RESET),
-				 10000, 100000);
+				 10000, 200000);
 }
 
 /* CSR1 enables the transmit DMA to check for new descriptor */
-- 
2.27.0



