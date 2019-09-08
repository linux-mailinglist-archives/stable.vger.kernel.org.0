Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7064ACE34
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732693AbfIHMzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732631AbfIHMva (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:30 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E8E620693;
        Sun,  8 Sep 2019 12:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947089;
        bh=j6EGaUgINAbUeHJRDMaId7xXvK70U2UclSJg0QPS1sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIl4AAv9JaImaNsNsE9BtGTa61TSKrWmULHt/e3tad5mfuc0yLVlBTcdKzDzq4vyO
         ve4gmQPwS310DkAOwN5jhwtH611fmr9vmrhm7l8MzSMKA5Rbsl0dLUye8R4DTcPlcO
         rfeKZfIRmQNZzsfLEgR1LOgqhiDAdm2QHYYi0kIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Hartmann <marco.hartmann@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 15/94] Add genphy_c45_config_aneg() function to phy-c45.c
Date:   Sun,  8 Sep 2019 13:41:11 +0100
Message-Id: <20190908121150.869039333@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Hartmann <marco.hartmann@nxp.com>

[ Upstream commit 2ebb991641d3f64b70fec0156e2b6933810177e9 ]

Commit 34786005eca3 ("net: phy: prevent PHYs w/o Clause 22 regs from calling
genphy_config_aneg") introduced a check that aborts phy_config_aneg()
if the phy is a C45 phy.
This causes phy_state_machine() to call phy_error() so that the phy
ends up in PHY_HALTED state.

Instead of returning -EOPNOTSUPP, call genphy_c45_config_aneg()
(analogous to the C22 case) so that the state machine can run
correctly.

genphy_c45_config_aneg() closely resembles mv3310_config_aneg()
in drivers/net/phy/marvell10g.c, excluding vendor specific
configurations for 1000BaseT.

Fixes: 22b56e827093 ("net: phy: replace genphy_10g_driver with genphy_c45_driver")

Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy-c45.c |   26 ++++++++++++++++++++++++++
 drivers/net/phy/phy.c     |    2 +-
 include/linux/phy.h       |    1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -523,6 +523,32 @@ int genphy_c45_read_status(struct phy_de
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_status);
 
+/**
+ * genphy_c45_config_aneg - restart auto-negotiation or forced setup
+ * @phydev: target phy_device struct
+ *
+ * Description: If auto-negotiation is enabled, we configure the
+ *   advertising, and then restart auto-negotiation.  If it is not
+ *   enabled, then we force a configuration.
+ */
+int genphy_c45_config_aneg(struct phy_device *phydev)
+{
+	bool changed = false;
+	int ret;
+
+	if (phydev->autoneg == AUTONEG_DISABLE)
+		return genphy_c45_pma_setup_forced(phydev);
+
+	ret = genphy_c45_an_config_aneg(phydev);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		changed = true;
+
+	return genphy_c45_check_and_restart_aneg(phydev, changed);
+}
+EXPORT_SYMBOL_GPL(genphy_c45_config_aneg);
+
 /* The gen10g_* functions are the old Clause 45 stub */
 
 int gen10g_config_aneg(struct phy_device *phydev)
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -499,7 +499,7 @@ static int phy_config_aneg(struct phy_de
 	 * allowed to call genphy_config_aneg()
 	 */
 	if (phydev->is_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
-		return -EOPNOTSUPP;
+		return genphy_c45_config_aneg(phydev);
 
 	return genphy_config_aneg(phydev);
 }
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1108,6 +1108,7 @@ int genphy_c45_an_disable_aneg(struct ph
 int genphy_c45_read_mdix(struct phy_device *phydev);
 int genphy_c45_pma_read_abilities(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
+int genphy_c45_config_aneg(struct phy_device *phydev);
 
 /* The gen10g_* functions are the old Clause 45 stub */
 int gen10g_config_aneg(struct phy_device *phydev);


