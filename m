Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3496E21727F
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgGGPeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728562AbgGGPTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:19:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E3C12065D;
        Tue,  7 Jul 2020 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135145;
        bh=lgdF+Vr6Tm668xiX0c10KvvsPSRsQV1zh/UWjozhaRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=il5kGz3+RDLIFZs4ekxDRF5OTFbDTdZC/TpQGLioHNvSoqRgoYluE78VE03xXf6zt
         TcMBQar/7OtZdY9BWsGbdUmo1IOOmeDF4UpoDMcMvhofbFuEK7riri+nFKKUWsmIKD
         YWgz5tKfF4qrDXnGRlORxz3IpTHNIPiVkD9kDB5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/36] nvme-multipath: set bdi capabilities once
Date:   Tue,  7 Jul 2020 17:17:01 +0200
Message-Id: <20200707145749.588807254@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
References: <20200707145749.130272978@linuxfoundation.org>
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



