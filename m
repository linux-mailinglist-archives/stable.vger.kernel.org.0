Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A98F408FD2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242997AbhIMNqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243677AbhIMNov (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:44:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FD5E61440;
        Mon, 13 Sep 2021 13:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539874;
        bh=g5bvzzsZ30AzMLtzWBmROfQKl3rddEjPsLLezYEkHdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZ4fsa89q9RMdBjnl97PdjD/WcyayN1vxk1AAhLFj7DSvGRXmtS1yevWJT/2Sqdw1
         fbqh0SEpdUyo33dyKk52jw1mRgSCu1vHjkzWrNFLlT1d0XHNXvb277akYKb8fT4Ofn
         iG2EKxMNPFaVYgnTVYGTGh5w7ryeXapy2b5mb784=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/236] usb: bdc: Fix a resource leak in the error handling path of bdc_probe()
Date:   Mon, 13 Sep 2021 15:15:00 +0200
Message-Id: <20210913131107.010324831@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6f15a2a09cecb7a2faba4a75bbd101f6f962294b ]

If an error occurs after a successful 'clk_prepare_enable()' call, it must
be undone by a corresponding 'clk_disable_unprepare()' call.
This call is already present in the remove function.

Add this call in the error handling path and reorder the code so that the
'clk_prepare_enable()' call happens later in the function.
The goal is to have as much managed resources functions as possible
before the 'clk_prepare_enable()' call in order to keep the error handling
path simple.

While at it, remove the now unneeded 'clk' variable.

Fixes: c87dca047849 ("usb: bdc: Add clock enable for new chips with a separate BDC clock")
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/f8a4a6897deb0c8cb2e576580790303550f15fcd.1629314734.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bdc/bdc_core.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index 251db57e51fa..fa1a3908ec3b 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -488,27 +488,14 @@ static int bdc_probe(struct platform_device *pdev)
 	int irq;
 	u32 temp;
 	struct device *dev = &pdev->dev;
-	struct clk *clk;
 	int phy_num;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	clk = devm_clk_get_optional(dev, "sw_usbd");
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	ret = clk_prepare_enable(clk);
-	if (ret) {
-		dev_err(dev, "could not enable clock\n");
-		return ret;
-	}
-
 	bdc = devm_kzalloc(dev, sizeof(*bdc), GFP_KERNEL);
 	if (!bdc)
 		return -ENOMEM;
 
-	bdc->clk = clk;
-
 	bdc->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(bdc->regs))
 		return PTR_ERR(bdc->regs);
@@ -545,10 +532,20 @@ static int bdc_probe(struct platform_device *pdev)
 		}
 	}
 
+	bdc->clk = devm_clk_get_optional(dev, "sw_usbd");
+	if (IS_ERR(bdc->clk))
+		return PTR_ERR(bdc->clk);
+
+	ret = clk_prepare_enable(bdc->clk);
+	if (ret) {
+		dev_err(dev, "could not enable clock\n");
+		return ret;
+	}
+
 	ret = bdc_phy_init(bdc);
 	if (ret) {
 		dev_err(bdc->dev, "BDC phy init failure:%d\n", ret);
-		return ret;
+		goto disable_clk;
 	}
 
 	temp = bdc_readl(bdc->regs, BDC_BDCCAP1);
@@ -581,6 +578,8 @@ cleanup:
 	bdc_hw_exit(bdc);
 phycleanup:
 	bdc_phy_exit(bdc);
+disable_clk:
+	clk_disable_unprepare(bdc->clk);
 	return ret;
 }
 
-- 
2.30.2



