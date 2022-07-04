Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56DA564EEF
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 09:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiGDHo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 03:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiGDHo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 03:44:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B05B65
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 00:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D3BBB80DDE
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 07:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66173C341CF;
        Mon,  4 Jul 2022 07:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656920694;
        bh=VwFiFJcrvFdPa1SW0noRIravt2DI1L9GqEfsx4tDVc0=;
        h=Subject:To:Cc:From:Date:From;
        b=fmkBhTrAA4P5yMZr+KWchAYv7menUy/JcBhJZiI8PLAgHNLwMXHG1zceoTQWPP8QG
         VmexdgYQD3CEFjdWX8IPNCcEU1iNJDcFSclfULHPCWyu7v6hBHJXYySzjQfJ8bN5Sc
         Lp5suOkheJT+9W+cTA4tY7AqLrbPDYx9d1DbkAFg=
Subject: FAILED: patch "[PATCH] net: phy: Don't trigger state machine while in suspend" failed to apply to 5.4-stable tree
To:     lukas@wunner.de, andrew@lunn.ch, kuba@kernel.org,
        m.szyprowski@samsung.com, rafael.j.wysocki@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 09:44:44 +0200
Message-ID: <165692068413156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1758bde2e4aa5ff188d53e7d9d388bbb7e12eebb Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Tue, 28 Jun 2022 12:15:08 +0200
Subject: [PATCH] net: phy: Don't trigger state machine while in suspend

Upon system sleep, mdio_bus_phy_suspend() stops the phy_state_machine(),
but subsequent interrupts may retrigger it:

They may have been left enabled to facilitate wakeup and are not
quiesced until the ->suspend_noirq() phase.  Unwanted interrupts may
hence occur between mdio_bus_phy_suspend() and dpm_suspend_noirq(),
as well as between dpm_resume_noirq() and mdio_bus_phy_resume().

Retriggering the phy_state_machine() through an interrupt is not only
undesirable for the reason given in mdio_bus_phy_suspend() (freezing it
midway with phydev->lock held), but also because the PHY may be
inaccessible after it's suspended:  Accesses to USB-attached PHYs are
blocked once usb_suspend_both() clears the can_submit flag and PHYs on
PCI network cards may become inaccessible upon suspend as well.

Amend phy_interrupt() to avoid triggering the state machine if the PHY
is suspended.  Signal wakeup instead if the attached net_device or its
parent has been configured as a wakeup source.  (Those conditions are
identical to mdio_bus_phy_may_suspend().)  Postpone handling of the
interrupt until the PHY has resumed.

Before stopping the phy_state_machine() in mdio_bus_phy_suspend(),
wait for a concurrent phy_interrupt() to run to completion.  That is
necessary because phy_interrupt() may have checked the PHY's suspend
status before the system sleep transition commenced and it may thus
retrigger the state machine after it was stopped.

Likewise, after re-enabling interrupt handling in mdio_bus_phy_resume(),
wait for a concurrent phy_interrupt() to complete to ensure that
interrupts which it postponed are properly rerun.

The issue was exposed by commit 1ce8b37241ed ("usbnet: smsc95xx: Forward
PHY interrupts to PHY driver to avoid polling"), but has existed since
forever.

Fixes: 541cd3ee00a4 ("phylib: Fix deadlock on resume")
Link: https://lore.kernel.org/netdev/a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com/
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable@vger.kernel.org # v2.6.33+
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/b7f386d04e9b5b0e2738f0125743e30676f309ef.1656410895.git.lukas@wunner.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef62f357b76d..8d3ee3a6495b 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
+#include <linux/suspend.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 #include <net/sock.h>
@@ -976,6 +977,28 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	struct phy_driver *drv = phydev->drv;
 	irqreturn_t ret;
 
+	/* Wakeup interrupts may occur during a system sleep transition.
+	 * Postpone handling until the PHY has resumed.
+	 */
+	if (IS_ENABLED(CONFIG_PM_SLEEP) && phydev->irq_suspended) {
+		struct net_device *netdev = phydev->attached_dev;
+
+		if (netdev) {
+			struct device *parent = netdev->dev.parent;
+
+			if (netdev->wol_enabled)
+				pm_system_wakeup();
+			else if (device_may_wakeup(&netdev->dev))
+				pm_wakeup_dev_event(&netdev->dev, 0, true);
+			else if (parent && device_may_wakeup(parent))
+				pm_wakeup_dev_event(parent, 0, true);
+		}
+
+		phydev->irq_rerun = 1;
+		disable_irq_nosync(irq);
+		return IRQ_HANDLED;
+	}
+
 	mutex_lock(&phydev->lock);
 	ret = drv->handle_interrupt(phydev);
 	mutex_unlock(&phydev->lock);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 431a8719c635..46acddd865a7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -278,6 +278,15 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 	if (phydev->mac_managed_pm)
 		return 0;
 
+	/* Wakeup interrupts may occur during the system sleep transition when
+	 * the PHY is inaccessible. Set flag to postpone handling until the PHY
+	 * has resumed. Wait for concurrent interrupt handler to complete.
+	 */
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->irq_suspended = 1;
+		synchronize_irq(phydev->irq);
+	}
+
 	/* We must stop the state machine manually, otherwise it stops out of
 	 * control, possibly with the phydev->lock held. Upon resume, netdev
 	 * may call phy routines that try to grab the same lock, and that may
@@ -315,6 +324,20 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 no_resume:
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->irq_suspended = 0;
+		synchronize_irq(phydev->irq);
+
+		/* Rerun interrupts which were postponed by phy_interrupt()
+		 * because they occurred during the system sleep transition.
+		 */
+		if (phydev->irq_rerun) {
+			phydev->irq_rerun = 0;
+			enable_irq(phydev->irq);
+			irq_wake_thread(phydev->irq, phydev);
+		}
+	}
+
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_start_machine(phydev);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 508f1149665b..b09f7d36cff2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -572,6 +572,10 @@ struct macsec_ops;
  * @mdix_ctrl: User setting of crossover
  * @pma_extable: Cached value of PMA/PMD Extended Abilities Register
  * @interrupts: Flag interrupts have been enabled
+ * @irq_suspended: Flag indicating PHY is suspended and therefore interrupt
+ *                 handling shall be postponed until PHY has resumed
+ * @irq_rerun: Flag indicating interrupts occurred while PHY was suspended,
+ *             requiring a rerun of the interrupt handler after resume
  * @interface: enum phy_interface_t value
  * @skb: Netlink message for cable diagnostics
  * @nest: Netlink nest used for cable diagnostics
@@ -626,6 +630,8 @@ struct phy_device {
 
 	/* Interrupts are enabled */
 	unsigned interrupts:1;
+	unsigned irq_suspended:1;
+	unsigned irq_rerun:1;
 
 	enum phy_state state;
 

