Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACD921FAF3
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbgGNS5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbgGNS5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:57:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 782BE22AAB;
        Tue, 14 Jul 2020 18:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753028;
        bh=9Fk8qdwtNyCMUQozg+B9JWPTakSh+mBFWMA1kk8Q0ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khx4j+yBWeRk//1usasFLfeNKVdnPmwcVkrzVDVTvdcsnRMOG5CLkPdP39dD79+to
         0EDR7aXhjZqUbkvcJwkzJ1hVJB4to5OYpDTRYt6XIG4JVF06CPpQOIl0mo5krzEJIG
         9JSWCwN73utKWZwjQS94FAeLDSfasdc2Ax88QxD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 062/166] net: mvneta: fix use of state->speed
Date:   Tue, 14 Jul 2020 20:43:47 +0200
Message-Id: <20200714184118.843343974@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit f2ca673d2cd5df9a76247b670e9ffd4d63682b3f ]

When support for short preambles was added, it incorrectly keyed its
decision off state->speed instead of state->interface.  state->speed
is not guaranteed to be correct for in-band modes, which can lead to
short preambles being unexpectedly disabled.

Fix this by keying off the interface mode, which is the only way that
mvneta can operate at 2.5Gbps.

Fixes: da58a931f248 ("net: mvneta: Add support for 2500Mbps SGMII")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index af578a5813bd2..cf26cf4e47aa8 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3953,7 +3953,7 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	/* When at 2.5G, the link partner can send frames with shortened
 	 * preambles.
 	 */
-	if (state->speed == SPEED_2500)
+	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
 		new_ctrl4 |= MVNETA_GMAC4_SHORT_PREAMBLE_ENABLE;
 
 	if (pp->phy_interface != state->interface) {
-- 
2.25.1



