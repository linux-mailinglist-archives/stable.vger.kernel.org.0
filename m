Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74154228CC
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhJENyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235468AbhJENxV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6394A619E0;
        Tue,  5 Oct 2021 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441890;
        bh=9SgO9cxeWovV1mzhMMpheRCaBIhZQ8eFKP2U2MzFVgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7YBS9ZbVfpqkItEFe2pkr5p8fWEiwMLAX2/+4pa+88/B8hTOHAei7BJTuvQefBin
         wgRH00XZNpQatLPJi0ztVL566u5yaINMpUND9XxPBpkGJFTLfe5OkMZ6odJjru21xN
         jcoqTnM+C9SiJyhfx1R+KfUWqTegeMCmvvznUToG4OV3Ff5r8s14V3YoCOmAip7Q7F
         DaGMxtKSerJjA2oQ/DBRY2/9eQI5AXe5Kpj1NdYHiXndNMBss5DGxFB4i4ZiR7yj4l
         ATYJAnLbUkV2MOnCBb/1jBlVhCL7OtBujLZtIcVEIjHYOSYFeXgiLWbcSz3iaJ4gKK
         qmxAXKr7W/MDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 35/40] scsi: qla2xxx: Fix excessive messages during device logout
Date:   Tue,  5 Oct 2021 09:50:14 -0400
Message-Id: <20211005135020.214291-35-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 8e2d81c6b5be0d7629fb50b6f678fc07a4c58fae ]

Disable default logging of some I/O path messages. If desired, the messages
can be turned back on by setting ql2xextended_error_logging.

Link: https://lore.kernel.org/r/20210925035154.29815-1-njavali@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d9fb093a60a1..4ae7e3174647 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2399,7 +2399,7 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	if (unlikely(logit))
-		ql_log(ql_log_warn, fcport->vha, 0x5060,
+		ql_log(ql_dbg_io, fcport->vha, 0x5060,
 		   "NVME-%s ERR Handling - hdl=%x status(%x) tr_len:%x resid=%x  ox_id=%x\n",
 		   sp->name, sp->handle, comp_status,
 		   fd->transferred_length, le32_to_cpu(sts->residual_len),
@@ -3246,7 +3246,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 out:
 	if (logit)
-		ql_log(ql_log_warn, fcport->vha, 0x3022,
+		ql_log(ql_dbg_io, fcport->vha, 0x3022,
 		       "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
 		       comp_status, scsi_status, res, vha->host_no,
 		       cp->device->id, cp->device->lun, fcport->d_id.b.domain,
-- 
2.33.0

