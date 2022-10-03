Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA215F2AAC
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbiJCHjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiJCHhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:37:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A2C543FF;
        Mon,  3 Oct 2022 00:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E15EFCE0B11;
        Mon,  3 Oct 2022 07:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4053C433C1;
        Mon,  3 Oct 2022 07:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781389;
        bh=WZC/dCR8VP/ltTJFeAkVwSkyuWMGKYRxmnWKzQ4k+jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fnZM+HsutuhoB2G8uekjE1yQNGVoR4pXxRmPyhnsJipaC0HmnER16DxjSqS3tbKs
         YSn/FtlOdvQb7fmJLMDwyHke+iJC5w5EUwLTrwxb285LSmBYYSrb2wTB3wx6ZTXrnj
         YDZFN2jl5sm3xQnhdNaildjXCbBQyb8aMBOkO1HY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Chang <junxiao.chang@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Jimmy JS Chen <jimmyjs.chen@adlinktech.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Looi@vger.kernel.org
Subject: [PATCH 5.19 081/101] net: stmmac: power up/down serdes in stmmac_open/release
Date:   Mon,  3 Oct 2022 09:11:17 +0200
Message-Id: <20221003070726.468731280@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Junxiao Chang <junxiao.chang@intel.com>

[ Upstream commit 49725ffc15fc4e9fae68c55b691fd25168cbe5c1 ]

This commit fixes DMA engine reset timeout issue in suspend/resume
with ADLink I-Pi SMARC Plus board which dmesg shows:
...
[   54.678271] PM: suspend exit
[   54.754066] intel-eth-pci 0000:00:1d.2 enp0s29f2: PHY [stmmac-3:01] driver [Maxlinear Ethernet GPY215B] (irq=POLL)
[   54.755808] intel-eth-pci 0000:00:1d.2 enp0s29f2: Register MEM_TYPE_PAGE_POOL RxQ-0
...
[   54.780482] intel-eth-pci 0000:00:1d.2 enp0s29f2: Register MEM_TYPE_PAGE_POOL RxQ-7
[   55.784098] intel-eth-pci 0000:00:1d.2: Failed to reset the dma
[   55.784111] intel-eth-pci 0000:00:1d.2 enp0s29f2: stmmac_hw_setup: DMA engine initialization failed
[   55.784115] intel-eth-pci 0000:00:1d.2 enp0s29f2: stmmac_open: Hw setup failed
...

The issue is related with serdes which impacts clock.  There is
serdes in ADLink I-Pi SMARC board ethernet controller. Please refer to
commit b9663b7ca6ff78 ("net: stmmac: Enable SERDES power up/down sequence")
for detial. When issue is reproduced, DMA engine clock is not ready
because serdes is not powered up.

To reproduce DMA engine reset timeout issue with hardware which has
serdes in GBE controller, install Ubuntu. In Ubuntu GUI, click
"Power Off/Log Out" -> "Suspend" menu, it disables network interface,
then goes to sleep mode. When it wakes up, it enables network
interface again. Stmmac driver is called in this way:

1. stmmac_release: Stop network interface. In this function, it
   disables DMA engine and network interface;
2. stmmac_suspend: It is called in kernel suspend flow. But because
   network interface has been disabled(netif_running(ndev) is
   false), it does nothing and returns directly;
3. System goes into S3 or S0ix state. Some time later, system is
   waken up by keyboard or mouse;
4. stmmac_resume: It does nothing because network interface has
   been disabled;
5. stmmac_open: It is called to enable network interace again. DMA
   engine is initialized in this API, but serdes is not power on so
   there will be DMA engine reset timeout issue.

Similarly, serdes powerdown should be added in stmmac_release.
Network interface might be disabled by cmd "ifconfig eth0 down",
DMA engine, phy and mac have been disabled in ndo_stop callback,
serdes should be powered down as well. It doesn't make sense that
serdes is on while other components have been turned off.

If ethernet interface is in enabled state(netif_running(ndev) is true)
before suspend/resume, the issue couldn't be reproduced  because serdes
could be powered up in stmmac_resume.

Because serdes_powerup is added in stmmac_open, it doesn't need to be
called in probe function.

Fixes: b9663b7ca6ff78 ("net: stmmac: Enable SERDES power up/down sequence")
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Tested-by: Jimmy JS Chen <jimmyjs.chen@adlinktech.com>
Tested-by: Looi, Hong Aun <hong.aun.looi@intel.com>
Link: https://lore.kernel.org/r/20220923050448.1220250-1-junxiao.chang@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 78f11dabca05..8d9272f01e31 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3704,6 +3704,15 @@ static int stmmac_open(struct net_device *dev)
 		goto init_error;
 	}
 
+	if (priv->plat->serdes_powerup) {
+		ret = priv->plat->serdes_powerup(dev, priv->plat->bsp_priv);
+		if (ret < 0) {
+			netdev_err(priv->dev, "%s: Serdes powerup failed\n",
+				   __func__);
+			goto init_error;
+		}
+	}
+
 	ret = stmmac_hw_setup(dev, true);
 	if (ret < 0) {
 		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
@@ -3793,6 +3802,10 @@ static int stmmac_release(struct net_device *dev)
 	/* Disable the MAC Rx/Tx */
 	stmmac_mac_set(priv, priv->ioaddr, false);
 
+	/* Powerdown Serdes if there is */
+	if (priv->plat->serdes_powerdown)
+		priv->plat->serdes_powerdown(dev, priv->plat->bsp_priv);
+
 	netif_carrier_off(dev);
 
 	stmmac_release_ptp(priv);
@@ -7158,14 +7171,6 @@ int stmmac_dvr_probe(struct device *device,
 		goto error_netdev_register;
 	}
 
-	if (priv->plat->serdes_powerup) {
-		ret = priv->plat->serdes_powerup(ndev,
-						 priv->plat->bsp_priv);
-
-		if (ret < 0)
-			goto error_serdes_powerup;
-	}
-
 #ifdef CONFIG_DEBUG_FS
 	stmmac_init_fs(ndev);
 #endif
@@ -7180,8 +7185,6 @@ int stmmac_dvr_probe(struct device *device,
 
 	return ret;
 
-error_serdes_powerup:
-	unregister_netdev(ndev);
 error_netdev_register:
 	phylink_destroy(priv->phylink);
 error_xpcs_setup:
-- 
2.35.1



