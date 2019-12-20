Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267F1127D79
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfLTOei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfLTOeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:34:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70D2421D7D;
        Fri, 20 Dec 2019 14:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852475;
        bh=E3M3Rk+EtBVG5nA2dJqBGAMJi8GXyVnnEdorwCIOzTI=;
        h=From:To:Cc:Subject:Date:From;
        b=EOogzwtg/6H9jSoJ7BmQI1EXt7baaBmVqzt3ajOCOlT/10tvDNhlV8uMVwuZ5Xl/U
         PQ2wZkbzIvxyR7BafhZZCeBTTpDTAts2zpB3c7Fi86cx8PEyqykKgzUhdq+Ll7nTRK
         7x0l9HowfbvsywIR3vyMMPVMqcDFnCY8CcLGzPlA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/34] nvme_fc: add module to ops template to allow module references
Date:   Fri, 20 Dec 2019 09:34:00 -0500
Message-Id: <20191220143433.9922-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 863fbae929c7a5b64e96b8a3ffb34a29eefb9f8f ]

In nvme-fc: it's possible to have connected active controllers
and as no references are taken on the LLDD, the LLDD can be
unloaded.  The controller would enter a reconnect state and as
long as the LLDD resumed within the reconnect timeout, the
controller would resume.  But if a namespace on the controller
is the root device, allowing the driver to unload can be problematic.
To reload the driver, it may require new io to the boot device,
and as it's no longer connected we get into a catch-22 that
eventually fails, and the system locks up.

Fix this issue by taking a module reference for every connected
controller (which is what the core layer did to the transport
module). Reference is cleared when the controller is removed.

Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c          | 14 ++++++++++++--
 drivers/nvme/target/fcloop.c    |  1 +
 drivers/scsi/lpfc/lpfc_nvme.c   |  2 ++
 drivers/scsi/qla2xxx/qla_nvme.c |  1 +
 include/linux/nvme-fc-driver.h  |  4 ++++
 5 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 565bddcfd130d..d567035571bf2 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -342,7 +342,8 @@ nvme_fc_register_localport(struct nvme_fc_port_info *pinfo,
 	    !template->ls_req || !template->fcp_io ||
 	    !template->ls_abort || !template->fcp_abort ||
 	    !template->max_hw_queues || !template->max_sgl_segments ||
-	    !template->max_dif_sgl_segments || !template->dma_boundary) {
+	    !template->max_dif_sgl_segments || !template->dma_boundary ||
+	    !template->module) {
 		ret = -EINVAL;
 		goto out_reghost_failed;
 	}
@@ -1986,6 +1987,7 @@ nvme_fc_ctrl_free(struct kref *ref)
 {
 	struct nvme_fc_ctrl *ctrl =
 		container_of(ref, struct nvme_fc_ctrl, ref);
+	struct nvme_fc_lport *lport = ctrl->lport;
 	unsigned long flags;
 
 	if (ctrl->ctrl.tagset) {
@@ -2011,6 +2013,7 @@ nvme_fc_ctrl_free(struct kref *ref)
 	if (ctrl->ctrl.opts)
 		nvmf_free_options(ctrl->ctrl.opts);
 	kfree(ctrl);
+	module_put(lport->ops->module);
 }
 
 static void
@@ -3040,10 +3043,15 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 		goto out_fail;
 	}
 
+	if (!try_module_get(lport->ops->module)) {
+		ret = -EUNATCH;
+		goto out_free_ctrl;
+	}
+
 	idx = ida_simple_get(&nvme_fc_ctrl_cnt, 0, 0, GFP_KERNEL);
 	if (idx < 0) {
 		ret = -ENOSPC;
-		goto out_free_ctrl;
+		goto out_mod_put;
 	}
 
 	ctrl->ctrl.opts = opts;
@@ -3185,6 +3193,8 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 out_free_ida:
 	put_device(ctrl->dev);
 	ida_simple_remove(&nvme_fc_ctrl_cnt, ctrl->cnum);
+out_mod_put:
+	module_put(lport->ops->module);
 out_free_ctrl:
 	kfree(ctrl);
 out_fail:
diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 291f4121f516a..f0536d341f2f2 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -825,6 +825,7 @@ fcloop_targetport_delete(struct nvmet_fc_target_port *targetport)
 #define FCLOOP_DMABOUND_4G		0xFFFFFFFF
 
 static struct nvme_fc_port_template fctemplate = {
+	.module			= THIS_MODULE,
 	.localport_delete	= fcloop_localport_delete,
 	.remoteport_delete	= fcloop_remoteport_delete,
 	.create_queue		= fcloop_create_queue,
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index f73726e55e44d..6c355d87c709d 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1903,6 +1903,8 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 
 /* Declare and initialization an instance of the FC NVME template. */
 static struct nvme_fc_port_template lpfc_nvme_template = {
+	.module	= THIS_MODULE,
+
 	/* initiator-based functions */
 	.localport_delete  = lpfc_nvme_localport_delete,
 	.remoteport_delete = lpfc_nvme_remoteport_delete,
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 5590d6e8b5762..db367e428095d 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -560,6 +560,7 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 }
 
 static struct nvme_fc_port_template qla_nvme_fc_transport = {
+	.module	= THIS_MODULE,
 	.localport_delete = qla_nvme_localport_delete,
 	.remoteport_delete = qla_nvme_remoteport_delete,
 	.create_queue   = qla_nvme_alloc_queue,
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index 496ff759f84c6..2f3ae41c212dc 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -282,6 +282,8 @@ struct nvme_fc_remote_port {
  *
  * Host/Initiator Transport Entrypoints/Parameters:
  *
+ * @module:  The LLDD module using the interface
+ *
  * @localport_delete:  The LLDD initiates deletion of a localport via
  *       nvme_fc_deregister_localport(). However, the teardown is
  *       asynchronous. This routine is called upon the completion of the
@@ -395,6 +397,8 @@ struct nvme_fc_remote_port {
  *       Value is Mandatory. Allowed to be zero.
  */
 struct nvme_fc_port_template {
+	struct module	*module;
+
 	/* initiator-based functions */
 	void	(*localport_delete)(struct nvme_fc_local_port *);
 	void	(*remoteport_delete)(struct nvme_fc_remote_port *);
-- 
2.20.1

