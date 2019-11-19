Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13EB7101870
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbfKSFbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbfKSFbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87A7A208C3;
        Tue, 19 Nov 2019 05:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141475;
        bh=dCT13uGBIsVx/oGMOfn3IyzwIG3bK91+YxGQFljnVqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfGilmChu9hcEQql1oDp+HYo1uTvhSEzDnjoIAj+sxIY2ZjOF43LlBe09nQOrIin2
         Rk8RRdV6vrwjexbW9zve9E3NXkrw6w41zCpiAZtQkiEVKKSvQAwmBwbfV1Hl2xou0A
         Tk7ud8SmmNTOoDl2kFpqwtI1zgBz++SFEzdAFybE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 172/422] scsi: qla2xxx: Fix deadlock between ATIO and HW lock
Date:   Tue, 19 Nov 2019 06:16:09 +0100
Message-Id: <20191119051409.570618975@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 1073daa470d906f1853ed4b828f16e2350a5875c ]

Move ATIO queue processing out of hardware_lock to prevent deadlock.

Fixes: 3bb67df5b5f8 ("qla2xxx: Check for online flag instead of active reset when transmitting responses")
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 17 +++---------
 drivers/scsi/qla2xxx/qla_isr.c  | 48 +++++++++++++++------------------
 2 files changed, 26 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e5ecef94aebdb..733a55c09b1ca 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4869,19 +4869,10 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 			 */
 			if (qla_tgt_mode_enabled(vha) ||
 			    qla_dual_mode_enabled(vha)) {
-				if (IS_QLA27XX(ha) || IS_QLA83XX(ha)) {
-					spin_lock_irqsave(&ha->tgt.atio_lock,
-					    flags);
-					qlt_24xx_process_atio_queue(vha, 0);
-					spin_unlock_irqrestore(
-					    &ha->tgt.atio_lock, flags);
-				} else {
-					spin_lock_irqsave(&ha->hardware_lock,
-					    flags);
-					qlt_24xx_process_atio_queue(vha, 1);
-					spin_unlock_irqrestore(
-					    &ha->hardware_lock, flags);
-				}
+				spin_lock_irqsave(&ha->tgt.atio_lock, flags);
+				qlt_24xx_process_atio_queue(vha, 0);
+				spin_unlock_irqrestore(&ha->tgt.atio_lock,
+				    flags);
 			}
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 88d8acf86a2a4..f559beda8d5ad 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3121,6 +3121,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	uint16_t	mb[8];
 	struct rsp_que *rsp;
 	unsigned long	flags;
+	bool process_atio = false;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -3181,22 +3182,13 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			qla24xx_process_response_queue(vha, rsp);
 			break;
 		case INTR_ATIO_QUE_UPDATE_27XX:
-		case INTR_ATIO_QUE_UPDATE:{
-			unsigned long flags2;
-			spin_lock_irqsave(&ha->tgt.atio_lock, flags2);
-			qlt_24xx_process_atio_queue(vha, 1);
-			spin_unlock_irqrestore(&ha->tgt.atio_lock, flags2);
+		case INTR_ATIO_QUE_UPDATE:
+			process_atio = true;
 			break;
-		}
-		case INTR_ATIO_RSP_QUE_UPDATE: {
-			unsigned long flags2;
-			spin_lock_irqsave(&ha->tgt.atio_lock, flags2);
-			qlt_24xx_process_atio_queue(vha, 1);
-			spin_unlock_irqrestore(&ha->tgt.atio_lock, flags2);
-
+		case INTR_ATIO_RSP_QUE_UPDATE:
+			process_atio = true;
 			qla24xx_process_response_queue(vha, rsp);
 			break;
-		}
 		default:
 			ql_dbg(ql_dbg_async, vha, 0x504f,
 			    "Unrecognized interrupt type (%d).\n", stat * 0xff);
@@ -3210,6 +3202,12 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+	if (process_atio) {
+		spin_lock_irqsave(&ha->tgt.atio_lock, flags);
+		qlt_24xx_process_atio_queue(vha, 0);
+		spin_unlock_irqrestore(&ha->tgt.atio_lock, flags);
+	}
+
 	return IRQ_HANDLED;
 }
 
@@ -3256,6 +3254,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	uint32_t	hccr;
 	uint16_t	mb[8];
 	unsigned long flags;
+	bool process_atio = false;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -3312,22 +3311,13 @@ qla24xx_msix_default(int irq, void *dev_id)
 			qla24xx_process_response_queue(vha, rsp);
 			break;
 		case INTR_ATIO_QUE_UPDATE_27XX:
-		case INTR_ATIO_QUE_UPDATE:{
-			unsigned long flags2;
-			spin_lock_irqsave(&ha->tgt.atio_lock, flags2);
-			qlt_24xx_process_atio_queue(vha, 1);
-			spin_unlock_irqrestore(&ha->tgt.atio_lock, flags2);
+		case INTR_ATIO_QUE_UPDATE:
+			process_atio = true;
 			break;
-		}
-		case INTR_ATIO_RSP_QUE_UPDATE: {
-			unsigned long flags2;
-			spin_lock_irqsave(&ha->tgt.atio_lock, flags2);
-			qlt_24xx_process_atio_queue(vha, 1);
-			spin_unlock_irqrestore(&ha->tgt.atio_lock, flags2);
-
+		case INTR_ATIO_RSP_QUE_UPDATE:
+			process_atio = true;
 			qla24xx_process_response_queue(vha, rsp);
 			break;
-		}
 		default:
 			ql_dbg(ql_dbg_async, vha, 0x5051,
 			    "Unrecognized interrupt type (%d).\n", stat & 0xff);
@@ -3338,6 +3328,12 @@ qla24xx_msix_default(int irq, void *dev_id)
 	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+	if (process_atio) {
+		spin_lock_irqsave(&ha->tgt.atio_lock, flags);
+		qlt_24xx_process_atio_queue(vha, 0);
+		spin_unlock_irqrestore(&ha->tgt.atio_lock, flags);
+	}
+
 	return IRQ_HANDLED;
 }
 
-- 
2.20.1



