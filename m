Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7C94F395A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbiDELcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353296AbiDEKF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:05:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8993BF02D;
        Tue,  5 Apr 2022 02:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 758A06157A;
        Tue,  5 Apr 2022 09:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F800C385A1;
        Tue,  5 Apr 2022 09:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152478;
        bh=/oKC84/WbxoCYlMiCfuJj/lbf7aFOvMbFYN9mk8q9Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2R/g/VMnLcgy68pt+WK1pI+6+AgPVRJzgouBge7PKujT8gkjCRAT7cXWxROnv9FMH
         NgwukwE5kpYxdJZShfNhh0EWbtV6N+jVW5PgwdEdPepy2fO81mYV5Vn/t0Xo4F0wKJ
         BcSjVOFJAZEttNfhOXXX+oqwv1A27nVCOI4UZD64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 792/913] scsi: qla2xxx: Fix premature hw access after PCI error
Date:   Tue,  5 Apr 2022 09:30:54 +0200
Message-Id: <20220405070403.574223588@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit e35920ab7874d5e2faeb4f958a74bfa793f1ce5a upstream.

After a recoverable PCI error has been detected and recovered, qla driver
needs to check to see if the error condition still persist and/or wait
for the OS to give the resume signal.

Sep  8 22:26:03 localhost kernel: WARNING: CPU: 9 PID: 124606 at qla_tmpl.c:440
qla27xx_fwdt_entry_t266+0x55/0x60 [qla2xxx]
Sep  8 22:26:03 localhost kernel: RIP: 0010:qla27xx_fwdt_entry_t266+0x55/0x60
[qla2xxx]
Sep  8 22:26:03 localhost kernel: Call Trace:
Sep  8 22:26:03 localhost kernel: ? qla27xx_walk_template+0xb1/0x1b0 [qla2xxx]
Sep  8 22:26:03 localhost kernel: ? qla27xx_execute_fwdt_template+0x12a/0x160
[qla2xxx]
Sep  8 22:26:03 localhost kernel: ? qla27xx_fwdump+0xa0/0x1c0 [qla2xxx]
Sep  8 22:26:03 localhost kernel: ? qla2xxx_pci_mmio_enabled+0xfb/0x120
[qla2xxx]
Sep  8 22:26:03 localhost kernel: ? report_mmio_enabled+0x44/0x80
Sep  8 22:26:03 localhost kernel: ? report_slot_reset+0x80/0x80
Sep  8 22:26:03 localhost kernel: ? pci_walk_bus+0x70/0x90
Sep  8 22:26:03 localhost kernel: ? aer_dev_correctable_show+0xc0/0xc0
Sep  8 22:26:03 localhost kernel: ? pcie_do_recovery+0x1bb/0x240
Sep  8 22:26:03 localhost kernel: ? aer_recover_work_func+0xaa/0xd0
Sep  8 22:26:03 localhost kernel: ? process_one_work+0x1a7/0x360
..
Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-8041:22: detected PCI
disconnect.
Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-107ff:22:
qla27xx_fwdt_entry_t262: dump ram MB failed. Area 5h start 198013h end 198013h
Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-107ff:22: Unable to
capture FW dump
Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-1015:22: cmd=0x0,
waited 5221 msecs
Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-680d:22: mmio
enabled returning.
Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-d04c:22: MBX
Command timeout for cmd 0, iocontrol=ffffffff jiffies=10140f2e5
mb[0-3]=[0xffff 0xffff 0xffff 0xffff]

Link: https://lore.kernel.org/r/20220110050218.3958-6-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c   |   10 +++++++++-
 drivers/scsi/qla2xxx/qla_tmpl.c |    9 +++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7641,7 +7641,7 @@ qla2xxx_pci_error_detected(struct pci_de
 
 	switch (state) {
 	case pci_channel_io_normal:
-		ha->flags.eeh_busy = 0;
+		qla_pci_set_eeh_busy(vha);
 		if (ql2xmqsupport || ql2xnvmeenable) {
 			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
@@ -7682,9 +7682,16 @@ qla2xxx_pci_mmio_enabled(struct pci_dev
 	       "mmio enabled\n");
 
 	ha->pci_error_state = QLA_PCI_MMIO_ENABLED;
+
 	if (IS_QLA82XX(ha))
 		return PCI_ERS_RESULT_RECOVERED;
 
+	if (qla2x00_isp_reg_stat(ha)) {
+		ql_log(ql_log_info, base_vha, 0x803f,
+		    "During mmio enabled, PCI/Register disconnect still detected.\n");
+		goto out;
+	}
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)){
 		stat = rd_reg_word(&reg->hccr);
@@ -7706,6 +7713,7 @@ qla2xxx_pci_mmio_enabled(struct pci_dev
 		    "RISC paused -- mmio_enabled, Dumping firmware.\n");
 		qla2xxx_dump_fw(base_vha);
 	}
+out:
 	/* set PCI_ERS_RESULT_NEED_RESET to trigger call to qla2xxx_pci_slot_reset */
 	ql_dbg(ql_dbg_aer, base_vha, 0x600d,
 	       "mmio enabled returning.\n");
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -435,8 +435,13 @@ qla27xx_fwdt_entry_t266(struct scsi_qla_
 {
 	ql_dbg(ql_dbg_misc, vha, 0xd20a,
 	    "%s: reset risc [%lx]\n", __func__, *len);
-	if (buf)
-		WARN_ON_ONCE(qla24xx_soft_reset(vha->hw) != QLA_SUCCESS);
+	if (buf) {
+		if (qla24xx_soft_reset(vha->hw) != QLA_SUCCESS) {
+			ql_dbg(ql_dbg_async, vha, 0x5001,
+			    "%s: unable to soft reset\n", __func__);
+			return INVALID_ENTRY;
+		}
+	}
 
 	return qla27xx_next_entry(ent);
 }


