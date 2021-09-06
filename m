Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6EB401392
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbhIFB1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240168AbhIFBZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ADD161153;
        Mon,  6 Sep 2021 01:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891337;
        bh=AbnGdYKQC5qqiEOoKwJTjXRBceh5WyClv3tpWA0VNFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2JCSVc71u5m1e6qwsaBA88xhH/Cz4bRmwaGpR6dVn2XtqM8JYLZAWiFCPK9k+4GO
         B0kXpJP7LuPP7ETu+0h8rKDIbgYJOCQuNUEpkIz/3VypHEmwW+taJayQtKKun57Inq
         DJja3w/G3D0qSjf8ujTCwvHpxM4Vu15EukZl8FBcxAeTOaH9j+m3LXx6/TThwStSKU
         746y6bbCLZbfAGrx+kTTitVr+keoJ/R9EIs2pag9VnCF3ie958I6z1KWAWid5Jxb5B
         PZAB3AkrjV9sllWa6qP4M3TnyJK+f5BePD3rzDkSMmaOViBDGzgBqUKOdtw60mznxa
         Y1rvmO4SmxlZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ruozhu Li <liruozhu@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 19/39] nvme-tcp: don't update queue count when failing to set io queues
Date:   Sun,  5 Sep 2021 21:21:33 -0400
Message-Id: <20210906012153.929962-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
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
index 82b2611d39a2..5b11d8a23813 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1755,13 +1755,13 @@ static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
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

