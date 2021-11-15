Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E1945243E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345328AbhKPBgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242477AbhKOSoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:44:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1B6B63380;
        Mon, 15 Nov 2021 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999589;
        bh=OIdNUZQQSpPxNuGZ8qXaNkIUAr5KQG6W9KKsjlVfmo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aq+rcszAa8hP5jfgG6GbA269DJPklC5vjiskIqc+WqdW0ACnNR7oaYiAodxBMwmWL
         wiGx9SdlFXaL9gGu2neosu0wuVqNl08DFECQ6T8DRjuzYpLyr6ASGHPC+wyUzwwMdv
         u4RNJBJU+u/V43WGh6MUXM2xzo1fsp4icYo5mN+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 351/849] net: phylink: dont call netif_carrier_off() with NULL netdev
Date:   Mon, 15 Nov 2021 17:57:14 +0100
Message-Id: <20211115165432.113099309@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit cbcca2e3961eac736566ac13ef0d0bf6f0b764ec ]

Dan Carpenter points out that we have a code path that permits a NULL
netdev pointer to be passed to netif_carrier_off(), which will cause
a kernel oops. In any case, we need to set pl->old_link_state to false
to have the desired effect when there is no netdev present.

Fixes: f97493657c63 ("net: phylink: add suspend/resume support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0d3d9c3ee83c8..6e96d7b7ee445 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1332,7 +1332,10 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
 		 * but one would hope all packets have been sent. This
 		 * also means phylink_resolve() will do nothing.
 		 */
-		netif_carrier_off(pl->netdev);
+		if (pl->netdev)
+			netif_carrier_off(pl->netdev);
+		else
+			pl->old_link_state = false;
 
 		/* We do not call mac_link_down() here as we want the
 		 * link to remain up to receive the WoL packets.
-- 
2.33.0



