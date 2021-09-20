Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A478D411B19
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244812AbhITQzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245229AbhITQxi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:53:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B9C6127A;
        Mon, 20 Sep 2021 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156615;
        bh=zd0DkbpuQcpBmHy18xkWnu4PKH7ypTbTfRWtx7Uo9sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXUOvaktPeO1Xfyn5n8gE7bpnfKjYlP3T+IFB1/MsujCQZzl/Dy1wE+IG1CpugqCV
         /PYvYzufY66O/MIL96/G7PHa6Q9FGAiQOY7pGRM9R/AeXz2Kgu5dxsh+uQ6FTfmZ/9
         I5Y3Y9utASMZ9ZuyBo8PJXjW6IjJjy2bNOgVZuwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 133/133] net: renesas: sh_eth: Fix freeing wrong tx descriptor
Date:   Mon, 20 Sep 2021 18:43:31 +0200
Message-Id: <20210920163916.971064473@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
index 1942264b621b..73fc8e9683b7 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2426,6 +2426,7 @@ static int sh_eth_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	else
 		txdesc->status |= cpu_to_edmac(mdp, TD_TACT);
 
+	wmb(); /* cur_tx must be incremented after TACT bit was set */
 	mdp->cur_tx++;
 
 	if (!(sh_eth_read(ndev, EDTRR) & sh_eth_get_edtrr_trns(mdp)))
-- 
2.30.2



