Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B7B111FCC
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfLCWiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbfLCWiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:38:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CEAC216C8;
        Tue,  3 Dec 2019 22:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412729;
        bh=LeeLcaM9dh5pkKj54i2S2TuddtD99GXVNipPeh9Atok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRh5zz7g73kQZBnNEpCaZ/UQt7gRR4sASVfTjcjs4G2VEP8xtu0zWmVbH3bs+kGOL
         VfhAgpP7adXearI7w3LHSOWHvo5liLnjcG2h63AaFms12Xn6ZsTXntwrcEW6Xd+h3n
         MR/XnjkAgjDRrJFvm8/6TOKEi4rGp/kC/jT1w7qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jhdskag3 <jhdskag3@tutanota.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 40/46] r8169: fix resume on cable plug-in
Date:   Tue,  3 Dec 2019 23:36:00 +0100
Message-Id: <20191203212802.666805566@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 398fd408ccfb5e44b1cbe73a209d2281d3efa83c ]

It was reported [0] that network doesn't wake up on cable plug-in with
certain chip versions. Reason is that on these chip versions the PHY
doesn't detect cable plug-in when being in power-down mode. So prevent
the PHY from powering down if WoL is enabled.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=202103

Fixes: 95fb8bb3181b ("net: phy: force phy suspend when calling phy_stop")
Reported-by: jhdskag3 <jhdskag3@tutanota.com>
Tested-by: jhdskag3 <jhdskag3@tutanota.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1516,6 +1516,7 @@ static void __rtl8169_set_wol(struct rtl
 	rtl_lock_config_regs(tp);
 
 	device_set_wakeup_enable(tp_to_dev(tp), wolopts);
+	tp->dev->wol_enabled = wolopts ? 1 : 0;
 }
 
 static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)


