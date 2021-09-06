Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740F9401292
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238913AbhIFBVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238786AbhIFBVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4CC261076;
        Mon,  6 Sep 2021 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891216;
        bh=fdSGnyx4gstkhSKuoXc7lYXqj42Gf2IBpghzFdPw4/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+8i5dl7P1CyrIh8mx0oeMB0+0ARrL04Gsahaed256kzUpfdLOSXteRNUzwcwFCkg
         defUbNpKBGz+1pEoeSj0aDtssLyzg6M+NnLWiJsVdXyrbKUJm7rvE/SE/mEQRQZPVP
         85ATXqqa/QGVq1kSEZU9msyQsxIj+dZXMIVgXNouaA9dNzSaFd8rH6qGcyrqPT0Crk
         e8/VjjN/B9xxhCczir0hcRZZlVnU6nd5TOl81dxJNuQkfD5X56/7wkCVSvZKgtzci8
         j7C4vieKIE3ycAw1LMcSaxuvGWLDCvKOlEGMnY3M973bSNJmq+13FDMvD9PIzzpeNA
         uI2FJ2STKFiFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ruozhu Li <liruozhu@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 20/47] nvme-tcp: don't update queue count when failing to set io queues
Date:   Sun,  5 Sep 2021 21:19:24 -0400
Message-Id: <20210906011951.928679-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruozhu Li <liruozhu@huawei.com>

[ Upstream commit 664227fde63844d69e9ec9e90a8a7801e6ff072d ]

We update ctrl->queue_count and schedule another reconnect when io queue
count is zero.But we will never try to create any io queue in next reco-
nnection, because ctrl->queue_count already set to zero.We will end up
having an admin-only session in Live state, which is exactly what we try
to avoid in the original patch.
Update ctrl->queue_count after queue_count zero checking to fix it.

Signed-off-by: Ruozhu Li <liruozhu@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8cb15ee5b249..18bd68b82d78 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1769,13 +1769,13 @@ static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 	if (ret)
 		return ret;
 
-	ctrl->queue_count = nr_io_queues + 1;
-	if (ctrl->queue_count < 2) {
+	if (nr_io_queues == 0) {
 		dev_err(ctrl->device,
 			"unable to set any I/O queues\n");
 		return -ENOMEM;
 	}
 
+	ctrl->queue_count = nr_io_queues + 1;
 	dev_info(ctrl->device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
-- 
2.30.2

