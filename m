Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279AD20E732
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733279AbgF2VzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgF2Sfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55E9B24682;
        Mon, 29 Jun 2020 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443977;
        bh=JlCPYTpFqqQ42W/PHGp9eRBzhh4t6fJ0tvG04jWsRWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vaoTNxPwbiuyTb6NdU4AJC9dZYrWhkyPLp5Uw7Dm6MBaAvgFm+h1gQW5uRdlPqrh0
         NLvGvcSgkdMebKPH+tjF89UHK43gLfa0ag52+h/FnugQHq9O56YgEBL7C9jNrdlwrU
         qGarvOSedOMvyjGyIYaGLT2+QtVZaLp+Qv7Uc2fs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Shyam Sundar <ssundar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 081/265] scsi: qla2xxx: Keep initiator ports after RSCN
Date:   Mon, 29 Jun 2020 11:15:14 -0400
Message-Id: <20200629151818.2493727-82-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

commit 632f24f09d5b7c8a2f94932c3391ca957ae76cc4 upstream.

The driver performs SCR (state change registration) in all modes including
pure target mode.

For each RSCN, scan_needed flag is set in qla2x00_handle_rscn() for the
port mentioned in the RSCN and fabric rescan is scheduled. During the
rescan, GNN_FT handler, qla24xx_async_gnnft_done() deletes session of the
port that caused the RSCN.

In target mode, the session deletion has an impact on ATIO handler,
qlt_24xx_atio_pkt(). Target responds with SAM STATUS BUSY to I/O incoming
from the deleted session. qlt_handle_cmd_for_atio() and
qlt_handle_task_mgmt() return -EFAULT if they are not able to find session
of the command/TMF, and that results in invocation of qlt_send_busy():

  qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0014
  qla_target(0): Unable to send command to target, sending BUSY status

Such response causes command timeout on the initiator. Error handler thread
on the initiator will be spawned to abort the commands:

  scsi 23:0:0:0: tag#0 abort scheduled
  scsi 23:0:0:0: tag#0 aborting command
  qla2xxx [0000:af:00.0]-188c:23: Entered qla24xx_abort_command.
  qla2xxx [0000:af:00.0]-801c:23: Abort command issued nexus=23:0:0 -- 0 2003.

Command abort is rejected by target and fails (2003), error handler then
tries to perform DEVICE RESET and TARGET RESET but they're also doomed to
fail because TMFs are ignored for the deleted sessions.

Then initiator makes BUS RESET that resets the link via
qla2x00_full_login_lip(). BUS RESET succeeds and brings initiator port up,
SAN switch detects that and sends RSCN to the target port and it fails
again the same way as described above. It never goes out of the loop.

The change breaks the RSCN loop by keeping initiator sessions mentioned in
RSCN payload in all modes, including dual and pure target mode.

Link: https://lore.kernel.org/r/20200605144435.27023-1-r.bolshakov@yadro.com
Fixes: 2037ce49d30a ("scsi: qla2xxx: Fix stale session")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: stable@vger.kernel.org # v5.4+
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 42c3ad27f1cbc..df670fba2ab8a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3496,7 +3496,9 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 				qla2x00_clear_loop_id(fcport);
 				fcport->flags |= FCF_FABRIC_DEVICE;
 			} else if (fcport->d_id.b24 != rp->id.b24 ||
-				fcport->scan_needed) {
+				   (fcport->scan_needed &&
+				    fcport->port_type != FCT_INITIATOR &&
+				    fcport->port_type != FCT_NVME_INITIATOR)) {
 				qlt_schedule_sess_for_deletion(fcport);
 			}
 			fcport->d_id.b24 = rp->id.b24;
-- 
2.25.1

