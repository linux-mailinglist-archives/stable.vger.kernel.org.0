Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154742A38C7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgKCBVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:21:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbgKCBVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:21:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42F66223EA;
        Tue,  3 Nov 2020 01:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366477;
        bh=DGZTENDzbp6mxPh1IGC1gwlNV6twzpG0WabrC4IU5Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teCRVt8qkVzIPjybEg+A7o6ONC4mks6sRJ3IixE10OSSghwn8wumlbExftAFQzY86
         OiTrHDLPjv9nE9lQBScyRibdqKnGohYRsMWP9QTQsCdDHZZufO0PO5YtG4mE+UPOaR
         Km1UX0VY7kyBfhf7fqu22t2KwgxTzqbN3d650CXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhenwei pi <pizhenwei@bytedance.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 6/7] nvme-rdma: handle unexpected nvme completion data length
Date:   Mon,  2 Nov 2020 20:21:07 -0500
Message-Id: <20201103012108.183942-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012108.183942-1-sashal@kernel.org>
References: <20201103012108.183942-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhenwei pi <pizhenwei@bytedance.com>

[ Upstream commit 25c1ca6ecaba3b751d3f7ff92d5cddff3b05f8d0 ]

Receiving a zero length message leads to the following warnings because
the CQE is processed twice:

refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 0 at lib/refcount.c:28

RIP: 0010:refcount_warn_saturate+0xd9/0xe0
Call Trace:
 <IRQ>
 nvme_rdma_recv_done+0xf3/0x280 [nvme_rdma]
 __ib_process_cq+0x76/0x150 [ib_core]
 ...

Sanity check the received data length, to avoids this.

Thanks to Chao Leng & Sagi for suggestions.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ab4f8db2a8cac..5c1245bbf9a1d 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1199,6 +1199,14 @@ static int __nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc, int tag)
 		return 0;
 	}
 
+	/* sanity checking for received data length */
+	if (unlikely(wc->byte_len < len)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"Unexpected nvme completion length(%d)\n", wc->byte_len);
+		nvme_rdma_error_recovery(queue->ctrl);
+		return;
+	}
+
 	ib_dma_sync_single_for_cpu(ibdev, qe->dma, len, DMA_FROM_DEVICE);
 	/*
 	 * AEN requests are special as they don't time out and can
-- 
2.27.0

