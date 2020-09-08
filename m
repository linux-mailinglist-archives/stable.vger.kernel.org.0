Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AAA261CB0
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbgIHTYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731080AbgIHQBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011C823D22;
        Tue,  8 Sep 2020 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579408;
        bh=JKzs0guyM9YvZO6uqN0KbuEC1FWIlpV2kgvpKhYr0cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYSUCF5joQWwZlF3EXGmm1DFPVqynCdCwQ08y2weKhv0eQgmSnJU2AVAJDbTeq6dV
         6BWAgzBmjM0ykDZSpUaon9Pntgrp5yXRaIhnxE9fUfU/tAIxNFafUz3g2katJbQE6U
         xJnykG+IcQKV/ufQrLI9G3RJpaSDyLF5Kl9ROA2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 065/186] net: ethernet: ti: cpsw: fix clean up of vlan mc entries for host port
Date:   Tue,  8 Sep 2020 17:23:27 +0200
Message-Id: <20200908152244.808958254@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>

[ Upstream commit 99d469fc64d06f0c81c0fe2a1c01645a67e0cbf0 ]

To flush the vid + mc entries from ALE, which is required when a VLAN
interface is removed, driver needs to call cpsw_ale_flush_multicast()
with ALE_PORT_HOST for port mask as these entries are added only for
host port. Without this, these entries remain in the ALE table even
after removing the VLAN interface. cpsw_ale_flush_multicast() calls
cpsw_ale_flush_mcast which expects a port mask to do the job.

Fixes: 15180eca569b ("net: ethernet: ti: cpsw: fix vlan mcast")
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9b17bbbe102fe..4a65edc5a3759 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1116,7 +1116,7 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
 				  HOST_PORT_NUM, ALE_VLAN, vid);
 	ret |= cpsw_ale_del_mcast(cpsw->ale, priv->ndev->broadcast,
 				  0, ALE_VLAN, vid);
-	ret |= cpsw_ale_flush_multicast(cpsw->ale, 0, vid);
+	ret |= cpsw_ale_flush_multicast(cpsw->ale, ALE_PORT_HOST, vid);
 err:
 	pm_runtime_put(cpsw->dev);
 	return ret;
-- 
2.25.1



