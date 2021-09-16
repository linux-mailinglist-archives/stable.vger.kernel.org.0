Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCB140E6B9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352633AbhIPRZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344045AbhIPRWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45B556044F;
        Thu, 16 Sep 2021 16:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810583;
        bh=VIATtPJ0D92dbWg+eENiigWc7KCEyc/ZyJO/wyvcxVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9BZVAEEMmSAmnL0oTLT00G88e0loDmCak2NtfzD3NVbbvfd1W7d2rBqWbUot6BHJ
         dgf3ORtjD8QXz7cc8UlkxSk3yxsD6DFHuiX/I4aW8Zh1kRhJ+NEULXHtRL5reS1V9G
         AYZmcGtoi7i6l4bjBWezluhHfCDCPXRptUkTVBrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 193/432] igc: Check if num of q_vectors is smaller than max before array access
Date:   Thu, 16 Sep 2021 17:59:02 +0200
Message-Id: <20210916155817.298427239@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 373e2829e7c2e1e606503cdb5c97749f512a4be9 ]

Ensure that the adapter->q_vector[MAX_Q_VECTORS] array isn't accessed
beyond its size. It was fixed by using a local variable num_q_vectors
as a limit for loop index, and ensure that num_q_vectors is not bigger
than MAX_Q_VECTORS.

Suggested-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ed2d66bc2d6c..f62982c4d933 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4817,6 +4817,7 @@ static irqreturn_t igc_msix_ring(int irq, void *data)
  */
 static int igc_request_msix(struct igc_adapter *adapter)
 {
+	unsigned int num_q_vectors = adapter->num_q_vectors;
 	int i = 0, err = 0, vector = 0, free_vector = 0;
 	struct net_device *netdev = adapter->netdev;
 
@@ -4825,7 +4826,13 @@ static int igc_request_msix(struct igc_adapter *adapter)
 	if (err)
 		goto err_out;
 
-	for (i = 0; i < adapter->num_q_vectors; i++) {
+	if (num_q_vectors > MAX_Q_VECTORS) {
+		num_q_vectors = MAX_Q_VECTORS;
+		dev_warn(&adapter->pdev->dev,
+			 "The number of queue vectors (%d) is higher than max allowed (%d)\n",
+			 adapter->num_q_vectors, MAX_Q_VECTORS);
+	}
+	for (i = 0; i < num_q_vectors; i++) {
 		struct igc_q_vector *q_vector = adapter->q_vector[i];
 
 		vector++;
-- 
2.30.2



