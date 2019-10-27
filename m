Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B5CE6860
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731401AbfJ0VTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731395AbfJ0VTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:07 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2B5214E0;
        Sun, 27 Oct 2019 21:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211146;
        bh=rR/tHFx4pomAVWweAo1Zmziuu9yLjxENE/5tcvMBfd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYxczeVh6fu2xv0Ou9DLKZ6oWaIhHIBhwPNVYBka5CG2CeN/YGCBUJpj+RDBPV2oJ
         JLuqwnBRh35d0QhbKyUYyaZN70PXZHd9nFNAeC7qYCi8uAQcSYFkjZZ2d4gbb3qGM+
         vV3KCgiJUPupwvd1FBlBiLevXgGdHiduLpiZpQxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bitan Biswas <bbiswas@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 049/197] net: stmmac: Avoid deadlock on suspend/resume
Date:   Sun, 27 Oct 2019 21:59:27 +0100
Message-Id: <20191027203354.341058811@linuxfoundation.org>
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

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 134cc4cefad34d8d24670d8a911b59c3b89c6731 ]

The stmmac driver will try to acquire its private mutex during suspend
via phylink_resolve() -> stmmac_mac_link_down() -> stmmac_eee_init().
However, the phylink configuration is updated with the private mutex
held already, which causes a deadlock during suspend.

Fix this by moving the phylink configuration updates out of the region
of code protected by the private mutex.

Fixes: 19e13cb27b99 ("net: stmmac: Hold rtnl lock in suspend/resume callbacks")
Suggested-by: Bitan Biswas <bbiswas@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 69cc9133336fc..8d5ec73e02d34 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4454,10 +4454,10 @@ int stmmac_suspend(struct device *dev)
 	if (!ndev || !netif_running(ndev))
 		return 0;
 
-	mutex_lock(&priv->lock);
-
 	phylink_mac_change(priv->phylink, false);
 
+	mutex_lock(&priv->lock);
+
 	netif_device_detach(ndev);
 	stmmac_stop_all_queues(priv);
 
@@ -4471,9 +4471,11 @@ int stmmac_suspend(struct device *dev)
 		stmmac_pmt(priv, priv->hw, priv->wolopts);
 		priv->irq_wake = 1;
 	} else {
+		mutex_unlock(&priv->lock);
 		rtnl_lock();
 		phylink_stop(priv->phylink);
 		rtnl_unlock();
+		mutex_lock(&priv->lock);
 
 		stmmac_mac_set(priv, priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
@@ -4565,6 +4567,8 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_start_all_queues(priv);
 
+	mutex_unlock(&priv->lock);
+
 	if (!device_may_wakeup(priv->device)) {
 		rtnl_lock();
 		phylink_start(priv->phylink);
@@ -4573,8 +4577,6 @@ int stmmac_resume(struct device *dev)
 
 	phylink_mac_change(priv->phylink, true);
 
-	mutex_unlock(&priv->lock);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_resume);
-- 
2.20.1



