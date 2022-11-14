Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0939B627E84
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbiKNMsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiKNMsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:48:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416CA6148
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:48:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D21096115D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0913C433C1;
        Mon, 14 Nov 2022 12:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430116;
        bh=xCQd1Tg8gD3vR7yYoMB+upy9UbKEeHG1iPGSHlERUq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAW4GcZwzX22LHwJGUDL0IdNOO+Ctx1YyjIqoAwnwmFtJdseW7IsS8GCqdId4qgzj
         ii4qnmbcakH833tJpdWgG2WNMEiToRnY+41eFX0zX2L72kdVRNMuzeGJO+2cduCQBM
         FtzxIpPKYf7mHLtnJoTYgNOkiJTG/bIVFdMo6flc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Florian Fainelli <f.fainelli@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/95] net: broadcom: Fix BCMGENET Kconfig
Date:   Mon, 14 Nov 2022 13:45:25 +0100
Message-Id: <20221114124443.847812384@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 8d820bc9d12b8beebca836cceaf2bbe68216c2f8 ]

While BCMGENET select BROADCOM_PHY as y, but PTP_1588_CLOCK_OPTIONAL is m,
kconfig warning and build errors:

WARNING: unmet direct dependencies detected for BROADCOM_PHY
  Depends on [m]: NETDEVICES [=y] && PHYLIB [=y] && PTP_1588_CLOCK_OPTIONAL [=m]
  Selected by [y]:
  - BCMGENET [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && HAS_IOMEM [=y] && ARCH_BCM2835 [=y]

drivers/net/phy/broadcom.o: In function `bcm54xx_suspend':
broadcom.c:(.text+0x6ac): undefined reference to `bcm_ptp_stop'
drivers/net/phy/broadcom.o: In function `bcm54xx_phy_probe':
broadcom.c:(.text+0x784): undefined reference to `bcm_ptp_probe'
drivers/net/phy/broadcom.o: In function `bcm54xx_config_init':
broadcom.c:(.text+0xd4c): undefined reference to `bcm_ptp_config_init'

Fixes: 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Florian Fainelli <f.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20221105090245.8508-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 7b79528d6eed..2b6d929d462f 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -69,7 +69,7 @@ config BCMGENET
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
-	select BROADCOM_PHY if ARCH_BCM2835
+	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
-- 
2.35.1



