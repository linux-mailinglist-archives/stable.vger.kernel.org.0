Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281E73C54F7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbhGLII0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347546AbhGLH5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:57:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5838D61437;
        Mon, 12 Jul 2021 07:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076346;
        bh=AYI3tVDU7op24lNw+YTvykOKAYthXj7g98sSpSh4YQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6X0+g8GAIHmHDSh6Q7nZXV+Kybk+ZePz2a6PhjQfFzxBCg2F0wuJHIRyj33e2/aH
         fJAr+/WRAmBm7IT08zpD4tEGXexqoY7Gk/VZT5R+95ovM9jnB3qmneHuTm17UhNB+u
         zEGqPE5CyVd+IkKfHxd1SNy4PfeOW7/rga97DmWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 567/800] ibmvnic: free tx_pool if tso_pool alloc fails
Date:   Mon, 12 Jul 2021 08:09:50 +0200
Message-Id: <20210712061027.766112319@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index b8bdab0b2701..ede65b32f821 100644
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



