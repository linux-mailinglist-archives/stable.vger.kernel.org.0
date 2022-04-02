Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91134F03DE
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 16:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356158AbiDBOWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 10:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242997AbiDBOWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 10:22:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20F712D0B1
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 07:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99AECB8093B
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 14:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F41C340EC;
        Sat,  2 Apr 2022 14:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648909213;
        bh=FrvxBeTqd3MC5anSCiyhXrPSkM1wME8hqTBebMPGG2Q=;
        h=Subject:To:Cc:From:Date:From;
        b=ImAKToYxB5CBXx85RCCESOTnDpRTPU9P2jk/EyOI6X+gnneDwg4mcVFnDCar1wAnt
         8/bCDrmuyi7+Ld9nEa2Rb/nZXQe6F6eBwD2kgN0VpZxvzXP/4Cg6vrZMuZ733Yl0S7
         80kak5CRFMLZ8d8pA4ozUens+GTX2MRZn7fQmNVs=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix missed DMA unmap for NVMe ls requests" failed to apply to 4.14-stable tree
To:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 16:20:10 +0200
Message-ID: <164890921013578@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c85ab7d9e27a80e48d5b7d7fb2fe2b0fdb2de523 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Thu, 10 Mar 2022 01:25:55 -0800
Subject: [PATCH] scsi: qla2xxx: Fix missed DMA unmap for NVMe ls requests

At NVMe ELS request time, request structure is DMA mapped and never
unmapped. Fix this by calling the unmap on ELS completion.

Link: https://lore.kernel.org/r/20220310092604.22950-5-njavali@marvell.com
Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and transport registration")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 3bf5cbd754a7..794a95b2e3b4 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -175,6 +175,18 @@ static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
 
+static void qla_nvme_ls_unmap(struct srb *sp, struct nvmefc_ls_req *fd)
+{
+	if (sp->flags & SRB_DMA_VALID) {
+		struct srb_iocb *nvme = &sp->u.iocb_cmd;
+		struct qla_hw_data *ha = sp->fcport->vha->hw;
+
+		dma_unmap_single(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
+				 fd->rqstlen, DMA_TO_DEVICE);
+		sp->flags &= ~SRB_DMA_VALID;
+	}
+}
+
 static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 {
 	struct srb *sp = container_of(kref, struct srb, cmd_kref);
@@ -191,6 +203,8 @@ static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
 	fd = priv->fd;
+
+	qla_nvme_ls_unmap(sp, fd);
 	fd->done(fd, priv->comp_status);
 out:
 	qla2x00_rel_sp(sp);
@@ -361,6 +375,8 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
 	    fd->rqstlen, DMA_TO_DEVICE);
 
+	sp->flags |= SRB_DMA_VALID;
+
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x700e,
@@ -368,6 +384,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
+		qla_nvme_ls_unmap(sp, fd);
 		qla2x00_rel_sp(sp);
 		return rval;
 	}

