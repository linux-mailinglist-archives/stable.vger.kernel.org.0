Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF966433AE
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbiLETim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiLETiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:38:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E567429C93
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:35:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9463DB81157
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE3EC433D6;
        Mon,  5 Dec 2022 19:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268914;
        bh=kU1kfjcVR4sSNdfulp/nQ/SlSOe1yoOidtQexURk1dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0/eBC+rhM71CFvTqcLZCT6uL4oM0mh+Ei+8mR05jak8uDzIbv9oGiMpIQNr2ekRu
         F4ZVepRU1NIScWHZp9Dt8SAb1Ag9MaPiLaBqtyon7Ga5hT/BesFmh6KAuqJlL06dOj
         IaZVOu2uOoGD3gygJP5uRbvi9+NBWvgv4WtsK/Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/120] net: mdiobus: fix unbalanced node reference count
Date:   Mon,  5 Dec 2022 20:09:58 +0100
Message-Id: <20221205190808.366526856@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit cdde1560118f82498fc9e9a7c1ef7f0ef7755891 ]

I got the following report while doing device(mscc-miim) load test
with CONFIG_OF_UNITTEST and CONFIG_OF_DYNAMIC enabled:

  OF: ERROR: memory leak, expected refcount 1 instead of 2,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /spi/soc@0/mdio@7107009c/ethernet-phy@0

If the 'fwnode' is not an acpi node, the refcount is get in
fwnode_mdiobus_phy_device_register(), but it has never been
put when the device is freed in the normal path. So call
fwnode_handle_put() in phy_device_release() to avoid leak.

If it's an acpi node, it has never been get, but it's put
in the error path, so call fwnode_handle_get() before
phy_device_register() to keep get/put operation balanced.

Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221124150130.609420-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/fwnode_mdio.c | 2 +-
 drivers/net/phy/phy_device.c   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1c1584fca632..40e745a1d185 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -120,7 +120,7 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		/* Associate the fwnode with the device structure so it
 		 * can be looked up later.
 		 */
-		phy->mdio.dev.fwnode = child;
+		phy->mdio.dev.fwnode = fwnode_handle_get(child);
 
 		/* All data is now stored in the phy struct, so register it */
 		rc = phy_device_register(phy);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1dd521c99725..996842a1a9a3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -215,6 +215,7 @@ static void phy_mdio_device_free(struct mdio_device *mdiodev)
 
 static void phy_device_release(struct device *dev)
 {
+	fwnode_handle_put(dev->fwnode);
 	kfree(to_phy_device(dev));
 }
 
-- 
2.35.1



