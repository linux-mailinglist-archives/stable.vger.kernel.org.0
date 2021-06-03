Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3844A39A8D8
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhFCRSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233695AbhFCRQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:16:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C41F9613F8;
        Thu,  3 Jun 2021 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740286;
        bh=NcClO2qhll0tcwIBkMTz8t4nm6/LZs5IVVsCDQxn3UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2coQUMBI2N1Y0wBDdVmIEABPuqF5xzMLvDuhhmwoOTK+50A/X7fBHC4j2vaINEf/
         0mz2CmzK0eJ1WC64blGhhWLWjAcR6MNhnRwkjTHFSrcepVu1Q/Urvag8aEQmwbj4Hb
         e8SxtM2X6YUBm2kPoiy82jcDtYI++6NHyAF6kYCnWrcb1iP7LwjkmpcHv1TRiz7RcV
         fyLR+CBdxTfW8N06UGWkNTSqU6XMdGXkX76RLTnceNjmkCBSlAV8t66/Z1K1PduC5N
         vAP7k706m+wm521C0FP2SssUzbmawK7AfT1DWr2xjPU5BphyzNs11c/PYyAFZ35bmh
         CV/TuJpdfsvXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/15] scsi: target: qla2xxx: Wait for stop_phase1 at WWN removal
Date:   Thu,  3 Jun 2021 13:11:08 -0400
Message-Id: <20210603171114.3170086-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171114.3170086-1-sashal@kernel.org>
References: <20210603171114.3170086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit 2ef7665dfd88830f15415ba007c7c9a46be7acd8 ]

Target de-configuration panics at high CPU load because TPGT and WWPN can
be removed on separate threads.

TPGT removal requests a reset HBA on a separate thread and waits for reset
complete (phase1). Due to high CPU load that HBA reset can be delayed for
some time.

WWPN removal does qlt_stop_phase2(). There it is believed that phase1 has
already completed and thus tgt.tgt_ops is subsequently cleared. However,
tgt.tgt_ops is needed to process incoming traffic and therefore this will
cause one of the following panics:

NIP qlt_reset+0x7c/0x220 [qla2xxx]
LR  qlt_reset+0x68/0x220 [qla2xxx]
Call Trace:
0xc000003ffff63a78 (unreliable)
qlt_handle_imm_notify+0x800/0x10c0 [qla2xxx]
qlt_24xx_atio_pkt+0x208/0x590 [qla2xxx]
qlt_24xx_process_atio_queue+0x33c/0x7a0 [qla2xxx]
qla83xx_msix_atio_q+0x54/0x90 [qla2xxx]

or

NIP qlt_24xx_handle_abts+0xd0/0x2a0 [qla2xxx]
LR  qlt_24xx_handle_abts+0xb4/0x2a0 [qla2xxx]
Call Trace:
qlt_24xx_handle_abts+0x90/0x2a0 [qla2xxx] (unreliable)
qlt_24xx_process_atio_queue+0x500/0x7a0 [qla2xxx]
qla83xx_msix_atio_q+0x54/0x90 [qla2xxx]

or

NIP qlt_create_sess+0x90/0x4e0 [qla2xxx]
LR  qla24xx_do_nack_work+0xa8/0x180 [qla2xxx]
Call Trace:
0xc0000000348fba30 (unreliable)
qla24xx_do_nack_work+0xa8/0x180 [qla2xxx]
qla2x00_do_work+0x674/0xbf0 [qla2xxx]
qla2x00_iocb_work_fn

The patch fixes the issue by serializing qlt_stop_phase1() and
qlt_stop_phase2() functions to make WWPN removal wait for phase1
completion.

Link: https://lore.kernel.org/r/20210415203554.27890-1-d.bogdanov@yadro.com
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1d9f19e5e0f8..0a8a5841e1b8 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1042,6 +1042,7 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 	    "Waiting for %d IRQ commands to complete (tgt %p)",
 	    tgt->irq_cmd_count, tgt);
 
+	mutex_lock(&tgt->ha->optrom_mutex);
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	while (tgt->irq_cmd_count != 0) {
@@ -1053,6 +1054,7 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 	tgt->tgt_stopped = 1;
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
+	mutex_unlock(&tgt->ha->optrom_mutex);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00c, "Stop of tgt %p finished",
 	    tgt);
-- 
2.30.2

