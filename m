Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199FB3C51E6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349552AbhGLHoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348617AbhGLHlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46A35601FE;
        Mon, 12 Jul 2021 07:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075501;
        bh=V7EyXYKUimWcMCi0dwLr/tKJynbs5rtBHmEcMuYnu5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDuLFRUbQkr03c3jjHkd105gT5E5hzUKM/SG6+EOrd0GT7Z1n86wt+vULYXrEeScx
         unWoDBEFf+otj4Yn5jz7MhCdkcfjWEzRrtxNaucepFKcR9q8z8yb/aRJe7Rha6gw8q
         UD4SlOcrGfAgsdsuO5owx6TMelz9n2eH68WVyIZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JK Kim <jongkang.kim2@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 240/800] nvme-pci: fix var. type for increasing cq_head
Date:   Mon, 12 Jul 2021 08:04:23 +0200
Message-Id: <20210712060947.542765757@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



