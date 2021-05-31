Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5E2395F4A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhEaOJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233298AbhEaOHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:07:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DD586195D;
        Mon, 31 May 2021 13:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468367;
        bh=lVmYbOfXRPQDI0BHM560+nSRPOfXdZPEgZZTm6SwwjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbC0wxhSc6amVD9ZSPXr5CKqHlDY6DX4vsfDnGarwT8EFYtU3Ur94ufSz42hiFhOG
         ONXcfV4S1wm/7B98v1KPDk3SG6r123PVeMgwJJwO1YFsnq+KezfgxrLzzClEXPH9dr
         2FqY77Ym6YCsyTWVYp9pLkF1Q4ueXKhYRR0tKYwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/252] gve: Check TX QPL was actually assigned
Date:   Mon, 31 May 2021 15:14:41 +0200
Message-Id: <20210531130705.357113930@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

[ Upstream commit 5aec55b46c6238506cdf0c60cd0e42ab77a1e5e0 ]

Correctly check the TX QPL was assigned and unassigned if
other steps in the allocation fail.

Fixes: f5cedc84a30d (gve: Add transmit and receive support)
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index d0244feb0301..30532ee28dd3 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -207,10 +207,12 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 		goto abort_with_info;
 
 	tx->tx_fifo.qpl = gve_assign_tx_qpl(priv);
+	if (!tx->tx_fifo.qpl)
+		goto abort_with_desc;
 
 	/* map Tx FIFO */
 	if (gve_tx_fifo_init(priv, &tx->tx_fifo))
-		goto abort_with_desc;
+		goto abort_with_qpl;
 
 	tx->q_resources =
 		dma_alloc_coherent(hdev,
@@ -229,6 +231,8 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 
 abort_with_fifo:
 	gve_tx_fifo_release(priv, &tx->tx_fifo);
+abort_with_qpl:
+	gve_unassign_qpl(priv, tx->tx_fifo.qpl->id);
 abort_with_desc:
 	dma_free_coherent(hdev, bytes, tx->desc, tx->bus);
 	tx->desc = NULL;
-- 
2.30.2



