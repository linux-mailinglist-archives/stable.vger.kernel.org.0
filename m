Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B87E6754
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731615AbfJ0VUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731100AbfJ0VUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:20:04 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBB2F2070B;
        Sun, 27 Oct 2019 21:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211203;
        bh=wGJG6dgJHfROtZnh12vuDuPwFT13RVooPwWmCpFfzXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Dt6Xx1U93mAqk5UF44ekQUj7OIWWbVWLlOf+1/9TuGieFqqfba10Mo2tjR328pwc
         YsectiRdp6+BkxNGvlbxu+1Lf7OxCxOK3rUwJXkOyDUwan0YXrwltiGpHwh6rn0LO5
         2Hzb0I+MgEtcm7TQa33XxkCGYMCzn8MPgAfmUnpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 041/197] net: stmmac: Do not stop PHY if WoL is enabled
Date:   Sun, 27 Oct 2019 21:59:19 +0100
Message-Id: <20191027203353.934280779@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 3e2bf04fb0447aa4b967b8000125178f55ae7800 ]

If WoL is enabled we can't really stop the PHY, otherwise we will not
receive the WoL packet. Fix this by telling phylink that only the MAC is
down and only stop the PHY if WoL is not enabled.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ade85ca9d8c7f..69cc9133336fc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4456,9 +4456,7 @@ int stmmac_suspend(struct device *dev)
 
 	mutex_lock(&priv->lock);
 
-	rtnl_lock();
-	phylink_stop(priv->phylink);
-	rtnl_unlock();
+	phylink_mac_change(priv->phylink, false);
 
 	netif_device_detach(ndev);
 	stmmac_stop_all_queues(priv);
@@ -4473,6 +4471,10 @@ int stmmac_suspend(struct device *dev)
 		stmmac_pmt(priv, priv->hw, priv->wolopts);
 		priv->irq_wake = 1;
 	} else {
+		rtnl_lock();
+		phylink_stop(priv->phylink);
+		rtnl_unlock();
+
 		stmmac_mac_set(priv, priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
@@ -4563,9 +4565,13 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_start_all_queues(priv);
 
-	rtnl_lock();
-	phylink_start(priv->phylink);
-	rtnl_unlock();
+	if (!device_may_wakeup(priv->device)) {
+		rtnl_lock();
+		phylink_start(priv->phylink);
+		rtnl_unlock();
+	}
+
+	phylink_mac_change(priv->phylink, true);
 
 	mutex_unlock(&priv->lock);
 
-- 
2.20.1



