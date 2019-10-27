Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88A0E6743
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbfJ0VT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731471AbfJ0VTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:24 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E0A5205C9;
        Sun, 27 Oct 2019 21:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211163;
        bh=YgTgS2O0USdRK7NbxME+XJnlDwM7ESi57XlogKtzr1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEjg/kY6T5qkepto4+aHfBbIDSr7CTk0S7NhKaVd6r36DdBgjLtF+bletEiCJg2ZC
         qGCCcG62toB+VOfeBlWpwl1htceDN8NA5+Zn6ZVBg2t4B6/F/zPHFBnhWGpPjHSN8N
         9a/69fFIKORS0hwy2OClnPZbHYAAxwoHmlqbvGKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 055/197] net: phy: fix write to mii-ctrl1000 register
Date:   Sun, 27 Oct 2019 21:59:33 +0100
Message-Id: <20191027203354.646387606@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 4cf6c57e61fee954f7b7685de31b80ec26843d27 ]

When userspace writes to the MII_ADVERTISE register, we update phylib's
advertising mask and trigger a renegotiation.  However, writing to the
MII_CTRL1000 register, which contains the gigabit advertisement, does
neither.  This can lead to phylib's copy of the advertisement becoming
de-synced with the values in the PHY register set, which can result in
incorrect negotiation resolution.

Fixes: 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy.c | 5 +++++
 include/linux/mii.h   | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 6b0f89369b460..0a314cf454080 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -457,6 +457,11 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 							   val);
 				change_autoneg = true;
 				break;
+			case MII_CTRL1000:
+				mii_ctrl1000_mod_linkmode_adv_t(phydev->advertising,
+							        val);
+				change_autoneg = true;
+				break;
 			default:
 				/* do nothing */
 				break;
diff --git a/include/linux/mii.h b/include/linux/mii.h
index 5cd824c1c0caa..4ce8901a1af65 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -455,6 +455,15 @@ static inline void mii_lpa_mod_linkmode_lpa_t(unsigned long *lp_advertising,
 			 lp_advertising, lpa & LPA_LPACK);
 }
 
+static inline void mii_ctrl1000_mod_linkmode_adv_t(unsigned long *advertising,
+						   u32 ctrl1000)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, advertising,
+			 ctrl1000 & ADVERTISE_1000HALF);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, advertising,
+			 ctrl1000 & ADVERTISE_1000FULL);
+}
+
 /**
  * linkmode_adv_to_lcl_adv_t
  * @advertising:pointer to linkmode advertising
-- 
2.20.1



