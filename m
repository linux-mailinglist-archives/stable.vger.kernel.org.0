Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 089081333A9
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgAGVU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbgAGVET (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:04:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E2320880;
        Tue,  7 Jan 2020 21:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431058;
        bh=cGFjV24DcR2yn+uYs+DxSEhJh+q+tRW59ozMyCzG6W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFdx/TrklTgxGWEAgNI6c2uuCbSyn+a6kixdkrIzhZUd5nPKhZQbBcUhuPoyB5gsp
         5gnnKWhUkxE6a2ePH44cCaOzxRoc9UYSRs66s3m97G5WSEPV4T9I/aJqxdaf/76dUn
         rKHFFda7QuBDGxDfyzONkvNexoVqWgH1tW5g0mlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/115] scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
Date:   Tue,  7 Jan 2020 21:53:47 +0100
Message-Id: <20200107205250.739117298@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

[ Upstream commit 0334cdea1fba36fad8bdf9516f267ce01de625f7 ]

The size of the buffer is hardcoded as 0x70 or 112 bytes, while the size of
ELS IOCB is 0x40 and the size of PLOGI payload returned by Get Parameters
command is 0x74.

Cc: Quinn Tran <qutran@marvell.com>
Link: https://lore.kernel.org/r/20191125165702.1013-9-r.bolshakov@yadro.com
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c699bbb8485b..7e47321e003c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2537,7 +2537,8 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3073,
 		    "PLOGI ELS IOCB:\n");
 		ql_dump_buffer(ql_log_info, vha, 0x0109,
-		    (uint8_t *)els_iocb, 0x70);
+		    (uint8_t *)els_iocb,
+		    sizeof(*els_iocb));
 	} else {
 		els_iocb->tx_byte_count = sizeof(struct els_logo_payload);
 		els_iocb->tx_address[0] =
@@ -2703,7 +2704,8 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3073, "PLOGI buffer:\n");
 	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x0109,
-	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld, 0x70);
+	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
+	    sizeof(*elsio->u.els_plogi.els_plogi_pyld));
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-- 
2.20.1



