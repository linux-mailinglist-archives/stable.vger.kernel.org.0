Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331FC2C9CE0
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgLAJFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388837AbgLAJEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:04:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B0320809;
        Tue,  1 Dec 2020 09:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813422;
        bh=wmm2grhwJ1Nu8cLPYREWXm5U/uquc+IX4MNyz3Ym0rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QV/zrVC2i4f4IY0PcZD7RzSZS3V1fHp1e6smQVt+ehFbwnmS+mWH54unOThWvYozm
         a4CJxay0VHDbCcAB6H+Y1QWM4z7kgGTP1oK99buJQu75kFP241rBMgTKmjUc1bm9zs
         i/DuJ6NI1+TaBwAqG7ICq2+aBEVZT6YN/Q77Jzvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/98] nvme: free sq/cq dbbuf pointers when dbbuf set fails
Date:   Tue,  1 Dec 2020 09:53:11 +0100
Message-Id: <20201201084656.801663017@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minwoo Im <minwoo.im.dev@gmail.com>

[ Upstream commit 0f0d2c876c96d4908a9ef40959a44bec21bdd6cf ]

If Doorbell Buffer Config command fails even 'dev->dbbuf_dbs != NULL'
which means OACS indicates that NVME_CTRL_OACS_DBBUF_SUPP is set,
nvme_dbbuf_update_and_check_event() will check event even it's not been
successfully set.

This patch fixes mismatch among dbbuf for sq/cqs in case that dbbuf
command fails.

Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f5d12bf109c78..9b1fc8633cfe1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -271,9 +271,21 @@ static void nvme_dbbuf_init(struct nvme_dev *dev,
 	nvmeq->dbbuf_cq_ei = &dev->dbbuf_eis[cq_idx(qid, dev->db_stride)];
 }
 
+static void nvme_dbbuf_free(struct nvme_queue *nvmeq)
+{
+	if (!nvmeq->qid)
+		return;
+
+	nvmeq->dbbuf_sq_db = NULL;
+	nvmeq->dbbuf_cq_db = NULL;
+	nvmeq->dbbuf_sq_ei = NULL;
+	nvmeq->dbbuf_cq_ei = NULL;
+}
+
 static void nvme_dbbuf_set(struct nvme_dev *dev)
 {
 	struct nvme_command c;
+	unsigned int i;
 
 	if (!dev->dbbuf_dbs)
 		return;
@@ -287,6 +299,9 @@ static void nvme_dbbuf_set(struct nvme_dev *dev)
 		dev_warn(dev->ctrl.device, "unable to set dbbuf\n");
 		/* Free memory and continue on */
 		nvme_dbbuf_dma_free(dev);
+
+		for (i = 1; i <= dev->online_queues; i++)
+			nvme_dbbuf_free(&dev->queues[i]);
 	}
 }
 
-- 
2.27.0



