Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E206345C07A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245498AbhKXNJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347055AbhKXNGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:06:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B9FF613BD;
        Wed, 24 Nov 2021 12:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757502;
        bh=ptO+mTu63sIievXAc9tYAb3BdD1yIC+/E1E6w+Bbr4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRPZMGffJ1W5Rj553Iarvs33VXk4jD87OhAHz6GjbadL0PEvNeKCJscoI05Qn+Ive
         kQWPajEpHyWRUlk56FJBKI57I9gF2YvwzroMukTX0jiD/dwHAbxu/HYm+0HRei7KgC
         zyAAtB3JjQhhnjxuVqzuIndE/BECyXcM4qrqc7nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/323] phy: micrel: ksz8041nl: do not use power down mode
Date:   Wed, 24 Nov 2021 12:55:47 +0100
Message-Id: <20211124115724.229361641@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit 2641b62d2fab52648e34cdc6994b2eacde2d27c1 ]

Some Micrel KSZ8041NL PHY chips exhibit continuous RX errors after using
the power down mode bit (0.11). If the PHY is taken out of power down
mode in a certain temperature range, the PHY enters a weird state which
leads to continuously reporting RX errors. In that state, the MAC is not
able to receive or send any Ethernet frames and the activity LED is
constantly blinking. Since Linux is using the suspend callback when the
interface is taken down, ending up in that state can easily happen
during a normal startup.

Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
clock recovery when using power down mode. Even the latest revision (A4,
Revision ID 0x1513) seems to suffer that problem, and according to the
errata is not going to be fixed.

Remove the suspend/resume callback to avoid using the power down mode
completely.

[*] https://ww1.microchip.com/downloads/en/DeviceDoc/80000700A.pdf

Fixes: 1a5465f5d6a2 ("phy/micrel: Add suspend/resume support to Micrel PHYs")
Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 55caaaf969da5..0135903300595 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -880,8 +880,9 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	/* No suspend/resume callbacks because of errata DS80000700A,
+	 * receiver error following software power down.
+	 */
 }, {
 	.phy_id		= PHY_ID_KSZ8041RNLI,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.33.0



