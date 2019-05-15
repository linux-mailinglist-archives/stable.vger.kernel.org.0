Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2471ECAE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfEOLAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbfEOLAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:00:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD5320843;
        Wed, 15 May 2019 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918014;
        bh=0LLQCSE2fNasj2xKeMezdrIxH17F8BSitWgnINPgfHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocv1vtKwCfyLNdvygGXiOULha6tNR9wEMIcfxAzH2HgpLC7vwydMrijI2zALiOmwl
         OjceWdsBpEgrZv/sG/K5EF+P7acIw+vMaE6ESNwQLKOP7RcHUfwpGiyF66wAifO2lJ
         tthI6q1hVOaXQsipzwphVgJXlnLwjwW3b+kQdBfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Frank Pavlic <f.pavlic@kunbus.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 3.18 20/86] net: ks8851: Set initial carrier state to down
Date:   Wed, 15 May 2019 12:54:57 +0200
Message-Id: <20190515090646.601766733@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9624bafa5f6418b9ca5b3f66d1f6a6a2e8bf6d4c ]

The ks8851 chip's initial carrier state is down. A Link Change Interrupt
is signaled once interrupts are enabled if the carrier is up.

The ks8851 driver has it backwards by assuming that the initial carrier
state is up. The state is therefore misrepresented if the interface is
opened with no cable attached. Fix it.

The Link Change interrupt is sometimes not signaled unless the P1MBSR
register (which contains the Link Status bit) is read on ->ndo_open().
This might be a hardware erratum. Read the register by calling
mii_check_link(), which has the desirable side effect of setting the
carrier state to down if the cable was detached while the interface was
closed.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Frank Pavlic <f.pavlic@kunbus.de>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index f90a1396535a..8a94add287de 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -870,6 +870,7 @@ static int ks8851_net_open(struct net_device *dev)
 	netif_dbg(ks, ifup, ks->netdev, "network device up\n");
 
 	mutex_unlock(&ks->lock);
+	mii_check_link(&ks->mii);
 	return 0;
 }
 
@@ -1527,6 +1528,7 @@ static int ks8851_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, ks);
 
+	netif_carrier_off(ks->netdev);
 	ndev->if_port = IF_PORT_100BASET;
 	ndev->netdev_ops = &ks8851_netdev_ops;
 	ndev->irq = spi->irq;
-- 
2.19.1



