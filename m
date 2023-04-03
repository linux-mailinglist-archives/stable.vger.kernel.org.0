Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD446D46E5
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjDCOPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjDCOPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:15:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53292953E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40204B81B35
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C870C433EF;
        Mon,  3 Apr 2023 14:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531305;
        bh=ApVjCvisLECc8T7GZaG4NPq9k5E8KDEEC9ZqL3Xay98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MafvIcnFHGOY9xW83Y5vlgh0Nk8CE3uK3WeVsVvxnqolIwAqxKhGVEMeqRw7LpTDg
         LwrD/42vqmK8EOYUuCLo+SoSwiq/3m25WYylad6gVDl8sjoESYSxTjU0QR8Wf0zovt
         BlYHmWJeVSJeNmDPwOGVGcHlIGWat0Aj3Mo0smPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/84] net: qcom/emac: Fix use after free bug in emac_remove due to race condition
Date:   Mon,  3 Apr 2023 16:08:14 +0200
Message-Id: <20230403140353.835274761@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
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
index 76a9b37c8680f..3c764c28d5dbc 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -752,9 +752,15 @@ static int emac_remove(struct platform_device *pdev)
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



