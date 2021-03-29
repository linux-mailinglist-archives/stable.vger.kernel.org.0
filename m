Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082E334C8E3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhC2IYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233751AbhC2IXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B17C61477;
        Mon, 29 Mar 2021 08:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006216;
        bh=eEJVoYkaI1r84j3V+kCRgMCnPWmDDoAETWzeYyE3snY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCHCQ1EPU/7BtSphSUU89fyBOX8OL5jxR9m6RdCA+gyL1L3MaXQseT+pnGjoCyJw0
         hgqzGrZTkqux2Cdf8+sEoEv4SVbfowPcrcde05h6JKcqjp9Pg21VBcCoIM1ZTqFdc8
         xKzNZRPB34rjQg0xGzF+8tZerkxYvwlmrW/BaU80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Belisko Marek <marek.belisko@gmail.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/221] net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes
Date:   Mon, 29 Mar 2021 09:58:11 +0200
Message-Id: <20210329075634.495320332@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index a5e0eff4a387..9f5ccf1a0a54 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1217,6 +1217,8 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	plat_dat->init = sun8i_dwmac_init;
 	plat_dat->exit = sun8i_dwmac_exit;
 	plat_dat->setup = sun8i_dwmac_setup;
+	plat_dat->tx_fifo_size = 4096;
+	plat_dat->rx_fifo_size = 16384;
 
 	ret = sun8i_dwmac_set_syscon(&pdev->dev, plat_dat);
 	if (ret)
-- 
2.30.1



