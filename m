Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA66121677
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbfLPSNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:13:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730741AbfLPSNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AEDC20CC7;
        Mon, 16 Dec 2019 18:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520003;
        bh=xM3l1nyEPHhbbcxD8IHwnFt40y0AFFRwzfxMpW0VxSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpbqIvHL0qQ8AwZOY/291iZd3tBV1MFkJX+2/TfQnCM5+Yf7t1qXC6ky9Mp9Awdz0
         meZ/lZIvCxSDSrIyRcQdzEgZl6KV0zdm2r4JBV133BqLZ7MW2zQgP8gERkNs2WRbWL
         PCadzWnxuLTEBV8i3FY/urfTvX+QrOGVL/ugWC9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 155/180] scsi: qla2xxx: Fix stale session
Date:   Mon, 16 Dec 2019 18:49:55 +0100
Message-Id: <20191216174844.675793574@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 2037ce49d30a0d07348df406ef78f6664f4bc899 ]

On fast cable pull, where driver is unable to detect device has disappeared
and came back based on switch info, qla2xxx would not re-login while remote
port has already invalidated the session.  This causes IO timeout.  This
patch would relogin to remote device for RSCN affected port.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Link: https://lore.kernel.org/r/20190830222402.23688-6-hmadhani@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index ebf223cfebbc5..dec521d726d91 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3674,7 +3674,6 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (memcmp(rp->port_name, fcport->port_name, WWN_SIZE))
 				continue;
-			fcport->scan_needed = 0;
 			fcport->scan_state = QLA_FCPORT_FOUND;
 			found = true;
 			/*
@@ -3683,10 +3682,12 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0) {
 				qla2x00_clear_loop_id(fcport);
 				fcport->flags |= FCF_FABRIC_DEVICE;
-			} else if (fcport->d_id.b24 != rp->id.b24) {
+			} else if (fcport->d_id.b24 != rp->id.b24 ||
+				fcport->scan_needed) {
 				qlt_schedule_sess_for_deletion(fcport);
 			}
 			fcport->d_id.b24 = rp->id.b24;
+			fcport->scan_needed = 0;
 			break;
 		}
 
-- 
2.20.1



