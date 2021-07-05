Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFCB3BBFFB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhGEPeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232764AbhGEPdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CA6A619C4;
        Mon,  5 Jul 2021 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499033;
        bh=P1wCF5MjMasoUsUhzJZ3trQHMHTl86FvkoaoOo0K928=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2zUvpc78/6QtnZ90Nb/FfYFzYkaX5necCuomTAarU32xpOIyWZOCCM7pbjQ1sY2G
         U5h7Or6BH35fSvNFZ6EqYxCHgcY0RZlZgBFQDqAdl3nIRkh868I6ZfdKA/OyC0vUCJ
         2/YszaoMX64e/KpCB/Gih0gSwW4ucOgRDedBUW2Uayva0OYGB1hxdekn9Butv9iKig
         wocqDu8otDFE/K5+Wg0sOL/qzQKavV3EO6q6N4ApJ0E2nDC+tVqJmG7zUbHsL5jTtM
         TbG+i/hGm6JexSvLCjJsYR5rWpO8wW5hW41tcm+yx4qq7SH97vQa8RxwepM/chZ8L5
         4zo3+IVwLAHaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     JK Kim <jongkang.kim2@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 25/41] nvme-pci: fix var. type for increasing cq_head
Date:   Mon,  5 Jul 2021 11:29:45 -0400
Message-Id: <20210705153001.1521447-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JK Kim <jongkang.kim2@gmail.com>

[ Upstream commit a0aac973a26d1ac814b9e131e209eb39472a67ce ]

nvmeq->cq_head is compared with nvmeq->q_depth and changed the value
and cq_phase for handling the next cq db.

but, nvmeq->q_depth's type is u32 and max. value is 0x10000 when
CQP.MSQE is 0xffff and io_queue_depth is 0x10000.

current temp. variable for comparing with nvmeq->q_depth is overflowed
when previous nvmeq->cq_head is 0xffff.

in this case, nvmeq->cq_phase is not updated.
so, fix data type for temp. variable to u32.

Signed-off-by: JK Kim <jongkang.kim2@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c1f3446216c5..56263214ea06 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1027,7 +1027,7 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 
 static inline void nvme_update_cq_head(struct nvme_queue *nvmeq)
 {
-	u16 tmp = nvmeq->cq_head + 1;
+	u32 tmp = nvmeq->cq_head + 1;
 
 	if (tmp == nvmeq->q_depth) {
 		nvmeq->cq_head = 0;
-- 
2.30.2

