Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D460DE68A0
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbfJ0VSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731189AbfJ0VSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:02 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7078420717;
        Sun, 27 Oct 2019 21:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211081;
        bh=2Vkxwzxf5v7bmtbDLQR/hmDRq0Mt1UcwVRUHSzDX9qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlL188OI/fFB1CDOXdZWEWbqh6kzQ2zIT7ZssFRzuMV6BRJSki8uXTamYi9RONr+Y
         nIzZkLo6yHsHxXIuAvQw9AbJww07nJSLGTXHDCv+Hr+ZoTo3ZlipKqFudeH9LqSb5h
         oWCYzkGJxtFnpoUUAbUYzYOJ8w7eG1TSUKwzUhaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 025/197] nvme-rdma: fix possible use-after-free in connect timeout
Date:   Sun, 27 Oct 2019 21:59:03 +0100
Message-Id: <20191027203353.061786254@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 67b483dd03c4cd9e90e4c3943132dce514ea4e88 ]

If the connect times out, we may have already destroyed the
queue in the timeout handler, so test if the queue is still
allocated in the connect error handler.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index cc1956349a2af..842ef876724f7 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -620,7 +620,8 @@ static int nvme_rdma_start_queue(struct nvme_rdma_ctrl *ctrl, int idx)
 	if (!ret) {
 		set_bit(NVME_RDMA_Q_LIVE, &queue->flags);
 	} else {
-		__nvme_rdma_stop_queue(queue);
+		if (test_bit(NVME_RDMA_Q_ALLOCATED, &queue->flags))
+			__nvme_rdma_stop_queue(queue);
 		dev_info(ctrl->ctrl.device,
 			"failed to connect queue: %d ret=%d\n", idx, ret);
 	}
-- 
2.20.1



