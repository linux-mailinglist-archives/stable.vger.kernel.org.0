Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B31786A64
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404151AbfHHTGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404142AbfHHTGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:06:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04EF321880;
        Thu,  8 Aug 2019 19:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291161;
        bh=+Av3d2kPZIsYYbULr+uL0eeswbcyrNwKWhD1JysRTp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXbWJR7NKpoxfRo9QQNyaAjD0FleZCWmcthnHQiFD39NcaKt5steibH7dKlGoBOpM
         zfEdZ5JZx2nZ4t+E1pTOO9MKsjy3Lv/5Pitrbcndx4B7/0u6tgB38/ecAJEaN2XX/K
         X05eP8M0BssKL7SSiX7n6YT+IO4wFOBEvIhvkMzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 10/56] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case
Date:   Thu,  8 Aug 2019 21:04:36 +0200
Message-Id: <20190808190453.280793067@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>

[ Upstream commit d934423ac26ed373dfe089734d505dca5ff679b6 ]

Orion5.x systems are still using machine files and not device-tree.
Commit 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be
specified for orion-mdio") has replaced devm_clk_get() with of_clk_get(),
leading to a oops at boot and not working network, as reported in
https://lists.debian.org/debian-arm/2019/07/msg00088.html and possibly in
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908712.

Link: https://lists.debian.org/debian-arm/2019/07/msg00088.html
Fixes: 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvmdio.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -319,15 +319,31 @@ static int orion_mdio_probe(struct platf
 
 	init_waitqueue_head(&dev->smi_busy_wait);
 
-	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
-		dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
-		if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
+	if (pdev->dev.of_node) {
+		for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
+			dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
+			if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
+				ret = -EPROBE_DEFER;
+				goto out_clk;
+			}
+			if (IS_ERR(dev->clk[i]))
+				break;
+			clk_prepare_enable(dev->clk[i]);
+		}
+
+		if (!IS_ERR(of_clk_get(pdev->dev.of_node,
+				       ARRAY_SIZE(dev->clk))))
+			dev_warn(&pdev->dev,
+				 "unsupported number of clocks, limiting to the first "
+				 __stringify(ARRAY_SIZE(dev->clk)) "\n");
+	} else {
+		dev->clk[0] = clk_get(&pdev->dev, NULL);
+		if (PTR_ERR(dev->clk[0]) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
 			goto out_clk;
 		}
-		if (IS_ERR(dev->clk[i]))
-			break;
-		clk_prepare_enable(dev->clk[i]);
+		if (!IS_ERR(dev->clk[0]))
+			clk_prepare_enable(dev->clk[0]);
 	}
 
 	dev->err_interrupt = platform_get_irq(pdev, 0);


