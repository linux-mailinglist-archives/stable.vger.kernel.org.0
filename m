Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EB420E598
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbgF2VjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgF2Skb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 242832415F;
        Mon, 29 Jun 2020 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443942;
        bh=eV1hwMrZg/nVMqycfjegu4dbxpDijmSyrwC/bRAfnqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1OdjMbDnjB9s4LKIz2Ox0KvUw7tje7N1AC1AGksLj+QybNVvlnIQLmKLNRsc3L5LD
         rzMllGK1DB5zWBsmaqogooRyXfxrB+nzco/FlzgO8PHNTTdhMtVpLIhmUh2Oy/8b45
         nLMI4gjK9FNwbTVCpemc7VRBBjMZpSyKF7LdmeQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 044/265] net: macb: call pm_runtime_put_sync on failure path
Date:   Mon, 29 Jun 2020 11:14:37 -0400
Message-Id: <20200629151818.2493727-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 0eaf228d574bd82a9aed73e3953bfb81721f4227 ]

Call pm_runtime_put_sync() on failure path of at91ether_open.

Fixes: e6a41c23df0d ("net: macb: ensure interface is not suspended on at91rm9200")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 257c4920cb886..5705359a36124 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3837,7 +3837,7 @@ static int at91ether_open(struct net_device *dev)
 
 	ret = at91ether_start(dev);
 	if (ret)
-		return ret;
+		goto pm_exit;
 
 	/* Enable MAC interrupts */
 	macb_writel(lp, IER, MACB_BIT(RCOMP)	|
@@ -3850,11 +3850,15 @@ static int at91ether_open(struct net_device *dev)
 
 	ret = macb_phylink_connect(lp);
 	if (ret)
-		return ret;
+		goto pm_exit;
 
 	netif_start_queue(dev);
 
 	return 0;
+
+pm_exit:
+	pm_runtime_put_sync(&lp->pdev->dev);
+	return ret;
 }
 
 /* Close the interface */
-- 
2.25.1

