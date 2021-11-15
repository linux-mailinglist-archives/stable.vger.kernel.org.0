Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBFE452390
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379447AbhKPB1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:27:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240765AbhKOTFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:05:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2843633E5;
        Mon, 15 Nov 2021 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000189;
        bh=B5JQf6jCMwswOKSRbpPx5oKX54SQ8nCH/fzmsPUa7X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzpSahq2hWwk4AqsUSS2xk3vt31YMmJJ/2AZDRtoZVW1sKtmjFhNyVoulpj4B+N4A
         qPIVgXgBcXxSWWQVLJVzs4K/hcUJoMhgJp5BI83PvoupxGFxyTn4jIhtDfUIhuojdp
         FoFggxPPMD+F74knLBZsIFIlAHFZ8Q+0ITFUfWVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 536/849] net: phylink: avoid mvneta warning when setting pause parameters
Date:   Mon, 15 Nov 2021 18:00:19 +0100
Message-Id: <20211115165438.396504525@linuxfoundation.org>
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
index 6e96d7b7ee445..d18e4e76a5df4 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1724,7 +1724,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 		return -EOPNOTSUPP;
 
 	if (!phylink_test(pl->supported, Asym_Pause) &&
-	    !pause->autoneg && pause->rx_pause != pause->tx_pause)
+	    pause->rx_pause != pause->tx_pause)
 		return -EINVAL;
 
 	pause_state = 0;
-- 
2.33.0



