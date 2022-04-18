Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39A9505259
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiDRMmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240320AbiDRMix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:38:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C49324F25;
        Mon, 18 Apr 2022 05:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A92761033;
        Mon, 18 Apr 2022 12:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76735C385A1;
        Mon, 18 Apr 2022 12:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284973;
        bh=3GMgtImb+7S5Cm6mxL67P/qzHVn0at/En+PwwCh4UhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stGvEdE8M6wTM9YsnQHSpVilK/sEXRLxARh835QybmYLDmU8s1tSHfE5BgQgzsTAP
         2nbaoSrJfIwkhlij7DK0WOqv3FsKtn6Toc6VmTa8v66RvKqvgdhpwLVCEMVxbdr9t3
         GwP4TVNrD8T2OKApLJsPV2Di6HWvYCqMNfsx5mks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/189] net: mdio: dont defer probe forever if PHY IRQ provider is missing
Date:   Mon, 18 Apr 2022 14:11:27 +0200
Message-Id: <20220418121202.411017860@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 74befa447e6839cdd90ed541159ec783726946f9 ]

When a driver for an interrupt controller is missing, of_irq_get()
returns -EPROBE_DEFER ad infinitum, causing
fwnode_mdiobus_phy_device_register(), and ultimately, the entire
of_mdiobus_register() call, to fail. In turn, any phy_connect() call
towards a PHY on this MDIO bus will also fail.

This is not what is expected to happen, because the PHY library falls
back to poll mode when of_irq_get() returns a hard error code, and the
MDIO bus, PHY and attached Ethernet controller work fine, albeit
suboptimally, when the PHY library polls for link status. However,
-EPROBE_DEFER has special handling given the assumption that at some
point probe deferral will stop, and the driver for the supplier will
kick in and create the IRQ domain.

Reasons for which the interrupt controller may be missing:

- It is not yet written. This may happen if a more recent DT blob (with
  an interrupt-parent for the PHY) is used to boot an old kernel where
  the driver didn't exist, and that kernel worked with the
  vintage-correct DT blob using poll mode.

- It is compiled out. Behavior is the same as above.

- It is compiled as a module. The kernel will wait for a number of
  seconds specified in the "deferred_probe_timeout" boot parameter for
  user space to load the required module. The current default is 0,
  which times out at the end of initcalls. It is possible that this
  might cause regressions unless users adjust this boot parameter.

The proposed solution is to use the driver_deferred_probe_check_state()
helper function provided by the driver core, which gives up after some
-EPROBE_DEFER attempts, taking "deferred_probe_timeout" into consideration.
The return code is changed from -EPROBE_DEFER into -ENODEV or
-ETIMEDOUT, depending on whether the kernel is compiled with support for
modules or not.

Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220407165538.4084809-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c              | 1 +
 drivers/net/mdio/fwnode_mdio.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 64ce42b6c6b6..95ae347df137 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -296,6 +296,7 @@ int driver_deferred_probe_check_state(struct device *dev)
 
 	return -EPROBE_DEFER;
 }
+EXPORT_SYMBOL_GPL(driver_deferred_probe_check_state);
 
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1becb1a731f6..1c1584fca632 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -43,6 +43,11 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	int rc;
 
 	rc = fwnode_irq_get(child, 0);
+	/* Don't wait forever if the IRQ provider doesn't become available,
+	 * just fall back to poll mode
+	 */
+	if (rc == -EPROBE_DEFER)
+		rc = driver_deferred_probe_check_state(&phy->mdio.dev);
 	if (rc == -EPROBE_DEFER)
 		return rc;
 
-- 
2.35.1



