Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C243723F9DB
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgHHXik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbgHHXii (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85AAE2075D;
        Sat,  8 Aug 2020 23:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929918;
        bh=REczOt4TXKPZcId4XYB6HQe/95cS7RHQwDga/Y9APWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T53sOhfHaCk5xgUL9AWPC9mJIIEoja6zFcN7MOTnWBAQC+aEZf07QovoGxD5cdOzo
         hX5+M0ukVK6YBaP3bq3Rgt6uSJfRc26J9NstR6ttiWbGjjizD/nM3odoy+eQ54NDcA
         xkfAcpinrjcVNzxRgNxDPRQAJTdmcZsP56QcEjBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 54/58] nvme-tcp: fix controller reset hang during traffic
Date:   Sat,  8 Aug 2020 19:37:20 -0400
Message-Id: <20200808233724.3618168-54-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 2875b0aecabe2f081a8432e2bc85b85df0529490 ]

commit fe35ec58f0d3 ("block: update hctx map when use multiple maps")
exposed an issue where we may hang trying to wait for queue freeze
during I/O. We call blk_mq_update_nr_hw_queues which in case of multiple
queue maps (which we have now for default/read/poll) is attempting to
freeze the queue. However we never started queue freeze when starting the
reset, which means that we have inflight pending requests that entered the
queue that we will not complete once the queue is quiesced.

So start a freeze before we quiesce the queue, and unfreeze the queue
after we successfully connected the I/O queues (and make sure to call
blk_mq_update_nr_hw_queues only after we are sure that the queue was
already frozen).

This follows to how the pci driver handles resets.

Fixes: fe35ec58f0d3 ("block: update hctx map when use multiple maps")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 26461bf3fdcc3..99eaa0474e10b 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1753,15 +1753,20 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 			ret = PTR_ERR(ctrl->connect_q);
 			goto out_free_tag_set;
 		}
-	} else {
-		blk_mq_update_nr_hw_queues(ctrl->tagset,
-			ctrl->queue_count - 1);
 	}
 
 	ret = nvme_tcp_start_io_queues(ctrl);
 	if (ret)
 		goto out_cleanup_connect_q;
 
+	if (!new) {
+		nvme_start_queues(ctrl);
+		nvme_wait_freeze(ctrl);
+		blk_mq_update_nr_hw_queues(ctrl->tagset,
+			ctrl->queue_count - 1);
+		nvme_unfreeze(ctrl);
+	}
+
 	return 0;
 
 out_cleanup_connect_q:
@@ -1866,6 +1871,7 @@ static void nvme_tcp_teardown_io_queues(struct nvme_ctrl *ctrl,
 {
 	if (ctrl->queue_count <= 1)
 		return;
+	nvme_start_freeze(ctrl);
 	nvme_stop_queues(ctrl);
 	nvme_tcp_stop_io_queues(ctrl);
 	if (ctrl->tagset) {
-- 
2.25.1

