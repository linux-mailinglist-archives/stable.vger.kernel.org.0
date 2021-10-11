Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4DB429085
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbhJKOJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237242AbhJKOH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F174D61216;
        Mon, 11 Oct 2021 14:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960846;
        bh=Iuzl5lyw/ZAuYiyH7fEuP7GovdKBv1hTQvZCbaBVD94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaHaKylWyAc0cWd0loy7x3gy0LKfvw8LOKO1N4RjL4eUuqzpOqXiB4k2KLAkW/rtV
         YymkyvXLlnJtmodSxwRYN3I+YukcoW0Lk/1rG1kUq3rup0Wo1kTTftVEi0FDRF+Vul
         rCgxVcxKqAWACJWDyM3SS9XO75M1jWsaMshoSha0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 092/151] net: pcs: xpcs: fix incorrect CL37 AN sequence
Date:   Mon, 11 Oct 2021 15:46:04 +0200
Message-Id: <20211011134520.806675344@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

[ Upstream commit e3cf002d5a4452f8adc5543df341cf96fd702fcf ]

According to Synopsys DesignWare Cores Ethernet PCS databook, it is
required to disable Clause 37 auto-negotiation by programming bit-12
(AN_ENABLE) to 0 if it is already enabled, before programming various
fields of VR_MII_AN_CTRL registers.

After all these programming are done, it is then required to enable
Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.

Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE controller")
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 4bd61339823c..4a169545797b 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -693,14 +693,17 @@ EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
 static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 {
-	int ret;
+	int ret, mdio_ctrl;
 
 	/* For AN for C37 SGMII mode, the settings are :-
-	 * 1) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
-	 * 2) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
+	 * 1) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 0b (Disable SGMII AN in case
+	      it is already enabled)
+	 * 2) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
+	 * 3) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
 	 *    DW xPCS used with DW EQoS MAC is always MAC side SGMII.
-	 * 3) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
+	 * 4) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
 	 *    speed/duplex mode change by HW after SGMII AN complete)
+	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 1b (Enable SGMII AN)
 	 *
 	 * Note: Since it is MAC side SGMII, there is no need to set
 	 *	 SR_MII_AN_ADV. MAC side SGMII receives AN Tx Config from
@@ -708,6 +711,17 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	 *	 between PHY and Link Partner. There is also no need to
 	 *	 trigger AN restart for MAC-side SGMII.
 	 */
+	mdio_ctrl = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
+	if (mdio_ctrl < 0)
+		return mdio_ctrl;
+
+	if (mdio_ctrl & AN_CL37_EN) {
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
+				 mdio_ctrl & ~AN_CL37_EN);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
 	if (ret < 0)
 		return ret;
@@ -732,7 +746,15 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	else
 		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
 
-	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+	if (ret < 0)
+		return ret;
+
+	if (phylink_autoneg_inband(mode))
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
+				 mdio_ctrl | AN_CL37_EN);
+
+	return ret;
 }
 
 static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
-- 
2.33.0



