Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04588272EEB
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgIUQw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729852AbgIUQsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:48:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B926238A1;
        Mon, 21 Sep 2020 16:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706920;
        bh=tF1m/ZemcRK+9KBti0OKGH+jzU0pV4thYClwxfHa0Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7BxDN58UDVqJ3oMb8hQ8o+9CJe0o4aWKMzDU9QFrjUD64bNZmX8IYDzR6BbFjEF1
         wt6KVarEk2IwDfNI0oZ3fpmiU6RWTTEUf50Zg8XaCbQ/Gs3rv8e9l6OvJ8jE5JlV5V
         3NLyTOXWMbqQODEEZ1Mv44NBIthdl3aOtanGO52E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Milburn <dmilburn@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/72] nvme-rdma: cancel async events before freeing event struct
Date:   Mon, 21 Sep 2020 18:30:59 +0200
Message-Id: <20200921163122.826554112@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
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
index f0847f2bb117b..f9444272f861e 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -769,6 +769,7 @@ static void nvme_rdma_destroy_admin_queue(struct nvme_rdma_ctrl *ctrl,
 		blk_mq_free_tag_set(ctrl->ctrl.admin_tagset);
 	}
 	if (ctrl->async_event_sqe.data) {
+		cancel_work_sync(&ctrl->ctrl.async_event_work);
 		nvme_rdma_free_qe(ctrl->device->dev, &ctrl->async_event_sqe,
 				sizeof(struct nvme_command), DMA_TO_DEVICE);
 		ctrl->async_event_sqe.data = NULL;
-- 
2.25.1



