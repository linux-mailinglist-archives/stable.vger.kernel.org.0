Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F0E73D55
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403916AbfGXTvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391378AbfGXTv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:51:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B7E220659;
        Wed, 24 Jul 2019 19:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997888;
        bh=eTgpNJu5JsY/z5hJKLo+gLDe9ykzQxTfOjwBS90F6P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nh3b4vEHfdb31wpetnXUI8G3YfzHZY9lEESb0td7IHQXYu5K6HxsFXCTk2a97QFnE
         AK8TYJeXKniEvPgapfJiIBIWcLULh1ENe+x87E2odAvCeS35eW75xdVuDufKG+ML9G
         OdGiUpt3GHFwaCh+bwKhtS4S/pn/NB+LEyIURbPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 179/371] net: hns3: add Asym Pause support to fix autoneg problem
Date:   Wed, 24 Jul 2019 21:18:51 +0200
Message-Id: <20190724191738.654765336@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bc3781edcea017aa1a29abd953b776cdba298ce2 ]

Local device and link partner config auto-negotiation on both,
local device config pause frame use as: rx on/tx off,
link partner config pause frame use as: rx off/tx on.

We except the result is:
Local device:
Autonegotiate:  on
RX:             on
TX:             off
RX negotiated:  on
TX negotiated:  off

Link partner:
Autonegotiate:  on
RX:             off
TX:             on
RX negotiated:  off
TX negotiated:  on

But actually, the result of Local device and link partner is both:
Autonegotiate:  on
RX:             off
TX:             off
RX negotiated:  off
TX negotiated:  off

The root cause is that the supported flag is has only Pause,
reference to the function genphy_config_advert():
static int genphy_config_advert(struct phy_device *phydev)
{
	...
	linkmode_and(phydev->advertising, phydev->advertising,
		     phydev->supported);
	...
}
The pause frame use of link partner is rx off/tx on, so its
advertising only set the bit Asym_Pause, and the supported is
only set the bit Pause, so the result of linkmode_and(), is
rx off/tx off.

This patch adds Asym_Pause to the supported flag to fix it.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 563eefa20003..14d37c26196b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -889,6 +889,7 @@ static void hclge_parse_copper_link_mode(struct hclge_dev *hdev,
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_TP_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, supported);
 }
 
 static void hclge_parse_link_mode(struct hclge_dev *hdev, u8 speed_ability)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 48eda2c6fdae..71a6f7c734b6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -215,6 +215,13 @@ int hclge_mac_connect_phy(struct hnae3_handle *handle)
 	linkmode_and(phydev->supported, phydev->supported, mask);
 	linkmode_copy(phydev->advertising, phydev->supported);
 
+	/* supported flag is Pause and Asym Pause, but default advertising
+	 * should be rx on, tx on, so need clear Asym Pause in advertising
+	 * flag
+	 */
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			   phydev->advertising);
+
 	return 0;
 }
 
-- 
2.20.1



