Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFEA5F2A32
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiJCHcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiJCHbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:31:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665B51CB02;
        Mon,  3 Oct 2022 00:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ADBC60FB6;
        Mon,  3 Oct 2022 07:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217C4C433D6;
        Mon,  3 Oct 2022 07:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781623;
        bh=6BZmbZpXFKe+jJYKjPvyocQRtW+3xcRxtRgORGiOudk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwNXsltOPD9ucyNOylolYRuwp91RQpKmHysg7mZpKJqWEwrJkU+BW5c1Quy6Lyht9
         8lUkUj/mJa9SpU2KBbS0yEnQ2DfOZftEJ6rrp4hPfDRp1smyvZsUlqAkxOzlNjUWk4
         IBBoirmdUwmA6emVzCGHQny3IvxYwNp57EFxmMY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lukas Wunner <lukas@wunner.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaolei Wang <xiaolei.wang@windriver.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 63/83] net: phy: Dont WARN for PHY_UP state in mdio_bus_phy_resume()
Date:   Mon,  3 Oct 2022 09:11:28 +0200
Message-Id: <20221003070723.578840618@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit ea64cdfad124922c931633e39287c5a31a9b14a1 ]

Commit 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume()
state") introduced a WARN() on resume from system sleep if a PHY is not
in PHY_HALTED state.

Commit 6dbe852c379f ("net: phy: Don't WARN for PHY_READY state in
mdio_bus_phy_resume()") added an exemption for PHY_READY state from
the WARN().

It turns out PHY_UP state needs to be exempted as well because the
following may happen on suspend:

  mdio_bus_phy_suspend()
    phy_stop_machine()
      phydev->state = PHY_UP  #  if (phydev->state >= PHY_UP)

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/netdev/2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Xiaolei Wang <xiaolei.wang@windriver.com>
Link: https://lore.kernel.org/r/8128fdb51eeebc9efbf3776a4097363a1317aaf1.1663905575.git.lukas@wunner.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index b616f55ea222..c5b92ffaffb9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -315,11 +315,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
-	/* If we manged to get here with the PHY state machine in a state neither
-	 * PHY_HALTED nor PHY_READY this is an indication that something went wrong
-	 * and we should most likely be using MAC managed PM and we are not.
+	/* If we managed to get here with the PHY state machine in a state
+	 * neither PHY_HALTED, PHY_READY nor PHY_UP, this is an indication
+	 * that something went wrong and we should most likely be using
+	 * MAC managed PM, but we are not.
 	 */
-	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY);
+	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY &&
+		phydev->state != PHY_UP);
 
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
-- 
2.35.1



