Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC58E26B68B
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgIPAHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgIOO2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:28:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95C6B2247F;
        Tue, 15 Sep 2020 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179603;
        bh=zyMhEILdnhRs/kiCBE05Ta6dzHkPEUWBrm5rQ1l1MsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmG2eyEdMqPc53DrJb6ScEspnKF5v2GcgeKg4dYhAXoxOxSchGeyWkuBDFk3xOoWw
         zUsJH9l/sa2nZy3Bs1wVnH9gmZ0LLgW1zD0XTu/lpJLjc05vlvIiACY4yj3n7pxEpT
         LBWEcYSr4w8/WcEVXSGWcIE8RgYlT5AReGCN9KPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/132] nvme-fabrics: allow to queue requests for live queues
Date:   Tue, 15 Sep 2020 16:12:10 +0200
Message-Id: <20200915140645.514063807@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 73a5379937ec89b91e907bb315e2434ee9696a2c ]

Right now we are failing requests based on the controller state (which
is checked inline in nvmf_check_ready) however we should definitely
accept requests if the queue is live.

When entering controller reset, we transition the controller into
NVME_CTRL_RESETTING, and then return BLK_STS_RESOURCE for non-mpath
requests (have blk_noretry_request set).

This is also the case for NVME_REQ_USER for the wrong reason. There
shouldn't be any reason for us to reject this I/O in a controller reset.
We do want to prevent passthru commands on the admin queue because we
need the controller to fully initialize first before we let user passthru
admin commands to be issued.

In a non-mpath setup, this means that the requests will simply be
requeued over and over forever not allowing the q_usage_counter to drop
its final reference, causing controller reset to hang if running
concurrently with heavy I/O.

Fixes: 35897b920c8a ("nvme-fabrics: fix and refine state checks in __nvmf_check_ready")
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 74b8818ac9a1e..aa8d0805ba148 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -565,10 +565,14 @@ bool __nvmf_check_ready(struct nvme_ctrl *ctrl, struct request *rq,
 	struct nvme_request *req = nvme_req(rq);
 
 	/*
-	 * If we are in some state of setup or teardown only allow
-	 * internally generated commands.
+	 * currently we have a problem sending passthru commands
+	 * on the admin_q if the controller is not LIVE because we can't
+	 * make sure that they are going out after the admin connect,
+	 * controller enable and/or other commands in the initialization
+	 * sequence. until the controller will be LIVE, fail with
+	 * BLK_STS_RESOURCE so that they will be rescheduled.
 	 */
-	if (!blk_rq_is_passthrough(rq) || (req->flags & NVME_REQ_USERCMD))
+	if (rq->q == ctrl->admin_q && (req->flags & NVME_REQ_USERCMD))
 		return false;
 
 	/*
@@ -578,7 +582,7 @@ bool __nvmf_check_ready(struct nvme_ctrl *ctrl, struct request *rq,
 	switch (ctrl->state) {
 	case NVME_CTRL_NEW:
 	case NVME_CTRL_CONNECTING:
-		if (nvme_is_fabrics(req->cmd) &&
+		if (blk_rq_is_passthrough(rq) && nvme_is_fabrics(req->cmd) &&
 		    req->cmd->fabrics.fctype == nvme_fabrics_type_connect)
 			return true;
 		break;
-- 
2.25.1



