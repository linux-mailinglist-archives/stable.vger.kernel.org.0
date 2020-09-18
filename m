Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BA626EC32
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgIRCKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728473AbgIRCKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D1B421582;
        Fri, 18 Sep 2020 02:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395036;
        bh=Tt6DnYGiWAjDPqOMfhauHSXDFE4oJt7VPHo/MIsFYJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEwAGEJfQjBu41svsv2Y4W+7qHbZlTJXOqD3jBY5cY7yM7IxSA4RaavNqQJSyh4sc
         Zce201OkZddF2OXKWpzg1zSOTwm47vtiq1X2LJGkbD0bytoIxjWeNzgWQgV6ujwKji
         kgUmBabwCXUaR79Pfxe7FrcfFWFt5KeNfjF93Xl4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 127/206] nvme: Fix controller creation races with teardown flow
Date:   Thu, 17 Sep 2020 22:06:43 -0400
Message-Id: <20200918020802.2065198-127-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@mellanox.com>

[ Upstream commit ce1518139e6976cf19c133b555083354fdb629b8 ]

Calling nvme_sysfs_delete() when the controller is in the middle of
creation may cause several bugs. If the controller is in NEW state we
remove delete_controller file and don't delete the controller. The user
will not be able to use nvme disconnect command on that controller again,
although the controller may be active. Other bugs may happen if the
controller is in the middle of create_ctrl callback and
nvme_do_delete_ctrl() starts. For example, freeing I/O tagset at
nvme_do_delete_ctrl() before it was allocated at create_ctrl callback.

To fix all those races don't allow the user to delete the controller
before it was fully created.

Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 +++++
 drivers/nvme/host/nvme.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4b182ac15687e..faa7feebb6095 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2856,6 +2856,10 @@ static ssize_t nvme_sysfs_delete(struct device *dev,
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
 
+	/* Can't delete non-created controllers */
+	if (!ctrl->created)
+		return -EBUSY;
+
 	if (device_remove_file_self(dev, attr))
 		nvme_delete_ctrl_sync(ctrl);
 	return count;
@@ -3576,6 +3580,7 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 		queue_work(nvme_wq, &ctrl->async_event_work);
 		nvme_start_queues(ctrl);
 	}
+	ctrl->created = true;
 }
 EXPORT_SYMBOL_GPL(nvme_start_ctrl);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 31c1496f938fb..a70b997060e68 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -206,6 +206,7 @@ struct nvme_ctrl {
 	struct nvme_command ka_cmd;
 	struct work_struct fw_act_work;
 	unsigned long events;
+	bool created;
 
 #ifdef CONFIG_NVME_MULTIPATH
 	/* asymmetric namespace access: */
-- 
2.25.1

