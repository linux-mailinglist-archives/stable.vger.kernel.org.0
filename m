Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C6D2D9DE0
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502181AbgLNRhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408598AbgLNRhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:20 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 017/105] ibmvnic: avoid memset null scrq msgs
Date:   Mon, 14 Dec 2020 18:27:51 +0100
Message-Id: <20201214172556.101359881@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

[ Upstream commit 9281cf2d584083a450fd65fd27cc5f0e692f6e30 ]

scrq->msgs could be NULL during device reset, causing Linux to crash.
So, check before memset scrq->msgs.

Fixes: c8b2ad0a4a901 ("ibmvnic: Sanitize entire SCRQ buffer on reset")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 32fc0266d99b1..f892cb4a08f4e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2857,15 +2857,26 @@ static int reset_one_sub_crq_queue(struct ibmvnic_adapter *adapter,
 {
 	int rc;
 
+	if (!scrq) {
+		netdev_dbg(adapter->netdev,
+			   "Invalid scrq reset. irq (%d) or msgs (%p).\n",
+			   scrq->irq, scrq->msgs);
+		return -EINVAL;
+	}
+
 	if (scrq->irq) {
 		free_irq(scrq->irq, scrq);
 		irq_dispose_mapping(scrq->irq);
 		scrq->irq = 0;
 	}
-
-	memset(scrq->msgs, 0, 4 * PAGE_SIZE);
-	atomic_set(&scrq->used, 0);
-	scrq->cur = 0;
+	if (scrq->msgs) {
+		memset(scrq->msgs, 0, 4 * PAGE_SIZE);
+		atomic_set(&scrq->used, 0);
+		scrq->cur = 0;
+	} else {
+		netdev_dbg(adapter->netdev, "Invalid scrq reset\n");
+		return -EINVAL;
+	}
 
 	rc = h_reg_sub_crq(adapter->vdev->unit_address, scrq->msg_token,
 			   4 * PAGE_SIZE, &scrq->crq_num, &scrq->hw_irq);
-- 
2.27.0



