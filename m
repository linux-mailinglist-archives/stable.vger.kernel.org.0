Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E75520E59C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgF2Vj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgF2Skb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2490723EB3;
        Mon, 29 Jun 2020 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443903;
        bh=um6uLRaw7yzcdv0KweyEdePc+kM+tlhpRsre8nvAxfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StE01DfEwuezSkCyM+WBoPb8p49jAzhDrlKsA4lBrY9SWyjmYkUud6LjZUbsKKMmX
         DZj2oTIYWKja66YdaWEgi16vCThIfvrl6V0Et1iVA1/hwX30b0AWACeC19wdlBFzDM
         aNKalFb9guHkqtWZz8mjIba+r//5iLVcpNhg3P7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 003/265] enetc: Fix tx rings bitmap iteration range, irq handling
Date:   Mon, 29 Jun 2020 11:13:56 -0400
Message-Id: <20200629151818.2493727-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index ccf2611f4a203..4486a0db8ef0c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -266,7 +266,7 @@ static irqreturn_t enetc_msix(int irq, void *data)
 	/* disable interrupts */
 	enetc_wr_reg(v->rbier, 0);
 
-	for_each_set_bit(i, &v->tx_rings_map, v->count_tx_rings)
+	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
 		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i), 0);
 
 	napi_schedule_irqoff(&v->napi);
@@ -302,7 +302,7 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	/* enable interrupts */
 	enetc_wr_reg(v->rbier, ENETC_RBIER_RXTIE);
 
-	for_each_set_bit(i, &v->tx_rings_map, v->count_tx_rings)
+	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
 		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i),
 			     ENETC_TBIER_TXTIE);
 
-- 
2.25.1

