Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46DB3A6050
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhFNKdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233116AbhFNKcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2712661241;
        Mon, 14 Jun 2021 10:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666623;
        bh=B9shrIN/EPsWRXvQ+usxH2+OnyYTBoJHP+2+hdRHZz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocrFpey+jk0gUFnsulw7JQ9ybQ7jYgN7AuW1f4Pgy/PCjh2ZJiZil1Bx09/HTCqmt
         M955xvvVSo0C2sbL8CkWPuklX/FY9oLGLouCr/9BIX2o6mAmBNvbKwwv31S8210fdY
         AdyOlS0Cvltw32hRbfwblIq/3WZvDOYtBnkdu8YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Bolshakov <r.bolshakov@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/42] scsi: target: qla2xxx: Wait for stop_phase1 at WWN removal
Date:   Mon, 14 Jun 2021 12:27:03 +0200
Message-Id: <20210614102643.100947222@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



