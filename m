Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F42A268DB5
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgINO35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgINNGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:06:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9EE722267;
        Mon, 14 Sep 2020 13:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088718;
        bh=MzWnIxtOue9UZv1v1Vab4i0yZPiIvaGLn0jYHvew5aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kwhnv5/zl00RRXY17cN6NHgle0dG4pa383Dm5rXUg/S+k0DUU/YGQ2g6oqwn/pzaN
         WuzNFbzrT+9KMS4Lr98zLs9U/h4ODgktGoQBz6CJMqxrJoE08VJpUd0z/DoGs9zKk0
         VzQR0i8mfPpAe7o3Ky0G92yKpt4ubafHU/MM6vcs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Milburn <dmilburn@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 13/19] nvme-rdma: cancel async events before freeing event struct
Date:   Mon, 14 Sep 2020 09:04:56 -0400
Message-Id: <20200914130502.1804708-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130502.1804708-1-sashal@kernel.org>
References: <20200914130502.1804708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index f393a6193252e..8a11e26d17683 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -739,6 +739,7 @@ static void nvme_rdma_destroy_admin_queue(struct nvme_rdma_ctrl *ctrl,
 		nvme_rdma_free_tagset(&ctrl->ctrl, ctrl->ctrl.admin_tagset);
 	}
 	if (ctrl->async_event_sqe.data) {
+		cancel_work_sync(&ctrl->ctrl.async_event_work);
 		nvme_rdma_free_qe(ctrl->device->dev, &ctrl->async_event_sqe,
 				sizeof(struct nvme_command), DMA_TO_DEVICE);
 		ctrl->async_event_sqe.data = NULL;
-- 
2.25.1

