Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CDB593AC1
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344331AbiHOTpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344338AbiHOTnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:43:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09F36C745;
        Mon, 15 Aug 2022 11:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48E20B810A4;
        Mon, 15 Aug 2022 18:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920C0C433C1;
        Mon, 15 Aug 2022 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589304;
        bh=J4jmhqH1QHUDWaxI00qFdkuWTbHMMJ3/Y4bD2QdzluQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xj7J/wa1kzGrJDT7/p7wcr2Zda13knEnFsZ/9dWXTcQDPBrNhnFQ1lmcIcTccpORj
         TIfNA173LKZX001XL+nsWhs0b2s14ztRR/rNjDcxDWEKz23ASh/UouC59QhgU2pSoz
         rIXlfy07nh7PhuBUmJFjh7CEAX+z0PxgoYF3OYbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 677/779] scsi: qla2xxx: Wind down adapter after PCIe error
Date:   Mon, 15 Aug 2022 20:05:21 +0200
Message-Id: <20220815180406.287571695@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit d3117c83ba316b3200d9f2fe900f2b9a5525a25c upstream.

Put adapter into a wind down state if OS does not make any attempt to
recover the adapter after PCIe error.

Link: https://lore.kernel.org/r/20220616053508.27186-4-njavali@marvell.com
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |   10 +++++++-
 drivers/scsi/qla2xxx/qla_def.h  |    4 +++
 drivers/scsi/qla2xxx/qla_init.c |   20 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |   48 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 81 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2972,6 +2972,13 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_
 
 	ql_log(ql_log_info, vha, 0x708b, "%s CMD timeout. bsg ptr %p.\n",
 	    __func__, bsg_job);
