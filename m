Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD57328ECC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbhCATiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:38:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235341AbhCATaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:30:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 879EA652E9;
        Mon,  1 Mar 2021 17:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620372;
        bh=6uEV57uYIyJuD4mTxZjWCo3vG8rnDz7tFsqutPhVpbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnpLemkOQGhQBp3YVIlqR1gLcx4qMqRqxVewxFysLqEuUeuzAUK3SRasm0dELv4zW
         shdVt9wZoUiKfTtwdkGRSxShFFTzxTnt/udhoqaxTFc+52JELn8sSGMbHyKiko6jit
         SHxHDh5ztUwNdKU6OgAlqnvC1WeE/xZruDoHd6cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 129/775] ibmvnic: skip send_request_unmap for timeout reset
Date:   Mon,  1 Mar 2021 17:04:57 +0100
Message-Id: <20210301161208.037684388@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 7d3a7b9ea59ddb223aec59b45fa1713c633aaed4 ]

Timeout reset will trigger the VIOS to unmap it automatically,
similarly as FAILVOER and MOBILITY events. If we unmap it
in the linux side, we will see errors like
"30000003: Error 4 in REQUEST_UNMAP_RSP".
So, don't call send_request_unmap for timeout reset.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f6402a20ba320..cd201f89ce6c0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -247,8 +247,13 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	if (!ltb->buff)
 		return;
 
+	/* VIOS automatically unmaps the long term buffer at remote
+	 * end for the following resets:
+	 * FAILOVER, MOBILITY, TIMEOUT.
+	 */
 	if (adapter->reset_reason != VNIC_RESET_FAILOVER &&
-	    adapter->reset_reason != VNIC_RESET_MOBILITY)
+	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
+	    adapter->reset_reason != VNIC_RESET_TIMEOUT)
 		send_request_unmap(adapter, ltb->map_id);
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
 }
-- 
2.27.0



