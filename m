Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF643C4EFB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbhGLHWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241498AbhGLHVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BC2561153;
        Mon, 12 Jul 2021 07:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074313;
        bh=VbYQrgvhe0aVkGjfUOiJLFo0lotve3uY4ypn/0VDXcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5G5NR4PNcdO1Y7Rub/DEFETeH593Dx6wVCVuB85m6r0Uzku12npRwA6xofYqdtdR
         gSTsopSfVRDXHmyPgjo8FSjhC1rpCU5yowlAUR4OXxP1/s+ep996YzVWfaZIP+3/FQ
         CJ7OlCj1o00GqaiERzgJ00qc24srAC9g5sh0gnKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 485/700] ibmvnic: set ltb->buff to NULL after freeing
Date:   Mon, 12 Jul 2021 08:09:28 +0200
Message-Id: <20210712061028.183649390@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 552a33729f1a7cc5115d0752064fe9abd6e3e336 ]

free_long_term_buff() checks ltb->buff to decide whether we have a long
term buffer to free. So set ltb->buff to NULL afer freeing. While here,
also clear ->map_id, fix up some coding style and log an error.

Fixes: 9c4eaabd1bb39 ("Check CRQ command return codes")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f1a6f454fe97..accf362193f8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -211,12 +211,11 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 	mutex_lock(&adapter->fw_lock);
 	adapter->fw_done_rc = 0;
 	reinit_completion(&adapter->fw_done);
-	rc = send_request_map(adapter, ltb->addr,
-			      ltb->size, ltb->map_id);
+
+	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
 	if (rc) {
-		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
-		mutex_unlock(&adapter->fw_lock);
-		return rc;
+		dev_err(dev, "send_request_map failed, rc = %d\n", rc);
+		goto out;
 	}
 
 	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
@@ -224,20 +223,23 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 		dev_err(dev,
 			"Long term map request aborted or timed out,rc = %d\n",
 			rc);
-		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
-		mutex_unlock(&adapter->fw_lock);
-		return rc;
+		goto out;
 	}
 
 	if (adapter->fw_done_rc) {
 		dev_err(dev, "Couldn't map long term buffer,rc = %d\n",
 			adapter->fw_done_rc);
+		rc = -1;
+		goto out;
+	}
+	rc = 0;
+out:
+	if (rc) {
 		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
-		mutex_unlock(&adapter->fw_lock);
-		return -1;
+		ltb->buff = NULL;
 	}
 	mutex_unlock(&adapter->fw_lock);
-	return 0;
+	return rc;
 }
 
 static void free_long_term_buff(struct ibmvnic_adapter *adapter,
@@ -257,6 +259,8 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	    adapter->reset_reason != VNIC_RESET_TIMEOUT)
 		send_request_unmap(adapter, ltb->map_id);
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
+	ltb->buff = NULL;
+	ltb->map_id = 0;
 }
 
 static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
-- 
2.30.2



