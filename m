Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D63420E26
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhJDNWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236300AbhJDNUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:20:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1741361B53;
        Mon,  4 Oct 2021 13:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352918;
        bh=1MSdX/7T85dYSahuEBGLAHfRw5oKIFE15uxVa3Nitjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyEZHjDYyp9SF1cDrGF7AwVaVshw+ejz1b1pXdewbybbiS8O8YZcF8YBnqyDvPDEu
         NUtDSoLsBXrOVBQe3VQ6d59ldtzi+ikP/6EojQ96w/cx6UpTJh4vSe+4J/wqcaRtGZ
         bsRZyc0btVzZ7WuwODDubPjWtN+pwBI5X2QuAlEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/93] scsi: qla2xxx: Changes to support kdump kernel for NVMe BFS
Date:   Mon,  4 Oct 2021 14:52:01 +0200
Message-Id: <20211004125034.697111153@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 4a0a542fe5e4273baf9228459ef3f75c29490cba ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |  1 -
 drivers/scsi/qla2xxx/qla_isr.c  |  2 ++
 drivers/scsi/qla2xxx/qla_nvme.c | 40 +++++++++++++++------------------
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 4f0486fe30dd..e1fd91a58120 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3913,7 +3913,6 @@ struct qla_hw_data {
 		uint32_t	scm_supported_f:1;
 				/* Enabled in Driver */
 		uint32_t	scm_enabled:1;
-		uint32_t	max_req_queue_warned:1;
 		uint32_t	plogi_template_valid:1;
 	} flags;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a24b82de4aab..5e040b6debc8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4158,6 +4158,8 @@ skip_msi:
 		ql_dbg(ql_dbg_init, vha, 0x0125,
 		    "INTa mode: Enabled.\n");
 		ha->flags.mr_intr_valid = 1;
+		/* Set max_qpair to 0, as MSI-X and MSI in not enabled */
+		ha->max_qpairs = 0;
 	}
 
 clear_risc_ints:
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index f6c76a063294..5acee3c798d4 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -109,19 +109,24 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
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
 
@@ -715,18 +720,9 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 
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
-- 
2.33.0



