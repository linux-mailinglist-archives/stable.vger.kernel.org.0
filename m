Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92D42F9A56
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 08:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbhARHH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 02:07:27 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:48144 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730433AbhARHH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 02:07:26 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 214A8412ED;
        Mon, 18 Jan 2021 07:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1610953602; x=
        1612768003; bh=hhle16S0/J3MZmEVmyrK/xm9DzNqb3MgPk5rabZDex0=; b=U
        Xvwg3qvDczeeI/1WZGc6RBJ3vRm22yga7bYGD1LzVDK9mKrbTSaKaM7puX9IHste
        EntVldZN9YTbItnG84mmg/2hrJIZWXiO2yUKwJSdYY6irlY1hsv6a+J9h6ayS7A4
        ifbfnmps5UD12Ng8VDH/kaed1ab+JPVAU/tGegAX/U=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ocS7ykBsy4jB; Mon, 18 Jan 2021 10:06:42 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3C8A841273;
        Mon, 18 Jan 2021 10:06:42 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 18
 Jan 2021 10:06:42 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Andrew Vasquez <andrewv@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] Revert "scsi: qla2xxx: Use a dedicated interrupt handler for 'handshake-required' ISPs"
Date:   Mon, 18 Jan 2021 10:06:38 +0300
Message-ID: <20210118070638.9250-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 7b2a73963c91cf6bad6b8f58636560cd1f3cf319.

The offending commit is setting up interrupt handlers in
qla25xx_create_rsp_que() before disable_msix_handshake is set up for
pure target mode in qla24xx_config_rings(). That leads to a case when
host always clears interrupt bit in HCCR despite that's not needed.
Shortly afterwards firmware stops sending interrupts.

Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Andrew Vasquez <andrewv@marvell.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org # >= v5.7
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 -
 drivers/scsi/qla2xxx/qla_gbl.h |  2 --
 drivers/scsi/qla2xxx/qla_isr.c | 31 +++++++------------------------
 drivers/scsi/qla2xxx/qla_mid.c |  3 +--
 4 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 30c7e5e63851..8490b41d2353 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3328,7 +3328,6 @@ struct isp_operations {
 #define QLA_MSIX_RSP_Q			0x01
 #define QLA_ATIO_VECTOR		0x02
 #define QLA_MSIX_QPAIR_MULTIQ_RSP_Q	0x03
-#define QLA_MSIX_QPAIR_MULTIQ_RSP_Q_HS	0x04
 
 #define QLA_MIDX_DEFAULT	0
 #define QLA_MIDX_RSP_Q		1
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e39b4f2da73a..0f626e212e8b 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -570,8 +570,6 @@ qla2x00_process_completed_request(struct scsi_qla_host *, struct req_que *,
 	uint32_t);
 extern irqreturn_t
 qla2xxx_msix_rsp_q(int irq, void *dev_id);
-extern irqreturn_t
-qla2xxx_msix_rsp_q_hs(int irq, void *dev_id);
 fc_port_t *qla2x00_find_fcport_by_loopid(scsi_qla_host_t *, uint16_t);
 fc_port_t *qla2x00_find_fcport_by_wwpn(scsi_qla_host_t *, u8 *, u8);
 fc_port_t *qla2x00_find_fcport_by_nportid(scsi_qla_host_t *, port_id_t *, u8);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f9142dbec112..f18d46b0efe0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3895,25 +3895,6 @@ qla24xx_msix_default(int irq, void *dev_id)
 
 irqreturn_t
 qla2xxx_msix_rsp_q(int irq, void *dev_id)
-{
-	struct qla_hw_data *ha;
-	struct qla_qpair *qpair;
-
-	qpair = dev_id;
-	if (!qpair) {
-		ql_log(ql_log_info, NULL, 0x505b,
-		    "%s: NULL response queue pointer.\n", __func__);
-		return IRQ_NONE;
-	}
-	ha = qpair->hw;
-
-	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
-
-	return IRQ_HANDLED;
-}
-
-irqreturn_t
-qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
 {
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
@@ -3928,10 +3909,13 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
 	}
 	ha = qpair->hw;
 
-	reg = &ha->iobase->isp24;
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	/* Clear the interrupt, if enabled, for this response queue */
+	if (unlikely(!ha->flags.disable_msix_handshake)) {
+		reg = &ha->iobase->isp24;
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	}
 
 	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
 
@@ -3950,7 +3934,6 @@ static const struct qla_init_msix_entry msix_entries[] = {
 	{ "rsp_q", qla24xx_msix_rsp_q },
 	{ "atio_q", qla83xx_msix_atio_q },
 	{ "qpair_multiq", qla2xxx_msix_rsp_q },
-	{ "qpair_multiq_hs", qla2xxx_msix_rsp_q_hs },
 };
 
 static const struct qla_init_msix_entry qla82xx_msix_entries[] = {
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c7caf322f445..7e15dc358f04 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -893,8 +893,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	    rsp->rsp_q_out);
 
 	ret = qla25xx_request_irq(ha, qpair, qpair->msix,
-		ha->flags.disable_msix_handshake ?
-		QLA_MSIX_QPAIR_MULTIQ_RSP_Q : QLA_MSIX_QPAIR_MULTIQ_RSP_Q_HS);
+	    QLA_MSIX_QPAIR_MULTIQ_RSP_Q);
 	if (ret)
 		goto que_failed;
 
-- 
2.30.0

