Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696FB11D4F
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfEBP3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727637AbfEBP3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:29:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD43021734;
        Thu,  2 May 2019 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810948;
        bh=Y4XNUNO9m72VC4aWc7ww6A/+NV1nbcXL9btbHA7Dzec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXg7bq2griqvieN+/iKiZlv3+trAAmuWXzNi4NWLclJo9Ce5WuLXabjcChDP7JAve
         dvIElUaTz5rjmX4rTz9Xh8ExWK2tcfched+65O0awEJQnK6ODLOAGUiQW37kbcua6g
         uFQkVjxDQhhPTjchhe4ZK0q8fGgzrTR9/kG8XbLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 018/101] net: stmmac: fix jumbo frame sending with non-linear skbs
Date:   Thu,  2 May 2019 17:20:20 +0200
Message-Id: <20190502143341.207733001@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 58f2ce6f61615dfd8dd3cc01c9e5bb54ed35637e ]

When sending non-linear skbs with jumbo frames, we set up the non-paged
data and mark that as a last segment, although the paged fragments are
also prepared. This will stall the TX queue and trigger a watchdog warning
(a simple reproducer is to run an iperf client mode TCP test with a large
MTU - networking fails instantly).

Fix by checking if the skb is non-linear.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Acked-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
index afed0f0f4027..4d9bcb4d0378 100644
--- a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
@@ -79,7 +79,8 @@ static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
 
 		desc->des3 = cpu_to_le32(des2 + BUF_SIZE_4KiB);
 		stmmac_prepare_tx_desc(priv, desc, 0, len, csum,
-				STMMAC_RING_MODE, 1, true, skb->len);
+				STMMAC_RING_MODE, 1, !skb_is_nonlinear(skb),
+				skb->len);
 	} else {
 		des2 = dma_map_single(priv->device, skb->data,
 				      nopaged_len, DMA_TO_DEVICE);
@@ -91,7 +92,8 @@ static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
 		tx_q->tx_skbuff_dma[entry].is_jumbo = true;
 		desc->des3 = cpu_to_le32(des2 + BUF_SIZE_4KiB);
 		stmmac_prepare_tx_desc(priv, desc, 1, nopaged_len, csum,
-				STMMAC_RING_MODE, 0, true, skb->len);
+				STMMAC_RING_MODE, 0, !skb_is_nonlinear(skb),
+				skb->len);
 	}
 
 	tx_q->cur_tx = entry;
-- 
2.19.1



