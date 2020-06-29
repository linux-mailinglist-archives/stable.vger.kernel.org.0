Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B792F20E54C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgF2VfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbgF2Skv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 726D724140;
        Mon, 29 Jun 2020 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443938;
        bh=tHKeWTmblrT4lq8h5vz2KlmQG2ELREY9h+fGXVFQfXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTdOWevtmSr+m3eUZncN1s37R76u0RfpCis7tRGL0Gsa09FiVj9jQn6tUp+s+pVpM
         DJuA1rG/BpmMoVLktJaNnxLb9NwmON1aYVv/vubqK9zg9VToiw9u8RH4hpiIB+m5r0
         RKe1rt42J00aiyei2kkPPjxRwCHacS83zFXAO970=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 039/265] net: macb: undo operations in case of failure
Date:   Mon, 29 Jun 2020 11:14:32 -0400
Message-Id: <20200629151818.2493727-40-sashal@kernel.org>
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

[ Upstream commit faa620876b01d6744f1599e279042bb8149247ab ]

Undo previously done operation in case macb_phylink_connect()
fails. Since macb_reset_hw() is the 1st undo operation the
napi_exit label was renamed to reset_hw.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 67933079aeea5..257c4920cb886 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2558,7 +2558,7 @@ static int macb_open(struct net_device *dev)
 
 	err = macb_phylink_connect(bp);
 	if (err)
-		goto napi_exit;
+		goto reset_hw;
 
 	netif_tx_start_all_queues(dev);
 
@@ -2567,9 +2567,11 @@ static int macb_open(struct net_device *dev)
 
 	return 0;
 
-napi_exit:
+reset_hw:
+	macb_reset_hw(bp);
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_disable(&queue->napi);
+	macb_free_consistent(bp);
 pm_exit:
 	pm_runtime_put_sync(&bp->pdev->dev);
 	return err;
-- 
2.25.1

