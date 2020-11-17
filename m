Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AE52B6316
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731879AbgKQNev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731584AbgKQNep (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CE8C246A5;
        Tue, 17 Nov 2020 13:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620086;
        bh=6IoiOFJUKOcUhztuRrXe9uOyWyzAOJU/nq/G7DDNUvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZ8b1ODlCHswM3ZpSdSe2geZYr/Ge8rI+6m8vhutbPIh6LLgFegLrEGaZGfdcj0wA
         kQlU1sKoSGINa6pVV3MQdQEmK2A32nQj5dfgdVL4aKewqDoRMEmflFEkKVy3W1H3El
         7QDDCaXZwEW/kNEfIK4v/g5VeLOQSxXiSn660XLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "B.L. Jones" <brandon.gustav@googlemail.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 103/255] Revert "nvme-pci: remove last_sq_tail"
Date:   Tue, 17 Nov 2020 14:04:03 +0100
Message-Id: <20201117122143.971355832@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 38210800bf66d7302da1bb5b624ad68638da1562 ]

Multiple CPUs may be mapped to the same hctx, allowing mulitple
submission contexts to attempt commit_rqs(). We need to verify we're
not writing the same doorbell value multiple times since that's a spec
violation.

Revert commit 54b2fcee1db041a83b52b51752dade6090cf952f.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1878596
Reported-by: "B.L. Jones" <brandon.gustav@googlemail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8984796db0c80..a6af96aaa0eb7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -198,6 +198,7 @@ struct nvme_queue {
 	u32 q_depth;
 	u16 cq_vector;
 	u16 sq_tail;
+	u16 last_sq_tail;
 	u16 cq_head;
 	u16 qid;
 	u8 cq_phase;
@@ -455,11 +456,24 @@ static int nvme_pci_map_queues(struct blk_mq_tag_set *set)
 	return 0;
 }
 
-static inline void nvme_write_sq_db(struct nvme_queue *nvmeq)
+/*
+ * Write sq tail if we are asked to, or if the next command would wrap.
+ */
+static inline void nvme_write_sq_db(struct nvme_queue *nvmeq, bool write_sq)
 {
+	if (!write_sq) {
+		u16 next_tail = nvmeq->sq_tail + 1;
+
+		if (next_tail == nvmeq->q_depth)
+			next_tail = 0;
+		if (next_tail != nvmeq->last_sq_tail)
+			return;
+	}
+
 	if (nvme_dbbuf_update_and_check_event(nvmeq->sq_tail,
 			nvmeq->dbbuf_sq_db, nvmeq->dbbuf_sq_ei))
 		writel(nvmeq->sq_tail, nvmeq->q_db);
+	nvmeq->last_sq_tail = nvmeq->sq_tail;
 }
 
 /**
@@ -476,8 +490,7 @@ static void nvme_submit_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
 	       cmd, sizeof(*cmd));
 	if (++nvmeq->sq_tail == nvmeq->q_depth)
 		nvmeq->sq_tail = 0;
-	if (write_sq)
-		nvme_write_sq_db(nvmeq);
+	nvme_write_sq_db(nvmeq, write_sq);
 	spin_unlock(&nvmeq->sq_lock);
 }
 
@@ -486,7 +499,8 @@ static void nvme_commit_rqs(struct blk_mq_hw_ctx *hctx)
 	struct nvme_queue *nvmeq = hctx->driver_data;
 
 	spin_lock(&nvmeq->sq_lock);
-	nvme_write_sq_db(nvmeq);
+	if (nvmeq->sq_tail != nvmeq->last_sq_tail)
+		nvme_write_sq_db(nvmeq, true);
 	spin_unlock(&nvmeq->sq_lock);
 }
 
@@ -1496,6 +1510,7 @@ static void nvme_init_queue(struct nvme_queue *nvmeq, u16 qid)
 	struct nvme_dev *dev = nvmeq->dev;
 
 	nvmeq->sq_tail = 0;
+	nvmeq->last_sq_tail = 0;
 	nvmeq->cq_head = 0;
 	nvmeq->cq_phase = 1;
 	nvmeq->q_db = &dev->dbs[qid * 2 * dev->db_stride];
-- 
2.27.0



