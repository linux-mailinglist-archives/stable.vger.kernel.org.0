Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40185F7D9C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbfKKS6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:58:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730952AbfKKS6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:58:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78B5F20659;
        Mon, 11 Nov 2019 18:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498709;
        bh=UNKoRBtM+PCUOoBJR2Fga9b4eBO6VBZfy3vyN5ZIkzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+bElZPC6NSaScJn/pq91NZLCT1Fl61yU5ay3iIq4ANjOR7X2oh+lVfbyRfTO2iFn
         7j6aAGrwPHP+NtT/TLzaEIBP+W1sO9ejTR2PBDGcKm4o8q2Npwv64noYWLcETOoi9P
         mskkANz/pRFRptNZRvBm8WGlk01J/1R7o7CsgSgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Nicolas Waisman <nico@semmle.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 157/193] fjes: Handle workqueue allocation failure
Date:   Mon, 11 Nov 2019 19:28:59 +0100
Message-Id: <20191111181512.719769717@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 85ac30fa2e24f628e9f4f9344460f4015d33fd7d ]

In the highly unlikely event that we fail to allocate either of the
"/txrx" or "/control" workqueues, we should bail cleanly rather than
blindly march on with NULL queue pointer(s) installed in the
'fjes_adapter' instance.

Cc: "David S. Miller" <davem@davemloft.net>
Reported-by: Nicolas Waisman <nico@semmle.com>
Link: https://lore.kernel.org/lkml/CADJ_3a8WFrs5NouXNqS5WYe7rebFP+_A5CheeqAyD_p7DFJJcg@mail.gmail.com/
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/fjes/fjes_main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index bbbc1dcb6ab5c..b517c1af9de05 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1237,8 +1237,17 @@ static int fjes_probe(struct platform_device *plat_dev)
 	adapter->open_guard = false;
 
 	adapter->txrx_wq = alloc_workqueue(DRV_NAME "/txrx", WQ_MEM_RECLAIM, 0);
+	if (unlikely(!adapter->txrx_wq)) {
+		err = -ENOMEM;
+		goto err_free_netdev;
+	}
+
 	adapter->control_wq = alloc_workqueue(DRV_NAME "/control",
 					      WQ_MEM_RECLAIM, 0);
+	if (unlikely(!adapter->control_wq)) {
+		err = -ENOMEM;
+		goto err_free_txrx_wq;
+	}
 
 	INIT_WORK(&adapter->tx_stall_task, fjes_tx_stall_task);
 	INIT_WORK(&adapter->raise_intr_rxdata_task,
@@ -1255,7 +1264,7 @@ static int fjes_probe(struct platform_device *plat_dev)
 	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
 	err = fjes_hw_init(&adapter->hw);
 	if (err)
-		goto err_free_netdev;
+		goto err_free_control_wq;
 
 	/* setup MAC address (02:00:00:00:00:[epid])*/
 	netdev->dev_addr[0] = 2;
@@ -1277,6 +1286,10 @@ static int fjes_probe(struct platform_device *plat_dev)
 
 err_hw_exit:
 	fjes_hw_exit(&adapter->hw);
+err_free_control_wq:
+	destroy_workqueue(adapter->control_wq);
+err_free_txrx_wq:
+	destroy_workqueue(adapter->txrx_wq);
 err_free_netdev:
 	free_netdev(netdev);
 err_out:
-- 
2.20.1



