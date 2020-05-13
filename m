Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45F1D0CE0
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732555AbgEMJsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733032AbgEMJsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:48:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F70020753;
        Wed, 13 May 2020 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363296;
        bh=cFAc/IDSVmen1vlXx4gXPx148PrTuQYtAWHIc1Ke8Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJ0d6gSDjMk83z5X9zRh6vQ6P+dVzo1P0IL9DVm8gOU4yUYNbZdHM0hQFpcRrQ6kD
         XWnqR3afxR/a/McZ1tmwy2qari/ctHzdkair0UmaceJVXE/lXb4YpY4ArbPY/YoIfc
         EbWboVsHb/5dhs+hDc4sH1EdQb0IC2Yz14wEhsj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Yash Shah <yash.shah@sifive.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 17/90] net: macb: fix an issue about leak related system resources
Date:   Wed, 13 May 2020 11:44:13 +0200
Message-Id: <20200513094410.642137919@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>

[ Upstream commit b959c77dac09348955f344104c6a921ebe104753 ]

A call of the function macb_init() can fail in the function
fu540_c000_init. The related system resources were not released
then. use devm_platform_ioremap_resource() to replace ioremap()
to fix it.

Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Yash Shah <yash.shah@sifive.com>
Suggested-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4054,15 +4054,9 @@ static int fu540_c000_clk_init(struct pl
 
 static int fu540_c000_init(struct platform_device *pdev)
 {
-	struct resource *res;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!res)
-		return -ENODEV;
-
-	mgmt->reg = ioremap(res->start, resource_size(res));
-	if (!mgmt->reg)
-		return -ENOMEM;
+	mgmt->reg = devm_platform_ioremap_resource(pdev, 1);
+	if (IS_ERR(mgmt->reg))
+		return PTR_ERR(mgmt->reg);
 
 	return macb_init(pdev);
 }


