Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C71401408
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241013AbhIFBcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241256AbhIFB2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:28:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30A4E61166;
        Mon,  6 Sep 2021 01:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891383;
        bh=qpjiSVmAa/GUpIbdu/bOfFsVIDF2f69PRQ7Vm/j8hNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJw9o4iPFVb57aCGBQGPkb11O7K/3L9dwU03LpxrU6MdpLpRuVEcl4AN3MEkzu1gs
         uLTTi7wkUJd1cR3cuwTJZBE/h1m1yUqzd5Yrfu2ee2wiPfuB9FDLNhSkjJtprW9bYw
         CrEoI9CGKjPLGBckJyEwpVzYTcMg+taPhoUanMJqq9iVCnKr/jhQRaChEIPJLGVsZj
         BecGkaxnK65aVJny0qpL2f5hxcwXqh2sdeq5odHzYByRGa1ciozrlbNTwJQUKT/+cX
         p7yTAABi6Xjs6ZoOYeNs/6iM887q3FbYJPnRKI7VUyowi3bul4j3bL3asO2eKKKUmc
         rANG0LMsuHVrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ruozhu Li <liruozhu@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 16/30] nvme-tcp: don't update queue count when failing to set io queues
Date:   Sun,  5 Sep 2021 21:22:29 -0400
Message-Id: <20210906012244.930338-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
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
index 718152adc625..f6427a10a990 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1649,13 +1649,13 @@ static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
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

