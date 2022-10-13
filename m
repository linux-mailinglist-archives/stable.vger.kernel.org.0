Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8543C5FE049
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiJMSG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiJMSFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:05:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3701B3C17C;
        Thu, 13 Oct 2022 11:04:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D400361995;
        Thu, 13 Oct 2022 18:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACDDC433B5;
        Thu, 13 Oct 2022 18:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684055;
        bh=9vKia5o5B4xGTx3eWxIf6VhmDOv6agctG3itO2HEjxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Euxm4PuAH2v5SDgDBgVvMJmPGvUaVxG5z3WLW0v2+fNG/g8S55XvxT0cjrfWytXmu
         fc46i4oGNkMQPjyUzDi/jAODovZ9LveSLXLPrQtpE2pYftnEateGkT69oaLTl7m3h3
         1kQ6B4QikVDVRU5kzLQkN/LlyqfE9xh7p5OdRAIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.0 11/34] scsi: qla2xxx: Revert "scsi: qla2xxx: Fix response queue handler reading stale packets"
Date:   Thu, 13 Oct 2022 19:52:49 +0200
Message-Id: <20221013175146.815599374@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit 6dc45a7322cb9db48a5b6696597a00ef7c778ef9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    2 --
 drivers/scsi/qla2xxx/qla_isr.c |   25 ++-----------------------
 drivers/scsi/qla2xxx/qla_os.c  |   10 ----------
 3 files changed, 2 insertions(+), 35 deletions(-)

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
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3763,8 +3763,7 @@ void qla24xx_process_response_queue(stru
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
-	u16 rsp_in = 0, cur_ring_index;
-	int follow_inptr, is_shadow_hba;
+	u16 cur_ring_index;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3774,25 +3773,7 @@ void qla24xx_process_response_queue(stru
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
 
@@ -3906,8 +3887,6 @@ process_err:
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
-				__update_rsp_in(follow_inptr, is_shadow_hba,
-						rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -338,16 +338,6 @@ module_param(ql2xdelay_before_pci_error_
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


