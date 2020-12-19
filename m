Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69272DEFA5
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbgLSNGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727280AbgLSNDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:03:43 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 16/34] net: ll_temac: Fix potential NULL dereference in temac_probe()
Date:   Sat, 19 Dec 2020 14:03:13 +0100
Message-Id: <20201219125342.181724337@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
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
 drivers/net/ethernet/xilinx/ll_temac_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1425,9 +1425,7 @@ static int temac_probe(struct platform_d
 		of_node_put(dma_np);
 	} else if (pdata) {
 		/* 2nd memory resource specifies DMA registers */
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		lp->sdma_regs = devm_ioremap_nocache(&pdev->dev, res->start,
-						     resource_size(res));
+		lp->sdma_regs = devm_platform_ioremap_resource(pdev, 1);
 		if (IS_ERR(lp->sdma_regs)) {
 			dev_err(&pdev->dev,
 				"could not map DMA registers\n");


