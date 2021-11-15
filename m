Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C37451E46
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244124AbhKPAfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344777AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA951632BE;
        Mon, 15 Nov 2021 19:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003051;
        bh=N8ee0XOXqihG7E2GhDwzLczK4FwO2CDOqhdxBHaGB7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Avo9s0QPmYMwwm+kxg5fl3YLtMQ+0PzYg4tlpHNkHx9lYwlDMZIhjgrRuWwsBxAUG
         r9xtj17Jd1L94bWBopjvjWK0gpzrsdul8E39gTN8Mf2vNNHNj/mZeje+pmbHFQNrYm
         2AOmg3PmbJzJLPPOHLSvT4GrQnxHOENCvcOW25Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 792/917] net: phy: fix duplex out of sync problem while changing settings
Date:   Mon, 15 Nov 2021 18:04:47 +0100
Message-Id: <20211115165455.817289911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit a4db9055fdb9cf607775c66d39796caf6439ec92 ]

As reported by Zhang there's a small issue if in forced mode the duplex
mode changes with the link staying up [0]. In this case the MAC isn't
notified about the change.

The proposed patch relies on the phylib state machine and ignores the
fact that there are drivers that uses phylib but not the phylib state
machine. So let's don't change the behavior for such drivers and fix
it w/o re-adding state PHY_FORCING for the case that phylib state
machine is used.

[0] https://lore.kernel.org/netdev/a5c26ffd-4ee4-a5e6-4103-873208ce0dc5@huawei.com/T/

Fixes: 2bd229df5e2e ("net: phy: remove state PHY_FORCING")
Reported-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Tested-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/7b8b9456-a93f-abbc-1dc5-a2c2542f932c@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index a3bfb156c83d7..beb2b66da1324 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -815,7 +815,12 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	_phy_start_aneg(phydev);
+	if (phy_is_started(phydev)) {
+		phydev->state = PHY_UP;
+		phy_trigger_machine(phydev);
+	} else {
+		_phy_start_aneg(phydev);
+	}
 
 	mutex_unlock(&phydev->lock);
 	return 0;
-- 
2.33.0



