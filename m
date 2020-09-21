Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F025272F88
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgIUQ5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729208AbgIUQmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:42:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40442235F9;
        Mon, 21 Sep 2020 16:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706555;
        bh=6h1K6IulkA5jAF8Opli0PsZv5oyF4XJebxb1fr/+5P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jf1j+Qs7hazopVV24EVyU6B7UhimQ7kUJTw4Wx2/31xT5AE2pseF87CWadajOv86c
         FeskrLkaBN3MRX0wncaeET1jDGK7+Di3rNHVTEtwzcH7j3dY+l91ODL9gz3oJdSpVJ
         dV6welExdCgyrMC2w50TFUw4oqE+t17mqe32Or1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Milburn <dmilburn@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/49] nvme-rdma: cancel async events before freeing event struct
Date:   Mon, 21 Sep 2020 18:28:04 +0200
Message-Id: <20200921162035.566149310@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Milburn <dmilburn@redhat.com>

[ Upstream commit 925dd04c1f9825194b9e444c12478084813b2b5d ]

Cancel async event work in case async event has been queued up, and
nvme_rdma_submit_async_event() runs after event has been freed.

Signed-off-by: David Milburn <dmilburn@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 7e2cdb17c26d8..077c678166651 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -740,6 +740,7 @@ static void nvme_rdma_destroy_admin_queue(struct nvme_rdma_ctrl *ctrl,
 		nvme_rdma_free_tagset(&ctrl->ctrl, ctrl->ctrl.admin_tagset);
 	}
 	if (ctrl->async_event_sqe.data) {
+		cancel_work_sync(&ctrl->ctrl.async_event_work);
 		nvme_rdma_free_qe(ctrl->device->dev, &ctrl->async_event_sqe,
 				sizeof(struct nvme_command), DMA_TO_DEVICE);
 		ctrl->async_event_sqe.data = NULL;
-- 
2.25.1



