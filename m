Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10845BB92
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243671AbhKXMU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243836AbhKXMSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:18:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4679A61156;
        Wed, 24 Nov 2021 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755920;
        bh=N7S8ac7Rcg4fZBD6Dknklfv+P+OwiyD4Q7/zqVfK5yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYVCLs5/F9OLr5uOKZLPdEhbS9nS5cXrgaR4k0CPHjpm49KzLMlY5R+i6bHopD2ir
         0iMiqXWU+ysvyGkxhu3RLsPAgMN14zysuQNdy0CeHQfFHGif5oo1NOcMDKMRBgzhSz
         AWIVtDY/aFn3wSIwrn57NX/iBvbSKC1Wq2ixJUOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 107/207] phy: micrel: ksz8041nl: do not use power down mode
Date:   Wed, 24 Nov 2021 12:56:18 +0100
Message-Id: <20211124115707.540442304@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
index 1704d9e2ca8d1..c21328e1e3cca 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -876,8 +876,9 @@ static struct phy_driver ksphy_driver[] = {
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



