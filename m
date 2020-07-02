Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57421181D
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgGBBZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbgGBBXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB23C2082F;
        Thu,  2 Jul 2020 01:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653027;
        bh=en/aFQJyAVRxL52Micaqa7rQFOou5quQ6lPPSK0KI4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiltuNEUaf2nK9fFy4954kbSCIrSPpk6dggi0e2IMIACFAGcwvnQd3QSKs95vJ8ZS
         HgFIWFHJF/foD+R5vccTIXD457lRcfAbgJZGEs4UpNwRkBuN+NamZrsyLUfyVjrENP
         RFuXxOR6iACLs/ULMta3Txnvm1DpM0tDvKI39F+c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>, kbuild test robot <lkp@intel.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 42/53] scsi: qla2xxx: Fix MPI failure AEN (8200) handling
Date:   Wed,  1 Jul 2020 21:21:51 -0400
Message-Id: <20200702012202.2700645-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit cbb01c2f2f630f1497f703c51ff21538ae2d86b8 ]

Today, upon an MPI failure AEN, on top of collecting an MPI dump, a regular
firmware dump is also taken and then chip reset. This is disruptive to IOs
and not required. Make the firmware dump collection, followed by chip
reset, optional (not done by default).

Firmware dump buffer and MPI dump buffer are independent of each
other with this change and each can have dump that was taken at two
different times for two different issues. The MPI dump is saved in a
separate buffer and is retrieved differently from firmware dump.

To collect full dump on MPI failure AEN, a module parameter is
introduced:
    ql2xfulldump_on_mpifail (default: 0)

Link: https://lore.kernel.org/r/20200331104015.24868-2-njavali@marvell.com
Reported-by: kbuild test robot <lkp@intel.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |  30 +++++++-
 drivers/scsi/qla2xxx/qla_def.h  |  13 +++-
 drivers/scsi/qla2xxx/qla_gbl.h  |   3 +
 drivers/scsi/qla2xxx/qla_init.c |   2 +
 drivers/scsi/qla2xxx/qla_isr.c  |  54 +++++++++-----
 drivers/scsi/qla2xxx/qla_os.c   |   6 ++
 drivers/scsi/qla2xxx/qla_tmpl.c | 121 ++++++++++++++++++++++++++------
 7 files changed, 186 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2c9e5ac24692d..c4917f441b10a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -26,7 +26,8 @@ qla2x00_sysfs_read_fw_dump(struct file *filp, struct kobject *kobj,
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
-	if (!(ha->fw_dump_reading || ha->mctp_dump_reading))
+	if (!(ha->fw_dump_reading || ha->mctp_dump_reading ||
+	      ha->mpi_fw_dump_reading))
 		return 0;
 
 	mutex_lock(&ha->optrom_mutex);
@@ -42,6 +43,10 @@ qla2x00_sysfs_read_fw_dump(struct file *filp, struct kobject *kobj,
 	} else if (ha->mctp_dumped && ha->mctp_dump_reading) {
 		rval = memory_read_from_buffer(buf, count, &off, ha->mctp_dump,
 		    MCTP_DUMP_SIZE);
+	} else if (ha->mpi_fw_dumped && ha->mpi_fw_dump_reading) {
+		rval = memory_read_from_buffer(buf, count, &off,
+					       ha->mpi_fw_dump,
+					       ha->mpi_fw_dump_len);
 	} else if (ha->fw_dump_reading) {
 		rval = memory_read_from_buffer(buf, count, &off, ha->fw_dump,
 					ha->fw_dump_len);
@@ -103,7 +108,6 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 			qla82xx_set_reset_owner(vha);
 			qla8044_idc_unlock(ha);
 		} else {
-			ha->fw_dump_mpi = 1;
 			qla2x00_system_error(vha);
 		}
 		break;
@@ -137,6 +141,22 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 			    vha->host_no);
 		}
 		break;
+	case 8:
+		if (!ha->mpi_fw_dump_reading)
+			break;
+		ql_log(ql_log_info, vha, 0x70e7,
+		       "MPI firmware dump cleared on (%ld).\n", vha->host_no);
+		ha->mpi_fw_dump_reading = 0;
+		ha->mpi_fw_dumped = 0;
+		break;
+	case 9:
+		if (ha->mpi_fw_dumped && !ha->mpi_fw_dump_reading) {
+			ha->mpi_fw_dump_reading = 1;
+			ql_log(ql_log_info, vha, 0x70e8,
+			       "Raw MPI firmware dump ready for read on (%ld).\n",
+			       vha->host_no);
+		}
+		break;
 	}
 	return count;
 }
@@ -706,7 +726,8 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 		scsi_unblock_requests(vha->host);
 		break;
 	case 0x2025d:
