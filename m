Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9BB20DC23
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgF2UMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732870AbgF2TaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F7D125270;
        Mon, 29 Jun 2020 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444982;
        bh=lgdF+Vr6Tm668xiX0c10KvvsPSRsQV1zh/UWjozhaRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7+tIpgfT2wdGFBoZxQCcER75mMtgbc/gPPjkBUdLE5wsHOrXgV4btNblRaakl4jP
         nk8PZ3EyJGhXgopw/FndOXdP362zTLBSfBiBMp5EvgjDn7XeOvCyFUYK+VSgOl0p91
         rCiXybUMsI5QzAFy8TKLu3rE7vhvaFyK8bo97Yfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/131] nvme-multipath: set bdi capabilities once
Date:   Mon, 29 Jun 2020 11:34:12 -0400
Message-Id: <20200629153502.2494656-82-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/nvme/host/multipath.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 588864beabd80..6f584a9515f42 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -11,6 +11,7 @@
  * more details.
  */
 
+#include <linux/backing-dev.h>
 #include <linux/moduleparam.h>
 #include <trace/events/block.h>
 #include "nvme.h"
@@ -521,6 +522,13 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
 		nvme_mpath_set_live(ns);
 		mutex_unlock(&ns->head->lock);
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

