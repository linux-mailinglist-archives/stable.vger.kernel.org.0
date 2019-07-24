Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070A374556
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404690AbfGYFlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404686AbfGYFlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:41:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD5122BF3;
        Thu, 25 Jul 2019 05:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033295;
        bh=9g7CCjjavbfNXhLex0hZ7r+JBm+d9AM+T5LNW3TD2NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COUtcW7z4ZzpJewpoICCof7kwNn4zhBTvr+6TjVORY5fzd7yBMSa5Mi4/tLji91E6
         VBGkirfUTmLG2KxnF0fZaY5Z9lvfBbJjtWwJgqz6JpITgUuKAXYPCrheuhLxfoBxOG
         vRFrcYyQ9Bzd6AYvqFR2WnlazqZdYxTiVUUCBa1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josua Mayer <josua@solid-run.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/271] net: mvmdio: defer probe of orion-mdio if a clock is not ready
Date:   Wed, 24 Jul 2019 21:20:27 +0200
Message-Id: <20190724191708.744939917@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 433a06d7d74e677c40b1148c70c48677ff62fb6b ]

Defer probing of the orion-mdio interface when getting a clock returns
EPROBE_DEFER. This avoids locking up the Armada 8k SoC when mdio is used
before all clocks have been enabled.

Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvmdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index c5dac6bd2be4..903836e334d8 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -321,6 +321,10 @@ static int orion_mdio_probe(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
 		dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
+		if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto out_clk;
+		}
 		if (IS_ERR(dev->clk[i]))
 			break;
 		clk_prepare_enable(dev->clk[i]);
@@ -362,6 +366,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
 	if (dev->err_interrupt > 0)
 		writel(0, dev->regs + MVMDIO_ERR_INT_MASK);
 
+out_clk:
 	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
 		if (IS_ERR(dev->clk[i]))
 			break;
-- 
2.20.1



