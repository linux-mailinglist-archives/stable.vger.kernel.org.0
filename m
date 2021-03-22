Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0B6344294
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhCVMnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhCVMlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B54619C8;
        Mon, 22 Mar 2021 12:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416756;
        bh=XN+SzYjQA28BuanBUuph0uDTM2ITIbCpMbnWGhB+0l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Xa1uhTMHxdd5i8TfA8uYZs0i6x3WRxdLPJfW9iucr66Vo0FoOwz9eS8uN6LQclXp
         cBYcSs4bp/gZePiZWljwmF/n6uP35QYr22ytjCa/IyVUp6H9deoyowYg13SXtnzeEM
         KjfrlTo5RinuuiuvXK0DFjXCQ1muW0Pp9YKIt5Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        peter chang <dpf@google.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Radha Ramachandran <radha@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/157] scsi: pm80xx: Make mpi_build_cmd locking consistent
Date:   Mon, 22 Mar 2021 13:27:12 +0100
Message-Id: <20210322121936.141537576@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: peter chang <dpf@google.com>

[ Upstream commit 7640e1eb8c5de33dafa6c68fd4389214ff9ec1f9 ]

Driver submits all internal requests (like abort_task, event acknowledgment
etc.) through inbound queue 0. While submitting those, driver does not
acquire any lock and this may lead to a race when there is an I/O request
coming in on CPU0 and submitted through inbound queue 0.  To avoid this,
lock acquisition has been moved to pm8001_mpi_build_cmd().  All command
submission will go through this path.

Link: https://lore.kernel.org/r/20201102165528.26510-2-Viswas.G@microchip.com.com
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: peter chang <dpf@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 21 +++++++++++++++------
 drivers/scsi/pm8001/pm80xx_hwi.c |  8 --------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2b7b2954ec31..597d7a096a97 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1356,12 +1356,19 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 {
 	u32 Header = 0, hpriority = 0, bc = 1, category = 0x02;
 	void *pMessage;
-
-	if (pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
-		&pMessage) < 0) {
+	unsigned long flags;
+	int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
+	int rv = -1;
+
+	WARN_ON(q_index >= PM8001_MAX_INB_NUM);
+	spin_lock_irqsave(&circularQ->iq_lock, flags);
+	rv = pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
+			&pMessage);
+	if (rv < 0) {
 		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("No free mpi buffer\n"));
-		return -ENOMEM;
+			      pm8001_printk("No free mpi buffer\n"));
+		rv = -ENOMEM;
+		goto done;
 	}
 
 	if (nb > (pm8001_ha->iomb_size - sizeof(struct mpi_msg_hdr)))
@@ -1384,7 +1391,9 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 		pm8001_printk("INB Q %x OPCODE:%x , UPDATED PI=%d CI=%d\n",
 			responseQueue, opCode, circularQ->producer_idx,
 			circularQ->consumer_index));
-	return 0;
+done:
+	spin_unlock_irqrestore(&circularQ->iq_lock, flags);
+	return rv;
 }
 
 u32 pm8001_mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 155382ce8469..c9a89e980e1c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4281,7 +4281,6 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 	char *preq_dma_addr = NULL;
 	__le64 tmp_addr;
 	u32 i, length;
-	unsigned long flags;
 
 	memset(&smp_cmd, 0, sizeof(smp_cmd));
 	/*
@@ -4377,10 +4376,8 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag,
 				&smp_cmd, pm8001_ha->smp_exp_mode, length);
-	spin_lock_irqsave(&circularQ->iq_lock, flags);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &smp_cmd,
 			sizeof(smp_cmd), 0);
-	spin_unlock_irqrestore(&circularQ->iq_lock, flags);
 	if (rc)
 		goto err_out_2;
 	return 0;
@@ -4444,7 +4441,6 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	u64 phys_addr, start_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	struct inbound_queue_table *circularQ;
-	unsigned long flags;
 	u32 q_index, cpu_id;
 	u32 opc = OPC_INB_SSPINIIOSTART;
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
@@ -4582,10 +4578,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 			ssp_cmd.esgl = 0;
 		}
 	}
-	spin_lock_irqsave(&circularQ->iq_lock, flags);
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
 			&ssp_cmd, sizeof(ssp_cmd), q_index);
-	spin_unlock_irqrestore(&circularQ->iq_lock, flags);
 	return ret;
 }
 
@@ -4819,10 +4813,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			}
 		}
 	}
-	spin_lock_irqsave(&circularQ->iq_lock, flags);
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
 			&sata_cmd, sizeof(sata_cmd), q_index);
-	spin_unlock_irqrestore(&circularQ->iq_lock, flags);
 	return ret;
 }
 
-- 
2.30.1



