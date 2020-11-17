Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A232B64A2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732410AbgKQNe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732284AbgKQNe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 476682078E;
        Tue, 17 Nov 2020 13:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620098;
        bh=hUjuOwHmFj8PtPWjGMDtqE36XsdhC1+MHClHW6V98KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOXNfJUbyt19uoYX11MDSpIZIeR6AnJfx95FxYIoq+js85x92duhWmcBar2wJQwQ9
         Yx/9dw5TiTqUSmuDoWoWiJBS5TrkVoKQgh1ujblHsJJfDybbXJeUB5mVJxf3iMurVx
         L/oMhRxMAX8uNNA4dPjf0Gb+0onI9LZ30A3oK+Gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Leng <lengchao@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 107/255] nvme: introduce nvme_sync_io_queues
Date:   Tue, 17 Nov 2020 14:04:07 +0100
Message-Id: <20201117122144.165615914@linuxfoundation.org>
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

From: Chao Leng <lengchao@huawei.com>

[ Upstream commit 04800fbff4764ab7b32c49d19628605a5d4cb85c ]

Introduce sync io queues for some scenarios which just only need sync
io queues not sync all queues.

Signed-off-by: Chao Leng <lengchao@huawei.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 ++++++--
 drivers/nvme/host/nvme.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 893e29624c16b..59040bab5d6fa 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4641,8 +4641,7 @@ void nvme_start_queues(struct nvme_ctrl *ctrl)
 }
 EXPORT_SYMBOL_GPL(nvme_start_queues);
 
-
-void nvme_sync_queues(struct nvme_ctrl *ctrl)
+void nvme_sync_io_queues(struct nvme_ctrl *ctrl)
 {
 	struct nvme_ns *ns;
 
@@ -4650,7 +4649,12 @@ void nvme_sync_queues(struct nvme_ctrl *ctrl)
 	list_for_each_entry(ns, &ctrl->namespaces, list)
 		blk_sync_queue(ns->queue);
 	up_read(&ctrl->namespaces_rwsem);
+}
+EXPORT_SYMBOL_GPL(nvme_sync_io_queues);
 
+void nvme_sync_queues(struct nvme_ctrl *ctrl)
+{
+	nvme_sync_io_queues(ctrl);
 	if (ctrl->admin_q)
 		blk_sync_queue(ctrl->admin_q);
 }
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 2aaedfa43ed86..97fbd61191b33 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -602,6 +602,7 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl);
 void nvme_start_queues(struct nvme_ctrl *ctrl);
 void nvme_kill_queues(struct nvme_ctrl *ctrl);
 void nvme_sync_queues(struct nvme_ctrl *ctrl);
+void nvme_sync_io_queues(struct nvme_ctrl *ctrl);
 void nvme_unfreeze(struct nvme_ctrl *ctrl);
 void nvme_wait_freeze(struct nvme_ctrl *ctrl);
 int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);
-- 
2.27.0



