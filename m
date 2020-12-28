Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA572E3DFE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502674AbgL1OWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502668AbgL1OWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E0B322B2C;
        Mon, 28 Dec 2020 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165310;
        bh=+b53wZI83On3aGmgbPMhWqXugTD39OtO0fF5cNEUbHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vc7epCMYW0uUesdzsujixAw6sw6lDYCD+5n1EMywV8H88hG5ZSYBnxOPKvqieuApb
         w+aV1tsyYAt16jkai7peinrvrap8EXmtOLuku1ms8XiymXLIUMyclNbVOBSWuAPfCN
         kTpR+txqMroIGcHDwG9/nfrwBxDJIQTIB4veeX5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 488/717] vdpa/mlx5: Use write memory barrier after updating CQ index
Date:   Mon, 28 Dec 2020 13:48:06 +0100
Message-Id: <20201228125044.344626701@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 83ef73b27eb2363f44faf9c3ee28a3fe752cfd15 ]

Make sure to put dma write memory barrier after updating CQ consumer
index so the hardware knows that there are available CQE slots in the
queue.

Failure to do this can cause the update of the RX doorbell record to get
updated before the CQ consumer index resulting in CQ overrun.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20201209140004.15892-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 1fa6fcac82992..81b932f72e103 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -464,6 +464,11 @@ static int mlx5_vdpa_poll_one(struct mlx5_vdpa_cq *vcq)
 static void mlx5_vdpa_handle_completions(struct mlx5_vdpa_virtqueue *mvq, int num)
 {
 	mlx5_cq_set_ci(&mvq->cq.mcq);
+
+	/* make sure CQ cosumer update is visible to the hardware before updating
+	 * RX doorbell record.
+	 */
+	dma_wmb();
 	rx_post(&mvq->vqqp, num);
 	if (mvq->event_cb.callback)
 		mvq->event_cb.callback(mvq->event_cb.private);
-- 
2.27.0



