Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAF032864B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbhCARHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235634AbhCARDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:03:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71C3C64EBD;
        Mon,  1 Mar 2021 16:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616704;
        bh=xjs0Nd/oXMRI3/5NlNp0VafnFnzJ7ySqGn57JKwjn8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLReE0fPlaOWsI+W/DaOj+UsNR8yfbdNjngDwf6rwbxCRRl1b+Q599pHasRr6yVNH
         QMvm7/XcKLuRgtIi5dxxdgS+9FsTvbMfhb7zTD1WTqrs9j6BlcrrIzLbyfIbDYeVgn
         BRkYuQ39DLHyY7OLVOBVuJ24F4H+zs39vG8lt6Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/247] ibmvnic: skip send_request_unmap for timeout reset
Date:   Mon,  1 Mar 2021 17:11:27 +0100
Message-Id: <20210301161034.956515733@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 788d944b3b51b..0c7c0206b1be5 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -212,8 +212,13 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
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



