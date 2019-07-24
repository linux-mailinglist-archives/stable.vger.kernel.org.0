Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8544173F13
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389213AbfGXU3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388693AbfGXTcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:32:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C935E20659;
        Wed, 24 Jul 2019 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996764;
        bh=U18OzJ2Hs0BwigfMe9oIT1dXdOHAqd0d66RLb7M4YRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGifrLoArhN7tNcPAl0WtJdhXReHPrCh+T9JnWH6yj7dEmGW5krjBhEcsxBvCrVo8
         iFdu6xIwhxNq3S2cFBHoJb7URcyy+qeMH4gLHOXsmxFKOfN/Du7rbtLVWwvHTqMQwk
         xFz95bz3O9X83b3/WUEatBCXXTlb7/h2LA1Zr/ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 206/413] bnxt_en: Disable bus master during PCI shutdown and driver unload.
Date:   Wed, 24 Jul 2019 21:18:17 +0200
Message-Id: <20190724191749.254613245@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c20dc142dd7b2884b8570eeab323bcd4a84294fa ]

Some chips with older firmware can continue to perform DMA read from
context memory even after the memory has been freed.  In the PCI shutdown
method, we need to call pci_disable_device() to shutdown DMA to prevent
this DMA before we put the device into D3hot.  DMA memory request in
D3hot state will generate PCI fatal error.  Similarly, in the driver
remove method, the context memory should only be freed after DMA has
been shutdown for correctness.

Fixes: 98f04cf0f1fc ("bnxt_en: Check context memory requirements from firmware.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f758b2e0591f..b9bc829aa9da 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10262,10 +10262,10 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_dcb_free(bp);
 	kfree(bp->edev);
 	bp->edev = NULL;
+	bnxt_cleanup_pci(bp);
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
-	bnxt_cleanup_pci(bp);
 	bnxt_free_port_stats(bp);
 	free_netdev(dev);
 }
@@ -10859,6 +10859,7 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 
 	if (system_state == SYSTEM_POWER_OFF) {
 		bnxt_clear_int_mode(bp);
+		pci_disable_device(pdev);
 		pci_wake_from_d3(pdev, bp->wol);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
-- 
2.20.1



