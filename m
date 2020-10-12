Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5978628B7B6
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389836AbgJLNqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389830AbgJLNqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6B021D81;
        Mon, 12 Oct 2020 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510371;
        bh=bmXrs6Eo2u5AUVJJLJ2PFJDy+nEctI0yf9XvJco5+9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpkxn4YB/4T7h5U5zIlstqC4gKYTQqGO+yKfxeEGncn5Q8+sfBVr3BJJ2FxCCSwwM
         unCNZ7wBuFgv88y8TzYRUXmGTMFdLngt66FGWDTySib/8gwfBTVq4qpt5gUm3KyEPa
         kXQ0Q91Utct14UoVAiTqSMkWStjb7epFmGbNznvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 070/124] net: stmmac: Fix clock handling on remove path
Date:   Mon, 12 Oct 2020 15:31:14 +0200
Message-Id: <20201012133150.243950163@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>

[ Upstream commit ac322f86b56cb99d1c4224c209095aa67647c967 ]

While unloading the dwmac-intel driver, clk_disable_unprepare() is
being called twice in stmmac_dvr_remove() and
intel_eth_pci_remove(). This causes kernel panic on the second call.

Removing the second call of clk_disable_unprepare() in
intel_eth_pci_remove().

Fixes: 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove paths")
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 2ac9dfb3462c6..9e6d60e75f85d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -653,7 +653,6 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	pci_free_irq_vectors(pdev);
 
-	clk_disable_unprepare(priv->plat->stmmac_clk);
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	pcim_iounmap_regions(pdev, BIT(0));
-- 
2.25.1



