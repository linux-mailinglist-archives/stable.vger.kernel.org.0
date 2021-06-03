Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0994B39A8A4
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhFCRQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233428AbhFCRPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:15:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEE7F61440;
        Thu,  3 Jun 2021 17:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740266;
        bh=B9shrIN/EPsWRXvQ+usxH2+OnyYTBoJHP+2+hdRHZz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCK0sBoylN60wj1QglOXMVTzCe0DkQGddpUBnrMjZTHAwFtpycrjARiVJqTVBJLop
         F8gKjH8H6Vf6knvV/pF572enTHRsPxTDT7U0aD4/jgSA7gujx2XAxsao9rQb9QH2nS
         ni3ETRBtFqdMCGlDSKYnhbnESDH57eApwtKig+tvT1vl9pPx9T63XM5wsOzmQrwQiS
         enipdePh6A3R9bAE2AcOUH4OuK4+A2YgiE3mOJUurU0mVNYEIUyiE1zgxjc6QkjSXj
         lcvsIJKZ0VyXjFzcpf6k2avAnnsfRygvlDv4IN+xxqETD2ya92Mn2zr6jcGZTs/Qrx
         AinIrE/HW68iQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/17] scsi: target: qla2xxx: Wait for stop_phase1 at WWN removal
Date:   Thu,  3 Jun 2021 13:10:46 -0400
Message-Id: <20210603171052.3169893-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171052.3169893-1-sashal@kernel.org>
References: <20210603171052.3169893-1-sashal@kernel.org>
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
index b889caa556a0..6ef7a094ee51 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1224,6 +1224,7 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 	    "Waiting for %d IRQ commands to complete (tgt %p)",
 	    tgt->irq_cmd_count, tgt);
 
+	mutex_lock(&tgt->ha->optrom_mutex);
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	while ((tgt->irq_cmd_count != 0) || (tgt->atio_irq_cmd_count != 0)) {
@@ -1235,6 +1236,7 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 	tgt->tgt_stopped = 1;
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
+	mutex_unlock(&tgt->ha->optrom_mutex);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00c, "Stop of tgt %p finished",
 	    tgt);
-- 
2.30.2

