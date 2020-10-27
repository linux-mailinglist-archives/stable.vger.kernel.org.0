Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7E729AF8B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754157AbgJ0OLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755331AbgJ0OJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:09:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DD36218AC;
        Tue, 27 Oct 2020 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807768;
        bh=bmENid1PSUdCkmn35COXjeVESRGRhx/VJAjay8tYfUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnXdLNK3+FN5uUOwKJevmGZJ5PZ78ZRViWL7FE2osyLP8rJ0jblNZ/8flWJEzz2Ap
         9gb1lC4atBgTDwZN2AJaja529bGCBin3A/Bv3OK4sKF4akBt6f+umhBPXtxjxuUcR1
         vy7TsRNK7/fApsxxlQMUpl2GamDTxaRToruWA9L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 004/191] mlx4: handle non-napi callers to napi_poll
Date:   Tue, 27 Oct 2020 14:47:39 +0100
Message-Id: <20201027134909.929357072@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

[ Upstream commit b2b8a92733b288128feb57ffa694758cf475106c ]

netcons calls napi_poll with a budget of 0 to transmit packets.
Handle this by:
 - skipping RX processing
 - do not try to recycle TX packets to the RX cache

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c |    3 +++
 drivers/net/ethernet/mellanox/mlx4/en_tx.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -948,6 +948,9 @@ int mlx4_en_poll_rx_cq(struct napi_struc
 	bool clean_complete = true;
 	int done;
 
+	if (!budget)
+		return 0;
+
 	if (priv->tx_ring_num[TX_XDP]) {
 		xdp_tx_cq = priv->tx_cq[TX_XDP][cq->ring];
 		if (xdp_tx_cq->xdp_busy) {
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -343,7 +343,7 @@ u32 mlx4_en_recycle_tx_desc(struct mlx4_
 		.dma = tx_info->map0_dma,
 	};
 
-	if (!mlx4_en_rx_recycle(ring->recycle_ring, &frame)) {
+	if (!napi_mode || !mlx4_en_rx_recycle(ring->recycle_ring, &frame)) {
 		dma_unmap_page(priv->ddev, tx_info->map0_dma,
 			       PAGE_SIZE, priv->dma_dir);
 		put_page(tx_info->page);


