Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E2723A444
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgHCMZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgHCMZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C738D204EC;
        Mon,  3 Aug 2020 12:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457516;
        bh=Q/6h68lCkWJwD+if01Y84y2vBS2h14vSLslRM3wq/sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1y+xD96KWxDN5NETFG8SK8L0y2+Da0KDDHM43C1Ge2WTJ8rDCdPIvU9OjENZzoV57
         tnOiLIgqrVMhUNdoYwfayNaL2zv24XOBIff3QOshwqKdKvBzTYrq3sRXogtMyb7a/N
         qtxLeV7JVoh1NiI/1PyiVhd9tb4V3BOOO9tq+ABc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 066/120] octeontx2-pf: Fix reset_task bugs
Date:   Mon,  3 Aug 2020 14:18:44 +0200
Message-Id: <20200803121906.020753689@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 948a66338f44c16f52c0f03f6ad81a6f59eb5604 ]

Two bugs exist in the code related to reset_task
in PF driver one is the missing protection
against network stack ndo_open and ndo_close.
Other one is the missing cancel_work.
This patch fixes those problems.

Fixes: 4ff7d1488a84 ("octeontx2-pf: Error handling support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 64786568af0db..75a8c407e815c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1730,10 +1730,12 @@ static void otx2_reset_task(struct work_struct *work)
 	if (!netif_running(pf->netdev))
 		return;
 
+	rtnl_lock();
 	otx2_stop(pf->netdev);
 	pf->reset_count++;
 	otx2_open(pf->netdev);
 	netif_trans_update(pf->netdev);
+	rtnl_unlock();
 }
 
 static const struct net_device_ops otx2_netdev_ops = {
@@ -2111,6 +2113,7 @@ static void otx2_remove(struct pci_dev *pdev)
 
 	pf = netdev_priv(netdev);
 
+	cancel_work_sync(&pf->reset_task);
 	/* Disable link notifications */
 	otx2_cgx_config_linkevents(pf, false);
 
-- 
2.25.1



