Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2ED450AB7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbhKOROK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:43766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236664AbhKORMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:12:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7262361C14;
        Mon, 15 Nov 2021 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996160;
        bh=540QfVl89Ha5vARFsuyAkCUjzblk5aZxZ8bzJf2tx+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2O21CSkAJkaNhR1P0pu3LH7u+Y2jupdsmX+meG4W7PDKO/nzEOMfpyF1HLibGqbV
         GTokNGJIdpBS9PFQWfA9WtI/RBRaqHYXAIrQqRdiit/4BnX+v1u7+Byqc7UlzvJarg
         QR8YQyt2miZdmGMWrtZvRgn8KUxejFbonc8DQZNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/355] scsi: qla2xxx: Fix unmap of already freed sgl
Date:   Mon, 15 Nov 2021 17:59:22 +0100
Message-Id: <20211115165314.784724398@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit 4a8f71014b4d56c4fb287607e844c0a9f68f46d9 ]

The sgl is freed in the target stack in target_release_cmd_kref() before
calling qlt_free_cmd() but there is an unmap of sgl in qlt_free_cmd() that
causes a panic if sgl is not yet DMA unmapped:

NIP dma_direct_unmap_sg+0xdc/0x180
LR  dma_direct_unmap_sg+0xc8/0x180
Call Trace:
 ql_dbg_prefix+0x68/0xc0 [qla2xxx] (unreliable)
 dma_unmap_sg_attrs+0x54/0xf0
 qlt_unmap_sg.part.19+0x54/0x1c0 [qla2xxx]
 qlt_free_cmd+0x124/0x1d0 [qla2xxx]
 tcm_qla2xxx_release_cmd+0x4c/0xa0 [tcm_qla2xxx]
 target_put_sess_cmd+0x198/0x370 [target_core_mod]
 transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
 tcm_qla2xxx_complete_free+0x6c/0x90 [tcm_qla2xxx]

The sgl may be left unmapped in error cases of response sending.  For
instance, qlt_rdy_to_xfer() maps sgl and exits when session is being
deleted keeping the sgl mapped.

This patch removes use-after-free of the sgl and ensures that the sgl is
unmapped for any command that was not sent to firmware.

Link: https://lore.kernel.org/r/20211018122650.11846-1-d.bogdanov@yadro.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 57068e2faef54..0111c543f0e64 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3251,8 +3251,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			"RESET-RSP online/active/old-count/new-count = %d/%d/%d/%d.\n",
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return 0;
+		goto out_unmap_unlock;
 	}
 
 	/* Does F/W have an IOCBs for this request */
@@ -3375,10 +3374,6 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	prm.sg = NULL;
 	prm.req_cnt = 1;
 
-	/* Calculate number of entries and segments required */
-	if (qlt_pci_map_calc_cnt(&prm) != 0)
-		return -EAGAIN;
-
 	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		/*
@@ -3396,6 +3391,10 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 		return 0;
 	}
 
+	/* Calculate number of entries and segments required */
+	if (qlt_pci_map_calc_cnt(&prm) != 0)
+		return -EAGAIN;
+
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	/* Does F/W have an IOCBs for this request */
 	res = qlt_check_reserve_free_req(qpair, prm.req_cnt);
@@ -3800,9 +3799,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 
 	BUG_ON(cmd->cmd_in_wq);
 
-	if (cmd->sg_mapped)
-		qlt_unmap_sg(cmd->vha, cmd);
-
 	if (!cmd->q_full)
 		qlt_decr_num_pend_cmds(cmd->vha);
 
-- 
2.33.0



