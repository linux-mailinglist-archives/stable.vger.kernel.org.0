Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAFA2F9F8E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403905AbhARM1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390845AbhARLpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0652422D71;
        Mon, 18 Jan 2021 11:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970321;
        bh=YP2OK2BAnGfEVd1VXRwL+RCVlpkQfuyOZdcBvQmDNXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cP3QjMZBP6uX8d5zje9jsxP04uwxm+xqhAkoBgeOGdcKyz8xqVRR2gODmGBsXHaf4
         yIui3+9wvGH0Ek9rbD7D2gO6fXyze9q408LUUUfb19RqS0FFpD/zE5aELiIDMD0aib
         X9rcHekayLMsKzZGO9qGqhmBB0sW4GU1zqasOQiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/152] nvme-fc: avoid calling _nvme_fc_abort_outstanding_ios from interrupt context
Date:   Mon, 18 Jan 2021 12:34:38 +0100
Message-Id: <20210118113357.676033784@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

[ Upstream commit 19fce0470f05031e6af36e49ce222d0f0050d432 ]

Recent patches changed calling sequences. nvme_fc_abort_outstanding_ios
used to be called from a timeout or work context. Now it is being called
in an io completion context, which can be an interrupt handler.
Unfortunately, the abort outstanding ios routine attempts to stop nvme
queues and nested routines that may try to sleep, which is in conflict
with the interrupt handler.

Correct replacing the direct call with a work element scheduling, and the
abort outstanding ios routine will be called in the work element.

Fixes: 95ced8a2c72d ("nvme-fc: eliminate terminate_io use by nvme_fc_error_recovery")
Signed-off-by: James Smart <james.smart@broadcom.com>
Reported-by: Daniel Wagner <dwagner@suse.de>
Tested-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index f4c246462658f..5ead217ac2bc8 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -166,6 +166,7 @@ struct nvme_fc_ctrl {
 	struct blk_mq_tag_set	admin_tag_set;
 	struct blk_mq_tag_set	tag_set;
 
+	struct work_struct	ioerr_work;
 	struct delayed_work	connect_work;
 
 	struct kref		ref;
@@ -1888,6 +1889,15 @@ __nvme_fc_fcpop_chk_teardowns(struct nvme_fc_ctrl *ctrl,
 	}
 }
 
+static void
+nvme_fc_ctrl_ioerr_work(struct work_struct *work)
+{
+	struct nvme_fc_ctrl *ctrl =
+			container_of(work, struct nvme_fc_ctrl, ioerr_work);
+
+	nvme_fc_error_recovery(ctrl, "transport detected io error");
+}
+
 static void
 nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 {
@@ -2046,7 +2056,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 
 check_error:
 	if (terminate_assoc)
-		nvme_fc_error_recovery(ctrl, "transport detected io error");
+		queue_work(nvme_reset_wq, &ctrl->ioerr_work);
 }
 
 static int
@@ -3233,6 +3243,7 @@ nvme_fc_delete_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(nctrl);
 
+	cancel_work_sync(&ctrl->ioerr_work);
 	cancel_delayed_work_sync(&ctrl->connect_work);
 	/*
 	 * kill the association on the link side.  this will block
@@ -3449,6 +3460,7 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	INIT_WORK(&ctrl->ctrl.reset_work, nvme_fc_reset_ctrl_work);
 	INIT_DELAYED_WORK(&ctrl->connect_work, nvme_fc_connect_ctrl_work);
+	INIT_WORK(&ctrl->ioerr_work, nvme_fc_ctrl_ioerr_work);
 	spin_lock_init(&ctrl->lock);
 
 	/* io queue count */
@@ -3540,6 +3552,7 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 fail_ctrl:
 	nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_DELETING);
+	cancel_work_sync(&ctrl->ioerr_work);
 	cancel_work_sync(&ctrl->ctrl.reset_work);
 	cancel_delayed_work_sync(&ctrl->connect_work);
 
-- 
2.27.0



