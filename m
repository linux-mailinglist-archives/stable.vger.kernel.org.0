Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353354124B9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381269AbhITShJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:37:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380886AbhITSfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95A161AAA;
        Mon, 20 Sep 2021 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158931;
        bh=8TqArL+z2lYrdkY/JU0A2XqwBC+e8fr5C/fpXsiGA+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lSqnsQUHI7H8lKXLINNi6E1S4YSVAksaeL/6pb9JTtxMX3+q3CSAabafci+dHCs0f
         mOhqSqhnEM07XagA6aAZlHOSQCySTLc/LEPyIf1wJsmpjKCsN1qQmtreirLBqD+w68
         q4C9N16hNIhPGs8csH3O39XnP8/cEgLRHtWqQIVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/122] net: renesas: sh_eth: Fix freeing wrong tx descriptor
Date:   Mon, 20 Sep 2021 18:44:53 +0200
Message-Id: <20210920163919.779174316@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
index 5cab2d3c0023..8927d5997745 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2533,6 +2533,7 @@ static netdev_tx_t sh_eth_start_xmit(struct sk_buff *skb,
 	else
 		txdesc->status |= cpu_to_le32(TD_TACT);
 
+	wmb(); /* cur_tx must be incremented after TACT bit was set */
 	mdp->cur_tx++;
 
 	if (!(sh_eth_read(ndev, EDTRR) & mdp->cd->edtrr_trns))
-- 
2.30.2



