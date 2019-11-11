Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874A3F7F3C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbfKKSeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbfKKSeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:34:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12BA421655;
        Mon, 11 Nov 2019 18:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497261;
        bh=EQQrDM4SDoY+LFlYDSrXnqCfNeEYCk61TU+DLzuUP48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gb+pyIMf0xQZohONvRY6+Q1HiDF7wInyS7vl5MMbM4N1KFqD30C/V6Y9tJGdkZ1iq
         HefA4qKx5YVSrUDpiTeb+3ztdDP6ipYABUzm5liGnAKkk7rO67IHfGjNwoG0CUXooP
         rcivW2Sd6tywkBb7+tHJgS2+FDnZVCv5YDI0u2uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 59/65] e1000: fix memory leaks
Date:   Mon, 11 Nov 2019 19:28:59 +0100
Message-Id: <20191111181355.181472836@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 8472ba62154058b64ebb83d5f57259a352d28697 ]

In e1000_set_ringparam(), 'tx_old' and 'rx_old' are not deallocated if
e1000_up() fails, leading to memory leaks. Refactor the code to fix this
issue.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 2a81f6d721404..8936f19e9325f 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -628,6 +628,7 @@ static int e1000_set_ringparam(struct net_device *netdev,
 	for (i = 0; i < adapter->num_rx_queues; i++)
 		rxdr[i].count = rxdr->count;
 
+	err = 0;
 	if (netif_running(adapter->netdev)) {
 		/* Try to get new resources before deleting old */
 		err = e1000_setup_all_rx_resources(adapter);
@@ -648,14 +649,13 @@ static int e1000_set_ringparam(struct net_device *netdev,
 		adapter->rx_ring = rxdr;
 		adapter->tx_ring = txdr;
 		err = e1000_up(adapter);
-		if (err)
-			goto err_setup;
 	}
 	kfree(tx_old);
 	kfree(rx_old);
 
 	clear_bit(__E1000_RESETTING, &adapter->flags);
-	return 0;
+	return err;
+
 err_setup_tx:
 	e1000_free_all_rx_resources(adapter);
 err_setup_rx:
@@ -667,7 +667,6 @@ err_alloc_rx:
 err_alloc_tx:
 	if (netif_running(adapter->netdev))
 		e1000_up(adapter);
-err_setup:
 	clear_bit(__E1000_RESETTING, &adapter->flags);
 	return err;
 }
-- 
2.20.1



