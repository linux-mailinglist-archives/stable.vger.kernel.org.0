Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844172A520A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731153AbgKCUqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbgKCUqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63817223FD;
        Tue,  3 Nov 2020 20:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436368;
        bh=IGD3QrIt2NG33JUC1teWQNkm1+ENNM39+4m66PlKT+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7U2zH4RgpqR9Mv1v7qPTkUxx+Q3jmlTK1oSlEyL/upS1M3OUQYtDWw5V87PSZ2fU
         gl/WXDCL4eJwJi4/2coD0pY/FgzOT/6MMyXGm9MIfOeReuFcOpPg0c9Agn6WmCNccJ
         QkGx3X8OheM6X/3P9PHmiPDA/UdyoZ3qrdkB7zFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.9 218/391] scsi: qla2xxx: Fix reset of MPI firmware
Date:   Tue,  3 Nov 2020 21:34:29 +0100
Message-Id: <20201103203401.643859182@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit 3e6efab865ac943f4ec43913eb665695737112b0 upstream.

Normally, the MPI firmware is reset when an MPI dump is collected.  If an
unsaved MPI dump exists in the driver, though, an alternate mechanism is
used. This mechanism, which was not fully correct, is not recommended and
instead an MPI dump template walk is suggested to perform the MPI reset.

To allow for the MPI dump template walk, extra space is reserved in the MPI
dump buffer which gets used only when there is already an MPI dump in
place.

Link: https://lore.kernel.org/r/20200929102152.32278-5-njavali@marvell.com
Fixes: cbb01c2f2f63 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_attr.c |   10 ++++++--
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 
 drivers/scsi/qla2xxx/qla_init.c |    2 +
 drivers/scsi/qla2xxx/qla_tmpl.c |   49 ++++++++++------------------------------
 4 files changed, 23 insertions(+), 39 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -157,6 +157,14 @@ qla2x00_sysfs_write_fw_dump(struct file
 			       vha->host_no);
 		}
 		break;
+	case 10:
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+			ql_log(ql_log_info, vha, 0x70e9,
+			       "Issuing MPI firmware dump on host#%ld.\n",
+			       vha->host_no);
+			ha->isp_ops->mpi_fw_dump(vha, 0);
+		}
+		break;
 	}
 	return count;
 }
@@ -744,8 +752,6 @@ qla2x00_sysfs_write_reset(struct file *f
 			qla83xx_idc_audit(vha, IDC_AUDIT_TIMESTAMP);
 			qla83xx_idc_unlock(vha, 0);
 			break;
-		} else if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-			qla27xx_reset_mpi(vha);
 		} else {
 			/* Make sure FC side is not in reset */
 			WARN_ON_ONCE(qla2x00_wait_for_hba_online(vha) !=
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -938,6 +938,5 @@ extern void qla24xx_process_purex_list(s
 
 /* nvme.c */
 void qla_nvme_unregister_remote_port(struct fc_port *fcport);
-void qla27xx_reset_mpi(scsi_qla_host_t *vha);
 void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
 #endif /* _QLA_GBL_H */
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3298,6 +3298,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *v
 			    j, fwdt->dump_size);
 			dump_size += fwdt->dump_size;
 		}
+		/* Add space for spare MPI fw dump. */
+		dump_size += ha->fwdt[1].dump_size;
 	} else {
 		req_q_size = req->length * sizeof(request_t);
 		rsp_q_size = rsp->length * sizeof(response_t);
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -12,33 +12,6 @@
 #define IOBASE(vha)	IOBAR(ISPREG(vha))
 #define INVALID_ENTRY ((struct qla27xx_fwdt_entry *)0xffffffffffffffffUL)
 
-/* hardware_lock assumed held. */
-static void
-qla27xx_write_remote_reg(struct scsi_qla_host *vha,
-			 u32 addr, u32 data)
-{
-	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
-
-	ql_dbg(ql_dbg_misc, vha, 0xd300,
-	       "%s: addr/data = %xh/%xh\n", __func__, addr, data);
-
-	wrt_reg_dword(&reg->iobase_addr, 0x40);
-	wrt_reg_dword(&reg->iobase_c4, data);
-	wrt_reg_dword(&reg->iobase_window, addr);
-}
-
-void
-qla27xx_reset_mpi(scsi_qla_host_t *vha)
-{
-	ql_dbg(ql_dbg_misc + ql_dbg_verbose, vha, 0xd301,
-	       "Entered %s.\n", __func__);
-
-	qla27xx_write_remote_reg(vha, 0x104050, 0x40004);
-	qla27xx_write_remote_reg(vha, 0x10405c, 0x4);
-
-	vha->hw->stat.num_mpi_reset++;
-}
-
 static inline void
 qla27xx_insert16(uint16_t value, void *buf, ulong *len)
 {
@@ -1028,7 +1001,6 @@ void
 qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	ulong flags = 0;
-	bool need_mpi_reset = true;
 
 #ifndef __CHECKER__
 	if (!hardware_locked)
@@ -1036,14 +1008,20 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha,
 #endif
 	if (!vha->hw->mpi_fw_dump) {
 		ql_log(ql_log_warn, vha, 0x02f3, "-> mpi_fwdump no buffer\n");
-	} else if (vha->hw->mpi_fw_dumped) {
-		ql_log(ql_log_warn, vha, 0x02f4,
-		       "-> MPI firmware already dumped (%p) -- ignoring request\n",
-		       vha->hw->mpi_fw_dump);
 	} else {
 		struct fwdt *fwdt = &vha->hw->fwdt[1];
 		ulong len;
 		void *buf = vha->hw->mpi_fw_dump;
+		bool walk_template_only = false;
+
+		if (vha->hw->mpi_fw_dumped) {
+			/* Use the spare area for any further dumps. */
+			buf += fwdt->dump_size;
+			walk_template_only = true;
+			ql_log(ql_log_warn, vha, 0x02f4,
+			       "-> MPI firmware already dumped -- dump saving to temporary buffer %p.\n",
+			       buf);
+		}
 
 		ql_log(ql_log_warn, vha, 0x02f5, "-> fwdt1 running...\n");
 		if (!fwdt->template) {
@@ -1058,9 +1036,10 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha,
 			ql_log(ql_log_warn, vha, 0x02f7,
 			       "-> fwdt1 fwdump residual=%+ld\n",
 			       fwdt->dump_size - len);
-		} else {
-			need_mpi_reset = false;
 		}
+		vha->hw->stat.num_mpi_reset++;
+		if (walk_template_only)
+			goto bailout;
 
 		vha->hw->mpi_fw_dump_len = len;
 		vha->hw->mpi_fw_dumped = 1;
@@ -1072,8 +1051,6 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha,
 	}
 
 bailout:
-	if (need_mpi_reset)
-		qla27xx_reset_mpi(vha);
 #ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);


