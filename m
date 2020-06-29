Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0524820D92B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732748AbgF2TpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387825AbgF2Tkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420DE24810;
        Mon, 29 Jun 2020 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444331;
        bh=kfz40U3GJTPN7qzf2x608CXIypAWHOkTtsPZiquQHbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atjNXCt1hCw73NbxiZLLgFIhTA2FIOaG8sREqSJZgRKuTI2WY7YxOmTm65vcz1gBw
         OVF10ftOeEouYWqPXbAJGXtUA1ND0hzyfqEFs2MsHT9Gv/0ja5JZnx2+W/u4kNhPPF
         NanFqGGtd+CC6COfF8UelmZLGwO/eiXGNHC6qGIE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 006/178] mvpp2: ethtool rxtx stats fix
Date:   Mon, 29 Jun 2020 11:22:31 -0400
Message-Id: <20200629152523.2494198-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit cc970925feb9a38c2f0d34305518e00a3084ce85 ]

The ethtool rx and tx queue statistics are reporting wrong values.
Fix reading out the correct ones.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index cf5d447af7db2..0f136f1af5d14 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1541,7 +1541,7 @@ static void mvpp2_read_stats(struct mvpp2_port *port)
 	for (q = 0; q < port->ntxqs; q++)
 		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_txq_regs); i++)
 			*pstats++ += mvpp2_read_index(port->priv,
-						      MVPP22_CTRS_TX_CTR(port->id, i),
+						      MVPP22_CTRS_TX_CTR(port->id, q),
 						      mvpp2_ethtool_txq_regs[i].offset);
 
 	/* Rxqs are numbered from 0 from the user standpoint, but not from the
@@ -1550,7 +1550,7 @@ static void mvpp2_read_stats(struct mvpp2_port *port)
 	for (q = 0; q < port->nrxqs; q++)
 		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_rxq_regs); i++)
 			*pstats++ += mvpp2_read_index(port->priv,
-						      port->first_rxq + i,
+						      port->first_rxq + q,
 						      mvpp2_ethtool_rxq_regs[i].offset);
 }
 
-- 
2.25.1

