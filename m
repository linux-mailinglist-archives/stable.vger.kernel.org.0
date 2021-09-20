Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD52412384
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348245AbhITSZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378120AbhITSW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C08FE632C7;
        Mon, 20 Sep 2021 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158680;
        bh=poPWJcpSkpTLbEYw/N+6U80JvAPvY99qxB/d7h2wsnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izel8e0/AcbCPOlu2Pm6ju4s796EDoCR/VHCpEVhjeTAw1a3t8NzjexcBdFhTAGiW
         J2NWgP/4oT0W6PjsvEWG2QmoGg/7/Jw8vZ+S7WLAO+exoTw1clat48aPq6vayX4q0B
         hpg4XagyK25Fz5C3kM9/pUyM8igcjcRMVV35mdEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 260/260] net: renesas: sh_eth: Fix freeing wrong tx descriptor
Date:   Mon, 20 Sep 2021 18:44:38 +0200
Message-Id: <20210920163939.942082775@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 0341d5e3d1ee2a36dd5a49b5bef2ce4ad1cfa6b4 ]

The cur_tx counter must be incremented after TACT bit of
txdesc->status was set. However, a CPU is possible to reorder
instructions and/or memory accesses between cur_tx and
txdesc->status. And then, if TX interrupt happened at such a
timing, the sh_eth_tx_free() may free the descriptor wrongly.
So, add wmb() before cur_tx++.
Otherwise NETDEV WATCHDOG timeout is possible to happen.

Fixes: 86a74ff21a7a ("net: sh_eth: add support for Renesas SuperH Ethernet")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 931a44fe7afe..50d85d037230 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2567,6 +2567,7 @@ static int sh_eth_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	else
 		txdesc->status |= cpu_to_le32(TD_TACT);
 
+	wmb(); /* cur_tx must be incremented after TACT bit was set */
 	mdp->cur_tx++;
 
 	if (!(sh_eth_read(ndev, EDTRR) & mdp->cd->edtrr_trns))
-- 
2.30.2



