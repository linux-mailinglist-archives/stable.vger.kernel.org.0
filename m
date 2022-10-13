Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3255FDA47
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 15:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiJMNSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 09:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiJMNSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 09:18:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8949A12FF88
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 06:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51F88617B0
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 13:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DB5C433C1;
        Thu, 13 Oct 2022 13:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665667111;
        bh=L9+Qy3OudK+bBy7aOZwUa+ick8NqVL3l12UeIZLFC6M=;
        h=Subject:To:Cc:From:Date:From;
        b=mh/AMdpBJNtWLKPNhXzfac8Jz1gCkXaRfsWhLK3wE6aBoZTpQE8vIfzUxRsA6Xpmu
         GjlL013jgzUJBWAGYS8MA6dA7sRxblj5MKSXuOM2qKqFK4mp6Gnzd0C8yYRX76NoI2
         qYD+OEurqArbBCzuMJOzWEcYRpYoLXCvQaGbHwOA=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Revert "scsi: qla2xxx: Fix response queue" failed to apply to 5.19-stable tree
To:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Oct 2022 15:13:41 +0200
Message-ID: <1665666821178186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.


thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6dc45a7322cb9db48a5b6696597a00ef7c778ef9 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Fri, 26 Aug 2022 03:25:53 -0700
Subject: [PATCH] scsi: qla2xxx: Revert "scsi: qla2xxx: Fix response queue
 handler reading stale packets"

Reverting this commit so that a fixed up patch, without adding new module
parameters, can be submitted.

    Link: https://lore.kernel.org/stable/166039743723771@kroah.com/

This reverts commit b1f707146923335849fb70237eec27d4d1ae7d62.

Link: https://lore.kernel.org/r/20220826102559.17474-2-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5dd2932382ee..bb69fa8b956a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -193,8 +193,6 @@ extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
 extern u32 ql2xnvme_queues;
-extern int ql2xrspq_follow_inptr;
-extern int ql2xrspq_follow_inptr_legacy;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 76e79f350a22..ede76357ccb6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3763,8 +3763,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
-	u16 rsp_in = 0, cur_ring_index;
-	int follow_inptr, is_shadow_hba;
+	u16 cur_ring_index;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3774,25 +3773,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
-#define __update_rsp_in(_update, _is_shadow_hba, _rsp, _rsp_in)		\
-	do {								\
-		if (_update) {						\
-			_rsp_in = _is_shadow_hba ? *(_rsp)->in_ptr :	\
-				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
-		}							\
-	} while (0)
-
-	is_shadow_hba = IS_SHADOW_REG_CAPABLE(ha);
-	follow_inptr = is_shadow_hba ? ql2xrspq_follow_inptr :
-				ql2xrspq_follow_inptr_legacy;
-
-	__update_rsp_in(follow_inptr, is_shadow_hba, rsp, rsp_in);
-
-	while ((likely(follow_inptr &&
-		       rsp->ring_index != rsp_in &&
-		       rsp->ring_ptr->signature != RESPONSE_PROCESSED)) ||
-		       (!follow_inptr &&
-			rsp->ring_ptr->signature != RESPONSE_PROCESSED)) {
+	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 		cur_ring_index = rsp->ring_index;
 
@@ -3906,8 +3887,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
-				__update_rsp_in(follow_inptr, is_shadow_hba,
-						rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f19cd2b59ad5..ce7cf7750f62 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -338,16 +338,6 @@ module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
 MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
 	"Number of seconds delayed before qla begin PCI error self-handling (default: 5).\n");
 
-int ql2xrspq_follow_inptr = 1;
-module_param(ql2xrspq_follow_inptr, int, 0644);
-MODULE_PARM_DESC(ql2xrspq_follow_inptr,
-		 "Follow RSP IN pointer for RSP updates for HBAs 27xx and newer (default: 1).");
-
-int ql2xrspq_follow_inptr_legacy = 1;
-module_param(ql2xrspq_follow_inptr_legacy, int, 0644);
-MODULE_PARM_DESC(ql2xrspq_follow_inptr_legacy,
-		 "Follow RSP IN pointer for RSP updates for HBAs older than 27XX. (default: 1).");
-
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);

