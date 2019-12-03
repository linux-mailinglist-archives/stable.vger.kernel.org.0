Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE22A111FA7
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfLCWlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbfLCWlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B39FB2084B;
        Tue,  3 Dec 2019 22:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412909;
        bh=FfefrJbWEyx89dWQUGF9mYlUXuopa8fzSZPZ4K0dL9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xk0XMSI6bmdQylxGvVBv/+D4vlBpBi5sueig0JhKeFXXRHcv/u/yG74vCttOI0Evq
         nmqvW9vb6i024FE+IPIMPV3RKNBC1GD6DduH4pqEfuCVkYTQfmjTeTHnnP6opW5NUs
         E0M1cIB9nTVU6jQq8OaXrJ9RBWm8AI1VP1TpODuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <maxg@mellanox.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 063/135] nvme-rdma: fix a segmentation fault during module unload
Date:   Tue,  3 Dec 2019 23:35:03 +0100
Message-Id: <20191203213023.672786472@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

[ Upstream commit 9ad9e8d6ca29c1446d81c6518ae634a2141dfd22 ]

In case there are controllers that are not associated with any RDMA
device (e.g. during unsuccessful reconnection) and the user will unload
the module, these controllers will not be freed and will access already
freed memory. The same logic appears in other fabric drivers as well.

Fixes: 87fd125344d6 ("nvme-rdma: remove redundant reference between ib_device and tagset")
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 842ef876724f7..439e66769f250 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -2118,8 +2118,16 @@ err_unreg_client:
 
 static void __exit nvme_rdma_cleanup_module(void)
 {
+	struct nvme_rdma_ctrl *ctrl;
+
 	nvmf_unregister_transport(&nvme_rdma_transport);
 	ib_unregister_client(&nvme_rdma_ib_client);
+
+	mutex_lock(&nvme_rdma_ctrl_mutex);
+	list_for_each_entry(ctrl, &nvme_rdma_ctrl_list, list)
+		nvme_delete_ctrl(&ctrl->ctrl);
+	mutex_unlock(&nvme_rdma_ctrl_mutex);
+	flush_workqueue(nvme_delete_wq);
 }
 
 module_init(nvme_rdma_init_module);
-- 
2.20.1



