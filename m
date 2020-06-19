Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519BB201247
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388018AbgFSPvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404009AbgFSPYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:24:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA08B21548;
        Fri, 19 Jun 2020 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580250;
        bh=0kTjp2ybDUM0ctaeDR3fOgYBPE7QHYAKia5yuuniklk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1M7Rqm7y4llSkVbJ00sLzZULuq4l+n9qxj+6cScx/j0U9wqgsKPNPQCydvPqoQkH
         Mvu0F/F8C6+/fXJKdrfoJaUb1fJACjtRkRopKYUOyQtZz35eBAzM0FECPbG4ItQVqe
         muGvOeyIlYoQWHtJkio3E0CL0beMr91GEp9kJbmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 148/376] ath11k: fix error return code in ath11k_dp_alloc()
Date:   Fri, 19 Jun 2020 16:31:06 +0200
Message-Id: <20200619141717.334193760@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit f76f750aeea47fd98b6502eb6d37f84ca33662bf ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: d0998eb84ed3 ("ath11k: optimise ath11k_dp_tx_completion_handler")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200427104621.23752-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index 50350f77b309..2f35d325f7a5 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -909,8 +909,10 @@ int ath11k_dp_alloc(struct ath11k_base *ab)
 		dp->tx_ring[i].tx_status_head = 0;
 		dp->tx_ring[i].tx_status_tail = DP_TX_COMP_RING_SIZE - 1;
 		dp->tx_ring[i].tx_status = kmalloc(size, GFP_KERNEL);
-		if (!dp->tx_ring[i].tx_status)
+		if (!dp->tx_ring[i].tx_status) {
+			ret = -ENOMEM;
 			goto fail_cmn_srng_cleanup;
+		}
 	}
 
 	for (i = 0; i < HAL_DSCP_TID_MAP_TBL_NUM_ENTRIES_MAX; i++)
-- 
2.25.1



