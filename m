Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FFA2788B4
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgIYMvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgIYMvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B60F02075E;
        Fri, 25 Sep 2020 12:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038261;
        bh=0DlG/3RHYmeZOr2woLPqvPkBfh6V3La1uN1zjYf9+mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsXPbWE7aVQCzx4G1F+BgrUZyu6jSScbpFsZi4zzaRs0vs4js4l212yEUvZyGG2mR
         Lzmk8B5YtZ9CbRWz1vYwDcjJZdvpMD/Wkc+qeoH4SZd+p0wknzkwHzPn920t0hjPbP
         DASkzKnPFgqfhVPBuzR0JjtxVADcqFIkoI1cilxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 40/56] net: phy: Do not warn in phy_stop() on PHY_DOWN
Date:   Fri, 25 Sep 2020 14:48:30 +0200
Message-Id: <20200925124733.881946682@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 5116a8ade333b6c2e180782139c9c516a437b21c ]

When phy_is_started() was added to catch incorrect PHY states,
phy_stop() would not be qualified against PHY_DOWN. It is possible to
reach that state when the PHY driver has been unbound and the network
device is then brought down.

Fixes: 2b3e88ea6528 ("net: phy: improve phy state checking")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -948,7 +948,7 @@ void phy_stop(struct phy_device *phydev)
 {
 	struct net_device *dev = phydev->attached_dev;
 
-	if (!phy_is_started(phydev)) {
+	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
 		WARN(1, "called from state %s\n",
 		     phy_state_to_str(phydev->state));
 		return;