+
+	if (qla2x00_isp_reg_stat(ha)) {
+		ql_log(ql_log_info, vha, 0x9007,
+		    "PCI/Register disconnect.\n");
+		qla_pci_set_eeh_busy(vha);
+	}
+
 	/* find the bsg job from the active list of commands */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (que = 0; que < ha->max_req_queues; que++) {
@@ -2989,7 +2996,8 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_
 			    sp->u.bsg_job == bsg_job) {
 				req->outstanding_cmds[cnt] = NULL;
 				spin_unlock_irqrestore(&ha->hardware_lock, flags);
-				if (ha->isp_ops->abort_command(sp)) {
+
+				if (!ha->flags.eeh_busy && ha->isp_ops->abort_command(sp)) {
 					ql_log(ql_log_warn, vha, 0x7089,
 					    "mbx abort_command failed.\n");
 					bsg_reply->result = -EIO;
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4045,6 +4045,9 @@ struct qla_hw_data {
 		uint32_t	n2n_fw_acc_sec:1;
 		uint32_t	plogi_template_valid:1;
 		uint32_t	port_isolated:1;
+		uint32_t	eeh_flush:2;
+#define EEH_FLUSH_RDY  1
+#define EEH_FLUSH_DONE 2
 	} flags;
 
 	uint16_t max_exchg;
@@ -4079,6 +4082,7 @@ struct qla_hw_data {
 	uint32_t		rsp_que_len;
 	uint32_t		req_que_off;
 	uint32_t		rsp_que_off;
+	unsigned long		eeh_jif;
 
 	/* Multi queue data structs */
 	device_reg_t *mqiobase;
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -47,6 +47,7 @@ qla2x00_sp_timeout(struct timer_list *t)
 {
 	srb_t *sp = from_timer(sp, t, u.iocb_cmd.timer);
 	struct srb_iocb *iocb;
+	scsi_qla_host_t *vha = sp->vha;
 
 	WARN_ON(irqs_disabled());
 	iocb = &sp->u.iocb_cmd;
@@ -54,6 +55,12 @@ qla2x00_sp_timeout(struct timer_list *t)
 
 	/* ref: TMR */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+
+	if (vha && qla2x00_isp_reg_stat(vha->hw)) {
+		ql_log(ql_log_info, vha, 0x9008,
+		    "PCI/Register disconnect.\n");
+		qla_pci_set_eeh_busy(vha);
+	}
 }
 
 void qla2x00_sp_free(srb_t *sp)
@@ -9731,6 +9738,12 @@ int qla2xxx_disable_port(struct Scsi_Hos
 
 	vha->hw->flags.port_isolated = 1;
 
+	if (qla2x00_isp_reg_stat(vha->hw)) {
+		ql_log(ql_log_info, vha, 0x9006,
+		    "PCI/Register disconnect, exiting.\n");
+		qla_pci_set_eeh_busy(vha);
+		return FAILED;
+	}
 	if (qla2x00_chip_is_down(vha))
 		return 0;
 
@@ -9746,6 +9759,13 @@ int qla2xxx_enable_port(struct Scsi_Host
 {
 	scsi_qla_host_t *vha = shost_priv(host);
 
+	if (qla2x00_isp_reg_stat(vha->hw)) {
+		ql_log(ql_log_info, vha, 0x9001,
+		    "PCI/Register disconnect, exiting.\n");
+		qla_pci_set_eeh_busy(vha);
+		return FAILED;
+	}
+
 	vha->hw->flags.port_isolated = 0;
 	/* Set the flag to 1, so that isp_abort can proceed */
 	vha->flags.online = 1;
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -333,6 +333,11 @@ MODULE_PARM_DESC(ql2xabts_wait_nvme,
 		 "To wait for ABTS response on I/O timeouts for NVMe. (default: 1)");
 
 
+u32 ql2xdelay_before_pci_error_handling = 5;
+module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
+MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
+	"Number of seconds delayed before qla begin PCI error self-handling (default: 5).\n");
+
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);
@@ -7251,6 +7256,44 @@ static void qla_heart_beat(struct scsi_q
 	}
 }
 
+static void qla_wind_down_chip(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!ha->flags.eeh_busy)
+		return;
+	if (ha->pci_error_state)
+		/* system is trying to recover */
+		return;
+
+	/*
+	 * Current system is not handling PCIE error.  At this point, this is
+	 * best effort to wind down the adapter.
+	 */
+	if (time_after_eq(jiffies, ha->eeh_jif + ql2xdelay_before_pci_error_handling * HZ) &&
+	    !ha->flags.eeh_flush) {
+		ql_log(ql_log_info, vha, 0x9009,
+		    "PCI Error detected, attempting to reset hardware.\n");
+
+		ha->isp_ops->reset_chip(vha);
+		ha->isp_ops->disable_intrs(ha);
+
+		ha->flags.eeh_flush = EEH_FLUSH_RDY;
+		ha->eeh_jif = jiffies;
+
+	} else if (ha->flags.eeh_flush == EEH_FLUSH_RDY &&
+	    time_after_eq(jiffies, ha->eeh_jif +  5 * HZ)) {
+		pci_clear_master(ha->pdev);
+
+		/* flush all command */
+		qla2x00_abort_isp_cleanup(vha);
+		ha->flags.eeh_flush = EEH_FLUSH_DONE;
+
+		ql_log(ql_log_info, vha, 0x900a,
+		    "PCI Error handling complete, all IOs aborted.\n");
+	}
+}
+
 /**************************************************************************
 *   qla2x00_timer
 *
@@ -7274,6 +7317,8 @@ qla2x00_timer(struct timer_list *t)
 	fc_port_t *fcport = NULL;
 
 	if (ha->flags.eeh_busy) {
+		qla_wind_down_chip(vha);
+
 		ql_dbg(ql_dbg_timer, vha, 0x6000,
 		    "EEH = %d, restarting timer.\n",
 		    ha->flags.eeh_busy);
@@ -7854,6 +7899,9 @@ void qla_pci_set_eeh_busy(struct scsi_ql
 
 	spin_lock_irqsave(&base_vha->work_lock, flags);
 	if (!ha->flags.eeh_busy) {
+		ha->eeh_jif = jiffies;
+		ha->flags.eeh_flush = 0;
+
 		ha->flags.eeh_busy = 1;
 		do_cleanup = true;
 	}