-		if (!IS_QLA81XX(ha) && !IS_QLA83XX(ha))
+		if (!IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
+		    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
 			return -EPERM;
 
 		ql_log(ql_log_info, vha, 0x706f,
@@ -724,6 +745,8 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 			qla83xx_idc_audit(vha, IDC_AUDIT_TIMESTAMP);
 			qla83xx_idc_unlock(vha, 0);
 			break;
+		} else if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+			qla27xx_reset_mpi(vha);
 		} else {
 			/* Make sure FC side is not in reset */
 			WARN_ON_ONCE(qla2x00_wait_for_hba_online(vha) !=
@@ -737,6 +760,7 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 			scsi_unblock_requests(vha->host);
 			break;
 		}
+		break;
 	case 0x2025e:
 		if (!IS_P3P_TYPE(ha) || vha != base_vha) {
 			ql_log(ql_log_info, vha, 0x7071,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 47c7a56438b54..daa9e936887bb 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3223,6 +3223,7 @@ struct isp_operations {
 		uint32_t);
 
 	void (*fw_dump) (struct scsi_qla_host *, int);
+	void (*mpi_fw_dump)(struct scsi_qla_host *, int);
 
 	int (*beacon_on) (struct scsi_qla_host *);
 	int (*beacon_off) (struct scsi_qla_host *);
@@ -3748,6 +3749,11 @@ struct qlt_hw_data {
 
 #define LEAK_EXCHG_THRESH_HOLD_PERCENT 75	/* 75 percent */
 
+struct qla_hw_data_stat {
+	u32 num_fw_dump;
+	u32 num_mpi_reset;
+};
+
 /*
  * Qlogic host adapter specific data structure.
 */
@@ -4230,7 +4236,6 @@ struct qla_hw_data {
 	uint32_t	fw_dump_len;
 	u32		fw_dump_alloc_len;
 	bool		fw_dumped;
-	bool		fw_dump_mpi;
 	unsigned long	fw_dump_cap_flags;
 #define RISC_PAUSE_CMPL		0
 #define DMA_SHUTDOWN_CMPL	1
@@ -4241,6 +4246,10 @@ struct qla_hw_data {
 #define ISP_MBX_RDY		6
 #define ISP_SOFT_RESET_CMPL	7
 	int		fw_dump_reading;
+	void		*mpi_fw_dump;
+	u32		mpi_fw_dump_len;
+	int		mpi_fw_dump_reading:1;
+	int		mpi_fw_dumped:1;
 	int		prev_minidump_failed;
 	dma_addr_t	eft_dma;
 	void		*eft;
@@ -4454,6 +4463,8 @@ struct qla_hw_data {
 	uint16_t last_zio_threshold;
 
 #define DEFAULT_ZIO_THRESHOLD 5
+
+	struct qla_hw_data_stat stat;
 };
 
 struct active_regions {
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 1b93f5b4d77d9..b20c5fa122fb2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -173,6 +173,7 @@ extern int ql2xenablemsix;
 extern int qla2xuseresexchforels;
 extern int ql2xexlogins;
 extern int ql2xdifbundlinginternalbuffers;
+extern int ql2xfulldump_on_mpifail;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
@@ -645,6 +646,7 @@ extern void qla82xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla8044_fw_dump(scsi_qla_host_t *, int);
 
 extern void qla27xx_fwdump(scsi_qla_host_t *, int);
+extern void qla27xx_mpi_fwdump(scsi_qla_host_t *, int);
 extern ulong qla27xx_fwdt_calculate_dump_size(struct scsi_qla_host *, void *);
 extern int qla27xx_fwdt_template_valid(void *);
 extern ulong qla27xx_fwdt_template_size(void *);
@@ -933,5 +935,6 @@ extern void qla24xx_process_purex_list(struct purex_list *);
 
 /* nvme.c */
 void qla_nvme_unregister_remote_port(struct fc_port *fcport);
+void qla27xx_reset_mpi(scsi_qla_host_t *vha);
 void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index caa6b840e4594..496ead29b51e4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3339,6 +3339,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 				    dump_size / 1024);
 
 				if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+					ha->mpi_fw_dump = (char *)fw_dump +
+						ha->fwdt[1].dump_size;
 					mutex_unlock(&ha->optrom_mutex);
 					return;
 				}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8a78d395bbc8f..4d9ec7ee59cc7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -756,6 +756,39 @@ qla2x00_find_fcport_by_nportid(scsi_qla_host_t *vha, port_id_t *id,
 	return NULL;
 }
 
+/* Shall be called only on supported adapters. */
+static void
+qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
+{
+	struct qla_hw_data *ha = vha->hw;
+	bool reset_isp_needed = 0;
+
+	ql_log(ql_log_warn, vha, 0x02f0,
+	       "MPI Heartbeat stop. MPI reset is%s needed. "
+	       "MB0[%xh] MB1[%xh] MB2[%xh] MB3[%xh]\n",
+	       mb[0] & BIT_8 ? "" : " not",
+	       mb[0], mb[1], mb[2], mb[3]);
+
+	if ((mb[1] & BIT_8) == 0)
+		return;
+
+	ql_log(ql_log_warn, vha, 0x02f1,
+	       "MPI Heartbeat stop. FW dump needed\n");
+
+	if (ql2xfulldump_on_mpifail) {
+		ha->isp_ops->fw_dump(vha, 1);
+		reset_isp_needed = 1;
+	}
+
+	ha->isp_ops->mpi_fw_dump(vha, 1);
+
+	if (reset_isp_needed) {
+		vha->hw->flags.fw_init_done = 0;
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+	}
+}
+
 /**
  * qla2x00_async_event() - Process aynchronous events.
  * @vha: SCSI driver HA context
@@ -871,9 +904,9 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n ",
 			    mb[1], mb[2], mb[3]);
 
-		ha->fw_dump_mpi =
-		    (IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
-		    RD_REG_WORD(&reg24->mailbox7) & BIT_8;
+		if ((IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
+		    RD_REG_WORD(&reg24->mailbox7) & BIT_8)
+			ha->isp_ops->mpi_fw_dump(vha, 1);
 		ha->isp_ops->fw_dump(vha, 1);
 		ha->flags.fw_init_done = 0;
 		QLA_FW_STOPPED(ha);
@@ -1374,20 +1407,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 
 	case MBA_IDC_AEN:
 		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-			ha->flags.fw_init_done = 0;
-			ql_log(ql_log_warn, vha, 0xffff,
-			    "MPI Heartbeat stop. Chip reset needed. MB0[%xh] MB1[%xh] MB2[%xh] MB3[%xh]\n",
-			    mb[0], mb[1], mb[2], mb[3]);
-
-			if ((mb[1] & BIT_8) ||
-			    (mb[2] & BIT_8)) {
-				ql_log(ql_log_warn, vha, 0xd013,
-				    "MPI Heartbeat stop. FW dump needed\n");
-				ha->fw_dump_mpi = 1;
-				ha->isp_ops->fw_dump(vha, 1);
-			}
-			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-			qla2xxx_wake_dpc(vha);
+			qla27xx_handle_8200_aen(vha, mb);
 		} else if (IS_QLA83XX(ha)) {
 			mb[4] = RD_REG_WORD(&reg24->mailbox4);
 			mb[5] = RD_REG_WORD(&reg24->mailbox5);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9179bb4caed84..1120d133204c2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -35,6 +35,11 @@ static int apidev_major;
  */
 struct kmem_cache *srb_cachep;
 
+int ql2xfulldump_on_mpifail;
+module_param(ql2xfulldump_on_mpifail, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
+		 "Set this to take full dump on MPI hang.");
+
 /*
  * CT6 CTX allocation cache
  */
@@ -2518,6 +2523,7 @@ static struct isp_operations qla27xx_isp_ops = {
 	.read_nvram		= NULL,
 	.write_nvram		= NULL,
 	.fw_dump		= qla27xx_fwdump,
+	.mpi_fw_dump		= qla27xx_mpi_fwdump,
 	.beacon_on		= qla24xx_beacon_on,
 	.beacon_off		= qla24xx_beacon_off,
 	.beacon_blink		= qla83xx_beacon_blink,
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 6aeb1c3fb7a87..3423638624344 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -12,6 +12,33 @@
 #define IOBASE(vha)	IOBAR(ISPREG(vha))
 #define INVALID_ENTRY ((struct qla27xx_fwdt_entry *)0xffffffffffffffffUL)
 
+/* hardware_lock assumed held. */
+static void
+qla27xx_write_remote_reg(struct scsi_qla_host *vha,
+			 u32 addr, u32 data)
+{
+	char *reg = (char *)ISPREG(vha);
+
+	ql_dbg(ql_dbg_misc, vha, 0xd300,
+	       "%s: addr/data = %xh/%xh\n", __func__, addr, data);
+
+	WRT_REG_DWORD(reg + IOBASE(vha), 0x40);
+	WRT_REG_DWORD(reg + 0xc4, data);
+	WRT_REG_DWORD(reg + 0xc0, addr);
+}
+
+void
+qla27xx_reset_mpi(scsi_qla_host_t *vha)
+{
+	ql_dbg(ql_dbg_misc + ql_dbg_verbose, vha, 0xd301,
+	       "Entered %s.\n", __func__);
+
+	qla27xx_write_remote_reg(vha, 0x104050, 0x40004);
+	qla27xx_write_remote_reg(vha, 0x10405c, 0x4);
+
+	vha->hw->stat.num_mpi_reset++;
+}
+
 static inline void
 qla27xx_insert16(uint16_t value, void *buf, ulong *len)
 {
@@ -997,6 +1024,62 @@ qla27xx_fwdt_template_valid(void *p)
 	return true;
 }
 
+void
+qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
+{
+	ulong flags = 0;
+	bool need_mpi_reset = 1;
+
+#ifndef __CHECKER__
+	if (!hardware_locked)
+		spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+#endif
+	if (!vha->hw->mpi_fw_dump) {
+		ql_log(ql_log_warn, vha, 0x02f3, "-> mpi_fwdump no buffer\n");
+	} else if (vha->hw->mpi_fw_dumped) {
+		ql_log(ql_log_warn, vha, 0x02f4,
+		       "-> MPI firmware already dumped (%p) -- ignoring request\n",
+		       vha->hw->mpi_fw_dump);
+	} else {
+		struct fwdt *fwdt = &vha->hw->fwdt[1];
+		ulong len;
+		void *buf = vha->hw->mpi_fw_dump;
+
+		ql_log(ql_log_warn, vha, 0x02f5, "-> fwdt1 running...\n");
+		if (!fwdt->template) {
+			ql_log(ql_log_warn, vha, 0x02f6,
+			       "-> fwdt1 no template\n");
+			goto bailout;
+		}
+		len = qla27xx_execute_fwdt_template(vha, fwdt->template, buf);
+		if (len == 0) {
+			goto bailout;
+		} else if (len != fwdt->dump_size) {
+			ql_log(ql_log_warn, vha, 0x02f7,
+			       "-> fwdt1 fwdump residual=%+ld\n",
+			       fwdt->dump_size - len);
+		} else {
+			need_mpi_reset = 0;
+		}
+
+		vha->hw->mpi_fw_dump_len = len;
+		vha->hw->mpi_fw_dumped = 1;
+
+		ql_log(ql_log_warn, vha, 0x02f8,
+		       "-> MPI firmware dump saved to buffer (%lu/%p)\n",
+		       vha->host_no, vha->hw->mpi_fw_dump);
+		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
+	}
+
+bailout:
+	if (need_mpi_reset)
+		qla27xx_reset_mpi(vha);
+#ifndef __CHECKER__
+	if (!hardware_locked)
+		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+#endif
+}
+
 void
 qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 {
@@ -1015,30 +1098,25 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 		    vha->hw->fw_dump);
 	} else {
 		struct fwdt *fwdt = vha->hw->fwdt;
-		uint j;
 		ulong len;
 		void *buf = vha->hw->fw_dump;
-		uint count = vha->hw->fw_dump_mpi ? 2 : 1;
-
-		for (j = 0; j < count; j++, fwdt++, buf += len) {
-			ql_log(ql_log_warn, vha, 0xd011,
-			    "-> fwdt%u running...\n", j);
-			if (!fwdt->template) {
-				ql_log(ql_log_warn, vha, 0xd012,
-				    "-> fwdt%u no template\n", j);
-				break;
-			}
-			len = qla27xx_execute_fwdt_template(vha,
-			    fwdt->template, buf);
-			if (len == 0) {
-				goto bailout;
-			} else if (len != fwdt->dump_size) {
-				ql_log(ql_log_warn, vha, 0xd013,
-				    "-> fwdt%u fwdump residual=%+ld\n",
-				    j, fwdt->dump_size - len);
-			}
+
+		ql_log(ql_log_warn, vha, 0xd011, "-> fwdt0 running...\n");
+		if (!fwdt->template) {
+			ql_log(ql_log_warn, vha, 0xd012,
+			       "-> fwdt0 no template\n");
+			goto bailout;
 		}
-		vha->hw->fw_dump_len = buf - (void *)vha->hw->fw_dump;
+		len = qla27xx_execute_fwdt_template(vha, fwdt->template, buf);
+		if (len == 0) {
+			goto bailout;
+		} else if (len != fwdt->dump_size) {
+			ql_log(ql_log_warn, vha, 0xd013,
+			       "-> fwdt0 fwdump residual=%+ld\n",
+				fwdt->dump_size - len);
+		}
+
+		vha->hw->fw_dump_len = len;
 		vha->hw->fw_dumped = 1;
 
 		ql_log(ql_log_warn, vha, 0xd015,
@@ -1048,7 +1126,6 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 
 bailout:
-	vha->hw->fw_dump_mpi = 0;
 #ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
-- 
2.25.1

