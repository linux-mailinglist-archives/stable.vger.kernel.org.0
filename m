Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12C21CACBE
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgEHMzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730086AbgEHMzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:55:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C51D2495A;
        Fri,  8 May 2020 12:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942537;
        bh=tIxpfOA4unSyFcuBwL1ysoSVx3S9UkoYppubKOKbt1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b946f0SwPwdIfehegOUcZP30BCseo/uxenRMH9LiW+p3c6msY++ycP2leTeJoMbfy
         +V1MlS2b0AOo4tRf5BXpFmLDl+LdcG/DwRSqnNdzxgKBQDBK/YyHqu+/kdkCis2dOH
         X4etUSNWfhDnfed6ZTbYtubLzvDv+ENlpFKE6tW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 35/49] net: phy: bcm84881: clear settings on link down
Date:   Fri,  8 May 2020 14:35:52 +0200
Message-Id: <20200508123048.022211521@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 796a8fa28980050bf1995617f0876484f3dc1026 ]

Clear the link partner advertisement, speed, duplex and pause when
the link goes down, as other phylib drivers do.  This avoids the
stale link partner, speed and duplex settings being reported via
ethtool.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm84881.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 14d55a77eb28a..1260115829283 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -174,9 +174,6 @@ static int bcm84881_read_status(struct phy_device *phydev)
 	if (phydev->autoneg == AUTONEG_ENABLE && !phydev->autoneg_complete)
 		phydev->link = false;
 
-	if (!phydev->link)
-		return 0;
-
 	linkmode_zero(phydev->lp_advertising);
 	phydev->speed = SPEED_UNKNOWN;
 	phydev->duplex = DUPLEX_UNKNOWN;
@@ -184,6 +181,9 @@ static int bcm84881_read_status(struct phy_device *phydev)
 	phydev->asym_pause = 0;
 	phydev->mdix = 0;
 
+	if (!phydev->link)
+		return 0;
+
 	if (phydev->autoneg_complete) {
 		val = genphy_c45_read_lpa(phydev);
 		if (val < 0)
-- 
2.20.1



