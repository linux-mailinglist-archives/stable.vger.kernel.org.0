Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC520DC51
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgF2UOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732843AbgF2TaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C684325319;
        Mon, 29 Jun 2020 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445149;
        bh=RNFCywLeG2tTMDAMM4IX7PTB/3LNjo9WHsXRCrjI2Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZ3Fv0B2X3thF4+LKGB1WpXkO4eLjiyNqtFV2+rW2ocelxOqFrokvemTOJHgxufqM
         qQQooDFZm3Dwg0+Fka9BFL7ZdwhZY/DwO5kDuBsF/cULz+CBBSRvuLfa3hFjYUL5P0
         Y1HMr55tDFm8SXjj42X5s7Op5Wd3uee4aKNCwflI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 52/78] net: bcmgenet: use hardware padding of runt frames
Date:   Mon, 29 Jun 2020 11:37:40 -0400
Message-Id: <20200629153806.2494953-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 20d1f2d1b024f6be199a3bedf1578a1d21592bc5 ]

When commit 474ea9cafc45 ("net: bcmgenet: correctly pad short
packets") added the call to skb_padto() it should have been
located before the nr_frags parameter was read since that value
could be changed when padding packets with lengths between 55
and 59 bytes (inclusive).

The use of a stale nr_frags value can cause corruption of the
pad data when tx-scatter-gather is enabled. This corruption of
the pad can cause invalid checksum computation when hardware
offload of tx-checksum is also enabled.

Since the original reason for the padding was corrected by
commit 7dd399130efb ("net: bcmgenet: fix skb_len in
bcmgenet_xmit_single()") we can remove the software padding all
together and make use of hardware padding of short frames as
long as the hardware also always appends the FCS value to the
frame.

Fixes: 474ea9cafc45 ("net: bcmgenet: correctly pad short packets")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 7d3cbbd88a005..8bfa2523e2533 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1567,11 +1567,6 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto out;
 	}
 
-	if (skb_padto(skb, ETH_ZLEN)) {
-		ret = NETDEV_TX_OK;
-		goto out;
-	}
-
 	/* Retain how many bytes will be sent on the wire, without TSB inserted
 	 * by transmit checksum offload
 	 */
@@ -1621,6 +1616,9 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 		len_stat = (size << DMA_BUFLENGTH_SHIFT) |
 			   (priv->hw_params->qtag_mask << DMA_TX_QTAG_SHIFT);
 
+		/* Note: if we ever change from DMA_TX_APPEND_CRC below we
+		 * will need to restore software padding of "runt" packets
+		 */
 		if (!i) {
 			len_stat |= DMA_TX_APPEND_CRC | DMA_SOP;
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
-- 
2.25.1

