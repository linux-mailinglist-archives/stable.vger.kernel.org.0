Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07C411E36
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfEBP1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727872AbfEBP1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:27:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E884320675;
        Thu,  2 May 2019 15:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810823;
        bh=FDNU4kDC2n76Cl9nLieE106/2Os9s6nt8AFRwtENVIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3swyAHHUo+ZIT/E/cr9a8xJ20zrZAH8IG3mSXWBPzDLVUn7/Q+RMadX0u7FPt8ap
         W0iy2YwLmQyTTxAgAPPtlAxjLYwyO7QgVV9loW+OCJlQmlep2MK20b9ec6p1qKxH65
         aDntSVtx6dh7I24W+z9Bmawma4E4LE5zFUZeOpnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 41/72] net: macb: Add null check for PCLK and HCLK
Date:   Thu,  2 May 2019 17:21:03 +0200
Message-Id: <20190502143336.755702883@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cd5afa91f078c0787be0a62b5ef90301c00b0271 ]

Both PCLK and HCLK are "required" clocks according to macb devicetree
documentation. There is a chance that devm_clk_get doesn't return a
negative error but just a NULL clock structure instead. In such a case
the driver proceeds as usual and uses pclk value 0 to calculate MDC
divisor which is incorrect. Hence fix the same in clock initialization.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 8abea1c3844f..7d7b51383adf 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3323,14 +3323,20 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		*hclk = devm_clk_get(&pdev->dev, "hclk");
 	}
 
-	if (IS_ERR(*pclk)) {
+	if (IS_ERR_OR_NULL(*pclk)) {
 		err = PTR_ERR(*pclk);
+		if (!err)
+			err = -ENODEV;
+
 		dev_err(&pdev->dev, "failed to get macb_clk (%u)\n", err);
 		return err;
 	}
 
-	if (IS_ERR(*hclk)) {
+	if (IS_ERR_OR_NULL(*hclk)) {
 		err = PTR_ERR(*hclk);
+		if (!err)
+			err = -ENODEV;
+
 		dev_err(&pdev->dev, "failed to get hclk (%u)\n", err);
 		return err;
 	}
-- 
2.19.1



