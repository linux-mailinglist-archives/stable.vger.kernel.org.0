Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD381B3CF0
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgDVKKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgDVKKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:10:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 499DC20775;
        Wed, 22 Apr 2020 10:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550199;
        bh=QENR4zGyzIN9PhPUaOgmP9y+gUIdnqamPAAH9RYeFPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iqSmnw4DEp6ZgWbaMe72WWknys92yMWzR7CbuiBj5DtkHJ/Rcz+wvOf7M7adf0Wg
         GgX/0IHHGCYMfe8sHSRhYI2h6ffsNaqS+ZFjdZAP1RPUIVBBit4UZDChMo7L6v5/99
         jNgVLF91vQaxZcl6IJbuFLR8HNOL4dCSciD2iz48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.14 048/199] nvme-fc: Revert "add module to ops template to allow module references"
Date:   Wed, 22 Apr 2020 11:56:14 +0200
Message-Id: <20200422095103.017626498@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 8c5c660529209a0e324c1c1a35ce3f83d67a2aa5 upstream.

The original patch was to resolve the lldd being able to be unloaded
while being used to talk to the boot device of the system. However, the
end result of the original patch is that any driver unload while a nvme
controller is live via the lldd is now being prohibited. Given the module
reference, the module teardown routine can't be called, thus there's no
way, other than manual actions to terminate the controllers.

Fixes: 863fbae929c7 ("nvme_fc: add module to ops template to allow module references")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/fc.c          |   14 ++------------
 drivers/nvme/target/fcloop.c    |    1 -
 drivers/scsi/lpfc/lpfc_nvme.c   |    2 --
 drivers/scsi/qla2xxx/qla_nvme.c |    1 -
 include/linux/nvme-fc-driver.h  |    4 ----
 5 files changed, 2 insertions(+), 20 deletions(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -337,8 +337,7 @@ nvme_fc_register_localport(struct nvme_f
 	    !template->ls_req || !template->fcp_io ||
 	    !template->ls_abort || !template->fcp_abort ||
 	    !template->max_hw_queues || !template->max_sgl_segments ||
-	    !template->max_dif_sgl_segments || !template->dma_boundary ||
-	    !template->module) {
+	    !template->max_dif_sgl_segments || !template->dma_boundary) {
 		ret = -EINVAL;
 		goto out_reghost_failed;
 	}
@@ -1763,7 +1762,6 @@ nvme_fc_ctrl_free(struct kref *ref)
 {
 	struct nvme_fc_ctrl *ctrl =
 		container_of(ref, struct nvme_fc_ctrl, ref);
-	struct nvme_fc_lport *lport = ctrl->lport;
 	unsigned long flags;
 
 	if (ctrl->ctrl.tagset) {
@@ -1789,7 +1787,6 @@ nvme_fc_ctrl_free(struct kref *ref)
 	if (ctrl->ctrl.opts)
 		nvmf_free_options(ctrl->ctrl.opts);
 	kfree(ctrl);
-	module_put(lport->ops->module);
 }
 
 static void
@@ -2768,15 +2765,10 @@ nvme_fc_init_ctrl(struct device *dev, st
 		goto out_fail;
 	}
 
-	if (!try_module_get(lport->ops->module)) {
-		ret = -EUNATCH;
-		goto out_free_ctrl;
-	}
-
 	idx = ida_simple_get(&nvme_fc_ctrl_cnt, 0, 0, GFP_KERNEL);
 	if (idx < 0) {
 		ret = -ENOSPC;
-		goto out_mod_put;
+		goto out_free_ctrl;
 	}
 
 	ctrl->ctrl.opts = opts;
@@ -2923,8 +2915,6 @@ out_free_queues:
 out_free_ida:
 	put_device(ctrl->dev);
 	ida_simple_remove(&nvme_fc_ctrl_cnt, ctrl->cnum);
-out_mod_put:
-	module_put(lport->ops->module);
 out_free_ctrl:
 	kfree(ctrl);
 out_fail:
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -693,7 +693,6 @@ fcloop_targetport_delete(struct nvmet_fc
 #define FCLOOP_DMABOUND_4G		0xFFFFFFFF
 
 static struct nvme_fc_port_template fctemplate = {
-	.module			= THIS_MODULE,
 	.localport_delete	= fcloop_localport_delete,
 	.remoteport_delete	= fcloop_remoteport_delete,
 	.create_queue		= fcloop_create_queue,
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1591,8 +1591,6 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local
 
 /* Declare and initialization an instance of the FC NVME template. */
 static struct nvme_fc_port_template lpfc_nvme_template = {
-	.module	= THIS_MODULE,
-
 	/* initiator-based functions */
 	.localport_delete  = lpfc_nvme_localport_delete,
 	.remoteport_delete = lpfc_nvme_remoteport_delete,
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -578,7 +578,6 @@ static void qla_nvme_remoteport_delete(s
 }
 
 static struct nvme_fc_port_template qla_nvme_fc_transport = {
-	.module	= THIS_MODULE,
 	.localport_delete = qla_nvme_localport_delete,
 	.remoteport_delete = qla_nvme_remoteport_delete,
 	.create_queue   = qla_nvme_alloc_queue,
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -279,8 +279,6 @@ struct nvme_fc_remote_port {
  *
  * Host/Initiator Transport Entrypoints/Parameters:
  *
- * @module:  The LLDD module using the interface
- *
  * @localport_delete:  The LLDD initiates deletion of a localport via
  *       nvme_fc_deregister_localport(). However, the teardown is
  *       asynchronous. This routine is called upon the completion of the
@@ -394,8 +392,6 @@ struct nvme_fc_remote_port {
  *       Value is Mandatory. Allowed to be zero.
  */
 struct nvme_fc_port_template {
-	struct module	*module;
-
 	/* initiator-based functions */
 	void	(*localport_delete)(struct nvme_fc_local_port *);
 	void	(*remoteport_delete)(struct nvme_fc_remote_port *);


