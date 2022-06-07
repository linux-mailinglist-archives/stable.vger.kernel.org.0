Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490B55419A0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378270AbiFGVXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378188AbiFGVWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:22:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D201A15D33E;
        Tue,  7 Jun 2022 12:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1029B823A5;
        Tue,  7 Jun 2022 18:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71E2C385A2;
        Tue,  7 Jun 2022 18:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628374;
        bh=iCzqAaDlEauDmKFP1NvQj5z/6UrWCL92RGzlJmskS8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/eMWXYtGJKRePo8EWG8kMfv/8skxSc0Occ93nxEiStwpfGHXhcMkaOo0GnzgWEya
         PqO0gBNKP1jkfO59bQin892Bp9BJ2VWlTIUA7MPpgioUtD0szCOhEFgL/9xuZCfwYV
         J6WIcRBWKEFWLyBnaWvBoCe69ms6BzyjEQ7wckZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 306/879] net: ethernet: ti: am65-cpsw: Fix build error without PHYLINK
Date:   Tue,  7 Jun 2022 18:57:04 +0200
Message-Id: <20220607165011.730721057@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit bfa323c659b1016c8e896920ba08cd6914cc3b0c ]

If PHYLINK is n, build fails:

drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_set_link_ksettings':
am65-cpsw-ethtool.c:(.text+0x118): undefined reference to `phylink_ethtool_ksettings_set'
drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_get_link_ksettings':
am65-cpsw-ethtool.c:(.text+0x138): undefined reference to `phylink_ethtool_ksettings_get'
drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_set_eee':
am65-cpsw-ethtool.c:(.text+0x158): undefined reference to `phylink_ethtool_set_eee'

Select PHYLINK for TI_K3_AM65_CPSW_NUSS to fix this.

Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20220409105931.9080-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index affcf92cd3aa..fb30bc5d56cb 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -94,6 +94,7 @@ config TI_K3_AM65_CPSW_NUSS
 	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
 	select NET_DEVLINK
 	select TI_DAVINCI_MDIO
+	select PHYLINK
 	imply PHY_TI_GMII_SEL
 	depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS
 	help
-- 
2.35.1



