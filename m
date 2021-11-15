Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CB94513F6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348802AbhKOUAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:00:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344169AbhKOTX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8278633C3;
        Mon, 15 Nov 2021 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002393;
        bh=DvTgWKyAVQF6pzzs+AFCnrupLILFjdZiSm+T4eRkDX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+Pi8/X+3Tk+IJhaYEkE01dbYcIYSPf2iMoHi/T1/t4I24VRPJVk4UsQaClVLUYro
         a7Lw8cBxlOYJMh65ed3FkVdvF1jyLOzL9PaJYCtmzsvvDt6m2l7qJDAxdvXXyL6I3a
         sKs/mjzp+Te//RHYbyf7soDl34LrovaJlHrWYNzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 549/917] nfp: fix potential deadlock when canceling dim work
Date:   Mon, 15 Nov 2021 18:00:44 +0100
Message-Id: <20211115165447.402050472@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

[ Upstream commit 17e712c6a1bade9dac02a7bf2b464746faa7e9a0 ]

When port is linked down, the process which has acquired rtnl_lock
will wait for the in-progress dim work to finish, and the work also
acquires rtnl_lock, which may cause deadlock.

Currently IRQ_MOD registers can be configured by `ethtool -C` and
dim work, and which will take effect depends on the execution order,
rtnl_lock is useless here, so remove them.

Fixes: 9d32e4e7e9e1 ("nfp: add support for coalesce adaptive feature")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index f8b880c8e5148..850bfdf83d0a4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3016,10 +3016,8 @@ static void nfp_net_rx_dim_work(struct work_struct *work)
 
 	/* copy RX interrupt coalesce parameters */
 	value = (moder.pkts << 16) | (factor * moder.usec);
-	rtnl_lock();
 	nn_writel(nn, NFP_NET_CFG_RXR_IRQ_MOD(r_vec->rx_ring->idx), value);
 	(void)nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_IRQMOD);
-	rtnl_unlock();
 
 	dim->state = DIM_START_MEASURE;
 }
@@ -3047,10 +3045,8 @@ static void nfp_net_tx_dim_work(struct work_struct *work)
 
 	/* copy TX interrupt coalesce parameters */
 	value = (moder.pkts << 16) | (factor * moder.usec);
-	rtnl_lock();
 	nn_writel(nn, NFP_NET_CFG_TXR_IRQ_MOD(r_vec->tx_ring->idx), value);
 	(void)nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_IRQMOD);
-	rtnl_unlock();
 
 	dim->state = DIM_START_MEASURE;
 }
-- 
2.33.0



