Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE9560FDC5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbiJ0Q6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236634AbiJ0Q6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BFC17999B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5316F623EC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FF1C433C1;
        Thu, 27 Oct 2022 16:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889930;
        bh=KkjluqTaCGdfRlJCQ2CD8Adk+I3oPN6UwH52JoFZjZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tD4grfVbuhSCk00jJJ5XMubbXaqj9vUxbe5b42JYM50Z/Y3RCDqcTaq/6xYxtv2bj
         2DGe6IO6gGgjIqm/2N+iz/ifu3V+UnceQN7xD918Nie+dDZUc/ftZ+Qh2C49f4hQlD
         qQhhce4ggN3BaNccxJUxMDJiD5Cc82dDNcBzZtms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 52/94] net: ethernet: mtk_eth_soc: fix possible memory leak in mtk_probe()
Date:   Thu, 27 Oct 2022 18:54:54 +0200
Message-Id: <20221027165059.275923483@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b3d0d98179d62f9d55635a600679c4fa362baf8d ]

If mtk_wed_add_hw() has been called, mtk_wed_exit() needs be called
in error path or removing module to free the memory allocated in
mtk_wed_add_hw().

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b344632beadd..84433f3a3e22 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4028,19 +4028,23 @@ static int mtk_probe(struct platform_device *pdev)
 			eth->irq[i] = platform_get_irq(pdev, i);
 		if (eth->irq[i] < 0) {
 			dev_err(&pdev->dev, "no IRQ%d resource found\n", i);
-			return -ENXIO;
+			err = -ENXIO;
+			goto err_wed_exit;
 		}
 	}
 	for (i = 0; i < ARRAY_SIZE(eth->clks); i++) {
 		eth->clks[i] = devm_clk_get(eth->dev,
 					    mtk_clks_source_name[i]);
 		if (IS_ERR(eth->clks[i])) {
-			if (PTR_ERR(eth->clks[i]) == -EPROBE_DEFER)
-				return -EPROBE_DEFER;
+			if (PTR_ERR(eth->clks[i]) == -EPROBE_DEFER) {
+				err = -EPROBE_DEFER;
+				goto err_wed_exit;
+			}
 			if (eth->soc->required_clks & BIT(i)) {
 				dev_err(&pdev->dev, "clock %s not found\n",
 					mtk_clks_source_name[i]);
-				return -EINVAL;
+				err = -EINVAL;
+				goto err_wed_exit;
 			}
 			eth->clks[i] = NULL;
 		}
@@ -4051,7 +4055,7 @@ static int mtk_probe(struct platform_device *pdev)
 
 	err = mtk_hw_init(eth);
 	if (err)
-		return err;
+		goto err_wed_exit;
 
 	eth->hwlro = MTK_HAS_CAPS(eth->soc->caps, MTK_HWLRO);
 
@@ -4140,6 +4144,8 @@ static int mtk_probe(struct platform_device *pdev)
 	mtk_free_dev(eth);
 err_deinit_hw:
 	mtk_hw_deinit(eth);
+err_wed_exit:
+	mtk_wed_exit();
 
 	return err;
 }
@@ -4159,6 +4165,7 @@ static int mtk_remove(struct platform_device *pdev)
 		phylink_disconnect_phy(mac->phylink);
 	}
 
+	mtk_wed_exit();
 	mtk_hw_deinit(eth);
 
 	netif_napi_del(&eth->tx_napi);
-- 
2.35.1



