Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8CA66CBCB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbjAPRSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbjAPRQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:16:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9FD442E7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:57:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 757B3B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D63C433D2;
        Mon, 16 Jan 2023 16:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888248;
        bh=x/E1275++nriudEESdByvvdrjuZIyYgblZbV1ffGE7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfVqZx9usiImbBayaMn6XUkryYsIHdr94ucWkGkjb6PEZA5B7FX093TMbjdhGy8kl
         AmqyCSUxAZm1o324+4WcKEKskID6HWT3RiM1mLhuH3aSDIwx4Iwsz0OFAMy/Bq4BHZ
         J+P9tjt9W9C83BKPHR0Rc4zilJGPBxkJFulCPSqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Biju Das <biju.das.jz@bp.renesas.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 427/521] ravb: Fix "failed to switch device to config mode" message during unbind
Date:   Mon, 16 Jan 2023 16:51:29 +0100
Message-Id: <20230116154906.224055927@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit c72a7e42592b2e18d862cf120876070947000d7a ]

This patch fixes the error "ravb 11c20000.ethernet eth0: failed to switch
device to config mode" during unbind.

We are doing register access after pm_runtime_put_sync().

We usually do cleanup in reverse order of init. Currently in
remove(), the "pm_runtime_put_sync" is not in reverse order.

Probe
	reset_control_deassert(rstc);
	pm_runtime_enable(&pdev->dev);
	pm_runtime_get_sync(&pdev->dev);

remove
	pm_runtime_put_sync(&pdev->dev);
	unregister_netdev(ndev);
	..
	ravb_mdio_release(priv);
	pm_runtime_disable(&pdev->dev);

Consider the call to unregister_netdev()
unregister_netdev->unregister_netdevice_queue->rollback_registered_many
that calls the below functions which access the registers after
pm_runtime_put_sync()
 1) ravb_get_stats
 2) ravb_close

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221214105118.2495313-1-biju.das.jz@bp.renesas.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9077014f6f40..ff374d0d80a7 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2199,11 +2199,11 @@ static int ravb_remove(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 	/* Set reset mode */
 	ravb_write(ndev, CCC_OPC_RESET, CCC);
-	pm_runtime_put_sync(&pdev->dev);
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
 	ravb_mdio_release(priv);
+	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	free_netdev(ndev);
 	platform_set_drvdata(pdev, NULL);
-- 
2.35.1



