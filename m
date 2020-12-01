Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E999E2C9DE9
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388800AbgLAJ3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387641AbgLAI7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:59:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D16FB217A0;
        Tue,  1 Dec 2020 08:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813145;
        bh=0n8jfaMWrlyg/5o+SmqrjEegfZzl9GLztMgGWzfjofw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsCD6AlYbSl48qj+mkqCt0VwBrKgfPJQQUEnQFckgOtlfjxDao5nO+EECHIcd8FGO
         icruLpKHwLb+5932C34mxaxVq7QyTREREEoCFzobTEkW1JMpSc992+XsiQ8NTePvvj
         aAls2tR1REjel/hOYymudwmPNjxcXYJhuFOA56vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/50] nvme: free sq/cq dbbuf pointers when dbbuf set fails
Date:   Tue,  1 Dec 2020 09:53:20 +0100
Message-Id: <20201201084647.730069293@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
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
index 3788c053a0b19..540fab9f850dd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -266,9 +266,21 @@ static void nvme_dbbuf_init(struct nvme_dev *dev,
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
@@ -282,6 +294,9 @@ static void nvme_dbbuf_set(struct nvme_dev *dev)
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



