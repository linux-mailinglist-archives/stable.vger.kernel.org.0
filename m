Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72944D74F
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfFTSRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbfFTSRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:17:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F9D205F4;
        Thu, 20 Jun 2019 18:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054655;
        bh=UYULzn93A56phEQURk35RZhM5uJHEBZUBnFkb6r3RXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+3AbsNOzaFvDBJbHhPU9+7Jq83Rkt3wguZmWpllnRGn/QpUVZdu4qDUrlz3a4gJs
         Fu4ma/9abqxbqCY48Uz9CtgHw0hg7kEfe7F1QJsXbA4Jul//R1lTU31eyMKcfEAPHk
         Aabajr/YbjpSy48CcKD4ns3Vbuu0MKTW9mj6TJkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 84/98] net: phylink: ensure consistent phy interface mode
Date:   Thu, 20 Jun 2019 19:57:51 +0200
Message-Id: <20190620174353.556736178@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c678726305b9425454be7c8a7624290b602602fc ]

Ensure that we supply the same phy interface mode to mac_link_down() as
we did for the corresponding mac_link_up() call.  This ensures that MAC
drivers that use the phy interface mode in these methods can depend on
mac_link_down() always corresponding to a mac_link_up() call for the
same interface mode.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index d8f919fe49fd..507baa10ec70 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -51,6 +51,10 @@ struct phylink {
 
 	/* The link configuration settings */
 	struct phylink_link_state link_config;
+
+	/* The current settings */
+	phy_interface_t cur_interface;
+
 	struct gpio_desc *link_gpio;
 	struct timer_list link_poll;
 	void (*get_fixed_state)(struct net_device *dev,
@@ -453,12 +457,12 @@ static void phylink_resolve(struct work_struct *w)
 		if (!link_state.link) {
 			netif_carrier_off(ndev);
 			pl->ops->mac_link_down(ndev, pl->link_an_mode,
-					       pl->phy_state.interface);
+					       pl->cur_interface);
 			netdev_info(ndev, "Link is Down\n");
 		} else {
+			pl->cur_interface = link_state.interface;
 			pl->ops->mac_link_up(ndev, pl->link_an_mode,
-					     pl->phy_state.interface,
-					     pl->phydev);
+					     pl->cur_interface, pl->phydev);
 
 			netif_carrier_on(ndev);
 
-- 
2.20.1



