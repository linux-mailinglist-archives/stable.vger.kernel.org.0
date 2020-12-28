Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8952E4037
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390307AbgL1Otp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437978AbgL1OVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD62208B6;
        Mon, 28 Dec 2020 14:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165257;
        bh=+uMgDeA9w8OnEA/mW5D3fzp7g8ppSCKBUrhmboa7jSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgRglz3URPCL0EZ/g0KnZHe/PcPSsCdtmTwYJCXuo6A/Q5z1nnJebJFxGXBdyUbDb
         3M8Op2XEGmM6TkpPq+0UO0iLZSU7z+xgK87/1jqrIaBjExxsJxBKbaMJsFZ6mp4biF
         nCLrEeRx1s1FltuvLqUyvcJyflkt5s7ASZ15Zxdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 468/717] net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
Date:   Mon, 28 Dec 2020 13:47:46 +0100
Message-Id: <20201228125043.392973964@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 862ea44beea77..5ed80d9a6b9fe 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -828,13 +828,13 @@ static int emac_probe(struct platform_device *pdev)
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
@@ -893,6 +893,8 @@ out_release_sram:
 	sunxi_sram_release(&pdev->dev);
 out_clk_disable_unprepare:
 	clk_disable_unprepare(db->clk);
+out_dispose_mapping:
+	irq_dispose_mapping(ndev->irq);
 out_iounmap:
 	iounmap(db->membase);
 out:
@@ -911,6 +913,7 @@ static int emac_remove(struct platform_device *pdev)
 	unregister_netdev(ndev);
 	sunxi_sram_release(&pdev->dev);
 	clk_disable_unprepare(db->clk);
+	irq_dispose_mapping(ndev->irq);
 	iounmap(db->membase);
 	free_netdev(ndev);
 
-- 
2.27.0



