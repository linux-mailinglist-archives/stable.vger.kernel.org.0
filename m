Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40575A4964
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiH2LYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbiH2LXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:23:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A403B7ED;
        Mon, 29 Aug 2022 04:14:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D322F611B5;
        Mon, 29 Aug 2022 11:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05FEC433C1;
        Mon, 29 Aug 2022 11:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771576;
        bh=nt+DbUpqklbw1Xto9ufSTnWDjmG3ka9/cgJeFua0RZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+9akYbDILkhxku6bn9ce33WUzrsER2jXgfaLI8Po7GQUSDi4HthXjib/5+Lg3u14
         ErfJo9pJ3o7Ea4KqGdzDHw+DkyClIZQu2AppOpRzySHUUUb5cNdffpZ21Qikx5FSMX
         5Nn/4TjORdbIX03ZIOL2rkR/F/j7rrzKlG9qO16M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaolei Wang <xiaolei.wang@windriver.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 045/158] net: phy: Dont WARN for PHY_READY state in mdio_bus_phy_resume()
Date:   Mon, 29 Aug 2022 12:58:15 +0200
Message-Id: <20220829105810.658040829@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 6dbe852c379ff032a70a6b13a91914918c82cb07 ]

For some MAC drivers, they set the mac_managed_pm to true in its
->ndo_open() callback. So before the mac_managed_pm is set to true,
we still want to leverage the mdio_bus_phy_suspend()/resume() for
the phy device suspend and resume. In this case, the phy device is
in PHY_READY, and we shouldn't warn about this. It also seems that
the check of mac_managed_pm in WARN_ON is redundant since we already
check this in the entry of mdio_bus_phy_resume(), so drop it.

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220819082451.1992102-1-xiaolei.wang@windriver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 608de5a94165f..f90a21781d8d6 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -316,11 +316,11 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
-	/* If we managed to get here with the PHY state machine in a state other
-	 * than PHY_HALTED this is an indication that something went wrong and
-	 * we should most likely be using MAC managed PM and we are not.
+	/* If we manged to get here with the PHY state machine in a state neither
+	 * PHY_HALTED nor PHY_READY this is an indication that something went wrong
+	 * and we should most likely be using MAC managed PM and we are not.
 	 */
-	WARN_ON(phydev->state != PHY_HALTED && !phydev->mac_managed_pm);
+	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY);
 
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
-- 
2.35.1



