Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BA62DEFAC
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgLSNHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgLSM6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:41 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.9 19/49] net: ll_temac: Fix potential NULL dereference in temac_probe()
Date:   Sat, 19 Dec 2020 13:58:23 +0100
Message-Id: <20201219125345.623282459@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit cc6596fc7295e9dcd78156ed42f9f8e1221f7530 ]

platform_get_resource() may fail and in this case a NULL dereference
will occur.

Fix it to use devm_platform_ioremap_resource() instead of calling
platform_get_resource() and devm_ioremap().

This is detected by Coccinelle semantic patch.

@@
expression pdev, res, n, t, e, e1, e2;
@@

res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t, n);
+ if (!res)
+   return -EINVAL;
... when != res == NULL
e = devm_ioremap(e1, res->start, e2);

Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1351,7 +1351,6 @@ static int temac_probe(struct platform_d
 	struct device_node *temac_np = dev_of_node(&pdev->dev), *dma_np;
 	struct temac_local *lp;
 	struct net_device *ndev;
-	struct resource *res;
 	const void *addr;
 	__be32 *p;
 	bool little_endian;
@@ -1500,13 +1499,11 @@ static int temac_probe(struct platform_d
 		of_node_put(dma_np);
 	} else if (pdata) {
 		/* 2nd memory resource specifies DMA registers */
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		lp->sdma_regs = devm_ioremap(&pdev->dev, res->start,
-						     resource_size(res));
-		if (!lp->sdma_regs) {
+		lp->sdma_regs = devm_platform_ioremap_resource(pdev, 1);
+		if (IS_ERR(lp->sdma_regs)) {
 			dev_err(&pdev->dev,
 				"could not map DMA registers\n");
-			return -ENOMEM;
+			return PTR_ERR(lp->sdma_regs);
 		}
 		if (pdata->dma_little_endian) {
 			lp->dma_in = temac_dma_in32_le;


