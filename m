Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D595524B524
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbgHTKTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731309AbgHTKRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:17:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B9B2067C;
        Thu, 20 Aug 2020 10:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918657;
        bh=lmIsvYU/A3zU0Wj4Gfl5Fb/bHZfLG7fczTimL1Pejz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVcKwBcHkkYJOblnyJxmnARNn1i2IfxmdqrA+ptijM1hSUpBwoFgFTueZDB6b2RRX
         0GH5lgBTRTKTnr/BKs317fymF8JOO2HVnAKv2F1XmPj+le1RNXvKMpl3g6mKytSU1J
         9L10pGJ5TO6Obx8qUDSH7Gzv5w1F6LPrkpQlARfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 020/149] mlxsw: core: Increase scope of RCU read-side critical section
Date:   Thu, 20 Aug 2020 11:21:37 +0200
Message-Id: <20200820092126.685237164@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 7d8e8f3433dc8d1dc87c1aabe73a154978fb4c4d ]

The lifetime of the Rx listener item ('rxl_item') is managed using RCU,
but is dereferenced outside of RCU read-side critical section, which can
lead to a use-after-free.

Fix this by increasing the scope of the RCU read-side critical section.

Fixes: 93c1edb27f9e ("mlxsw: Introduce Mellanox switch driver core")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 97f0d93caf994..085aaad902937 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1208,9 +1208,10 @@ void mlxsw_core_skb_receive(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 			break;
 		}
 	}
-	rcu_read_unlock();
-	if (!found)
+	if (!found) {
+		rcu_read_unlock();
 		goto drop;
+	}
 
 	pcpu_stats = this_cpu_ptr(mlxsw_core->pcpu_stats);
 	u64_stats_update_begin(&pcpu_stats->syncp);
@@ -1221,6 +1222,7 @@ void mlxsw_core_skb_receive(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 	u64_stats_update_end(&pcpu_stats->syncp);
 
 	rxl->func(skb, local_port, rxl_item->priv);
+	rcu_read_unlock();
 	return;
 
 drop:
-- 
2.25.1



