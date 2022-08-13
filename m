Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F45591AA3
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239451AbiHMNay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237284AbiHMNao (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:30:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540E810D0
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E0F0B80108
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E47C433C1;
        Sat, 13 Aug 2022 13:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660397440;
        bh=EZnnmMoldOu+SDRzbKvRU1wg5WHbDlOsvDlod6rdN7E=;
        h=Subject:To:Cc:From:Date:From;
        b=FdqE1qgvGPv8eN2HmeFV4JtSSFsuEDFs/cos4PhqELitVxqh3tdlfmqosh5Qb3fS0
         7W7PGiufY1khat9JWlHPiaxw7tUtCEYtztCZpofpOyyyWIF+LhTCqZZzlRQu1ISR8n
         uDOKKyAHLBZjNT+YQnBIsNUl5ES2HekTQumtCD7A=
Subject: WTF: patch "[PATCH] scsi: qla2xxx: Fix response queue handler reading stale" was seriously submitted to be applied to the 5.19-stable tree?
To:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 15:30:37 +0200
Message-ID: <166039743723771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.19-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b1f707146923335849fb70237eec27d4d1ae7d62 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Tue, 12 Jul 2022 22:20:39 -0700
Subject: [PATCH] scsi: qla2xxx: Fix response queue handler reading stale
 packets

On some platforms, the current logic of relying on finding new packet
solely based on signature pattern can lead to driver reading stale
packets. Though this is a bug in those platforms, reduce such exposures by
limiting reading packets until the IN pointer.

Two module parameters are introduced:

  ql2xrspq_follow_inptr:

    When set, on newer adapters that has queue pointer shadowing, look for
    response packets only until response queue in pointer.

    When reset, response packets are read based on a signature pattern
    logic (old way).

  ql2xrspq_follow_inptr_legacy:

    Like ql2xrspq_follow_inptr, but for those adapters where there is no
    queue pointer shadowing.

Link: https://lore.kernel.org/r/20220713052045.10683-5-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3674b35196b0..96147ca40126 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -193,6 +193,8 @@ extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
 extern u32 ql2xnvme_queues;
+extern int ql2xrspq_follow_inptr;
+extern int ql2xrspq_follow_inptr_legacy;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4fa24d318f14..35b425c446b9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3780,6 +3780,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
+	u16 rsp_in = 0;
+	int follow_inptr, is_shadow_hba;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3789,7 +3791,25 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
-	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
+#define __update_rsp_in(_update, _is_shadow_hba, _rsp, _rsp_in)		\
+	do {								\
+		if (_update) {						\
+			_rsp_in = _is_shadow_hba ? *(_rsp)->in_ptr :	\
+				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
+		}							\
+	} while (0)
+
+	is_shadow_hba = IS_SHADOW_REG_CAPABLE(ha);
+	follow_inptr = is_shadow_hba ? ql2xrspq_follow_inptr :
+				ql2xrspq_follow_inptr_legacy;
+
+	__update_rsp_in(follow_inptr, is_shadow_hba, rsp, rsp_in);
+
+	while ((likely(follow_inptr &&
+		       rsp->ring_index != rsp_in &&
+		       rsp->ring_ptr->signature != RESPONSE_PROCESSED)) ||
+		       (!follow_inptr &&
+			rsp->ring_ptr->signature != RESPONSE_PROCESSED)) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 
 		rsp->ring_index++;
@@ -3902,6 +3922,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
+				__update_rsp_in(follow_inptr, is_shadow_hba,
+						rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1c7fb6484db2..0bd0fd1042df 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -338,6 +338,16 @@ module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
 MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
 	"Number of seconds delayed before qla begin PCI error self-handling (default: 5).\n");
 
+int ql2xrspq_follow_inptr = 1;
+module_param(ql2xrspq_follow_inptr, int, 0644);
+MODULE_PARM_DESC(ql2xrspq_follow_inptr,
+		 "Follow RSP IN pointer for RSP updates for HBAs 27xx and newer (default: 1).");
+
+int ql2xrspq_follow_inptr_legacy = 1;
+module_param(ql2xrspq_follow_inptr_legacy, int, 0644);
+MODULE_PARM_DESC(ql2xrspq_follow_inptr_legacy,
+		 "Follow RSP IN pointer for RSP updates for HBAs older than 27XX. (default: 1).");
+
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);

