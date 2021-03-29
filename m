Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA2134CAAC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhC2Ijb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235180AbhC2IiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:38:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F06BA61581;
        Mon, 29 Mar 2021 08:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007095;
        bh=UqEwdEBpiBWo+u8PLQeItdkdt5rqimjDIluGjmBfnOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMzXqtxoW+7yvNhbIAaR3vq5zVWnyhVJnOCzFjQm2jPgP/nkk+dKT88XjZkB9yNqV
         UouqwRRp2So6BY9BTBVacN9cFjiKbMFGn4BD/ewfz5fOQ1XrrYh7nCBObXf3pe9ZBx
         l0nWs5FnT9xK0V+GqvkR576F+SoWJ7pqx1LCUgKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 219/254] net: phy: broadcom: Fix RGMII delays for BCM50160 and BCM50610M
Date:   Mon, 29 Mar 2021 09:58:55 +0200
Message-Id: <20210329075640.296299461@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit b1dd9bf688b0dcc5a34dca660de46c7570bd9243 ]

The PHY driver entry for BCM50160 and BCM50610M calls
bcm54xx_config_init() but does not call bcm54xx_config_clock_delay() in
order to configuration appropriate clock delays on the PHY, fix that.

Fixes: 733336262b28 ("net: phy: Allow BCM5481x PHYs to setup internal TX/RX clock delay")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index b160186dc766..07a98c324942 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -340,6 +340,10 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 	bcm54xx_adjust_rxrefclk(phydev);
 
 	switch (BRCM_PHY_MODEL(phydev)) {
+	case PHY_ID_BCM50610:
+	case PHY_ID_BCM50610M:
+		err = bcm54xx_config_clock_delay(phydev);
+		break;
 	case PHY_ID_BCM54210E:
 		err = bcm54210e_config_init(phydev);
 		break;
-- 
2.30.1



