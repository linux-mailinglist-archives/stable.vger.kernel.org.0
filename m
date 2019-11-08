Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE1F49ED
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390894AbfKHMGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:06:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389358AbfKHLlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFEF1222CE;
        Fri,  8 Nov 2019 11:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213280;
        bh=dCT13uGBIsVx/oGMOfn3IyzwIG3bK91+YxGQFljnVqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9muJ4FPPYxpGBpLbXkVqHDxf9Swk4xgh1h4jmVHduFavQjgDyqN9Q2Jp8Eb3fj+y
         cA5JvN/qZIczGDBgUr36saDVVdsaM4EX59Jf0rT9xvZAvs4o//lE1AD6i3jjKTmUry
         lKLhjc4T0fQUmXfpyzfzDqL0Lhids4luWu8Ij3FE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 141/205] scsi: qla2xxx: Fix deadlock between ATIO and HW lock
Date:   Fri,  8 Nov 2019 06:36:48 -0500
Message-Id: <20191108113752.12502-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

