Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA36D186343
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730331AbgCPClt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729515AbgCPCd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:33:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A72D206E9;
        Mon, 16 Mar 2020 02:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326007;
        bh=c89utpjyJCM1WC9RrJfhwK+FgjmLnvI7luTATiwF9VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P//H0Wj5Lc0Q1Xb/Qi358pvsRQOuq13joVChv3Ag1ExI7p+EKWGu54IbUVt2MUthi
         yGeCupJACapS8p1Ra0o3fachISF008RPmwlKz/iTj0iFpsUOycyXUqRJEDDfNW7jHN
         dOMLxBnPBNR4rmsbeMJGo/6Z3QY0Vlb9MAwymNfQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 06/41] phy: ti: gmii-sel: fix set of copy-paste errors
Date:   Sun, 15 Mar 2020 22:32:44 -0400
Message-Id: <20200316023319.749-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit eefed634eb61e4094b9fb8183cb8d43b26838517 ]

- under PHY_INTERFACE_MODE_MII the 'mode' func parameter is assigned
instead of 'gmii_sel_mode' and it's working only because the default value
'gmii_sel_mode' is set to 0.

- console outputs use 'rgmii_id' and 'mode' values to print PHY mode
instead of using 'submode' value which is representing PHY interface mode
now.

This patch fixes above two cases.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-gmii-sel.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/phy/ti/phy-gmii-sel.c b/drivers/phy/ti/phy-gmii-sel.c
index a28bd15297f53..e998e9cd8d1f8 100644
--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -80,20 +80,19 @@ static int phy_gmii_sel_mode(struct phy *phy, enum phy_mode mode, int submode)
 		break;
 
 	case PHY_INTERFACE_MODE_MII:
-		mode = AM33XX_GMII_SEL_MODE_MII;
+		gmii_sel_mode = AM33XX_GMII_SEL_MODE_MII;
 		break;
 
 	default:
-		dev_warn(dev,
-			 "port%u: unsupported mode: \"%s\". Defaulting to MII.\n",
-			 if_phy->id, phy_modes(rgmii_id));
+		dev_warn(dev, "port%u: unsupported mode: \"%s\"\n",
+			 if_phy->id, phy_modes(submode));
 		return -EINVAL;
 	}
 
 	if_phy->phy_if_mode = submode;
 
 	dev_dbg(dev, "%s id:%u mode:%u rgmii_id:%d rmii_clk_ext:%d\n",
-		__func__, if_phy->id, mode, rgmii_id,
+		__func__, if_phy->id, submode, rgmii_id,
 		if_phy->rmii_clock_external);
 
 	regfield = if_phy->fields[PHY_GMII_SEL_PORT_MODE];
-- 
2.20.1

