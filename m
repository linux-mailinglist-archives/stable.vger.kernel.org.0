Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9513C4EF6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbhGLHWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243048AbhGLHTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 596506145A;
        Mon, 12 Jul 2021 07:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074185;
        bh=kKo82JbQhrOpPRUGgosE3k7PE3su9KEwqP3z4tw5qeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSg4c2UOdY2JbgUIQq800TcNC3504kDTlyV3VWl0GEil0VVG8bjptzjjR7TI4QAJV
         v+PfLAulkelDFE/kb2YofBYxjMiMvMD9jJkXXdzPerosydBWLGc84u3UvA/PptKmUP
         Ju9ujhqGvSB6p4IUgKYAM/RaZRTRPF+QLSMQV+jY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 486/700] ibmvnic: free tx_pool if tso_pool alloc fails
Date:   Mon, 12 Jul 2021 08:09:29 +0200
Message-Id: <20210712061028.282224407@linuxfoundation.org>
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

[ Upstream commit f6ebca8efa52e4ae770f0325d618e7bcf08ada0c ]

Free tx_pool and clear it, if allocation of tso_pool fails.

release_tx_pools() assumes we have both tx and tso_pools if ->tx_pool is
non-NULL. If allocation of tso_pool fails in init_tx_pools(), the assumption
will not be true and we would end up dereferencing ->tx_buff, ->free_map
fields from a NULL pointer.

Fixes: 3205306c6b8d ("ibmvnic: Update TX pool initialization routine")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index accf362193f8..3c77897b3f31 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -778,8 +778,11 @@ static int init_tx_pools(struct net_device *netdev)
 
 	adapter->tso_pool = kcalloc(tx_subcrqs,
 				    sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
-	if (!adapter->tso_pool)
+	if (!adapter->tso_pool) {
+		kfree(adapter->tx_pool);
+		adapter->tx_pool = NULL;
 		return -1;
+	}
 
 	adapter->num_active_tx_pools = tx_subcrqs;
 
-- 
2.30.2



