Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67C429B134
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901856AbgJ0O2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901849AbgJ0O17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:27:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F123B206DC;
        Tue, 27 Oct 2020 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808878;
        bh=w+VEKb+Hf3pXAkLmexrxfM5CSLIe4/wyNYmE6gGGBjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XExbuGNi7ipNLXtj2/JebbTO3ZUHHNEGrS/eBxeSOrcutkjWouoKJQ59BLc1I1rZR
         FPcie6aZv+y3L8GDWlyI0cRTtzTguZZUfVo1JvoofK67jYB372TNK3RsODi3+DhnCk
         GEWWAKCjJPQ+dVUmDOHLuN81UVDzbQJPUZ0xLmnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 259/264] net: korina: cast KSEG0 address to pointer in kfree
Date:   Tue, 27 Oct 2020 14:55:17 +0100
Message-Id: <20201027135442.817287009@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>

[ Upstream commit 3bd57b90554b4bb82dce638e0668ef9dc95d3e96 ]

Fixes gcc warning:

passing argument 1 of 'kfree' makes pointer from integer without a cast

Fixes: 3af5f0f5c74e ("net: korina: fix kfree of rx/tx descriptor array")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Link: https://lore.kernel.org/r/20201018184255.28989-1-vvidic@valentin-vidic.from.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/korina.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 5bdff77c0ad10..993f495e2bf7b 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1113,7 +1113,7 @@ static int korina_probe(struct platform_device *pdev)
 	return rc;
 
 probe_err_register:
-	kfree(KSEG0ADDR(lp->td_ring));
+	kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
 probe_err_td_ring:
 	iounmap(lp->tx_dma_regs);
 probe_err_dma_tx:
@@ -1133,7 +1133,7 @@ static int korina_remove(struct platform_device *pdev)
 	iounmap(lp->eth_regs);
 	iounmap(lp->rx_dma_regs);
 	iounmap(lp->tx_dma_regs);
-	kfree(KSEG0ADDR(lp->td_ring));
+	kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
 
 	unregister_netdev(bif->dev);
 	free_netdev(bif->dev);
-- 
2.25.1



