Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429853962C9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhEaPBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234378AbhEaO7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C9BA61CCC;
        Mon, 31 May 2021 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469670;
        bh=dFUbBvP5pl2BpwYoRPE2ylkjeFaa8S6PoyjTVnwVUzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxpXBbjGymMAmB/x7BHPyJjNJln2iiSvpbpK4azocPk1TRyY9sApKQ/xLuDMEav/Z
         P1b5jyFR323RxDKIaTW6ObGAJPF3GGTQbg/PTFxnSYNu8+d1GmuMzpQXh39WvoBuYF
         zlabUq0kvIm+QQI2gWYfmRlNBUAULH2tRJ3r+qMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 251/296] gve: Check TX QPL was actually assigned
Date:   Mon, 31 May 2021 15:15:06 +0200
Message-Id: <20210531130712.202729601@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
 drivers/net/ethernet/google/gve/gve_tx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 6938f3a939d6..bb57c42872b4 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -212,10 +212,11 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 	tx->dev = &priv->pdev->dev;
 	if (!tx->raw_addressing) {
 		tx->tx_fifo.qpl = gve_assign_tx_qpl(priv);
-
+		if (!tx->tx_fifo.qpl)
+			goto abort_with_desc;
 		/* map Tx FIFO */
 		if (gve_tx_fifo_init(priv, &tx->tx_fifo))
-			goto abort_with_desc;
+			goto abort_with_qpl;
 	}
 
 	tx->q_resources =
@@ -236,6 +237,9 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 abort_with_fifo:
 	if (!tx->raw_addressing)
 		gve_tx_fifo_release(priv, &tx->tx_fifo);
+abort_with_qpl:
+	if (!tx->raw_addressing)
+		gve_unassign_qpl(priv, tx->tx_fifo.qpl->id);
 abort_with_desc:
 	dma_free_coherent(hdev, bytes, tx->desc, tx->bus);
 	tx->desc = NULL;
-- 
2.30.2



