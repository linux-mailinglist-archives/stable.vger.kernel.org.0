Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393864B7389
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbiBOPda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:33:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240377AbiBOPcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:32:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CC1BF949;
        Tue, 15 Feb 2022 07:30:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE04E60AC8;
        Tue, 15 Feb 2022 15:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A64FC340F4;
        Tue, 15 Feb 2022 15:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939003;
        bh=PFd0vWbuccoeBz31rmd7XX1dtx0C17Ku1YNGpKvMo6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyQYQbSy77Xyuii9zoq3t9OIDKCm3Qc59U+EFiLW8s3cfFHXiNV2Ghx9ijLtX2isY
         Pblnop9yMtDHwdbbIQ/uSE+9S0zlwWu5qs37Frzr6edQMhfF0WgcZxPEKwSpae0CAK
         DfrL3wSwWkcuJHgr5nJID6OCUj/NsCoBPrv2zF7ex+vXdN08jx2ioh3mMggHGt2cMd
         C7Yxl4gvnpgPoD18CNxYsLa2z2Eoh6TzxJ39w52zJbnd7jDB+jqvq5CpYTwpBME8a4
         6STGQSWKJxIJmLLehYs6eAAqs87ynqUgWs0VicZiK7gD6u+aJQ95dWvxcnS3Rpst0L
         S+Ag8iuikCXCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kishon@ti.com, bcm-kernel-feedback-list@broadcom.com,
        linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 03/23] phy: usb: Leave some clocks running during suspend
Date:   Tue, 15 Feb 2022 10:29:37 -0500
Message-Id: <20220215152957.581303-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152957.581303-1-sashal@kernel.org>
References: <20220215152957.581303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit 42fed57046fc74586d7058bd51a1c10ac9c690cb ]

The PHY client driver does a phy_exit() call on suspend or rmmod and
the PHY driver needs to know the difference because some clocks need
to be kept running for suspend but can be shutdown on unbind/rmmod
(or if there are no PHY clients at all).

The fix is to use a PM notifier so the driver can tell if a PHY
client is calling exit() because of a system suspend or a driver
unbind/rmmod.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211201180653.35097-2-alcooperx@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb.c | 38 +++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/phy/broadcom/phy-brcm-usb.c b/drivers/phy/broadcom/phy-brcm-usb.c
index 99fbc7e4138be..b901a0d4e2a80 100644
--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -17,6 +17,7 @@
 #include <linux/soc/brcmstb/brcmstb.h>
 #include <dt-bindings/phy/phy.h>
 #include <linux/mfd/syscon.h>
+#include <linux/suspend.h>
 
 #include "phy-brcm-usb-init.h"
 
@@ -69,12 +70,35 @@ struct brcm_usb_phy_data {
 	int			init_count;
 	int			wake_irq;
 	struct brcm_usb_phy	phys[BRCM_USB_PHY_ID_MAX];
+	struct notifier_block	pm_notifier;
+	bool			pm_active;
 };
 
 static s8 *node_reg_names[BRCM_REGS_MAX] = {
 	"crtl", "xhci_ec", "xhci_gbl", "usb_phy", "usb_mdio", "bdc_ec"
 };
 
+static int brcm_pm_notifier(struct notifier_block *notifier,
+			    unsigned long pm_event,
+			    void *unused)
+{
+	struct brcm_usb_phy_data *priv =
+		container_of(notifier, struct brcm_usb_phy_data, pm_notifier);
+
+	switch (pm_event) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		priv->pm_active = true;
+		break;
+	case PM_POST_RESTORE:
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		priv->pm_active = false;
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
 static irqreturn_t brcm_usb_phy_wake_isr(int irq, void *dev_id)
 {
 	struct phy *gphy = dev_id;
@@ -90,6 +114,9 @@ static int brcm_usb_phy_init(struct phy *gphy)
 	struct brcm_usb_phy_data *priv =
 		container_of(phy, struct brcm_usb_phy_data, phys[phy->id]);
 
+	if (priv->pm_active)
+		return 0;
+
 	/*
 	 * Use a lock to make sure a second caller waits until
 	 * the base phy is inited before using it.
@@ -119,6 +146,9 @@ static int brcm_usb_phy_exit(struct phy *gphy)
 	struct brcm_usb_phy_data *priv =
 		container_of(phy, struct brcm_usb_phy_data, phys[phy->id]);
 
+	if (priv->pm_active)
+		return 0;
+
 	dev_dbg(&gphy->dev, "EXIT\n");
 	if (phy->id == BRCM_USB_PHY_2_0)
 		brcm_usb_uninit_eohci(&priv->ini);
@@ -484,6 +514,9 @@ static int brcm_usb_phy_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	priv->pm_notifier.notifier_call = brcm_pm_notifier;
+	register_pm_notifier(&priv->pm_notifier);
+
 	mutex_init(&priv->mutex);
 
 	/* make sure invert settings are correct */
@@ -524,7 +557,10 @@ static int brcm_usb_phy_probe(struct platform_device *pdev)
 
 static int brcm_usb_phy_remove(struct platform_device *pdev)
 {
+	struct brcm_usb_phy_data *priv = dev_get_drvdata(&pdev->dev);
+
 	sysfs_remove_group(&pdev->dev.kobj, &brcm_usb_phy_group);
+	unregister_pm_notifier(&priv->pm_notifier);
 
 	return 0;
 }
@@ -535,6 +571,7 @@ static int brcm_usb_phy_suspend(struct device *dev)
 	struct brcm_usb_phy_data *priv = dev_get_drvdata(dev);
 
 	if (priv->init_count) {
+		dev_dbg(dev, "SUSPEND\n");
 		priv->ini.wake_enabled = device_may_wakeup(dev);
 		if (priv->phys[BRCM_USB_PHY_3_0].inited)
 			brcm_usb_uninit_xhci(&priv->ini);
@@ -574,6 +611,7 @@ static int brcm_usb_phy_resume(struct device *dev)
 	 * Uninitialize anything that wasn't previously initialized.
 	 */
 	if (priv->init_count) {
+		dev_dbg(dev, "RESUME\n");
 		if (priv->wake_irq >= 0)
 			disable_irq_wake(priv->wake_irq);
 		brcm_usb_init_common(&priv->ini);
-- 
2.34.1

