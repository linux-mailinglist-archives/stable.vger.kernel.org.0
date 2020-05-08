Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F931CABD7
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgEHMrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729550AbgEHMrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F8921473;
        Fri,  8 May 2020 12:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942051;
        bh=SCLdLovrLVRUd93rAlaRm+4XPG7UJBYmcHAxAVBWmBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSFGQI0AbJ3AwD0xAhrsICqS7daKdfv0uvufer5AC4XUFnqkN9uYUx+MNJ2G12rMx
         VS3hk5pYj7/qtKZ2LE5Z+ucx48WB1ispCL7KmiBhN3xD7GiB/GA2EMTllLbU4obOLs
         DqZ9SCgvtspZWCQxM3k6mYs2HZAh7oLXdF/qE9HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 237/312] mlx4: do not call napi_schedule() without care
Date:   Fri,  8 May 2020 14:33:48 +0200
Message-Id: <20200508123141.092527537@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 8cf699ec849f4ca1413cea01289bd7d37dbcc626 upstream.

Disable BH around the call to napi_schedule() to avoid following warning

[   52.095499] NOHZ: local_softirq_pending 08
[   52.421291] NOHZ: local_softirq_pending 08
[   52.608313] NOHZ: local_softirq_pending 08

Fixes: 8d59de8f7bb3 ("net/mlx4_en: Process all completions in RX rings after port goes up")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Erez Shitrit <erezsh@mellanox.com>
Cc: Eugenia Emantayev <eugenia@mellanox.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1724,8 +1724,11 @@ int mlx4_en_start_port(struct net_device
 	/* Process all completions if exist to prevent
 	 * the queues freezing if they are full
 	 */
-	for (i = 0; i < priv->rx_ring_num; i++)
+	for (i = 0; i < priv->rx_ring_num; i++) {
+		local_bh_disable();
 		napi_schedule(&priv->rx_cq[i]->napi);
+		local_bh_enable();
+	}
 
 	netif_tx_start_all_queues(dev);
 	netif_device_attach(dev);


