Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446C81D82FF
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbgERSBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732358AbgERSBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4103020826;
        Mon, 18 May 2020 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824866;
        bh=raz+isdNy/E92/IIzC/JGNOPqLGNyz1rATIizl4+t6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ci8+iqAcd4vXrF68qZNWU+BzY/ERBoQCRJtSXLBQv24nGxs5N36qhY71YQJyeXS96
         fyOL+q8zb1jmEORrEgy1yTo+FZlD2RvssOwZ4I9wRwk4Y6AxCf/YYo8GDWeM4wgtkp
         ThNLeKXer1+Gky13YTzj0EPRZj4gIwM2p6woCdek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 034/194] net: phy: fix aneg restart in phy_ethtool_set_eee
Date:   Mon, 18 May 2020 19:35:24 +0200
Message-Id: <20200518173534.458219948@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 9de5d235b60a7cdfcdd5461e70c5663e713fde87 ]

phy_restart_aneg() enables aneg in the PHY. That's not what we want
if phydev->autoneg is disabled. In this case still update EEE
advertisement register, but don't enable aneg and don't trigger an
aneg restart.

Fixes: f75abeb8338e ("net: phy: restart phy autonegotiation after EEE advertisment change")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1132,9 +1132,11 @@ int phy_ethtool_set_eee(struct phy_devic
 		/* Restart autonegotiation so the new modes get sent to the
 		 * link partner.
 		 */
-		ret = phy_restart_aneg(phydev);
-		if (ret < 0)
-			return ret;
+		if (phydev->autoneg == AUTONEG_ENABLE) {
+			ret = phy_restart_aneg(phydev);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	return 0;


