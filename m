Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745BE627F0F
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbiKNMzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbiKNMzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:55:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D548B2714F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:55:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D443B80EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD64C433C1;
        Mon, 14 Nov 2022 12:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430498;
        bh=0a3oUZGDpFtByFzZyGRGxGRIcLBdalGZ36N4F/zToO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQowicVfNd1viw38bLq0m0hD9j1ytLkxsqRqOFDp7ElYxupOqWRFrxUnyY6uWUqep
         IH/o0dEOV/0YYqm7PwC8ZKvAcFFR+iyHJfnjQaYHda7LX7yveoau0shbt2OTaoeK4g
         Izke1W/WvKX3lvJR/Fykdy+iQFUELMyUr6OtwQmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Florian Fainelli <f.fainelli@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/131] net: broadcom: Fix BCMGENET Kconfig
Date:   Mon, 14 Nov 2022 13:45:15 +0100
Message-Id: <20221114124450.690203793@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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
index 56e0fb07aec7..1cd3c289f49b 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -77,7 +77,7 @@ config BCMGENET
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



