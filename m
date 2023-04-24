Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEFA6D4745
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbjDCOSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbjDCOSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:18:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9981F2C9EE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:18:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 303ED61CEB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46834C433EF;
        Mon,  3 Apr 2023 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531525;
        bh=7yTdyPEdt1T6TU/RdjcpX5ybfC60Dmwad/+yB0Qvgsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VK7wbb1A0sEejQCCzc/JzUKilJ9D1ELgRmBsZF/52eXb/bms2n69XZtFrnJ/KmGvD
         /qMCAONi3dnvMw2EJaf6x30RzOywReXI9NuMDIGYnzdn8HjEZ0kPhmEQQgHarI7jVa
         b291qAwcWgyeqCiIsIDN4fUGL8q4VCze6O5iWI3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/104] net: qcom/emac: Fix use after free bug in emac_remove due to race condition
Date:   Mon,  3 Apr 2023 16:08:04 +0200
Message-Id: <20230403140404.641902364@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 6b6bc5b8bd2d4ca9e1efa9ae0f98a0b0687ace75 ]

In emac_probe, &adpt->work_thread is bound with
emac_work_thread. Then it will be started by timeout
handler emac_tx_timeout or a IRQ handler emac_isr.

If we remove the driver which will call emac_remove
  to make cleanup, there may be a unfinished work.

The possible sequence is as follows:

Fix it by finishing the work before cleanup in the emac_remove
and disable timeout response.

CPU0                  CPU1

                    |emac_work_thread
emac_remove         |
free_netdev         |
kfree(netdev);      |
                    |emac_reinit_locked
                    |emac_mac_down
                    |//use netdev
Fixes: b9b17debc69d ("net: emac: emac gigabit ethernet controller driver")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/emac/emac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 5c199d2516d47..5fe28dec60c1d 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -738,9 +738,15 @@ static int emac_remove(struct platform_device *pdev)
 	struct net_device *netdev = dev_get_drvdata(&pdev->dev);
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
 	unregister_netdev(netdev);
 	netif_napi_del(&adpt->rx_q.napi);
 
+	free_irq(adpt->irq.irq, &adpt->irq);
+	cancel_work_sync(&adpt->work_thread);
+
 	emac_clks_teardown(adpt);
 
 	put_device(&adpt->phydev->mdio.dev);
-- 
2.39.2



