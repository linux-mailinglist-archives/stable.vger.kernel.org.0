Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282711334CF
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgAGU4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgAGU4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:56:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EE382087F;
        Tue,  7 Jan 2020 20:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430582;
        bh=qDFVOxMnh+5wotgzHq5R04eplzdOYPdbyE2FLajrPqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHDP5Qf7A5BNvfoTPoCjQEYK/ZX168MfMIIPZCJ/i/Rnqudwe0PwrxTKkTutjwZwK
         psKUuk2uPT+MkJBxsYsqIZI56jueASOoZd5hFhYIRrBwlryS6JSL+MWOO9pAVZ3LHV
         IXwtIAsE8WyYF+FQbkjzRkUy5tthirhFHNjzy/cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Christoph Hellwig <hch@lst.de>,
        James Smart <jsmart2021@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/191] nvme_fc: add module to ops template to allow module references
Date:   Tue,  7 Jan 2020 21:52:02 +0100
Message-Id: <20200107205333.136068132@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 265f89e11d8b..3f102d9f39b8 100644
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
@@ -2015,6 +2016,7 @@ nvme_fc_ctrl_free(struct kref *ref)
 {
 	struct nvme_fc_ctrl *ctrl =
 		container_of(ref, struct nvme_fc_ctrl, ref);
+	struct nvme_fc_lport *lport = ctrl->lport;
 	unsigned long flags;
 
 	if (ctrl->ctrl.tagset) {
@@ -2041,6 +2043,7 @@ nvme_fc_ctrl_free(struct kref *ref)
 	if (ctrl->ctrl.opts)
 		nvmf_free_options(ctrl->ctrl.opts);
 	kfree(ctrl);
+	module_put(lport->ops->module);
 }
 
 static void
@@ -3056,10 +3059,15 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
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
@@ -3212,6 +3220,8 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 out_free_ida:
 	put_device(ctrl->dev);
 	ida_simple_remove(&nvme_fc_ctrl_cnt, ctrl->cnum);
+out_mod_put:
+	module_put(lport->ops->module);
 out_free_ctrl:
 	kfree(ctrl);
 out_fail:
diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index b50b53db3746..1c50af6219f3 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -850,6 +850,7 @@ fcloop_targetport_delete(struct nvmet_fc_target_port *targetport)
 #define FCLOOP_DMABOUND_4G		0xFFFFFFFF
 
 static struct nvme_fc_port_template fctemplate = {
+	.module			= THIS_MODULE,
 	.localport_delete	= fcloop_localport_delete,
 	.remoteport_delete	= fcloop_remoteport_delete,
 	.create_queue		= fcloop_create_queue,
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index a227e36cbdc2..8e0f03ef346b 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1976,6 +1976,8 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 
 /* Declare and initialization an instance of the FC NVME template. */
 static struct nvme_fc_port_template lpfc_nvme_template = {
+	.module	= THIS_MODULE,
+
 	/* initiator-based functions */
 	.localport_delete  = lpfc_nvme_localport_delete,
 	.remoteport_delete = lpfc_nvme_remoteport_delete,
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 941aa53363f5..bfcd02fdf2b8 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -610,6 +610,7 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 }
 
 static struct nvme_fc_port_template qla_nvme_fc_transport = {
+	.module	= THIS_MODULE,
 	.localport_delete = qla_nvme_localport_delete,
 	.remoteport_delete = qla_nvme_remoteport_delete,
 	.create_queue   = qla_nvme_alloc_queue,
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index 10f81629b9ce..6d0d70f3219c 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -270,6 +270,8 @@ struct nvme_fc_remote_port {
  *
  * Host/Initiator Transport Entrypoints/Parameters:
  *
+ * @module:  The LLDD module using the interface
+ *
  * @localport_delete:  The LLDD initiates deletion of a localport via
  *       nvme_fc_deregister_localport(). However, the teardown is
  *       asynchronous. This routine is called upon the completion of the
@@ -383,6 +385,8 @@ struct nvme_fc_remote_port {
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



