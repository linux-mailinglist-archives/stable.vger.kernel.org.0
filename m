Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F1538EEE0
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhEXPzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234088AbhEXPyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63CC36191A;
        Mon, 24 May 2021 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870768;
        bh=1dAMraQ5B+FymVoCYVg+XAajTuiOTDxvtot00gCCi/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAy+Iz+XJYKwsYW1L4UYXX57Au7xPaInbM8b8Ua5Sz0rQT2EBcqG+6Dga42sKo7q7
         JY0+fPODaF7vjHnAv8nrf/BTbxwHLY3qblP5dfKFYAEmH/QcixvBxN7dVRBH3ABZVR
         Q7s6AV/CzwFbuYCPZHSMTXGph9VryIKvufElxYSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liming Sun <limings@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/104] platform/mellanox: mlxbf-tmfifo: Fix a memory barrier issue
Date:   Mon, 24 May 2021 17:25:13 +0200
Message-Id: <20210524152333.427472665@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liming Sun <limings@nvidia.com>

[ Upstream commit 1c0e5701c5e792c090aef0e5b9b8923c334d9324 ]

The virtio framework uses wmb() when updating avail->idx. It
guarantees the write order, but not necessarily loading order
for the code accessing the memory. This commit adds a load barrier
after reading the avail->idx to make sure all the data in the
descriptor is visible. It also adds a barrier when returning the
packet to virtio framework to make sure read/writes are visible to
the virtio code.

Fixes: 1357dfd7261f ("platform/mellanox: Add TmFifo driver for Mellanox BlueField Soc")
Signed-off-by: Liming Sun <limings@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/1620433812-17911-1-git-send-email-limings@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-tmfifo.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index bbc4e71a16ff..38800e86ed8a 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -294,6 +294,9 @@ mlxbf_tmfifo_get_next_desc(struct mlxbf_tmfifo_vring *vring)
 	if (vring->next_avail == virtio16_to_cpu(vdev, vr->avail->idx))
 		return NULL;
 
+	/* Make sure 'avail->idx' is visible already. */
+	virtio_rmb(false);
+
 	idx = vring->next_avail % vr->num;
 	head = virtio16_to_cpu(vdev, vr->avail->ring[idx]);
 	if (WARN_ON(head >= vr->num))
@@ -322,7 +325,7 @@ static void mlxbf_tmfifo_release_desc(struct mlxbf_tmfifo_vring *vring,
 	 * done or not. Add a memory barrier here to make sure the update above
 	 * completes before updating the idx.
 	 */
-	mb();
+	virtio_mb(false);
 	vr->used->idx = cpu_to_virtio16(vdev, vr_idx + 1);
 }
 
@@ -733,6 +736,12 @@ static bool mlxbf_tmfifo_rxtx_one_desc(struct mlxbf_tmfifo_vring *vring,
 		desc = NULL;
 		fifo->vring[is_rx] = NULL;
 
+		/*
+		 * Make sure the load/store are in order before
+		 * returning back to virtio.
+		 */
+		virtio_mb(false);
+
 		/* Notify upper layer that packet is done. */
 		spin_lock_irqsave(&fifo->spin_lock[is_rx], flags);
 		vring_interrupt(0, vring->vq);
-- 
2.30.2



