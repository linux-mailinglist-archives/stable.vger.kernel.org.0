Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CE61B0997
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgDTMk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgDTMk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:40:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07BAF206D4;
        Mon, 20 Apr 2020 12:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386427;
        bh=Hu8tgyiUBh7gWxY1nr8Tvf+Nyv6VuHNif6h6Bv101GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TI+8lSF7iGIiHrA5sonln0r0U0Yem3eOTrLAAb9FLO3Wl74pFcKq5WeRUHIIBSKqY
         3jnuPSpSDmX7Q6HMquc0//6533ip9BPmNuqkJ6Rg8KzNuXlN05Z7dU6Br/6dzJrUnM
         cVXyBMnIC2Eo9s8It5QtBBldeE8zX9AFC1nCqp94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 19/65] net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes
Date:   Mon, 20 Apr 2020 14:38:23 +0200
Message-Id: <20200420121510.573480956@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 806fd188ce2a4f8b587e83e73c478e6484fbfa55 ]

After commit bfcb813203e619a8960a819bf533ad2a108d8105 ("net: dsa:
configure the MTU for switch ports") my Lamobo R1 platform which uses
an allwinner,sun7i-a20-gmac compatible Ethernet MAC started to fail
by rejecting a MTU of 1536. The reason for that is that the DMA
capabilities are not readable on this version of the IP, and there
is also no 'tx-fifo-depth' property being provided in Device Tree. The
property is documented as optional, and is not provided.

Chen-Yu indicated that the FIFO sizes are 4KB for TX and 16KB for RX, so
provide these values through platform data as an immediate fix until
various Device Tree sources get updated accordingly.

Fixes: eaf4fac47807 ("net: stmmac: Do not accept invalid MTU values")
Suggested-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -150,6 +150,8 @@ static int sun7i_gmac_probe(struct platf
 	plat_dat->init = sun7i_gmac_init;
 	plat_dat->exit = sun7i_gmac_exit;
 	plat_dat->fix_mac_speed = sun7i_fix_speed;
+	plat_dat->tx_fifo_size = 4096;
+	plat_dat->rx_fifo_size = 16384;
 
 	ret = sun7i_gmac_init(pdev, plat_dat->bsp_priv);
 	if (ret)


