Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85A344170D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhKAJcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232674AbhKAJaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE7061175;
        Mon,  1 Nov 2021 09:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758623;
        bh=5keLcXaK1HQ2seICZ9bhp3Wolv5XuiRc8ik4f5+7lsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tI9jLhouC1y2bTK5s4SlEXPphjwx4fZcf2KxeEP7XK/UVgWfzX9k4WwJYixomWfG
         VZeTJYvpuitGhSTYezzQJGJskAratv1R/tlQnWcxCkZvZx7UiYfPvQSeGnXy2qX2n+
         gpdtKlMz1yRkuy0zE3iI9OsY7RsN/e63Vvl0YFdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 40/51] phy: phy_start_aneg: Add an unlocked version
Date:   Mon,  1 Nov 2021 10:17:44 +0100
Message-Id: <20211101082510.027977380@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

commit 707293a56f95f8e7e0cfae008010c7933fb68973 upstream.

Split phy_start_aneg into a wrapper which takes the PHY lock, and a
helper doing the real work. This will be needed when
phy_ethtook_ksettings_set takes the lock.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -555,7 +555,7 @@ static int phy_check_link_status(struct
 }
 
 /**
- * phy_start_aneg - start auto-negotiation for this PHY device
+ * _phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
  *
  * Description: Sanitizes the settings (if we're not autonegotiating
@@ -563,25 +563,43 @@ static int phy_check_link_status(struct
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


