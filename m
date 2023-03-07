Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486546AF5A4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjCGT2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjCGT2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:28:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D130B4F78
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:14:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BACB0B817C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D59CC433D2;
        Tue,  7 Mar 2023 19:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216403;
        bh=c5JwjNDEsRkkMRTNirMefZ2CiiRJJwzJfRUxV69czr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQDy/38fw73tFnHNBzsj8RToaauqEgkpUn2MOlM5ij7mMzcGLBWrRkQFX6yZJz999
         Dk2GTqz184NOs/SkI+Yatj5gwsXn1b2bTlCrN1L2zUQ7LrPOv60ancdO+fzeA1l3GH
         mJ2uiITC+CQmb9rFoFkgwqRqouFQorCku6yfOHGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 541/567] scsi: qla2xxx: Fix DMA-API call trace on NVMe LS requests
Date:   Tue,  7 Mar 2023 18:04:37 +0100
Message-Id: <20230307165929.400666610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit c75e6aef5039830cce5d4cf764dd204522f89e6b upstream.

The following message and call trace was seen with debug kernels:

DMA-API: qla2xxx 0000:41:00.0: device driver failed to check map
error [device address=0x00000002a3ff38d8] [size=1024 bytes] [mapped as
single]
WARNING: CPU: 0 PID: 2930 at kernel/dma/debug.c:1017
	 check_unmap+0xf42/0x1990

Call Trace:
	debug_dma_unmap_page+0xc9/0x100
	qla_nvme_ls_unmap+0x141/0x210 [qla2xxx]

Remove DMA mapping from the driver altogether, as it is already done by FC
layer. This prevents the warning.

Fixes: c85ab7d9e27a ("scsi: qla2xxx: Fix missed DMA unmap for NVMe ls requests")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -165,18 +165,6 @@ out:
 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
 
-static void qla_nvme_ls_unmap(struct srb *sp, struct nvmefc_ls_req *fd)
-{
-	if (sp->flags & SRB_DMA_VALID) {
-		struct srb_iocb *nvme = &sp->u.iocb_cmd;
-		struct qla_hw_data *ha = sp->fcport->vha->hw;
-
-		dma_unmap_single(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
-				 fd->rqstlen, DMA_TO_DEVICE);
-		sp->flags &= ~SRB_DMA_VALID;
-	}
-}
-
 static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 {
 	struct srb *sp = container_of(kref, struct srb, cmd_kref);
@@ -194,7 +182,6 @@ static void qla_nvme_release_ls_cmd_kref
 
 	fd = priv->fd;
 
-	qla_nvme_ls_unmap(sp, fd);
 	fd->done(fd, priv->comp_status);
 out:
 	qla2x00_rel_sp(sp);
@@ -360,13 +347,10 @@ static int qla_nvme_ls_req(struct nvme_f
 	nvme->u.nvme.rsp_len = fd->rsplen;
 	nvme->u.nvme.rsp_dma = fd->rspdma;
 	nvme->u.nvme.timeout_sec = fd->timeout;
-	nvme->u.nvme.cmd_dma = dma_map_single(&ha->pdev->dev, fd->rqstaddr,
-	    fd->rqstlen, DMA_TO_DEVICE);
+	nvme->u.nvme.cmd_dma = fd->rqstdma;
 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
 	    fd->rqstlen, DMA_TO_DEVICE);
 
-	sp->flags |= SRB_DMA_VALID;
-
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x700e,
@@ -374,7 +358,6 @@ static int qla_nvme_ls_req(struct nvme_f
 		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
-		qla_nvme_ls_unmap(sp, fd);
 		qla2x00_rel_sp(sp);
 		return rval;
 	}


