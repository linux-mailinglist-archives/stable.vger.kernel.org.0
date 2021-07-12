Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1B83C46AB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbhGLG1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234931AbhGLG02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:26:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACA6D610CA;
        Mon, 12 Jul 2021 06:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071011;
        bh=PeLSUvw9UGAbSxAoyAVjzp6r6b8iTmqDoxAA0x/tM9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyEuVdczndROkSNkV39BhZwwzsdbIz0pD9hgbLOPBaXb7CiGlOYyQ5FjNESVkF6dX
         zzPRcnJR9NXCITRx4qcCgEPXpmjPk4oCsuTtKKVvM4hTWz9cBeIUgd033NvZinN1TL
         MyBg+GQcmUvgWLwhUI0EhjQUsD5EL1EUVwKX4Zro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 236/348] ibmvnic: free tx_pool if tso_pool alloc fails
Date:   Mon, 12 Jul 2021 08:10:20 +0200
Message-Id: <20210712060733.601263356@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index a3d64e61035e..ecfe588f330e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -694,8 +694,11 @@ static int init_tx_pools(struct net_device *netdev)
 
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



