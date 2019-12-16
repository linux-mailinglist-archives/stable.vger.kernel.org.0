Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F3B1214A6
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfLPSNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731082AbfLPSNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C392D207FF;
        Mon, 16 Dec 2019 18:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519996;
        bh=GPmgw5NZ3Wo99UcsvM0MofrYXw6eZWUQgcBxGmh+Jp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doh11DFFG6bcbfyUKDV9mBhllnIpEJM773L5UWFCvUkumLSpFNAnQYEt0LDzmR8cY
         taamyFwPqH0s+THNhCiZDts8kX2yIpQ8ZkQlkCeUC4dk1fH3/761hZ+p8a8/DYR3WP
         NCricn9vLBlim7KhIFwQdKLQ+wz0eIB5pIYUS6EY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 153/180] scsi: qla2xxx: Fix driver reload for ISP82xx
Date:   Mon, 16 Dec 2019 18:49:53 +0100
Message-Id: <20191216174844.448888662@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit 32a13df21668b92f70f0673387f29251e0f285ec ]

HINT_MBX_INT_PENDING is not guaranteed to be cleared by firmware. Remove
check that prevent driver load with ISP82XX.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Link: https://lore.kernel.org/r/20190830222402.23688-4-hmadhani@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 16 ++--------------
 drivers/scsi/qla2xxx/qla_nx.c  |  3 ++-
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ac4640f456786..45548628c6f3e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -253,21 +253,9 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	if ((!abort_active && io_lock_on) || IS_NOPOLLING_TYPE(ha)) {
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
-		if (IS_P3P_TYPE(ha)) {
-			if (RD_REG_DWORD(&reg->isp82.hint) &
-				HINT_MBX_INT_PENDING) {
-				ha->flags.mbox_busy = 0;
-				spin_unlock_irqrestore(&ha->hardware_lock,
-					flags);
-
-				atomic_dec(&ha->num_pend_mbx_stage2);
-				ql_dbg(ql_dbg_mbx, vha, 0x1010,
-				    "Pending mailbox timeout, exiting.\n");
-				rval = QLA_FUNCTION_TIMEOUT;
-				goto premature_exit;
-			}
+		if (IS_P3P_TYPE(ha))
 			WRT_REG_DWORD(&reg->isp82.hint, HINT_MBX_INT_PENDING);
-		} else if (IS_FWI2_CAPABLE(ha))
+		else if (IS_FWI2_CAPABLE(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 6ce0f026debb1..3a23827e0f0bc 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2287,7 +2287,8 @@ qla82xx_disable_intrs(struct qla_hw_data *ha)
 {
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
-	qla82xx_mbx_intr_disable(vha);
+	if (ha->interrupts_on)
+		qla82xx_mbx_intr_disable(vha);
 
 	spin_lock_irq(&ha->hardware_lock);
 	if (IS_QLA8044(ha))
-- 
2.20.1



