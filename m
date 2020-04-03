Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0DF519D92E
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 16:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgDCOdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 10:33:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55778 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbgDCOdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 10:33:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id r16so7364276wmg.5
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 07:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Rr7rz+y8nAcE1i55Rdc+GIs/hkMMrSyyxqp0VTw7iYs=;
        b=ADyZEb6r4HQb/R4tsPyfH6LX6U6mezsZwticOelRdLkJ+qHIniPJ9OpEGBZKhe+Lp7
         ytfFqFHnQiee512LB35qCzgVOpPGkd928uBtWWLWq8QkpvyjSgC9YiD0pWp5ICNcx8xZ
         sXzOLbQHD2glQtSLcooSSrgcPVnseQDHNxObY6AXQFXzuGp3fAWIF8udXngb7H0fZEyP
         /dS21isXve9TQjkoNCcKyvYcb30XFWH5/NSAkf1cwQOCmVaShbXdgSfAvA0pJ0J11QQv
         QwHYP8u71FBmitD3A1pNoKdqpLjbMrK2DTzwM2pEqlfg1FCPHjUbL51KMbh/9EBOsv89
         DaUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Rr7rz+y8nAcE1i55Rdc+GIs/hkMMrSyyxqp0VTw7iYs=;
        b=n3oGmH8wj3JzKqspvsmZQ3ffimamyfBUb+ZOsnLrMYdXFvzc2GlfXTU1gr1aN/aP/W
         aYDGzOa+4dFEgkKBNnn0nDflXOfntDAUQJl3PyhLkVP052cCONwZuLWPN83nQq/V7dH2
         jocFYRG32s0UAMwBYhy3yToGhEZw1NIAzkdt/Vj/zyNYKJflxdT7gq9esfKKw/zJpOBp
         7fvh2HMttipEB6tKWOQWq3LQfYZZqrnQxY1aBeFwzmc2fEVU9/vHd5DXBHjBBk5BjfgT
         ZAdIdGynmvogKc/2kabRXDc0pTvGKJfcK3GJNhPNBRJj+GndoqeYUPS68KS5YuSio2xu
         61MA==
X-Gm-Message-State: AGi0Puawwb/Jz0P+lHIa16oHOroj7v3o2zNwixDjCcmGYYY6UeZU4Ye5
        kjtGeVY2Rqii5D4soyXem+8=
X-Google-Smtp-Source: APiQypK5cbnF4rk9fEk5tyTGvXqD4VfFctko0saQXLPQe2H5Xh7JXLDlHzUt9FuMU9w18Xy5livsHQ==
X-Received: by 2002:a1c:648b:: with SMTP id y133mr8766766wmb.173.1585924407677;
        Fri, 03 Apr 2020 07:33:27 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f5sm2690647wrj.95.2020.04.03.07.33.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Apr 2020 07:33:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH] nvme-fc: Revert - add module to ops template to allow module references
Date:   Fri,  3 Apr 2020 07:33:20 -0700
Message-Id: <20200403143320.49522-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch reverts the commit for
   nvme_fc: add module to ops template to allow module references

The original patch was to resolve the lldd being able to be unloaded
while being used to talk to the boot device of the system. However, the
end result of the original patch is that any driver unload while a nvme
controller is live via the lldd is now being prohibited. Given the module
reference, the module teardown routine can't be called, thus there's no
way, other than manual actions to terminate the controllers.

-- james

