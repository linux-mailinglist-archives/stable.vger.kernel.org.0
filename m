Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504D2566C8E
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiGEMQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiGEMO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:14:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0161900E;
        Tue,  5 Jul 2022 05:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BECFA61988;
        Tue,  5 Jul 2022 12:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E39C341C7;
        Tue,  5 Jul 2022 12:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023100;
        bh=iBqu9UWOI3z5TXlrYoZ4yuHuCxo6e6nY0WZn15Qddac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03J3gZnsaJubsj0uLMVsgJJZMKIbss4j7WfGxaKaOpCycSo1/8450gm2nAJlk+0t6
         5xrYPDCMoWLLzb3jogbsdjHoibW7I2kUMKIDSfQeOgjGhLxGOxxlsAYeHli7hU7g5K
         TCpy+b/g8BijCh39RnqarAM/sNupRvlSHkMGOqpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lukas Wunner <lukas@wunner.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 07/98] net: phy: Dont trigger state machine while in suspend
Date:   Tue,  5 Jul 2022 13:57:25 +0200
Message-Id: <20220705115617.785722709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Lukas Wunner <lukas@wunner.de>

commit 1758bde2e4aa5ff188d53e7d9d388bbb7e12eebb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c        |   23 +++++++++++++++++++++++
 drivers/net/phy/phy_device.c |   23 +++++++++++++++++++++++
 include/linux/phy.h          |    6 ++++++
 3 files changed, 52 insertions(+)

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
@@ -972,6 +973,28 @@ static irqreturn_t phy_interrupt(int irq
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
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -277,6 +277,15 @@ static __maybe_unused int mdio_bus_phy_s
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
@@ -314,6 +323,20 @@ static __maybe_unused int mdio_bus_phy_r
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
 
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -536,6 +536,10 @@ struct macsec_ops;
  * @mdix: Current crossover
  * @mdix_ctrl: User setting of crossover
  * @interrupts: Flag interrupts have been enabled
+ * @irq_suspended: Flag indicating PHY is suspended and therefore interrupt
+ *                 handling shall be postponed until PHY has resumed
+ * @irq_rerun: Flag indicating interrupts occurred while PHY was suspended,
+ *             requiring a rerun of the interrupt handler after resume
  * @interface: enum phy_interface_t value
  * @skb: Netlink message for cable diagnostics
  * @nest: Netlink nest used for cable diagnostics
@@ -590,6 +594,8 @@ struct phy_device {
 
 	/* Interrupts are enabled */
 	unsigned interrupts:1;
+	unsigned irq_suspended:1;
+	unsigned irq_rerun:1;
 
 	enum phy_state state;
 


