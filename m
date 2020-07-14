Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9CA21FBA2
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbgGNTDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbgGNS5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:57:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6173207F5;
        Tue, 14 Jul 2020 18:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753058;
        bh=jTwNpFb2rkr80DQvw0fWw/2wsF8Yl1WzjH8/JVbUwZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqt1Ka+2N0JXGLMk5277Qnz24mPoCqnA+ZCoYlTaxsfBwIAmBhjZs0hNGCN70uXhy
         /nygW41NyLM3fcMHqqd/L3DagVsdQDjTRKQW2cf9j/U83ICdFPCpVcxP4RWR72tIyf
         bDSVd4peu4LaopFf8mcGseg0Lys4B6t93jgEGU9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Sergio Prado <sergio.prado@e-labworks.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 104/166] net: macb: fix call to pm_runtime in the suspend/resume functions
Date:   Tue, 14 Jul 2020 20:44:29 +0200
Message-Id: <20200714184120.822564844@linuxfoundation.org>
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

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 6c8f85cac98a4c6b767c4c4f6af7283724c32b47 ]

The calls to pm_runtime_force_suspend/resume() functions are only
relevant if the device is not configured to act as a WoL wakeup source.
Add the device_may_wakeup() test before calling them.

Fixes: 3e2a5e153906 ("net: macb: add wake-on-lan support via magic packet")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Sergio Prado <sergio.prado@e-labworks.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 548815255e22b..f1f0976e7669a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4606,7 +4606,8 @@ static int __maybe_unused macb_suspend(struct device *dev)
 
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(netdev);
-	pm_runtime_force_suspend(dev);
+	if (!device_may_wakeup(dev))
+		pm_runtime_force_suspend(dev);
 
 	return 0;
 }
@@ -4621,7 +4622,8 @@ static int __maybe_unused macb_resume(struct device *dev)
 	if (!netif_running(netdev))
 		return 0;
 
-	pm_runtime_force_resume(dev);
+	if (!device_may_wakeup(dev))
+		pm_runtime_force_resume(dev);
 
 	if (bp->wol & MACB_WOL_ENABLED) {
 		macb_writel(bp, IDR, MACB_BIT(WOL));
-- 
2.25.1



