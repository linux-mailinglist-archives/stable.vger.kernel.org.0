Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA6E290174
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406106AbgJPJOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395028AbgJPJJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B8FC212CC;
        Fri, 16 Oct 2020 09:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839385;
        bh=6HP10IP118D6l8T8lb1SWq27f6WOu9aeHQJxH/+BAjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwmpevMiWgGEvsMvBXj24CJF0MQloQfPNqv+UNTLuIJEZRHPz6UmzsL5CvnkdEuYN
         lK8wtVKtdU90vLOGiFrMsxIzUBfUmxx18VsvvVzf1VfQcc4LGuL/C2fDHB/MarNptE
         1GDcyFqFtF0fx87bOkOreu7D37WrHEJEeSHxlxQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 19/21] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case
Date:   Fri, 16 Oct 2020 11:07:38 +0200
Message-Id: <20201016090438.228311987@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.301376476@linuxfoundation.org>
References: <20201016090437.301376476@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud Patard <arnaud.patard@rtp-net.org>

commit d934423ac26ed373dfe089734d505dca5ff679b6 upstream.

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
 drivers/net/ethernet/marvell/mvmdio.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -319,15 +319,25 @@ static int orion_mdio_probe(struct platf
 
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


