Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBEE2E3B88
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406826AbgL1NvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:51:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406787AbgL1NvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C1F8205CB;
        Mon, 28 Dec 2020 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163459;
        bh=LPSr3OeM8MJl3yOVD3DmK3SgQLLLiSkciydMM+9pd8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsJ4DCF3/0Y5RSBWGOLP1cGQDDG3GrOpcesH9JVGnOaRxj2P2tDH4/NA4mExz4Gb0
         H2k4VnAZ5jQo5YxYNtvd4DM/5TZmqOm5md607lDSO4ML+hIU7unSW/ykl/Ok1+J+5D
         5OlqEqbVYVr94/BHiNr9BBBqMKJt93Azl5/i2UXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 293/453] net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
Date:   Mon, 28 Dec 2020 13:48:49 +0100
Message-Id: <20201228124951.303092806@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index ff318472a3eef..95155a1f9f9dc 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -845,13 +845,13 @@ static int emac_probe(struct platform_device *pdev)
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



