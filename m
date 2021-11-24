Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD72545BDBA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343579AbhKXMkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:40:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344659AbhKXMid (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:38:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7DFA613A8;
        Wed, 24 Nov 2021 12:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756589;
        bh=Jt0QQUne7RV6TmHkLL9C2pb/W/qD6bz86e/2GOS3O2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIp98xzbUskaw6Y3v5BJIY9UOoT46tgWoKKlH21FzdU7f69C6N7aCn5wf3L8wkTvp
         i4C7zIJeY9vmpzo/cFMBqyxJm/4nmwukV6renEdg4hssm9Rq3nKS+q2nxuizskYpbp
         HnBidTwXi8tg4loHzj2huc3tBLZzCFGjpbSFDbmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 136/251] net: phylink: avoid mvneta warning when setting pause parameters
Date:   Wed, 24 Nov 2021 12:56:18 +0100
Message-Id: <20211124115714.982506400@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit fd8d9731bcdfb22d28e45bce789bcb211c868c78 ]

mvneta does not support asymetric pause modes, and it flags this by the
lack of AsymPause in the supported field. When setting pause modes, we
check that pause->rx_pause == pause->tx_pause, but only when pause
autoneg is enabled. When pause autoneg is disabled, we still allow
pause->rx_pause != pause->tx_pause, which is incorrect when the MAC
does not support asymetric pause, and causes mvneta to issue a warning.

Fix this by removing the test for pause->autoneg, so we always check
that pause->rx_pause == pause->tx_pause for network devices that do not
support AsymPause.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 17acecfda5420..89d8efe8753e5 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1022,7 +1022,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 		return -EOPNOTSUPP;
 
 	if (!phylink_test(pl->supported, Asym_Pause) &&
-	    !pause->autoneg && pause->rx_pause != pause->tx_pause)
+	    pause->rx_pause != pause->tx_pause)
 		return -EINVAL;
 
 	config->pause &= ~(MLO_PAUSE_AN | MLO_PAUSE_TXRX_MASK);
-- 
2.33.0



