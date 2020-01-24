Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67419147C82
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387931AbgAXJwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:52:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbgAXJwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:52:38 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ADEE20709;
        Fri, 24 Jan 2020 09:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859557;
        bh=CCKhI/v2FhCZEj0XpRKJTUEDLmGwIIa6wspr8USUZTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdXHCCkY1iKIVWXDTz7g4HJvI/WUp4iGDOg9ATg+tlXUwsDrqagGRaKjJ3E8e+zHg
         1btjIs+Iq9RasoYUBdyASHLxU1gkvr2Wpr4vgYCMtKjLVAsEOuz96TvB7MI/B7Khf3
         aXm6sd7GkgK0Jj3wRJGUyOWn8X7h4ZYs0Wry/xsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 142/343] net: sh_eth: fix a missing check of of_get_phy_mode
Date:   Fri, 24 Jan 2020 10:29:20 +0100
Message-Id: <20200124092938.680657432@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 035a14e71f27eefa50087963b94cbdb3580d08bf ]

of_get_phy_mode may fail and return a negative error code;
the fix checks the return value of of_get_phy_mode and
returns NULL of it fails.

Fixes: b356e978e92f ("sh_eth: add device tree support")
Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 9b1906a65e113..25f3b2ad26e9c 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3046,12 +3046,16 @@ static struct sh_eth_plat_data *sh_eth_parse_dt(struct device *dev)
 	struct device_node *np = dev->of_node;
 	struct sh_eth_plat_data *pdata;
 	const char *mac_addr;
+	int ret;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return NULL;
 
-	pdata->phy_interface = of_get_phy_mode(np);
+	ret = of_get_phy_mode(np);
+	if (ret < 0)
+		return NULL;
+	pdata->phy_interface = ret;
 
 	mac_addr = of_get_mac_address(np);
 	if (mac_addr)
-- 
2.20.1



