Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F028F27C897
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgI2MDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730391AbgI2Lil (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B01FD208B8;
        Tue, 29 Sep 2020 11:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379521;
        bh=dZ55FMZQJ2bs669+Gn3BrOB1OSbVpEG7rvUyUoGlqYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHlEtiQ8WHsP56iU5yHBz4S+aNyGx7YebcZXocGQrccRP+soHnT9Wo2w/aK2w/YiR
         AS4lS2PlYSOFFc7MjAOvOijFTLL2BFbTB6Ej4pGlp4LIOqWST8F31Wf11rRtV3Z4OE
         WOYt1HJ11KEfYu6wOsnrnFh/6Y/cbkciFwKuFa6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 201/388] nvme: Fix controller creation races with teardown flow
Date:   Tue, 29 Sep 2020 12:58:52 +0200
Message-Id: <20200929110020.212497361@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 32cefbd80bdfb..438a03fc4bd94 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3197,6 +3197,10 @@ static ssize_t nvme_sysfs_delete(struct device *dev,
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
 
+	/* Can't delete non-created controllers */
+	if (!ctrl->created)
+		return -EBUSY;
+
 	if (device_remove_file_self(dev, attr))
 		nvme_delete_ctrl_sync(ctrl);
 	return count;
@@ -3992,6 +3996,7 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 		nvme_queue_scan(ctrl);
 		nvme_start_queues(ctrl);
 	}
+	ctrl->created = true;
 }
 EXPORT_SYMBOL_GPL(nvme_start_ctrl);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 66aafd42d2d91..5eb9500c89392 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -253,6 +253,7 @@ struct nvme_ctrl {
 	struct nvme_command ka_cmd;
 	struct work_struct fw_act_work;
 	unsigned long events;
+	bool created;
 
 #ifdef CONFIG_NVME_MULTIPATH
 	/* asymmetric namespace access: */
-- 
2.25.1



