Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C43C34C91A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhC2I04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233553AbhC2IZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07D38619EA;
        Mon, 29 Mar 2021 08:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006290;
        bh=7pWrXxggC99dNjxIDeJ+cig5EnZew3swofDFMdjklzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTaIf61VjOWQ+y5nIiVLj8UEhzzmQKTwSuD4KYmfnHXcHik7Mwu9zdsxOBT0DjyhA
         T9wUC9ZjVpKLCxWhEkqdoi91Hf8OixUS+r9OmwrSFMa9RYKRnMXo1TONchkJz9a/Tc
         keiB5z+4C6E2+Qmzc5Ak0kVBmBxzBgNURKjvPOW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/221] net: phy: broadcom: Fix RGMII delays for BCM50160 and BCM50610M
Date:   Mon, 29 Mar 2021 09:58:39 +0200
Message-Id: <20210329075635.397570189@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index 6f6e64f81924..dbed15dc0fe7 100644
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



