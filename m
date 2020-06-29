Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54320D9F2
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731945AbgF2TwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387711AbgF2Tka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7985424800;
        Mon, 29 Jun 2020 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444328;
        bh=TY+OzDIfjSGqQuHfrjy5eBvrcMpU/vCz/7fbYEldFgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aO+lpBukTh11QsHDBkQm/mdhQyuPbIvKKikXdcGPWZNjdGay/IE6cj7vQy98QKJZE
         l5kTmN/AukK/RlLpDDpdPJtlqiu+MhqPk4m1Zd4ew9GL/UR3Pjo3lx/1JnSzoyFVSJ
         f7QKYEt2nCq0vQGCC+pynoDXktdCP5YglyeQ4lmg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 002/178] enetc: Fix tx rings bitmap iteration range, irq handling
Date:   Mon, 29 Jun 2020 11:22:27 -0400
Message-Id: <20200629152523.2494198-3-sashal@kernel.org>
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

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 0574e2000fc3103cbc69ba82ec1175ce171fdf5e ]

The rings bitmap of an interrupt vector encodes
which of the device's rings were assigned to that
interrupt vector.
Hence the iteration range of the tx rings bitmap
(for_each_set_bit()) should be the total number of
Tx rings of that netdevice instead of the number of
rings assigned to the interrupt vector.
Since there are 2 cores, and one interrupt vector for
each core, the number of rings asigned to an interrupt
vector is half the number of available rings.
The impact of this error is that the upper half of the
tx rings could still generate interrupts during napi
polling.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index b6ff893074092..4ef4d41b0d8d6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -254,7 +254,7 @@ static irqreturn_t enetc_msix(int irq, void *data)
 	/* disable interrupts */
 	enetc_wr_reg(v->rbier, 0);
 
-	for_each_set_bit(i, &v->tx_rings_map, v->count_tx_rings)
+	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
 		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i), 0);
 
 	napi_schedule_irqoff(&v->napi);
@@ -290,7 +290,7 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	/* enable interrupts */
 	enetc_wr_reg(v->rbier, ENETC_RBIER_RXTIE);
 
-	for_each_set_bit(i, &v->tx_rings_map, v->count_tx_rings)
+	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
 		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i),
 			     ENETC_TBIER_TXTIE);
 
-- 
2.25.1

