Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB94E2788D9
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgIYMtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbgIYMtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8678B21741;
        Fri, 25 Sep 2020 12:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038147;
        bh=/0jvsuLylUNhGmPZKxrk1RUySzqXCKCDdYe/ff99pLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgvXdukaSClq2KE6ci6Nez0cZ0tchjX8iWeY11sfq30bVOa9cAKOGpdQEk++3v1x9
         KpKntp0wqNM4Ji9uANeu9+FKNkcgNWlFZ+xDr6whGqR1j5+zagVrptgG6m2xYVVIEG
         52aFa6u1Ztu63okt/nyeH9fCGS/4PqUOKzC4AYDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 21/56] net: phy: call phy_disable_interrupts() in phy_attach_direct() instead
Date:   Fri, 25 Sep 2020 14:48:11 +0200
Message-Id: <20200925124730.998490342@linuxfoundation.org>
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

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 7d3ba9360c6dac7c077fbd6631e08f32ea2bcd53 ]

Since the micrel phy driver calls phy_init_hw() as a workaround,
the commit 9886a4dbd2aa ("net: phy: call phy_disable_interrupts()
in phy_init_hw()") disables the interrupt unexpectedly. So,
call phy_disable_interrupts() in phy_attach_direct() instead.
Otherwise, the phy cannot link up after the ethernet cable was
disconnected.

Note that other drivers (like at803x.c) also calls phy_init_hw().
So, perhaps, the driver caused a similar issue too.

Fixes: 9886a4dbd2aa ("net: phy: call phy_disable_interrupts() in phy_init_hw()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1092,10 +1092,6 @@ int phy_init_hw(struct phy_device *phyde
 	if (ret < 0)
 		return ret;
 
-	ret = phy_disable_interrupts(phydev);
-	if (ret)
-		return ret;
-
 	if (phydev->drv->config_init)
 		ret = phydev->drv->config_init(phydev);
 
@@ -1372,6 +1368,10 @@ int phy_attach_direct(struct net_device
 	if (err)
 		goto error;
 
+	err = phy_disable_interrupts(phydev);
+	if (err)
+		return err;
+
 	phy_resume(phydev);
 	phy_led_triggers_register(phydev);
 


