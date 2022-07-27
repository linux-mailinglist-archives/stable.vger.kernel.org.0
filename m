Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F72558302B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbiG0RfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242103AbiG0Rdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:33:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972EE8238B;
        Wed, 27 Jul 2022 09:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5331BB821BE;
        Wed, 27 Jul 2022 16:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C9BC433D7;
        Wed, 27 Jul 2022 16:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940513;
        bh=y2bd9DdpkECpZ4Av2R+aDyqf3jrPr/dleq0g0aAcroA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lk3ShVJ/cqdmsu2swPbE8ioip4Ih0Wq5RnZfVd6Mi1k8h8j/PUbZitcWRR90GjBpr
         ENzJlyniN+9UyGcujolWE0n5qGvLG2TPt14VgPwc5ftfwOD0oObwmzHiyG+V+iqJqu
         L9rDGbanRLUP0oB+9GLJJTdqjJ31+jntrbGVJOlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biao Huang <biao.huang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 049/158] net: stmmac: fix pm runtime issue in stmmac_dvr_remove()
Date:   Wed, 27 Jul 2022 18:11:53 +0200
Message-Id: <20220727161023.483659059@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>

[ Upstream commit 0d9a15913b871e03fdd3b3d90a2e665fb22f9bcf ]

If netif is running when stmmac_dvr_remove is invoked,
the unregister_netdev will call ndo_stop(stmmac_release) and
vlan_kill_rx_filter(stmmac_vlan_rx_kill_vid).

Currently, stmmac_dvr_remove() will disable pm runtime before
unregister_netdev. When stmmac_vlan_rx_kill_vid is invoked,
pm_runtime_resume_and_get in it returns EACCESS error number,
and reports:

	dwmac-mediatek 11021000.ethernet eth0: stmmac_dvr_remove: removing driver
	dwmac-mediatek 11021000.ethernet eth0: FPE workqueue stop
	dwmac-mediatek 11021000.ethernet eth0: failed to kill vid 0081/0

Move the pm_runtime_disable to the end of stmmac_dvr_remove
to fix this issue.

Fixes: 6449520391dfc ("net: stmmac: properly handle with runtime pm in stmmac_dvr_remove()")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2525a80353b7..d43c9ba0b270 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7220,8 +7220,6 @@ int stmmac_dvr_remove(struct device *dev)
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
 	pm_runtime_get_sync(dev);
-	pm_runtime_disable(dev);
-	pm_runtime_put_noidle(dev);
 
 	stmmac_stop_all_dma(priv);
 	stmmac_mac_set(priv, priv->ioaddr, false);
@@ -7248,6 +7246,9 @@ int stmmac_dvr_remove(struct device *dev)
 	mutex_destroy(&priv->lock);
 	bitmap_free(priv->af_xdp_zc_qps);
 
+	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_dvr_remove);
-- 
2.35.1



