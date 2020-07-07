Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79786217247
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgGGPbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbgGGPXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2CFB20771;
        Tue,  7 Jul 2020 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135419;
        bh=QAD5qRIIxo3zrtd5no+WXBb73ggzwksH2e1jCZsJYOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytVssuHwcBD/I05/CCoib+lldBCrY1sOSGKzMYwGPYu+lpJk137ZzRyvjHMt67qp4
         BFf/NEM2SUsPM4tlYSuOtQamxlN9kJJB8e8P2sAi9FN31oWjL+uux7XXPThAhpHNbT
         jbLayn+LRCSiizJdeuq7z51oCdpTfth7G5txReN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 034/112] nvme-multipath: set bdi capabilities once
Date:   Tue,  7 Jul 2020 17:16:39 +0200
Message-Id: <20200707145802.611687480@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b2ce4d90690bd29ce5b554e203cd03682dd59697 ]

The queues' backing device info capabilities don't change with each
namespace revalidation. Set it only when each path's request_queue
is initially added to a multipath queue.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      | 7 -------
 drivers/nvme/host/multipath.c | 8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7b4cbe2c69541..887139f8fa53b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1910,13 +1910,6 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	if (ns->head->disk) {
 		nvme_update_disk_info(ns->head->disk, ns, id);
 		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);
-		if (bdi_cap_stable_pages_required(ns->queue->backing_dev_info)) {
-			struct backing_dev_info *info =
-				ns->head->disk->queue->backing_dev_info;
-
-                        info->capabilities |= BDI_CAP_STABLE_WRITES;
-		}
-
 		revalidate_disk(ns->head->disk);
 	}
 #endif
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 17f172cf456ad..91a8b1ce5a3a2 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2017-2018 Christoph Hellwig.
  */
 
+#include <linux/backing-dev.h>
 #include <linux/moduleparam.h>
 #include <trace/events/block.h>
 #include "nvme.h"
@@ -662,6 +663,13 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
 		ns->ana_state = NVME_ANA_OPTIMIZED; 
 		nvme_mpath_set_live(ns);
 	}
+
+	if (bdi_cap_stable_pages_required(ns->queue->backing_dev_info)) {
+		struct backing_dev_info *info =
+					ns->head->disk->queue->backing_dev_info;
+
+		info->capabilities |= BDI_CAP_STABLE_WRITES;
+	}
 }
 
 void nvme_mpath_remove_disk(struct nvme_ns_head *head)
-- 
2.25.1



