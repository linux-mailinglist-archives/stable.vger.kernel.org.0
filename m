Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A184F321C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353878AbiDEKJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345777AbiDEJXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:23:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1551191557;
        Tue,  5 Apr 2022 02:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A876AB81A22;
        Tue,  5 Apr 2022 09:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13105C385A0;
        Tue,  5 Apr 2022 09:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149929;
        bh=ZQtAJtFT3tYHabqpMHz6Tb1HyIxMzqpBLVOx+C0HNV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrFRnH3T9tMBswoZbbLtMLJP8WZ4Yhz2LV050HJ6U0IKIXWHIlR/NlkkbPpQT5KKh
         tO+saFs7okKEP0PoxjVOVlXFKP+P76T6a0VhkubFnyUY9PxDi4xs5pVud41F2fZ3LJ
         unFXldNi7e7ixK1xEKJ/2M2XxS+9upMlr/z3m/rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0893/1017] scsi: qla2xxx: Fix missed DMA unmap for NVMe ls requests
Date:   Tue,  5 Apr 2022 09:30:06 +0200
Message-Id: <20220405070420.735566910@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Arun Easi <aeasi@marvell.com>

commit c85ab7d9e27a80e48d5b7d7fb2fe2b0fdb2de523 upstream.

At NVMe ELS request time, request structure is DMA mapped and never
unmapped. Fix this by calling the unmap on ELS completion.

Link: https://lore.kernel.org/r/20220310092604.22950-5-njavali@marvell.com
Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and transport registration")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -172,6 +172,18 @@ out:
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
@@ -188,6 +200,8 @@ static void qla_nvme_release_ls_cmd_kref
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
 	fd = priv->fd;
+
+	qla_nvme_ls_unmap(sp, fd);
 	fd->done(fd, priv->comp_status);
 out:
 	qla2x00_rel_sp(sp);
@@ -358,6 +372,8 @@ static int qla_nvme_ls_req(struct nvme_f
 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
 	    fd->rqstlen, DMA_TO_DEVICE);
 
+	sp->flags |= SRB_DMA_VALID;
+
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x700e,
@@ -365,6 +381,7 @@ static int qla_nvme_ls_req(struct nvme_f
 		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
+		qla_nvme_ls_unmap(sp, fd);
 		qla2x00_rel_sp(sp);
 		return rval;
 	}


