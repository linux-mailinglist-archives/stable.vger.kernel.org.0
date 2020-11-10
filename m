Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587EA2ACC41
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732359AbgKJDyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732326AbgKJDx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0672A207BC;
        Tue, 10 Nov 2020 03:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980438;
        bh=6IoiOFJUKOcUhztuRrXe9uOyWyzAOJU/nq/G7DDNUvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+dBO5WR/M6rUsT3noxVNqk060j4t149FqY5FcewyLvFPQ50VPWJMqZqt91z2GiDM
         mpIZsnEYfbAnLFn0lnGDGaUBR8QccGk9saATHWs3oKQYBKHgjbiV1zdslQ0Ggjh3B6
         kb33pdEBBKNIpHntvpJJsv1/hpX2gxWO3LabYM48=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        "B.L. Jones" <brandon.gustav@googlemail.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 28/55] Revert "nvme-pci: remove last_sq_tail"
Date:   Mon,  9 Nov 2020 22:52:51 -0500
Message-Id: <20201110035318.423757-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

