Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF78259B99
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgIAPTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbgIAPTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:19:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD08206EB;
        Tue,  1 Sep 2020 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973547;
        bh=Aj2i/GFWkXVTO/WsK2WQJzbadJ+weGi3Imo/eq3lzZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ux10aOT888Qt/YYqs92rwQB5IrQaZDuFFvcvsh8jWO4YspHvgM7EIU76TdU/5pFae
         Uy8R0lS71WuIXwzx5tmOQQfAip242ZR3dL86SjBQWaJfvIw7sLfe+Hlj7beApfubck
         F8OiO+LWsim8ud0Kc6s1MuBxkFiKXvBHjNh2vQig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 43/91] nvme-fc: Fix wrong return value in __nvme_fc_init_request()
Date:   Tue,  1 Sep 2020 17:10:17 +0200
Message-Id: <20200901150930.277875366@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit f34448cd0dc697723fb5f4118f8431d9233b370d ]

On an error exit path, a negative error code should be returned
instead of a positive return value.

Fixes: e399441de9115 ("nvme-fabrics: Add host support for FC transport")
Cc: James Smart <jsmart2021@gmail.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 058d542647dd5..13c89cc9d10cf 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1492,7 +1492,7 @@ __nvme_fc_init_request(struct nvme_fc_ctrl *ctrl,
 	if (fc_dma_mapping_error(ctrl->lport->dev, op->fcp_req.cmddma)) {
 		dev_err(ctrl->dev,
 			"FCP Op failed - cmdiu dma mapping failed.\n");
-		ret = EFAULT;
+		ret = -EFAULT;
 		goto out_on_error;
 	}
 
@@ -1502,7 +1502,7 @@ __nvme_fc_init_request(struct nvme_fc_ctrl *ctrl,
 	if (fc_dma_mapping_error(ctrl->lport->dev, op->fcp_req.rspdma)) {
 		dev_err(ctrl->dev,
 			"FCP Op failed - rspiu dma mapping failed.\n");
-		ret = EFAULT;
+		ret = -EFAULT;
 	}
 
 	atomic_set(&op->state, FCPOP_STATE_IDLE);
-- 
2.25.1



