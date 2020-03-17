Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9D0187FA1
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCQLDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727319AbgCQLDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:03:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5579220735;
        Tue, 17 Mar 2020 11:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442986;
        bh=SpoceLHzg5AKCH01Z2ag0L+5AX9kLQ7kRAV+kLT7H7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukxIyd8/hNE5Pnsap3flf6i7WueCYrR+OoZr3ZKXuWHBJJ7Cctba3LYbbp3Gr7H98
         +vQpkkjUUnMmojGFB3yalGAO8wl0vTdqeOomuK75BX0Gnl/5nblIZn2StJhZFrtGO5
         c+FQEbxm/dR9LMIMPUJxGg61rn9zsbI5ov9hW/eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 057/123] net: phy: Avoid multiple suspends
Date:   Tue, 17 Mar 2020 11:54:44 +0100
Message-Id: <20200317103313.521377499@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 503ba7c6961034ff0047707685644cad9287c226 upstream.

It is currently possible for a PHY device to be suspended as part of a
network device driver's suspend call while it is still being attached to
that net_device, either via phy_suspend() or implicitly via phy_stop().

Later on, when the MDIO bus controller get suspended, we would attempt
to suspend again the PHY because it is still attached to a network
device.

This is both a waste of time and creates an opportunity for improper
clock/power management bugs to creep in.

Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/phy_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -246,7 +246,7 @@ static bool mdio_bus_phy_may_suspend(str
 	 * MDIO bus driver and clock gated at this point.
 	 */
 	if (!netdev)
-		return !phydev->suspended;
+		goto out;
 
 	if (netdev->wol_enabled)
 		return false;
@@ -266,7 +266,8 @@ static bool mdio_bus_phy_may_suspend(str
 	if (device_may_wakeup(&netdev->dev))
 		return false;
 
-	return true;
+out:
+	return !phydev->suspended;
 }
 
 static int mdio_bus_phy_suspend(struct device *dev)


