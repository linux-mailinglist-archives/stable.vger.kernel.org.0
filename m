Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611103A0C48
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 08:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhFIGU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 02:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhFIGU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 02:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29F6E6101A;
        Wed,  9 Jun 2021 06:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623219542;
        bh=ts8xmqJk/pwHSYmRZhFquxYo/UmYjLxgRf8jkeUmvFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juW1uIzphE/HLsxUx9qIJJvde/kBAY4i7huz33wahz0qL5OcEsvprb3hmJmze6Cjw
         vJ1npLy5jxEIOX4HGwgkM68BRfnZThpJQ0xEi/jsMlWpPOJHfGQgiiFA3EYkV0k80H
         aXkYrMGjYOXlpbx4qzFUAFhF1C30ABAhOR4XFSPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Walker, Benjamin" <benjamin.walker@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/137] nvme-rdma: fix in-casule data send for chained sgls
Date:   Tue,  8 Jun 2021 20:26:02 +0200
Message-Id: <20210608175943.167114424@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 12b2aaadb6d5ef77434e8db21f469f46fe2d392e ]

We have only 2 inline sg entries and we allow 4 sg entries for the send
wr sge. Larger sgls entries will be chained. However when we build
in-capsule send wr sge, we iterate without taking into account that the
sgl may be chained and still fit in-capsule (which can happen if the sgl
is bigger than 2, but lower-equal to 4).

Fix in-capsule data mapping to correctly iterate chained sgls.

Fixes: 38e1800275d3 ("nvme-rdma: Avoid preallocating big SGL for data")
Reported-by: Walker, Benjamin <benjamin.walker@intel.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 8b326508a480..e6d58402b829 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1327,16 +1327,17 @@ static int nvme_rdma_map_sg_inline(struct nvme_rdma_queue *queue,
 		int count)
 {
 	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
-	struct scatterlist *sgl = req->data_sgl.sg_table.sgl;
 	struct ib_sge *sge = &req->sge[1];
+	struct scatterlist *sgl;
 	u32 len = 0;
 	int i;
 
-	for (i = 0; i < count; i++, sgl++, sge++) {
+	for_each_sg(req->data_sgl.sg_table.sgl, sgl, count, i) {
 		sge->addr = sg_dma_address(sgl);
 		sge->length = sg_dma_len(sgl);
 		sge->lkey = queue->device->pd->local_dma_lkey;
 		len += sge->length;
+		sge++;
 	}
 
 	sg->addr = cpu_to_le64(queue->ctrl->ctrl.icdoff);
-- 
2.30.2



