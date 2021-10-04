Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E709942105B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbhJDNmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:42:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238661AbhJDNlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:41:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF3D861A38;
        Mon,  4 Oct 2021 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353536;
        bh=ShJlBkA40CjiAkPHOgUgb6ijLeB+QaFfCM6mx2ID/CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyhmMywC5p44wCF27AJ9rPbSBOvXPQI51lHr8CabHmbyPQo2PmRPbiJg/ZpBaycrp
         jDn65M8hJ2ac9nWJbW3wDEbZTj7GQSeclZjsZ7zYTDT2i2xijLnQFUUh7zATU2Gpwt
         BYuYVdJLBoaNdZimLE91nrd8MLEZvzP+9ao8Sy2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 135/172] net: stmmac: fix EEE init issue when paired with EEE capable PHYs
Date:   Mon,  4 Oct 2021 14:53:05 +0200
Message-Id: <20211004125049.321093067@linuxfoundation.org>
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

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

[ Upstream commit 656ed8b015f19bf3f6e6b3ddd9a4bb4aa5ca73e1 ]

When STMMAC is paired with Energy-Efficient Ethernet(EEE) capable PHY,
and the PHY is advertising EEE by default, we need to enable EEE on the
xPCS side too, instead of having user to manually trigger the enabling
config via ethtool.

Fixed this by adding xpcs_config_eee() call in stmmac_eee_init().

Fixes: 7617af3d1a5e ("net: pcs: Introducing support for DWC xpcs Energy Efficient Ethernet")
Cc: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2218bc3a624b..86151a817b79 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -486,6 +486,10 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 		timer_setup(&priv->eee_ctrl_timer, stmmac_eee_ctrl_timer, 0);
 		stmmac_set_eee_timer(priv, priv->hw, STMMAC_DEFAULT_LIT_LS,
 				     eee_tw_timer);
+		if (priv->hw->xpcs)
+			xpcs_config_eee(priv->hw->xpcs,
+					priv->plat->mult_fact_100ns,
+					true);
 	}
 
 	if (priv->plat->has_gmac4 && priv->tx_lpi_timer <= STMMAC_ET_MAX) {
-- 
2.33.0



