Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8101E42100A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbhJDNkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238475AbhJDNif (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CC7663250;
        Mon,  4 Oct 2021 13:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353453;
        bh=+C11mEzkqjtrmwWudTr03u0W/xZCZCn7y9Qbghxw7qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlxshnYOpojoaMQZKBMXuHVSb0XocBEzVMwaWFcDCJOTSCA2sQCQ8e4JQ7YT/GgjW
         jYM2mHz9SL4H5XhOfhFzUOkah+lTCVFj3n72DWW3lTS5vJ8KmakmWBHzFDRYLCF/WV
         /412b95xlUY0RhhpHq3xeTlQ6GDANtuUQxKa1vGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 101/172] net: enetc: fix the incorrect clearing of IF_MODE bits
Date:   Mon,  4 Oct 2021 14:52:31 +0200
Message-Id: <20211004125048.245955940@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
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
index c84f6c226743..cf00709caea4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -541,8 +541,7 @@ static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
 
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



