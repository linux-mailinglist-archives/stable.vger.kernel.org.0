Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72A014B983
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgA1OZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:25:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbgA1OZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:25:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B835424686;
        Tue, 28 Jan 2020 14:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221550;
        bh=/0hs1BMJug76hD76DDn1hUvFOfwgJOJkSsrfJoSqd8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGfCOSVWTJRs1YSwjQLvv2QVUdCsTIZ52y4kn+hbBojhYb19k5sb/whR/X1fUrr+K
         myJ8guGLhp7HssYyqsj0kYSxBU0+K96UnzR7WdZR44KyU6sxZc+dljL2l0JqsJR6r1
         8PEE6iKk7qbrcSc3NiA66OsX/JAjUf8tI18o0yEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 233/271] net: phy: Keep reporting transceiver type
Date:   Tue, 28 Jan 2020 15:06:22 +0100
Message-Id: <20200128135909.908143382@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit ceb628134a75564d7bfa8e4ef902e6e588339e11 upstream.

With commit 2d55173e71b0 ("phy: add generic function to support
ksetting support"), we lost the ability to report the transceiver type
like we used to. Now that we have added back the transceiver type to
ethtool_link_settings, we can report it back like we used to and have no
loss of information.

Fixes: 3f1ac7a700d0 ("net: ethtool: add new ETHTOOL_xLINKSETTINGS API")
Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/phy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -463,7 +463,8 @@ int phy_ethtool_ksettings_get(struct phy
 		cmd->base.port = PORT_BNC;
 	else
 		cmd->base.port = PORT_MII;
-
+	cmd->base.transceiver = phy_is_internal(phydev) ?
+				XCVR_INTERNAL : XCVR_EXTERNAL;
 	cmd->base.phy_address = phydev->mdio.addr;
 	cmd->base.autoneg = phydev->autoneg;
 	cmd->base.eth_tp_mdix_ctrl = phydev->mdix;


