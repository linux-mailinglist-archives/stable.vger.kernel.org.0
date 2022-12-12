Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C22B64A1A1
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiLLNno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiLLNnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A83D140F3
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:42:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA6C661072
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D591FC433D2;
        Mon, 12 Dec 2022 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852526;
        bh=m7nX502XKe6TIgvNUE4bMQoKJT2EFM1Yfcyd2BDRLD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNAWtLi7lxOO+dhO0z8OS+koKPsbfizq83EBVLPm/qEBWjsUmSmsNk7ZYze7FU/Kf
         p0EdeDBiQWx2Tqb0RwY8CIQDzMXCEM2uB7xTB7nJsjnCgF4pZbXAfMuF8lQxemTEYb
         zrp1Hjfj+aGYF3caRK7bQ3RfvtQ3uE5OkA9jx+Gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        YueHaibing <yuehaibing@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 099/157] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835
Date:   Mon, 12 Dec 2022 14:17:27 +0100
Message-Id: <20221212130938.808817281@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

[ Upstream commit 421f8663b3a775c32f724f793264097c60028f2e ]

commit 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig") fixes the build
that contain 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
and enable BCMGENET=y but PTP_1588_CLOCK_OPTIONAL=m, which otherwise
leads to a link failure. However this may trigger a runtime failure.

Fix the original issue by propagating the PTP_1588_CLOCK_OPTIONAL dependency
of BROADCOM_PHY down to BCMGENET.

Fixes: 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig")
Fixes: 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20221125115003.30308-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 1cd3c289f49b..cd1706909044 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -71,13 +71,14 @@ config BCM63XX_ENET
 config BCMGENET
 	tristate "Broadcom GENET internal MAC support"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
 	select MII
 	select PHYLIB
 	select FIXED_PHY
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
-	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
+	select BROADCOM_PHY if ARCH_BCM2835
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
-- 
2.35.1



