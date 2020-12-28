Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D602E3A09
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390587AbgL1Nbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390563AbgL1NbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:31:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA679207C9;
        Mon, 28 Dec 2020 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162252;
        bh=etFg+hdY9cYDgYnDmZBzPds9btDoJxw4EV86C3JFYyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjskC6bu147HNzftAhWtrye4fy+UpaYTiceUj0lVkCvurlMEv/tqX0m5JJKPHd3cf
         TuoTD7SnuBQdLfMvvFmmT6bOX1QKRCdYqMQ+1AS6t4zN4gnpL/NfbhPD6fvURVXrAE
         y/FFKdeN8bGaAHIAIK8UXbfhT0MPFmWArxlHDH9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/346] net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
Date:   Mon, 28 Dec 2020 13:49:18 +0100
Message-Id: <20201228124931.316767201@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 322e53d1e2529ae9d501f5e0f20604a79b873aef ]

'irq_of_parse_and_map()' should be balanced by a corresponding
'irq_dispose_mapping()' call. Otherwise, there is some resources leaks.

Add such a call in the error handling path of the probe function and in the
remove function.

Fixes: 492205050d77 ("net: Add EMAC ethernet driver found on Allwinner A10 SoC's")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201214202117.146293-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index c458b81ba63af..d249a4309da2f 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -847,13 +847,13 @@ static int emac_probe(struct platform_device *pdev)
 	db->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(db->clk)) {
 		ret = PTR_ERR(db->clk);
-		goto out_iounmap;
+		goto out_dispose_mapping;
 	}
 
 	ret = clk_prepare_enable(db->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "Error couldn't enable clock (%d)\n", ret);
-		goto out_iounmap;
+		goto out_dispose_mapping;
 	}
 
 	ret = sunxi_sram_claim(&pdev->dev);
@@ -910,6 +910,8 @@ out_release_sram:
 	sunxi_sram_release(&pdev->dev);
 out_clk_disable_unprepare:
 	clk_disable_unprepare(db->clk);
+out_dispose_mapping:
+	irq_dispose_mapping(ndev->irq);
 out_iounmap:
 	iounmap(db->membase);
 out:
@@ -928,6 +930,7 @@ static int emac_remove(struct platform_device *pdev)
 	unregister_netdev(ndev);
 	sunxi_sram_release(&pdev->dev);
 	clk_disable_unprepare(db->clk);
+	irq_dispose_mapping(ndev->irq);
 	iounmap(db->membase);
 	free_netdev(ndev);
 
-- 
2.27.0