Fixes: 863fbae929c7 ("nvme_fc: add module to ops template to allow module  references")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: James Smart <jsmart2021@gmail.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/fc.c          | 14 ++------------
 drivers/nvme/target/fcloop.c    |  1 -
 drivers/scsi/lpfc/lpfc_nvme.c   |  2 --
 drivers/scsi/qla2xxx/qla_nvme.c |  1 -
 include/linux/nvme-fc-driver.h  |  4 ----
 5 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index a8bf2fb1287b..7dfc4a2ecf1e 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -342,8 +342,7 @@ nvme_fc_register_localport(struct nvme_fc_port_info *pinfo,
 	    !template->ls_req || !template->fcp_io ||
 	    !template->ls_abort || !template->fcp_abort ||
 	    !template->max_hw_queues || !template->max_sgl_segments ||
-	    !template->max_dif_sgl_segments || !template->dma_boundary ||
-	    !template->module) {
+	    !template->max_dif_sgl_segments || !template->dma_boundary) {
 		ret = -EINVAL;
 		goto out_reghost_failed;
 	}
@@ -2016,7 +2015,6 @@ nvme_fc_ctrl_free(struct kref *ref)
 {
 	struct nvme_fc_ctrl *ctrl =
 		container_of(ref, struct nvme_fc_ctrl, ref);
-	struct nvme_fc_lport *lport = ctrl->lport;
 	unsigned long flags;
 
 	if (ctrl->ctrl.tagset) {
@@ -2043,7 +2041,6 @@ nvme_fc_ctrl_free(struct kref *ref)
 	if (ctrl->ctrl.opts)
 		nvmf_free_options(ctrl->ctrl.opts);
 	kfree(ctrl);
-	module_put(lport->ops->module);
 }
 
 static void
@@ -3074,15 +3071,10 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
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
@@ -3232,8 +3224,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 out_free_ida:
 	put_device(ctrl->dev);
 	ida_simple_remove(&nvme_fc_ctrl_cnt, ctrl->cnum);
-out_mod_put:
-	module_put(lport->ops->module);
 out_free_ctrl:
 	kfree(ctrl);
 out_fail:
diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 9861fcea39f6..f69ce66e2d44 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -875,7 +875,6 @@ fcloop_targetport_delete(struct nvmet_fc_target_port *targetport)
 #define FCLOOP_DMABOUND_4G		0xFFFFFFFF
 
 static struct nvme_fc_port_template fctemplate = {
-	.module			= THIS_MODULE,
 	.localport_delete	= fcloop_localport_delete,
 	.remoteport_delete	= fcloop_remoteport_delete,
 	.create_queue		= fcloop_create_queue,
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index f6c8963c915d..db4a04a207ec 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1985,8 +1985,6 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 
 /* Declare and initialization an instance of the FC NVME template. */
 static struct nvme_fc_port_template lpfc_nvme_template = {
-	.module	= THIS_MODULE,
-
 	/* initiator-based functions */
 	.localport_delete  = lpfc_nvme_localport_delete,
 	.remoteport_delete = lpfc_nvme_remoteport_delete,
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index bfcd02fdf2b8..941aa53363f5 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -610,7 +610,6 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 }
 
 static struct nvme_fc_port_template qla_nvme_fc_transport = {
-	.module	= THIS_MODULE,
 	.localport_delete = qla_nvme_localport_delete,
 	.remoteport_delete = qla_nvme_remoteport_delete,
 	.create_queue   = qla_nvme_alloc_queue,
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index 6d0d70f3219c..10f81629b9ce 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -270,8 +270,6 @@ struct nvme_fc_remote_port {
  *
  * Host/Initiator Transport Entrypoints/Parameters:
  *
- * @module:  The LLDD module using the interface
- *
  * @localport_delete:  The LLDD initiates deletion of a localport via
  *       nvme_fc_deregister_localport(). However, the teardown is
  *       asynchronous. This routine is called upon the completion of the
@@ -385,8 +383,6 @@ struct nvme_fc_remote_port {
  *       Value is Mandatory. Allowed to be zero.
  */
 struct nvme_fc_port_template {
-	struct module	*module;
-
 	/* initiator-based functions */
 	void	(*localport_delete)(struct nvme_fc_local_port *);
 	void	(*remoteport_delete)(struct nvme_fc_remote_port *);
-- 
2.16.4

