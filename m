Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C775450EA1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240989AbhKOSQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:16:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240685AbhKOSLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9FE7633C3;
        Mon, 15 Nov 2021 17:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998457;
        bh=ZBMenJ5V07daEHWSVGsBoKeOb+heEv2q1Hmd4hREvkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5Hj2yjzb9LiX7Ap0NBQWX1g6dG19+IiAE5XJv3at6JZg8Rjnxg/nrfJ6Xmxjkmh+
         VY5wNjCFZwD2+cTQI8bxUgtl7i/unnoSADK7o83Iw0zzqLxTrd5Ngr/wjkpmyssCok
         Sewdu8O97Cq8919oDWE1spK5SgzDYWD3pY8U4hR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 517/575] net: phy: fix duplex out of sync problem while changing settings
Date:   Mon, 15 Nov 2021 18:04:02 +0100
Message-Id: <20211115165401.563947987@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 5ee7cde0c2e97..db7866b6f7525 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -831,7 +831,12 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
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



