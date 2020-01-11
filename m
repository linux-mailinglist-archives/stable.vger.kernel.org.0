Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACD7137F74
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgAKKUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:20:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729320AbgAKKUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:20:00 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18620205F4;
        Sat, 11 Jan 2020 10:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737999;
        bh=TfKscB+YyGmraVZx/JDDwLL3JwcC8LoM23ldBIGOkXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scAYGKk+GI4OWA87YSlVgIbYXkeve2f6Zq49b3OdXB4GbyKIgKjbyGMKi3ocO0xjy
         H6+oiujkLWvKTRf2lCRtM0lUvIqcK15Iz+MlUwMIAdOdglCFWoxDGjT+IaecIsA8jU
         wqCSgIUzA/vOW36oBisc6qSRm+Q8eBgATylFzd2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 70/84] net: stmmac: dwmac-sunxi: Allow all RGMII modes
Date:   Sat, 11 Jan 2020 10:50:47 +0100
Message-Id: <20200111094911.365764059@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 52cc73e5404c7ba0cbfc50cb4c265108c84b3d5a ]

Allow all the RGMII modes to be used. This would allow us to represent
the hardware better in the device tree with RGMII_ID where in most
cases the PHY's internal delay for both RX and TX are used.

Fixes: af0bd4e9ba80 ("net: stmmac: sunxi platform extensions for GMAC in Allwinner A20 SoC's")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -53,7 +53,7 @@ static int sun7i_gmac_init(struct platfo
 	 * rate, which then uses the auto-reparenting feature of the
 	 * clock driver, and enabling/disabling the clock.
 	 */
-	if (gmac->interface == PHY_INTERFACE_MODE_RGMII) {
+	if (phy_interface_mode_is_rgmii(gmac->interface)) {
 		clk_set_rate(gmac->tx_clk, SUN7I_GMAC_GMII_RGMII_RATE);
 		clk_prepare_enable(gmac->tx_clk);
 		gmac->clk_enabled = 1;


