Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98B040D991
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 14:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239369AbhIPMQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 08:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239161AbhIPMQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 08:16:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBFED60E52;
        Thu, 16 Sep 2021 12:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631794481;
        bh=ksO6oeLEuBMUfKkIGt5j+0hnyWg5E+bqbjpI8sEAeu8=;
        h=Subject:To:Cc:From:Date:From;
        b=SVmwklCG1u+2MKOfPoPYz2VbSQruN8t8kcrQttvVPZm0Ek+g0AHune/CFMSXqZf98
         +3xmP0VLZ/5OPz1Ih/tc3Q+Vrj5kN/03AUMdPB7UgOuBP/hGBMk5yGXszcHBnFreBL
         fS7r8Xz9IIxqJou4vwGN3p1xDYrZ2tg6ECebSAAw=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Changes to support kdump kernel for NVMe BFS" failed to apply to 5.13-stable tree
To:     skashyap@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 14:14:36 +0200
Message-ID: <16317944767888@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4a0a542fe5e4273baf9228459ef3f75c29490cba Mon Sep 17 00:00:00 2001
From: Saurav Kashyap <skashyap@marvell.com>
Date: Mon, 9 Aug 2021 21:37:18 -0700
Subject: [PATCH] scsi: qla2xxx: Changes to support kdump kernel for NVMe BFS

The MSI-X and MSI calls fails in kdump kernel. Because of this
qla2xxx_create_qpair() fails leading to .create_queue callback failure.
The fix is to return existing qpair instead of allocating new one and
allocate a single hw queue.

[   19.975838] qla2xxx [0000:d8:00.1]-00c7:11: MSI-X: Failed to enable support,
giving   up -- 16/-28.
[   19.984885] qla2xxx [0000:d8:00.1]-0037:11: Falling back-to MSI mode --
ret=-28.
[   19.992278] qla2xxx [0000:d8:00.1]-0039:11: Falling back-to INTa mode --
ret=-28.
..
..
..
[   21.141518] qla2xxx [0000:d8:00.0]-2104:2: qla_nvme_alloc_queue: handle
00000000e7ee499d, idx =1, qsize 32
[   21.151166] qla2xxx [0000:d8:00.0]-0181:2: FW/Driver is not multi-queue capable.
[   21.158558] qla2xxx [0000:d8:00.0]-2122:2: Failed to allocate qpair
[   21.164824] nvme nvme0: NVME-FC{0}: reset: Reconnect attempt failed (-22)
[   21.171612] nvme nvme0: NVME-FC{0}: Reconnect attempt in 2 seconds

Link: https://lore.kernel.org/r/20210810043720.1137-13-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 60702d066ed9..55175e8a0749 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4022,7 +4022,6 @@ struct qla_hw_data {
 				/* Enabled in Driver */
 		uint32_t	scm_enabled:1;
 		uint32_t	edif_enabled:1;
-		uint32_t	max_req_queue_warned:1;
 		uint32_t	plogi_template_valid:1;
 		uint32_t	port_isolated:1;
 	} flags;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 32fe9682dd9f..cb02dade85f8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4508,6 +4508,8 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		ql_dbg(ql_dbg_init, vha, 0x0125,
 		    "INTa mode: Enabled.\n");
 		ha->flags.mr_intr_valid = 1;
+		/* Set max_qpair to 0, as MSI-X and MSI in not enabled */
+		ha->max_qpairs = 0;
 	}
 
 clear_risc_ints:
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index fdac3f7fa080..b12e01dab88d 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -108,19 +108,24 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 		return -EINVAL;
 	}
 
-	if (ha->queue_pair_map[qidx]) {
-		*handle = ha->queue_pair_map[qidx];
-		ql_log(ql_log_info, vha, 0x2121,
-		    "Returning existing qpair of %p for idx=%x\n",
-		    *handle, qidx);
-		return 0;
-	}
+	/* Use base qpair if max_qpairs is 0 */
+	if (!ha->max_qpairs) {
+		qpair = ha->base_qpair;
+	} else {
+		if (ha->queue_pair_map[qidx]) {
+			*handle = ha->queue_pair_map[qidx];
+			ql_log(ql_log_info, vha, 0x2121,
+			       "Returning existing qpair of %p for idx=%x\n",
+			       *handle, qidx);
+			return 0;
+		}
 
-	qpair = qla2xxx_create_qpair(vha, 5, vha->vp_idx, true);
-	if (qpair == NULL) {
-		ql_log(ql_log_warn, vha, 0x2122,
-		    "Failed to allocate qpair\n");
-		return -EINVAL;
+		qpair = qla2xxx_create_qpair(vha, 5, vha->vp_idx, true);
+		if (!qpair) {
+			ql_log(ql_log_warn, vha, 0x2122,
+			       "Failed to allocate qpair\n");
+			return -EINVAL;
+		}
 	}
 	*handle = qpair;
 
@@ -731,18 +736,9 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 
 	WARN_ON(vha->nvme_local_port);
 
-	if (ha->max_req_queues < 3) {
-		if (!ha->flags.max_req_queue_warned)
-			ql_log(ql_log_info, vha, 0x2120,
-			       "%s: Disabling FC-NVME due to lack of free queue pairs (%d).\n",
-			       __func__, ha->max_req_queues);
-		ha->flags.max_req_queue_warned = 1;
-		return ret;
-	}
-
 	qla_nvme_fc_transport.max_hw_queues =
 	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
-		(uint8_t)(ha->max_req_queues - 2));
+		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
 
 	pinfo.node_name = wwn_to_u64(vha->node_name);
 	pinfo.port_name = wwn_to_u64(vha->port_name);

