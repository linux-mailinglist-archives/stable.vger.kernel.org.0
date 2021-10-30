Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCA2440902
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhJ3NNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhJ3NNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:13:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 692FA60E9C;
        Sat, 30 Oct 2021 13:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635599470;
        bh=5rHL63jDMnCE+mJEmVcr/67HdHK+PwBmbbRDzFQkqxY=;
        h=Subject:To:Cc:From:Date:From;
        b=Jdoyb8sITGeyKuUXeloduXI6xOa8SvKO91aY34OXNNkY20cxXhy1OGq2RXhnWaMwI
         Eun8Frc/60usUdFrq7layzqJz0GEHyKGuuT3LZ0zfVlQ0O37WfLSOH9ssAQzGjq5S9
         C99FIje+lR+LiUnxBrWayrIE1Nm3d9bQGFJoCMhk=
Subject: FAILED: patch "[PATCH] phy: phy_start_aneg: Add an unlocked version" failed to apply to 4.9-stable tree
To:     andrew@lunn.ch, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 15:11:08 +0200
Message-ID: <163559946821734@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 707293a56f95f8e7e0cfae008010c7933fb68973 Mon Sep 17 00:00:00 2001
From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 24 Oct 2021 21:48:04 +0200
Subject: [PATCH] phy: phy_start_aneg: Add an unlocked version

Split phy_start_aneg into a wrapper which takes the PHY lock, and a
helper doing the real work. This will be needed when
phy_ethtook_ksettings_set takes the lock.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ee584fa8b76d..d845afab1af7 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -700,7 +700,7 @@ static int phy_check_link_status(struct phy_device *phydev)
 }
 
 /**
- * phy_start_aneg - start auto-negotiation for this PHY device
+ * _phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
  *
  * Description: Sanitizes the settings (if we're not autonegotiating
@@ -708,25 +708,43 @@ static int phy_check_link_status(struct phy_device *phydev)
  *   If the PHYCONTROL Layer is operating, we change the state to
  *   reflect the beginning of Auto-negotiation or forcing.
  */
-int phy_start_aneg(struct phy_device *phydev)
+static int _phy_start_aneg(struct phy_device *phydev)
 {
 	int err;
 
+	lockdep_assert_held(&phydev->lock);
+
 	if (!phydev->drv)
 		return -EIO;
 
-	mutex_lock(&phydev->lock);
-
 	if (AUTONEG_DISABLE == phydev->autoneg)
 		phy_sanitize_settings(phydev);
 
 	err = phy_config_aneg(phydev);
 	if (err < 0)
-		goto out_unlock;
+		return err;
 
 	if (phy_is_started(phydev))
 		err = phy_check_link_status(phydev);
-out_unlock:
+
+	return err;
+}
+
+/**
+ * phy_start_aneg - start auto-negotiation for this PHY device
+ * @phydev: the phy_device struct
+ *
+ * Description: Sanitizes the settings (if we're not autonegotiating
+ *   them), and then calls the driver's config_aneg function.
+ *   If the PHYCONTROL Layer is operating, we change the state to
+ *   reflect the beginning of Auto-negotiation or forcing.
+ */
+int phy_start_aneg(struct phy_device *phydev)
+{
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = _phy_start_aneg(phydev);
 	mutex_unlock(&phydev->lock);
 
 	return err;

