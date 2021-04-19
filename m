Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB8B36433B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240421AbhDSNP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240430AbhDSNOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:14:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCEA4613C7;
        Mon, 19 Apr 2021 13:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837959;
        bh=bdi/i4ya0l5GDr6rTYW17Jj+1iPzTgfriRoLZ+iP5es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD+wVzexabvePky7CXaaQ2uQ0nV6dIEY8yxyKZiVHrSUxsn9T5ekxpGin2b6X8CeK
         fZidreUStUMjRmcFQjizL7dnOSMoXVWd5fGd5m6+GrMPhIgsyXCU5bUN/I3+zYfKL3
         69/F3lB25JK34aTLLn4vkCBqc58iDFm6TwezywPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Mamedov <rm+bko@romanrm.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 116/122] r8169: dont advertise pause in jumbo mode
Date:   Mon, 19 Apr 2021 15:06:36 +0200
Message-Id: <20210419130534.113639532@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 453a77894efa4d9b6ef9644d74b9419c47ac427c ]

It has been reported [0] that using pause frames in jumbo mode impacts
performance. There's no available chip documentation, but vendor
drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
do the same, according to Roman it fixes the issue.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=212617

Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
Reported-by: Roman Mamedov <rm+bko@romanrm.net>
Tested-by: Roman Mamedov <rm+bko@romanrm.net>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 47a4ff832d75..e04e885f2893 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2384,6 +2384,13 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 
 	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
 		pcie_set_readrq(tp->pci_dev, readrq);
+
+	/* Chip doesn't support pause in jumbo mode */
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			 tp->phydev->advertising, !jumbo);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			 tp->phydev->advertising, !jumbo);
+	phy_start_aneg(tp->phydev);
 }
 
 DECLARE_RTL_COND(rtl_chipcmd_cond)
@@ -4662,8 +4669,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	if (!tp->supports_gmii)
 		phy_set_max_speed(phydev, SPEED_100);
 
-	phy_support_asym_pause(phydev);
-
 	phy_attached_info(phydev);
 
 	return 0;
-- 
2.30.2



