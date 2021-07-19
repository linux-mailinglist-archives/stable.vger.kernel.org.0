Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144CC3CDB0E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244665AbhGSOkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343975AbhGSOjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 884D261003;
        Mon, 19 Jul 2021 15:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708016;
        bh=mkVry7P2o1xJeU4WaX5ONZWEe88eCYXmoquoGytWTsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FN8bMh3rVCoAJ1Dcc1Ozrw8617VJ9Xq4dSgTlNkcrihKxZK72xliEK0fPRN2KrFfn
         +mY4PslHe/9nG//5/H6fgfSV9Zel97uPPe1feXO4L2idltH+9pkkvr4c6qmzU9gm7h
         +XpWzkz3Wk2mpMjHbkBQS1JrSHOVoofK76YO3HBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cristobal Forno <cforno12@linux.ibm.com>,
        Abdul Haleem <abdhalee@in.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 114/315] Revert "ibmvnic: remove duplicate napi_schedule call in open function"
Date:   Mon, 19 Jul 2021 16:50:03 +0200
Message-Id: <20210719144946.625073692@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

[ Upstream commit 2ca220f92878470c6ba03f9946e412323093cc94 ]

This reverts commit 7c451f3ef676c805a4b77a743a01a5c21a250a73.

When a vnic interface is taken down and then up, connectivity is not
restored. We bisected it to this commit. Reverting this commit until
we can fully investigate the issue/benefit of the change.

Fixes: 7c451f3ef676 ("ibmvnic: remove duplicate napi_schedule call in open function")
Reported-by: Cristobal Forno <cforno12@linux.ibm.com>
Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 66fddc4ba56b..76ab6c0d40cf 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -898,6 +898,11 @@ static int __ibmvnic_open(struct net_device *netdev)
 
 	netif_tx_start_all_queues(netdev);
 
+	if (prev_state == VNIC_CLOSED) {
+		for (i = 0; i < adapter->req_rx_queues; i++)
+			napi_schedule(&adapter->napi[i]);
+	}
+
 	adapter->state = VNIC_OPEN;
 	return rc;
 }
-- 
2.30.2



