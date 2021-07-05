Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5FB3BBF35
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhGEPbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232118AbhGEPbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 358D661995;
        Mon,  5 Jul 2021 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498938;
        bh=V7EyXYKUimWcMCi0dwLr/tKJynbs5rtBHmEcMuYnu5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyN065jiqezXt2GGbHWeDRhy5I5zDqCakJkcg/a2NDZ2l0bk/MZOITNfYRwQFLGq5
         YW2ssyZ37pH0BtVuxHSroiGHKKBGbUh5G87grv6ww7JtAGJkEDypBDrM+6GEUzBv6l
         uxPoliUMvKOA+Zbzix3le1XUbg3ZV01V/IAHcTJqPAuhI6dSyXy9Lx1Z40jKdyECuv
         GMFF5kdUdDU10oMq6gQra/RK+TRdSJqZPkKIRCsiD+KpsrgwxJ+fsbnqfeG1/UgzGd
         f1uc0brAwS4uX/IJ0eelFKB3597nkl/6xghfM49oruFa3rpzvuM5JYPQlaeIilMmcZ
         8Mg0bSX+mjBlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     JK Kim <jongkang.kim2@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 33/59] nvme-pci: fix var. type for increasing cq_head
Date:   Mon,  5 Jul 2021 11:27:49 -0400
Message-Id: <20210705152815.1520546-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
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
index a29b170701fc..2995e87ce776 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1032,7 +1032,7 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 
 static inline void nvme_update_cq_head(struct nvme_queue *nvmeq)
 {
-	u16 tmp = nvmeq->cq_head + 1;
+	u32 tmp = nvmeq->cq_head + 1;
 
 	if (tmp == nvmeq->q_depth) {
 		nvmeq->cq_head = 0;
-- 
2.30.2

