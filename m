Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F4FCAC71
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbfJCQKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387585AbfJCQKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:10:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89D88207FF;
        Thu,  3 Oct 2019 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119013;
        bh=++ww0M8FldhONH/sKfUkcOspcDTMgTrhuVQH5MzsDWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzvFHoCZrr6Db+GfCUPcWT0hY2OKXqqbLXPbqvt5yFiFWHckn25tWOMZ0mCTZMxuz
         aR8G5JWmrPs7Sru4l/7oid0Q6uis1JVMau4qY2MqDxYfSMWyWja6EX8KQtv37AeJqs
         g0vq0Air8MDfoc/XjAYNF2vw0yIZvSXrJ1Ox8JGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 094/185] net: lpc-enet: fix printk format strings
Date:   Thu,  3 Oct 2019 17:52:52 +0200
Message-Id: <20191003154459.576180428@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit de6f97b2bace0e2eb6c3a86e124d1e652a587b56 ]

compile-testing this driver on other architectures showed
multiple warnings:

  drivers/net/ethernet/nxp/lpc_eth.c: In function 'lpc_eth_drv_probe':
  drivers/net/ethernet/nxp/lpc_eth.c:1337:19: warning: format '%d' expects argument of type 'int', but argument 4 has type 'resource_size_t {aka long long unsigned int}' [-Wformat=]

  drivers/net/ethernet/nxp/lpc_eth.c:1342:19: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t {aka long long unsigned int}' [-Wformat=]

Use format strings that work on all architectures.

Link: https://lore.kernel.org/r/20190809144043.476786-10-arnd@arndb.de
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 08381ef8bdb48..41d30f55c946b 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1371,13 +1371,14 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	pldat->dma_buff_base_p = dma_handle;
 
 	netdev_dbg(ndev, "IO address space     :%pR\n", res);
-	netdev_dbg(ndev, "IO address size      :%d\n", resource_size(res));
+	netdev_dbg(ndev, "IO address size      :%zd\n",
+			(size_t)resource_size(res));
 	netdev_dbg(ndev, "IO address (mapped)  :0x%p\n",
 			pldat->net_base);
 	netdev_dbg(ndev, "IRQ number           :%d\n", ndev->irq);
-	netdev_dbg(ndev, "DMA buffer size      :%d\n", pldat->dma_buff_size);
-	netdev_dbg(ndev, "DMA buffer P address :0x%08x\n",
-			pldat->dma_buff_base_p);
+	netdev_dbg(ndev, "DMA buffer size      :%zd\n", pldat->dma_buff_size);
+	netdev_dbg(ndev, "DMA buffer P address :%pad\n",
+			&pldat->dma_buff_base_p);
 	netdev_dbg(ndev, "DMA buffer V address :0x%p\n",
 			pldat->dma_buff_base_v);
 
@@ -1424,8 +1425,8 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_out_unregister_netdev;
 
-	netdev_info(ndev, "LPC mac at 0x%08x irq %d\n",
-	       res->start, ndev->irq);
+	netdev_info(ndev, "LPC mac at 0x%08lx irq %d\n",
+	       (unsigned long)res->start, ndev->irq);
 
 	phydev = ndev->phydev;
 
-- 
2.20.1



