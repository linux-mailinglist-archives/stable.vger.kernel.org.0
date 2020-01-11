Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FAC1380DA
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731706AbgAKKer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:34:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgAKKeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:34:46 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5450220842;
        Sat, 11 Jan 2020 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738886;
        bh=ywR3dKnTOobjdUkovDCczSc/ksABxXIILvekC+jkN5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLHbxAc79UAKWubNSGCVbttRKJkE11ymzLP9RnauuIYSPlf3TkWLmgn1axVZEjzdd
         Tt++/WTf534TmQn3Wuu4Fku/gBCt/43haXubJNRjoTsDuS3cq/4+pK3XI35nSOwCJp
         joBVRvJrHcG0Ebo9QblPbrwQNReHtHoTn7lRPC6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Yash Shah <yash.shah@sifive.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <sboyd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 155/165] macb: Dont unregister clks unconditionally
Date:   Sat, 11 Jan 2020 10:51:14 +0100
Message-Id: <20200111094941.624505930@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit d89091a4930ee0d80bee3e259a98513f3a2543ec ]

The only clk init function in this driver that register a clk is
fu540_c000_clk_init(), and thus we need to unregister the clk when this
driver is removed on that platform. Other init functions, for example
macb_clk_init(), don't register clks and therefore we shouldn't
unregister the clks when this driver is removed. Convert this
registration path to devm so it gets auto-unregistered when this driver
is removed and drop the clk_unregister() calls in driver remove (and
error paths) so that we don't erroneously remove a clk from the system
that isn't registered by this driver.

Otherwise we get strange crashes with a use-after-free when the
devm_clk_get() call in macb_clk_init() calls clk_put() on a clk pointer
that has become invalid because it is freed in clk_unregister().

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Yash Shah <yash.shah@sifive.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: c218ad559020 ("macb: Add support for SiFive FU540-C000")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4027,7 +4027,7 @@ static int fu540_c000_clk_init(struct pl
 	mgmt->rate = 0;
 	mgmt->hw.init = &init;
 
-	*tx_clk = clk_register(NULL, &mgmt->hw);
+	*tx_clk = devm_clk_register(&pdev->dev, &mgmt->hw);
 	if (IS_ERR(*tx_clk))
 		return PTR_ERR(*tx_clk);
 
@@ -4361,7 +4361,6 @@ err_out_free_netdev:
 
 err_disable_clocks:
 	clk_disable_unprepare(tx_clk);
-	clk_unregister(tx_clk);
 	clk_disable_unprepare(hclk);
 	clk_disable_unprepare(pclk);
 	clk_disable_unprepare(rx_clk);
@@ -4397,7 +4396,6 @@ static int macb_remove(struct platform_d
 		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		if (!pm_runtime_suspended(&pdev->dev)) {
 			clk_disable_unprepare(bp->tx_clk);
-			clk_unregister(bp->tx_clk);
 			clk_disable_unprepare(bp->hclk);
 			clk_disable_unprepare(bp->pclk);
 			clk_disable_unprepare(bp->rx_clk);


