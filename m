Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882A545265E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349840AbhKPCFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240010AbhKOSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B5C063371;
        Mon, 15 Nov 2021 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998069;
        bh=KFLqRm6YvDx71RC1lPpY22hOq0Jb8J/NODucDGAnVqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxCV1e652/7tbfOGKxdYMnsoOq7bHt5Ua6Q6TRIU0oGbKQ+pIG7BEjvKqHQi8zuBg
         fr7NElUSS7xGRVBvxPvSr5WXadZflFsqo4M6DLiWOOwEbt0W5miKkFe+xXvwaY0otj
         3SFTGV9k5d9+d8vpSc2CyiMaT0BRPldcMBFy0SNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 376/575] net: phylink: avoid mvneta warning when setting pause parameters
Date:   Mon, 15 Nov 2021 18:01:41 +0100
Message-Id: <20211115165356.784611110@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 025c3246f3396..899496f089d2e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1610,7 +1610,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 		return -EOPNOTSUPP;
 
 	if (!phylink_test(pl->supported, Asym_Pause) &&
-	    !pause->autoneg && pause->rx_pause != pause->tx_pause)
+	    pause->rx_pause != pause->tx_pause)
 		return -EINVAL;
 
 	pause_state = 0;
-- 
2.33.0



