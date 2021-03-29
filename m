Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B62134C6C0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhC2IJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232354AbhC2IJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2BD561477;
        Mon, 29 Mar 2021 08:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005350;
        bh=5jfMjQVQa+Jz/Cu6Mly0VKQNQ/tjZGovQqeqfgKaLcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDDi0uMw2NT2R0bIXITsKqwUm7WmaioT8FOY5bnM7WHpZf+I7XOWGgOBbhDJsH3ZQ
         B/q54L8Vb4NuzSE5wHQmdlbi91BVKo1tGeNqZ0DCkrqSdSQaalgRypbcgA1x5rk/f4
         TR9vZyoH95X81nS/ZCXnkIRosiGLLKdn4FSj964w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Belisko Marek <marek.belisko@gmail.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/72] net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes
Date:   Mon, 29 Mar 2021 09:58:26 +0200
Message-Id: <20210329075611.930390137@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 014dfa26ce1c647af09bf506285ef67e0e3f0a6b ]

MTU cannot be changed on dwmac-sun8i. (ip link set eth0 mtu xxx returning EINVAL)
This is due to tx_fifo_size being 0, since this value is used to compute valid
MTU range.
Like dwmac-sunxi (with commit 806fd188ce2a ("net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes"))
dwmac-sun8i need to have tx and rx fifo sizes set.
I have used values from datasheets.
After this patch, setting a non-default MTU (like 1000) value works and network is still useable.

Tested-on: sun8i-h3-orangepi-pc
Tested-on: sun8i-r40-bananapi-m2-ultra
Tested-on: sun50i-a64-bananapi-m64
Tested-on: sun50i-h5-nanopi-neo-plus2
Tested-on: sun50i-h6-pine-h64
Fixes: 9f93ac8d408 ("net-next: stmmac: Add dwmac-sun8i")
Reported-by: Belisko Marek <marek.belisko@gmail.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 1e5e831718db..4382deaeb570 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1179,6 +1179,8 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	plat_dat->init = sun8i_dwmac_init;
 	plat_dat->exit = sun8i_dwmac_exit;
 	plat_dat->setup = sun8i_dwmac_setup;
+	plat_dat->tx_fifo_size = 4096;
+	plat_dat->rx_fifo_size = 16384;
 
 	ret = sun8i_dwmac_init(pdev, plat_dat->bsp_priv);
 	if (ret)
-- 
2.30.1



