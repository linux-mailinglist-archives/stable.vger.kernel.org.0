Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A56328B9D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240223AbhCASiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239410AbhCAS3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EA9864FC0;
        Mon,  1 Mar 2021 17:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620466;
        bh=WFhLke/mMFwdpNRneuTRhMm2ax9AsNEYxH8qoLqz1KY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=feSsGH4W3YSf5rZ2pqradJKmlNPNm8HIBcz1CLfdM95noBbVfeUJGmHOtpCl04qX/
         eilW7ibOcw9GapehqeAN28Ib7fMA1IeOYcz0E70cN5d9hynFipDinbP9cm5mcfFbPN
         KIE4fzfk953/hVmjxjLIfXBjict1Wo7CbPxglX2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 136/775] net: amd-xgbe: Reset link when the link never comes back
Date:   Mon,  1 Mar 2021 17:05:04 +0100
Message-Id: <20210301161208.388867446@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 84fe68eb67f9499309cffd97c1ba269de125ff14 ]

Normally, auto negotiation and reconnect should be automatically done by
the hardware. But there seems to be an issue where auto negotiation has
to be restarted manually. This happens because of link training and so
even though still connected to the partner the link never "comes back".
This needs an auto-negotiation restart.

Also, a change in xgbe-mdio is needed to get ethtool to recognize the
link down and get the link change message. This change is only
required in a backplane connection mode.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 19ee4db0156d6..4e97b48695220 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1345,7 +1345,7 @@ static void xgbe_phy_status(struct xgbe_prv_data *pdata)
 							     &an_restart);
 	if (an_restart) {
 		xgbe_phy_config_aneg(pdata);
-		return;
+		goto adjust_link;
 	}
 
 	if (pdata->phy.link) {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 087948085ae19..d3f72faecd1da 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2610,6 +2610,14 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 	if (reg & MDIO_STAT1_LSTATUS)
 		return 1;
 
+	if (pdata->phy.autoneg == AUTONEG_ENABLE &&
+	    phy_data->port_mode == XGBE_PORT_MODE_BACKPLANE) {
+		if (!test_bit(XGBE_LINK_INIT, &pdata->dev_state)) {
+			netif_carrier_off(pdata->netdev);
+			*an_restart = 1;
+		}
+	}
+
 	/* No link, attempt a receiver reset cycle */
 	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
 		phy_data->rrc_count = 0;
-- 
2.27.0



