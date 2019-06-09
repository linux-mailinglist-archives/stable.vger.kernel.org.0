Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0DF3A956
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387978AbfFIREB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388534AbfFIREA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:04:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A1E9204EC;
        Sun,  9 Jun 2019 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099839;
        bh=qgu/3aYKPH8ns+tk3Bx1JV3VWJ2iRA0rJI1PZ7GHb0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyxHNsnx6gW3C0QTcMVsAXNwNTkInjhchKO8AfIbjr1MDnXcpdUtCoZ20s86scaIx
         u4v7xG3GJOwuHMcC1glAAoOG3HEKRyIuGNGELow96BMtxZHu81D375RplrQf6BAN3d
         viNtwYeTuNlSUis6lEBsO9FNnkBlGg7xHDVABxrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 183/241] net: stmmac: fix reset gpio free missing
Date:   Sun,  9 Jun 2019 18:42:05 +0200
Message-Id: <20190609164153.154197923@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit 49ce881c0d4c4a7a35358d9dccd5f26d0e56fc61 ]

Commit 984203ceff27 ("net: stmmac: mdio: remove reset gpio free")
removed the reset gpio free, when the driver is unbinded or rmmod,
we miss the gpio free.

This patch uses managed API to request the reset gpio, so that the
gpio could be freed properly.

Fixes: 984203ceff27 ("net: stmmac: mdio: remove reset gpio free")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -154,7 +154,8 @@ int stmmac_mdio_reset(struct mii_bus *bu
 			of_property_read_u32_array(np,
 				"snps,reset-delays-us", data->delays, 3);
 
-			if (gpio_request(data->reset_gpio, "mdio-reset"))
+			if (devm_gpio_request(priv->device, data->reset_gpio,
+					      "mdio-reset"))
 				return 0;
 		}
 


