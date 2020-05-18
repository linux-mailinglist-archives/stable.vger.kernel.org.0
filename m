Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8866D1D808C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgERRkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729036AbgERRkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C5F7206D4;
        Mon, 18 May 2020 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823620;
        bh=wQj4eX7/FxHkNa5dyrYIrZEZLqrzpC4NjNtQNYdvArI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NB70sqOsgyE8COQNV8uszeFoztdBC/1geOAAPGujyEWRvsFnHXnNvJs7aACLTPPfp
         f04coi+vHbKTIViF17cIK9zA5K0T9tsdqrczqY9Uz9D5N/BuuN2gq86WTn28FXMKWd
         kR2zPYbB5+Y2R+ofIpSDKvouDH5sNnurtSf2ubR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/86] phy: micrel: Disable auto negotiation on startup
Date:   Mon, 18 May 2020 19:35:48 +0200
Message-Id: <20200518173453.976038108@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

[ Upstream commit 99f81afc139c6edd14d77a91ee91685a414a1c66 ]

Disable auto negotiation on init to properly detect an already plugged
cable at boot.

At boot, when the phy is started, it is in the PHY_UP state.
However, if a cable is plugged at boot, because auto negociation is already
enabled at the time we get the first interrupt, the phy is already running.
But the state machine then switches from PHY_UP to PHY_AN and calls
phy_start_aneg(). phy_start_aneg() will not do anything because aneg is
already enabled on the phy. It will then wait for a interrupt before going
further. This interrupt will never happen unless the cable is unplugged and
then replugged.

It was working properly before 321beec5047a (net: phy: Use interrupts when
available in NOLINK state) because switching to NOLINK meant starting
polling the phy, even if IRQ were enabled.

Fixes: 321beec5047a (net: phy: Use interrupts when available in NOLINK state)
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 4eba646789c30..98166e144f2dd 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -285,6 +285,17 @@ static int kszphy_config_init(struct phy_device *phydev)
 	if (priv->led_mode >= 0)
 		kszphy_setup_led(phydev, type->led_mode_reg, priv->led_mode);
 
+	if (phy_interrupt_is_valid(phydev)) {
+		int ctl = phy_read(phydev, MII_BMCR);
+
+		if (ctl < 0)
+			return ctl;
+
+		ret = phy_write(phydev, MII_BMCR, ctl & ~BMCR_ANENABLE);
+		if (ret < 0)
+			return ret;
+	}
+
 	return 0;
 }
 
-- 
2.20.1



