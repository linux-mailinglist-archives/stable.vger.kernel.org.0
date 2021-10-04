Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66A2420E49
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbhJDNYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236310AbhJDNWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:22:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 606A861BE2;
        Mon,  4 Oct 2021 13:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352972;
        bh=IjMMtgtM0oVf+t9/3xXFyfrH5reLdafwa1rTsgl+j78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5et2OKnRmgz69y7M6aepnUYJtVmfraGJH6cHXanJVm6NRt27hNRCJaNwVKM5JCZJ
         +4bdRDSImYlUR45FOFwK5r78/muC1xoJhvQYZpC4DskMtPBA+yFQJpx5mPg2dWxWT+
         Q8giP5k+9qdWojOg1X03tcKojoH9sPBwpCX0Ns0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/93] net: enetc: fix the incorrect clearing of IF_MODE bits
Date:   Mon,  4 Oct 2021 14:52:37 +0200
Message-Id: <20211004125035.855516921@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 325fd36ae76a6d089983b2d2eccb41237d35b221 ]

The enetc phylink .mac_config handler intends to clear the IFMODE field
(bits 1:0) of the PM0_IF_MODE register, but incorrectly clears all the
other fields instead.

For normal operation, the bug was inconsequential, due to the fact that
we write the PM0_IF_MODE register in two stages, first in
phylink .mac_config (which incorrectly cleared out a bunch of stuff),
then we update the speed and duplex to the correct values in
phylink .mac_link_up.

Judging by the code (not tested), it looks like maybe loopback mode was
broken, since this is one of the settings in PM0_IF_MODE which is
incorrectly cleared.

Fixes: c76a97218dcb ("net: enetc: force the RGMII speed and duplex instead of operating in inband mode")
Reported-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 68133563a40c..716b396bf094 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -504,8 +504,7 @@ static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
 
 	if (phy_interface_mode_is_rgmii(phy_mode)) {
 		val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
-		val &= ~ENETC_PM0_IFM_EN_AUTO;
-		val &= ENETC_PM0_IFM_IFMODE_MASK;
+		val &= ~(ENETC_PM0_IFM_EN_AUTO | ENETC_PM0_IFM_IFMODE_MASK);
 		val |= ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
 	}
-- 
2.33.0



