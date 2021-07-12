Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E3A3C4A17
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbhGLGsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236151AbhGLGri (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A96F610F7;
        Mon, 12 Jul 2021 06:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072205;
        bh=WJJL3Ul7RmUo+3DBvprBYGqS18+SvRU3ae3N1cIHDFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4qS3rvhr+XOpuejEGClwNQY4jbndE4SeQLxrZyY1+2+OFYSEVNSfsmqPl/4Dknw+
         OL0YgOWQ0agqMNGWH7X/AVoGXwzaFE9TGTQ91d88Bik5AfwzK4LspFDSQk15jm0Y++
         V7GZ6KCNeKpTv0Xvk8Q6/S8LoxePOucxpEujizJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/593] ibmvnic: set ltb->buff to NULL after freeing
Date:   Mon, 12 Jul 2021 08:09:20 +0200
Message-Id: <20210712060931.603422327@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 765b38c8b252..458619aa84f4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -212,12 +212,11 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
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
@@ -225,20 +224,23 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
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
@@ -258,6 +260,8 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	    adapter->reset_reason != VNIC_RESET_TIMEOUT)
 		send_request_unmap(adapter, ltb->map_id);
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
+	ltb->buff = NULL;
+	ltb->map_id = 0;
 }
 
 static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
-- 
2.30.2



